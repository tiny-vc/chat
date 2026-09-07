import { CallsService } from "../src/calls/calls.service";

describe("call media recovery and hangup", () => {
  const call = {
    id: "11111111-1111-4111-8111-111111111111",
    initiatorUserId: "a",
    targetUserId: "b",
    status: "ACCEPTED",
    livekitRoomName: "room",
    initiatorSessionId: "session-a",
    targetSessionId: "session-b",
    type: "AUDIO",
  };
  function setup() {
    let mediaMissingSince: Date | null = null;
    type UpdateInput = {
      data: { mediaMissingSince?: Date | null; status?: string };
    };
    const prisma = {
      callSession: {
        findMany: jest
          .fn()
          .mockImplementation(() =>
            Promise.resolve([{ ...call, mediaMissingSince }]),
          ),
        findUnique: jest.fn().mockResolvedValue(call),
        updateMany: jest.fn().mockImplementation(({ data }: UpdateInput) => {
          if (Object.hasOwn(data, "mediaMissingSince")) {
            mediaMissingSince = data.mediaMissingSince ?? null;
          }
          return Promise.resolve({ count: 1 });
        }),
      },
    };
    const livekit = {
      participantIdentities: jest.fn().mockResolvedValue(["a:session-a"]),
      deleteRoom: jest.fn().mockResolvedValue(undefined),
    };
    const im = { sendPersonalMessage: jest.fn().mockResolvedValue(undefined) };
    return {
      prisma,
      livekit,
      im,
      service: new CallsService(
        prisma as never,
        livekit as never,
        im as never,
        {} as never,
      ),
    };
  }
  beforeEach(() => {
    jest.useFakeTimers();
    jest.setSystemTime(new Date("2026-09-03T00:00:00Z"));
  });
  afterEach(() => jest.useRealTimers());

  it("allows brief absence and ends only after a full 90-second grace window", async () => {
    const { service, prisma, livekit, im } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(89_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: "ENDED" }),
      }),
    );
    jest.advanceTimersByTime(1_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
      data: {
        status: "ENDED",
        endedAt: expect.any(Date),
        endReason: "MEDIA_DISCONNECTED",
        mediaMissingSince: null,
      },
    });
    expect(livekit.deleteRoom).toHaveBeenCalledWith("room");
    expect(im.sendPersonalMessage).toHaveBeenCalledTimes(2);
  });

  it("resets grace when both participants return", async () => {
    const { service, prisma, livekit } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(80_000);
    livekit.participantIdentities.mockResolvedValueOnce([
      "a:session-a",
      "b:session-b",
    ]);
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(20_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: "ENDED" }),
      }),
    );
  });

  it("does not interpret a LiveKit API outage as participant absence", async () => {
    const { service, prisma, livekit } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(100_000);
    livekit.participantIdentities.mockRejectedValueOnce(new Error("timeout"));
    await service.reconcileMediaSessions();
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: "ENDED" }),
      }),
    );
  });

  it("broadcasts media termination to both accounts and safely retries", async () => {
    const { service, prisma, im } = setup();
    prisma.callSession.findUnique
      .mockResolvedValueOnce(call)
      .mockResolvedValueOnce({
        ...call,
        status: "ENDED",
        endReason: "MEDIA_DISCONNECTED",
      });

    await expect(service.endFromMedia("room")).resolves.toBe(true);
    await expect(service.endFromMedia("room")).resolves.toBe(true);
    expect(prisma.callSession.updateMany).toHaveBeenCalledTimes(1);
    expect(im.sendPersonalMessage).toHaveBeenCalledTimes(4);
    expect(im.sendPersonalMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        fromUserId: "a",
        toUserId: "b",
        payload: expect.objectContaining({ action: "end" }),
      }),
    );
    expect(im.sendPersonalMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        fromUserId: "b",
        toUserId: "a",
        payload: expect.objectContaining({ action: "end" }),
      }),
    );
  });

  it("does not delete a room if a concurrent terminal transition already won", async () => {
    const { service, prisma, livekit, im } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(100_000);
    prisma.callSession.updateMany.mockResolvedValue({ count: 0 });
    await service.reconcileMediaSessions();
    expect(livekit.deleteRoom).not.toHaveBeenCalled();
    expect(im.sendPersonalMessage).not.toHaveBeenCalled();
  });

  it("permits an authorized retry after acceptance without transitioning twice", async () => {
    const { service, prisma, im } = setup();
    const accepted = await service.accept("call", "b", "session-b");
    expect(accepted).toMatchObject({ id: call.id, status: "ACCEPTED" });
    expect(accepted).not.toHaveProperty("initiatorSessionId");
    expect(accepted).not.toHaveProperty("targetSessionId");
    expect(im.sendPersonalMessage).toHaveBeenCalledTimes(2);
    expect(im.sendPersonalMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        fromUserId: "b",
        toUserId: "b",
        payload: expect.objectContaining({ action: "answered_elsewhere" }),
      }),
    );
    await expect(
      service.accept("call", "b", "session-b-other"),
    ).rejects.toThrow("another device");
    // requireCall only runs expiry of unanswered invitations.
    expect(prisma.callSession.updateMany).not.toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: "ACCEPTED" }),
      }),
    );
    await expect(service.accept("call", "a", "session-a")).rejects.toThrow(
      "Only the recipient",
    );
  });

  it("repeated hangup is harmless but still enforces participant permissions", async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({
      ...call,
      status: "ENDED",
    });
    await expect(service.end("call", "a")).resolves.toMatchObject({
      status: "ENDED",
    });
    expect(livekit.deleteRoom).not.toHaveBeenCalled();
    await expect(service.end("call", "stranger")).rejects.toThrow(
      "not a participant",
    );
  });

  it("caller hangup cancels an unanswered invitation but recipient cannot end it", async () => {
    const { service, prisma, im } = setup();
    prisma.callSession.findUnique.mockResolvedValue({
      ...call,
      status: "RINGING",
    });
    await expect(service.end("call", "b")).rejects.toThrow("not active");
    await service.end("call", "a");
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: call.id, status: { in: ["INVITING", "RINGING"] } },
      data: {
        status: "CANCELLED",
        endedAt: expect.any(Date),
        endReason: "CANCELLED",
      },
    });
    expect(im.sendPersonalMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        payload: expect.objectContaining({ action: "cancel" }),
      }),
    );
  });

  it("turns an invitation/accept race into an active hangup without overwriting acceptance", async () => {
    const { service, prisma, im } = setup();
    prisma.callSession.findUnique
      .mockResolvedValueOnce({ ...call, status: "RINGING" })
      .mockResolvedValueOnce({ ...call, status: "ACCEPTED" })
      .mockResolvedValueOnce({ ...call, status: "ENDED" });
    prisma.callSession.updateMany
      .mockResolvedValueOnce({ count: 1 }) // requireParticipant expiry check
      .mockResolvedValueOnce({ count: 0 }) // acceptance won cancellation CAS
      .mockResolvedValueOnce({ count: 1 }) // requireCall expiry check
      .mockResolvedValueOnce({ count: 1 });

    await service.end("call", "a");

    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
      data: {
        status: "ENDED",
        endedAt: expect.any(Date),
        endReason: "HANGUP",
      },
    });
    expect(im.sendPersonalMessage).toHaveBeenCalledWith(
      expect.objectContaining({
        payload: expect.objectContaining({ action: "end" }),
      }),
    );
  });
});
