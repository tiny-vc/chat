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
    initiatorSessionId: "session-a",
    targetSessionId: null,
    startedAt: new Date(now.getTime() - 1000),
  };
  function setup() {
    const callSession = {
      updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      findUnique: jest.fn().mockResolvedValue(base),
      findFirst: jest.fn().mockResolvedValue(null),
      findMany: jest.fn().mockResolvedValue([]),
      create: jest.fn().mockResolvedValue({
        ...base,
        id: "11111111-1111-4111-8111-111111111111",
      }),
    };
    const transaction = {
      $queryRaw: jest.fn().mockResolvedValue([{ acquired: true }]),
      callSession,
    };
    const prisma = {
      $transaction: jest
        .fn()
        .mockImplementation(
          (operation: (tx: typeof transaction) => Promise<void>) =>
            operation(transaction),
        ),
      callSession,
      user: {
        findFirst: jest.fn().mockResolvedValue({ id: "bob" }),
        findMany: jest.fn().mockResolvedValue([]),
        findUniqueOrThrow: jest
          .fn()
          .mockResolvedValue({ nickname: "Test user" }),
      },
    };
    const im = { sendPersonalMessage: jest.fn().mockResolvedValue(undefined) };
    const livekit = { createJoinToken: jest.fn() };
    const friends = { areFriends: jest.fn().mockResolvedValue(true) };
    return {
      prisma,
      transaction,
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
    await service.create("alice", "session-a", {
      targetUserId: "bob",
      type: "VIDEO",
    });
    expect(prisma.callSession.updateMany.mock.calls[0][0].where.OR).toEqual([
      { initiatorUserId: { in: ["alice", "bob"] } },
      { targetUserId: { in: ["alice", "bob"] } },
    ]);
    expect(
      prisma.callSession.updateMany.mock.invocationCallOrder[0],
    ).toBeLessThan(prisma.callSession.findFirst.mock.invocationCallOrder[0]);
  });

  it("never exposes internal device bindings in call responses", async () => {
    const { service, prisma } = setup();
    prisma.callSession.findMany.mockResolvedValue([
      { ...base, targetSessionId: "session-b" },
    ]);

    const created = await service.create("alice", "session-a", {
      targetUserId: "bob",
      type: "VIDEO",
    });
    const listed = await service.list("alice");

    const fetched = await service.get("call", "alice");

    for (const response of [created, listed[0], fetched]) {
      expect(response).not.toHaveProperty("initiatorSessionId");
      expect(response).not.toHaveProperty("targetSessionId");
    }
  });

  it("paginates history with a stable startedAt and id cursor", async () => {
    const { service, prisma } = setup();
    const before = "2026-09-02T03:00:00.000Z";
    await service.list("alice", {
      before,
      beforeId: "11111111-1111-4111-8111-111111111111",
    });
    expect(prisma.callSession.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: {
          AND: [
            {
              OR: [{ initiatorUserId: "alice" }, { targetUserId: "alice" }],
            },
            {
              OR: [
                { startedAt: { lt: new Date(before) } },
                {
                  startedAt: new Date(before),
                  id: { lt: "11111111-1111-4111-8111-111111111111" },
                },
              ],
            },
          ],
        },
        orderBy: [{ startedAt: "desc" }, { id: "desc" }],
        take: 100,
      }),
    );
  });

  it("requires both call history cursor components", async () => {
    const { service, prisma } = setup();
    await expect(
      service.list("alice", { before: "2026-09-02T03:00:00.000Z" }),
    ).rejects.toThrow("must be supplied together");
    expect(prisma.callSession.findMany).not.toHaveBeenCalled();
  });

  it("does not reveal a call to a non-participant", async () => {
    const { service } = setup();
    await expect(service.get("call", "mallory")).rejects.toThrow(
      "not a participant",
    );
  });

  it("still blocks new calls when an accepted call exists", async () => {
    const { service, prisma } = setup();
    prisma.callSession.findFirst.mockResolvedValue({ id: "accepted" });
    await expect(
      service.create("alice", "session-a", {
        targetUserId: "bob",
        type: "VIDEO",
      }),
    ).rejects.toThrow("already in a call");
    expect(prisma.callSession.create).not.toHaveBeenCalled();
  });

  it("rejects acceptance if another operation won the race", async () => {
    const { service, prisma, im } = setup();
    prisma.callSession.updateMany.mockResolvedValue({ count: 0 });
    await expect(service.accept("call", "bob", "session-b")).rejects.toThrow(
      "expired or already handled",
    );
    expect(prisma.callSession.updateMany).toHaveBeenLastCalledWith({
      where: {
        id: "call",
        status: { in: ["INVITING", "RINGING"] },
        startedAt: { gt: new Date(now.getTime() - 45_000) },
      },
      data: {
        status: "ACCEPTED",
        answeredAt: now,
        targetSessionId: "session-b",
      },
    });
    expect(im.sendPersonalMessage).not.toHaveBeenCalled();
  });

  it("does not issue a token for an expired invitation", async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({
      ...base,
      status: "MISSED",
    });
    await expect(
      service.createToken("call", "alice", "session-a"),
    ).rejects.toThrow("no longer active");
    expect(livekit.createJoinToken).not.toHaveBeenCalled();
  });

  it("requires the recipient to accept before joining LiveKit", async () => {
    const { service, prisma, livekit } = setup();
    await expect(
      service.createToken("call", "bob", "session-b"),
    ).rejects.toThrow("must accept");
    expect(livekit.createJoinToken).not.toHaveBeenCalled();

    prisma.callSession.findUnique.mockResolvedValue({
      ...base,
      status: "ACCEPTED",
      targetSessionId: "session-b",
    });
    livekit.createJoinToken.mockResolvedValue({
      url: "ws://livekit:7880",
      token: "token",
    });
    await expect(
      service.createToken("call", "bob", "session-b"),
    ).resolves.toEqual({
      url: "ws://livekit:7880",
      token: "token",
    });
    expect(livekit.createJoinToken).toHaveBeenCalledWith(
      expect.objectContaining({ userId: "bob", sessionId: "session-b" }),
    );

    await expect(
      service.createToken("call", "bob", "session-b-other"),
    ).rejects.toThrow("another device session");
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

  it("skips maintenance when another server instance owns the lock", async () => {
    const { service, prisma, transaction } = setup();
    transaction.$queryRaw.mockResolvedValue([{ acquired: false }]);

    service.onApplicationBootstrap();
    await jest.advanceTimersByTimeAsync(1);
    service.onModuleDestroy();

    expect(prisma.callSession.updateMany).not.toHaveBeenCalled();
    expect(prisma.callSession.findMany).not.toHaveBeenCalled();
  });
});
