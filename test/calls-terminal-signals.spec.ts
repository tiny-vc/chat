import { CallsService } from "../src/calls/calls.service";

describe("terminal call signal compensation", () => {
  const base = {
    id: "11111111-1111-4111-8111-111111111111",
    initiatorUserId: "caller",
    targetUserId: "recipient",
    type: "AUDIO",
    livekitRoomName: "room",
  };

  it.each([
    ["reject", "REJECTED", "REJECTED", "recipient", "reject"],
    ["busy", "REJECTED", "BUSY", "recipient", "busy"],
    ["cancel", "CANCELLED", "CANCELLED", "caller", "cancel"],
    ["miss", "MISSED", "NO_ANSWER", "caller", "miss"],
    ["end", "CANCELLED", "CANCELLED", "caller", "cancel"],
    ["end", "ENDED", "HANGUP", "recipient", "end"],
  ] as const)(
    "retries %s by resending its terminal IM signal",
    async (method, status, endReason, actor, action) => {
      const call = { ...base, status, endReason };
      const prisma = {
        callSession: {
          updateMany: jest.fn().mockResolvedValue({ count: 0 }),
          findUnique: jest.fn().mockResolvedValue(call),
        },
      };
      const im = {
        sendPersonalMessage: jest.fn().mockResolvedValue(undefined),
      };
      const service = new CallsService(
        prisma as never,
        {} as never,
        im as never,
        {} as never,
      );

      await service[method]("call", actor);

      expect(im.sendPersonalMessage).toHaveBeenCalledWith(
        expect.objectContaining({
          fromUserId: actor,
          payload: expect.objectContaining({ action }),
        }),
      );
      expect(prisma.callSession.updateMany).toHaveBeenCalledTimes(1);
    },
  );
});
