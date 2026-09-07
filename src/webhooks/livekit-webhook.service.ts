import { Injectable, UnauthorizedException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { Prisma } from "@prisma/client";
import { WebhookReceiver } from "livekit-server-sdk";
import { LiveKitService } from "../integrations/livekit/livekit.service";
import { PrismaService } from "../prisma/prisma.service";
import { CallsService } from "../calls/calls.service";

@Injectable()
export class LivekitWebhookService {
  private readonly receiver: WebhookReceiver;

  constructor(
    config: ConfigService,
    private readonly prisma: PrismaService,
    private readonly livekit: LiveKitService,
    private readonly calls: CallsService,
  ) {
    this.receiver = new WebhookReceiver(
      config.getOrThrow<string>("LIVEKIT_API_KEY"),
      config.getOrThrow<string>("LIVEKIT_API_SECRET"),
    );
  }

  async receive(rawBody: string, authorization: string | undefined) {
    let event;
    try {
      event = await this.receiver.receive(rawBody, authorization);
    } catch {
      throw new UnauthorizedException("Invalid LiveKit webhook signature");
    }
    if (!event.id)
      throw new UnauthorizedException("Invalid LiveKit webhook event");

    const eventKey = `${event.event}:${event.id}`;
    const existing = await this.prisma.webhookEvent.findUnique({
      where: { eventKey },
      select: { processedAt: true, processingStartedAt: true },
    });
    if (existing?.processedAt) return { accepted: true, duplicate: true };

    const claimedAt = new Date();
    let claimed = false;
    if (!existing) {
      try {
        await this.prisma.webhookEvent.create({
          data: {
            source: "livekit",
            eventKey,
            eventType: event.event,
            payload: event.toJson() as Prisma.InputJsonValue,
            processingStartedAt: claimedAt,
          },
        });
        claimed = true;
      } catch (error) {
        if (
          !(error instanceof Prisma.PrismaClientKnownRequestError) ||
          error.code !== "P2002"
        ) {
          throw error;
        }
      }
    } else {
      const staleBefore = new Date(claimedAt.getTime() - 5 * 60_000);
      const claim = await this.prisma.webhookEvent.updateMany({
        where: {
          eventKey,
          processedAt: null,
          OR: [
            { processingStartedAt: null },
            { processingStartedAt: { lt: staleBefore } },
          ],
        },
        data: { processingStartedAt: claimedAt },
      });
      claimed = claim.count === 1;
    }
    if (!claimed) return { accepted: true, duplicate: true };

    try {
      const roomName = event.room?.name;
      if (roomName?.startsWith("call_") && event.event === "room_started") {
        const call = await this.prisma.callSession.findUnique({
          where: { livekitRoomName: roomName },
          select: { status: true },
        });
        const active =
          call &&
          ["INVITING", "RINGING", "ACCEPTED", "CONNECTED"].includes(
            call.status,
          );
        if (!active) await this.livekit.deleteRoom(roomName);
      } else if (roomName && event.event === "participant_joined") {
        const call = await this.prisma.callSession.findUnique({
          where: { livekitRoomName: roomName },
          select: {
            id: true,
            status: true,
            initiatorUserId: true,
            targetUserId: true,
          },
        });
        if (call?.status === "ACCEPTED" && call.targetUserId) {
          const participants =
            await this.livekit.participantIdentities(roomName);
          if (
            this.calls.hasUserParticipant(participants, call.initiatorUserId) &&
            this.calls.hasUserParticipant(participants, call.targetUserId)
          ) {
            await this.prisma.callSession.updateMany({
              where: { id: call.id, status: "ACCEPTED" },
              data: { status: "CONNECTED" },
            });
          }
        }
      } else if (roomName && event.event === "room_finished") {
        await this.calls.endFromMedia(roomName);
      }

      await this.prisma.webhookEvent.update({
        where: { eventKey },
        data: { processedAt: new Date(), processingStartedAt: null },
      });
      return { accepted: true, duplicate: false };
    } catch (error) {
      await this.prisma.webhookEvent
        .updateMany({
          where: {
            eventKey,
            processedAt: null,
            processingStartedAt: claimedAt,
          },
          data: { processingStartedAt: null },
        })
        .catch(() => undefined);
      throw error;
    }
  }
}
