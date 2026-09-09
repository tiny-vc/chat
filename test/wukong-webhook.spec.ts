import { ConfigService } from "@nestjs/config";
import { HTTP_CODE_METADATA } from "@nestjs/common/constants";
import { Prisma } from "@prisma/client";
import { WukongWebhookController } from "../src/webhooks/wukong-webhook.controller";
import { WukongWebhookService } from "../src/webhooks/wukong-webhook.service";

describe("WukongWebhookController", () => {
  it("returns HTTP 200 because WuKongIM rejects the default POST 201", () => {
    expect(
      Reflect.getMetadata(
        HTTP_CODE_METADATA,
        // Reflection must inspect the decorated prototype method itself.
        // eslint-disable-next-line @typescript-eslint/unbound-method
        WukongWebhookController.prototype.receive,
      ),
    ).toBe(200);
    expect(
      Reflect.getMetadata(
        HTTP_CODE_METADATA,
        // Reflection must inspect the decorated prototype method itself.
        // eslint-disable-next-line @typescript-eslint/unbound-method
        WukongWebhookController.prototype.receiveWithPathToken,
      ),
    ).toBe(200);
  });
});

describe("WukongWebhookService", () => {
  const secret = "webhook-secret-for-tests";
  const config = {
    getOrThrow: jest.fn(() => secret),
  } as unknown as ConfigService;

  it("stores a new event", async () => {
    const create = jest.fn().mockResolvedValue({ id: "event-id" });
    const service = new WukongWebhookService(config, {
      webhookEvent: { create },
      storedFile: { updateMany: jest.fn() },
    } as never);

    await expect(
      service.receive(secret, undefined, { event: "message.notify", id: "m1" }),
    ).resolves.toEqual({
      accepted: true,
      duplicate: false,
    });
    expect(create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        eventKey: "message.notify:m1",
        eventType: "message.notify",
      }),
    });
  });

  it("accepts duplicate delivery without inserting it twice", async () => {
    const duplicate = new Prisma.PrismaClientKnownRequestError("duplicate", {
      code: "P2002",
      clientVersion: "6.19.3",
    });
    const service = new WukongWebhookService(config, {
      webhookEvent: { create: jest.fn().mockRejectedValue(duplicate) },
      storedFile: { updateMany: jest.fn() },
    } as never);

    await expect(
      service.receive(secret, undefined, { type: "online", id: "u1" }),
    ).resolves.toEqual({
      accepted: true,
      duplicate: true,
    });
  });

  it("rejects an invalid token", async () => {
    const service = new WukongWebhookService(config, {
      webhookEvent: { create: jest.fn() },
      storedFile: { updateMany: jest.fn() },
    } as never);
    await expect(
      service.receive("wrong-token-value-000", undefined, {}),
    ).rejects.toThrow("Invalid webhook token");
  });

  it("marks scoped media as referenced from the official msg.notify batch", async () => {
    const updateMany = jest.fn().mockResolvedValue({ count: 2 });
    const service = new WukongWebhookService(config, {
      webhookEvent: { create: jest.fn().mockResolvedValue({ id: "event-id" }) },
      storedFile: { updateMany },
    } as never);
    const fileId = "00000000-0000-4000-8000-000000000001";
    const thumbnailFileId = "00000000-0000-4000-8000-000000000002";
    const body = [
      {
        from_uid: "00000000-0000-4000-8000-000000000003",
        channel_id: "00000000-0000-4000-8000-000000000004",
        channel_type: 2,
        payload: Buffer.from(
          JSON.stringify({ type: 2, fileId, thumbnailFileId }),
        ).toString("base64"),
      },
    ];

    await service.receive(secret, "msg.notify", body);

    expect(updateMany).toHaveBeenCalledWith({
      where: expect.objectContaining({
        id: { in: [fileId, thumbnailFileId] },
        ownerUserId: body[0].from_uid,
        scope: "GROUP",
        scopeId: body[0].channel_id,
      }),
      data: { referencedAt: expect.any(Date) },
    });
  });
});
