import { CallsService } from "../src/calls/calls.service";

describe("call invitation expiry", () => {
  const now = new Date("2026-09-03T03:00:00Z");
  const base = {
    id: "call",
    initiatorUserId: "alice",
    targetUserId: "bob",
    type: "VIDEO",
    status: "RINGING",
    livekitRoomName: "room",
    startedAt: new Date(now.getTime() - 1000),
  };
  function setup() {
    const prisma = {
      callSession: {
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
        findUnique: jest.fn().mockResolvedValue(base),
        findFirst: jest.fn().mockResolvedValue(null),
        findMany: jest.fn().mockResolvedValue([]),
        create: jest
          .fn()
          .mockResolvedValue({
            ...base,
            id: "11111111-1111-4111-8111-111111111111",
          }),
      },
      user: { findFirst: jest.fn().mockResolvedValue({ id: "bob" }) },
    };
    const im = { sendPersonalMessage: jest.fn().mockResolvedValue(undefined) };
    const livekit = { createJoinToken: jest.fn() };
    const friends = { areFriends: jest.fn().mockResolvedValue(true) };
    return {
      prisma,
      im,
      livekit,
      service: new CallsService(
        prisma as never,
        livekit as never,
        im as never,
        friends as never,
      ),
    };
  }
  beforeEach(() => {
    jest.useFakeTimers();
    jest.setSystemTime(now);
  });
  afterEach(() => jest.useRealTimers());

  it("expires only unanswered calls at or before the deadline", async () => {
    const { service, prisma } = setup();
    await service.expireInvitations();
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: {
        status: { in: ["INVITING", "RINGING"] },
        startedAt: { lte: new Date(now.getTime() - 45_000) },
      },
      data: { status: "MISSED", endedAt: now, endReason: "NO_ANSWER" },
    });
  });

  it("cleans relevant users before checking busy state", async () => {
    const { service, prisma } = setup();
    await service.create("alice", { targetUserId: "bob", type: "VIDEO" });
    expect(prisma.callSession.updateMany.mock.calls[0][0].where.OR).toEqual([
      { initiatorUserId: { in: ["alice", "bob"] } },
      { targetUserId: { in: ["alice", "bob"] } },
    ]);
    expect(
      prisma.callSession.updateMany.mock.invocationCallOrder[0],
    ).toBeLessThan(prisma.callSession.findFirst.mock.invocationCallOrder[0]);
  });

  it("still blocks new calls when an accepted call exists", async () => {
    const { service, prisma } = setup();
    prisma.callSession.findFirst.mockResolvedValue({ id: "accepted" });
    await expect(
      service.create("alice", { targetUserId: "bob", type: "VIDEO" }),
    ).rejects.toThrow("already in a call");
    expect(prisma.callSession.create).not.toHaveBeenCalled();
  });

  it("rejects acceptance if another operation won the race", async () => {
    const { service, prisma, im } = setup();
    prisma.callSession.updateMany.mockResolvedValue({ count: 0 });
    await expect(service.accept("call", "bob")).rejects.toThrow(
      "expired or already handled",
    );
    expect(prisma.callSession.updateMany).toHaveBeenLastCalledWith({
      where: {
        id: "call",
        status: { in: ["INVITING", "RINGING"] },
        startedAt: { gt: new Date(now.getTime() - 45_000) },
      },
      data: { status: "ACCEPTED", answeredAt: now },
    });
    expect(im.sendPersonalMessage).not.toHaveBeenCalled();
  });

  it("does not issue a token for an expired invitation", async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({
      ...base,
      status: "MISSED",
    });
    await expect(service.createToken("call", "alice")).rejects.toThrow(
      "no longer active",
    );
    expect(livekit.createJoinToken).not.toHaveBeenCalled();
  });

  it("runs at startup, periodically, and stops on shutdown", async () => {
    const { service, prisma } = setup();
    service.onApplicationBootstrap();
    await jest.advanceTimersByTimeAsync(15_000);
    expect(prisma.callSession.updateMany).toHaveBeenCalledTimes(2);
    service.onModuleDestroy();
    await jest.advanceTimersByTimeAsync(30_000);
    expect(prisma.callSession.updateMany).toHaveBeenCalledTimes(2);
  });
});
