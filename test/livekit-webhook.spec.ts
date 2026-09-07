import { createHash } from "node:crypto";
import { AccessToken } from "livekit-server-sdk";
import { LivekitWebhookService } from "../src/webhooks/livekit-webhook.service";

describe("LiveKit webhook processing", () => {
  const apiKey = "test-key";
  const apiSecret = "a-test-secret-that-is-long-enough-to-sign";

  async function signed(event: Record<string, unknown>) {
    const body = JSON.stringify(event);
    const token = new AccessToken(apiKey, apiSecret, { ttl: "5m" });
    token.sha256 = createHash("sha256").update(body).digest("base64");
    return { body, authorization: await token.toJwt() };
  }

  function setup() {
    const prisma = {
      webhookEvent: {
        findUnique: jest.fn().mockResolvedValue(null),
        create: jest.fn().mockResolvedValue({}),
        update: jest.fn().mockResolvedValue({}),
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      },
      callSession: {
        findUnique: jest.fn().mockResolvedValue({
          id: "call-id",
          status: "ACCEPTED",
          initiatorUserId: "alice",
          targetUserId: "bob",
        }),
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
      },
    };
    const livekit = {
      participantIdentities: jest
        .fn()
        .mockResolvedValue(["alice:session-a", "bob:session-b"]),
      deleteRoom: jest.fn().mockResolvedValue(undefined),
    };
    const calls = {
      endFromMedia: jest.fn().mockResolvedValue(true),
      hasUserParticipant: jest.fn((identities: string[], userId: string) =>
        identities.some((identity) => identity.startsWith(`${userId}:`)),
      ),
    };
    const config = {
      getOrThrow: jest.fn((key: string) =>
        key === "LIVEKIT_API_KEY" ? apiKey : apiSecret,
      ),
    };
    return {
      prisma,
      livekit,
      calls,
      service: new LivekitWebhookService(
        config as never,
        prisma as never,
        livekit as never,
        calls as never,
      ),
    };
  }

  it("marks an accepted call connected only after both users joined", async () => {
    const { service, prisma } = setup();
    const request = await signed({
      event: "participant_joined",
      id: "event-1",
      room: { name: "call-room" },
      participant: { identity: "bob" },
      createdAt: "1",
    });

    await expect(
      service.receive(request.body, request.authorization),
    ).resolves.toEqual({
      accepted: true,
      duplicate: false,
    });
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: "call-id", status: "ACCEPTED" },
      data: { status: "CONNECTED" },
    });
  });

  it("does not mark connected while only one participant is present", async () => {
    const { service, prisma, livekit } = setup();
    livekit.participantIdentities.mockResolvedValue(["bob:session-b"]);
    const request = await signed({
      event: "participant_joined",
      id: "event-2",
      room: { name: "call-room" },
      participant: { identity: "bob" },
      createdAt: "1",
    });
    await service.receive(request.body, request.authorization);
    expect(prisma.callSession.updateMany).not.toHaveBeenCalled();
  });

  it("rejects a forged webhook", async () => {
    const { service, prisma } = setup();
    await expect(
      service.receive('{"event":"room_started","id":"fake"}', "Bearer forged"),
    ).rejects.toThrow("Invalid LiveKit webhook signature");
    expect(prisma.webhookEvent.create).not.toHaveBeenCalled();
  });

  it("immediately closes a stale call room recreated with an old token", async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({ status: "ENDED" });
    const request = await signed({
      event: "room_started",
      id: "event-stale-room",
      room: { name: "call_11111111-1111-4111-8111-111111111111" },
      createdAt: "1",
    });
    await service.receive(request.body, request.authorization);
    expect(livekit.deleteRoom).toHaveBeenCalledWith(
      "call_11111111-1111-4111-8111-111111111111",
    );
  });

  it("keeps an active business call room", async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({ status: "RINGING" });
    const request = await signed({
      event: "room_started",
      id: "event-active-room",
      room: { name: "call_22222222-2222-4222-8222-222222222222" },
      createdAt: "1",
    });
    await service.receive(request.body, request.authorization);
    expect(livekit.deleteRoom).not.toHaveBeenCalled();
  });

  it("delegates a finished room to authoritative call termination", async () => {
    const { service, calls } = setup();
    const request = await signed({
      event: "room_finished",
      id: "event-finished",
      room: { name: "call-room" },
      createdAt: "1",
    });
    await service.receive(request.body, request.authorization);
    expect(calls.endFromMedia).toHaveBeenCalledWith("call-room");
  });

  it("acknowledges an already processed event without side effects", async () => {
    const { service, prisma, livekit } = setup();
    prisma.webhookEvent.findUnique.mockResolvedValue({
      processedAt: new Date(),
    });
    const request = await signed({
      event: "participant_joined",
      id: "event-3",
      room: { name: "call-room" },
      createdAt: "1",
    });
    await expect(
      service.receive(request.body, request.authorization),
    ).resolves.toEqual({
      accepted: true,
      duplicate: true,
    });
    expect(livekit.participantIdentities).not.toHaveBeenCalled();
  });
});
