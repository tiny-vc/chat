import { Injectable, UnauthorizedException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Prisma } from "@prisma/client";
import { createHash, timingSafeEqual } from "node:crypto";
import { PrismaService } from "../prisma/prisma.service";

@Injectable()
export class WukongWebhookService {
  private readonly secret: string;

  constructor(
    config: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    this.secret = config.getOrThrow<string>("WUKONGIM_WEBHOOK_SECRET");
  }

  async receive(
    token: string | undefined,
    event: string | undefined,
    payload: unknown,
  ) {
    if (!this.isValidToken(token))
      throw new UnauthorizedException("Invalid webhook token");
    const normalized = this.asJsonValue(payload);
    const bodyObject = this.asRecord(payload);
    const eventType =
      event ?? this.readString(bodyObject, ["event", "type"]) ?? "unknown";
    const suppliedId = this.readString(bodyObject, ["event_id", "id"]);
    const digest = createHash("sha256")
      .update(JSON.stringify(normalized))
      .digest("hex");
    const eventKey = suppliedId
      ? `${eventType}:${suppliedId}`
      : `${eventType}:${digest}`;

    try {
      if (eventType === "msg.notify") await this.markFileReferences(payload);
      await this.prisma.webhookEvent.create({
        data: {
          source: "wukongim",
          eventKey,
          eventType,
          payload: normalized,
          processedAt: new Date(),
        },
      });
      return { accepted: true, duplicate: false };
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === "P2002"
      ) {
        return { accepted: true, duplicate: true };
      }
      throw error;
    }
  }

  private isValidToken(token: string | undefined) {
    if (!token) return false;
    const actual = Buffer.from(token);
    const expected = Buffer.from(this.secret);
    return (
      actual.length === expected.length && timingSafeEqual(actual, expected)
    );
  }

  private async markFileReferences(payload: unknown) {
    if (!Array.isArray(payload)) return;
    for (const item of payload) {
      const message = this.asRecord(item);
      const fromUserId = this.readString(message, ["from_uid"]);
      const channelId = this.readString(message, ["channel_id"]);
      const channelType = Number(message.channel_type);
      const encoded = this.readString(message, ["payload"]);
      if (
        !fromUserId ||
        !channelId ||
        !encoded ||
        ![1, 2].includes(channelType)
      )
        continue;
      let content: Record<string, unknown>;
      try {
        content = this.asRecord(
          JSON.parse(Buffer.from(encoded, "base64").toString("utf8")),
        );
      } catch {
        continue;
      }
      if (![2, 4, 5, 8].includes(Number(content.type))) continue;
      const ids = [content.fileId, content.thumbnailFileId].filter(
        (value): value is string =>
          typeof value === "string" &&
          /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
            value,
          ),
      );
      if (ids.length === 0) continue;
      await this.prisma.storedFile.updateMany({
        where: {
          id: { in: ids },
          ownerUserId: fromUserId,
          status: "READY",
          purpose: {
            in: ["CHAT_IMAGE", "CHAT_VIDEO", "CHAT_VOICE", "CHAT_FILE"],
          },
          scope: channelType === 2 ? "GROUP" : "DIRECT",
          scopeId: channelId,
        },
        data: { referencedAt: new Date() },
      });
    }
  }

  private asJsonValue(payload: unknown): Prisma.InputJsonValue {
    if (payload === null || payload === undefined)
      return { value: String(payload) };
    return payload;
  }

  private asRecord(payload: unknown): Record<string, unknown> {
    if (!payload || typeof payload !== "object" || Array.isArray(payload))
      return {};
    return payload as Record<string, unknown>;
  }

  private readString(payload: Record<string, unknown>, keys: string[]) {
    for (const key of keys) {
      const value = payload[key];
      if (typeof value === "string" && value.length > 0) return value;
    }
    return undefined;
  }
}
