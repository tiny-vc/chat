import {
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
  Logger,
  OnApplicationBootstrap,
  OnModuleDestroy,
} from "@nestjs/common";
import { Prisma } from "@prisma/client";
import { randomUUID } from "node:crypto";
import { PrismaService } from "../prisma/prisma.service";
import { LiveKitService } from "../integrations/livekit/livekit.service";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";
import { FriendsService } from "../friends/friends.service";
import { CreateCallDto } from "./dto/create-call.dto";
import {
  MessageType,
  callSignalMessageSchema,
} from "../messages/message-protocol";

@Injectable()
export class CallsService implements OnApplicationBootstrap, OnModuleDestroy {
  private readonly logger = new Logger(CallsService.name);
  private timer?: NodeJS.Timeout;
  private sweeping = false;
  private static readonly inviteTimeoutMs = 45_000;
  private static readonly mediaGraceMs = 90_000;
  private readonly missingSince = new Map<string, number>();
  constructor(
    private readonly prisma: PrismaService,
    private readonly liveKit: LiveKitService,
    private readonly wuKongIm: WuKongImService,
    private readonly friends: FriendsService,
  ) {}

  onApplicationBootstrap() {
    void this.sweep();
    this.timer = setInterval(() => void this.sweep(), 15_000);
    this.timer.unref();
  }

  onModuleDestroy() {
    if (this.timer) clearInterval(this.timer);
  }

  private async sweep() {
    if (this.sweeping) return;
    this.sweeping = true;
    try {
      await this.expireInvitations();
      await this.reconcileMediaSessions();
    } catch {
      this.logger.warn(
        "Call maintenance failed; will retry on the next sweep",
      );
    } finally {
      this.sweeping = false;
    }
  }

  async expireInvitations(participants?: string[]) {
    const now = new Date();
    return this.prisma.callSession.updateMany({
      where: {
        status: { in: ["INVITING", "RINGING"] },
        startedAt: {
          lte: new Date(now.getTime() - CallsService.inviteTimeoutMs),
        },
        ...(participants
          ? {
              OR: [
                { initiatorUserId: { in: participants } },
                { targetUserId: { in: participants } },
              ],
            }
          : {}),
      },
      data: { status: "MISSED", endedAt: now, endReason: "NO_ANSWER" },
    });
  }

  async reconcileMediaSessions() {
    const calls = await this.prisma.callSession.findMany({
      where: { status: { in: ["ACCEPTED", "CONNECTED"] } },
      select: { id: true, initiatorUserId: true, targetUserId: true,
        livekitRoomName: true, type: true },
    });
    const activeIds = new Set(calls.map((call) => call.id));
    for (const id of this.missingSince.keys()) {
      if (!activeIds.has(id)) this.missingSince.delete(id);
    }
    for (const call of calls) {
      try {
        const participants = await this.liveKit.participantIdentities(call.livekitRoomName);
        if (participants.includes(call.initiatorUserId) &&
            call.targetUserId && participants.includes(call.targetUserId)) {
          this.missingSince.delete(call.id);
          continue;
        }
        const now = Date.now();
        const missingAt = this.missingSince.get(call.id);
        if (missingAt === undefined) {
          this.missingSince.set(call.id, now);
          continue;
        }
        if (now - missingAt < CallsService.mediaGraceMs) continue;
        const result = await this.prisma.callSession.updateMany({
          where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
          data: { status: "ENDED", endedAt: new Date(now), endReason: "MEDIA_DISCONNECTED" },
        });
        this.missingSince.delete(call.id);
        if (!result.count) continue;
        await this.liveKit.deleteRoom(call.livekitRoomName).catch(() => undefined);
        if (call.targetUserId) {
          await Promise.all([
            this.sendSignal(call, call.initiatorUserId, call.targetUserId, "end").catch(() => undefined),
            this.sendSignal(call, call.targetUserId, call.initiatorUserId, "end").catch(() => undefined),
          ]);
        }
      } catch {
        // Require a fresh grace window after an unobservable interval.
        this.missingSince.delete(call.id);
        this.logger.warn("Unable to reconcile call media; preserving active state");
      }
    }
  }

  private async transitionInvitation(
    id: string,
    data: Prisma.CallSessionUpdateManyMutationInput,
  ) {
    const result = await this.prisma.callSession.updateMany({
      where: {
        id,
        status: { in: ["INVITING", "RINGING"] },
        startedAt: { gt: new Date(Date.now() - CallsService.inviteTimeoutMs) },
      },
      data,
    });
    if (!result.count)
      throw new ConflictException("Call invitation expired or already handled");
    return this.requireCall(id);
  }

  async create(initiatorUserId: string, input: CreateCallDto) {
    if (initiatorUserId === input.targetUserId) {
      throw new ForbiddenException("Cannot call yourself");
    }
    const target = await this.prisma.user.findFirst({
      where: { id: input.targetUserId, status: "ACTIVE" },
      select: { id: true },
    });
    if (!target) throw new NotFoundException("Target user not found");
    if (!(await this.friends.areFriends(initiatorUserId, input.targetUserId))) {
      throw new ForbiddenException("Calls are only allowed between friends");
    }

    await this.expireInvitations([initiatorUserId, input.targetUserId]);
    const active = await this.prisma.callSession.findFirst({
      where: {
        status: { in: ["INVITING", "RINGING", "ACCEPTED", "CONNECTED"] },
        OR: [
          { initiatorUserId: { in: [initiatorUserId, input.targetUserId] } },
          { targetUserId: { in: [initiatorUserId, input.targetUserId] } },
        ],
      },
      select: { id: true },
    });
    if (active)
      throw new ConflictException("One of the users is already in a call");

    const call = await this.prisma.callSession.create({
      data: {
        initiatorUserId,
        targetUserId: input.targetUserId,
        type: input.type,
        livekitRoomName: `call_${randomUUID()}`,
      },
    });
    try {
      await this.sendSignal(
        call,
        initiatorUserId,
        input.targetUserId,
        "invite",
      );
      await this.prisma.callSession.updateMany({
        where: {
          id: call.id,
          status: "INVITING",
          startedAt: {
            gt: new Date(Date.now() - CallsService.inviteTimeoutMs),
          },
        },
        data: { status: "RINGING" },
      });
      return await this.requireCall(call.id);
    } catch (error) {
      await this.prisma.callSession.updateMany({
        where: { id: call.id, status: "INVITING" },
        data: {
          status: "FAILED",
          endedAt: new Date(),
          endReason: "SIGNAL_FAILED",
        },
      });
      throw error;
    }
  }

  async list(userId: string) {
    await this.expireInvitations([userId]);
    const calls = await this.prisma.callSession.findMany({
      where: { OR: [{ initiatorUserId: userId }, { targetUserId: userId }] },
      orderBy: { startedAt: "desc" },
      take: 100,
    });
    const participantIds = [
      ...new Set(
        calls.flatMap((call) =>
          [call.initiatorUserId, call.targetUserId].filter((id): id is string =>
            Boolean(id),
          ),
        ),
      ),
    ];
    const users = await this.prisma.user.findMany({
      where: { id: { in: participantIds } },
      select: {
        id: true,
        username: true,
        nickname: true,
        avatarFileId: true,
        avatarUrl: true,
      },
    });
    const usersById = new Map(users.map((user) => [user.id, user]));
    return calls.map((call) => ({
      ...call,
      outgoing: call.initiatorUserId === userId,
      peer:
        usersById.get(
          call.initiatorUserId === userId
            ? call.targetUserId!
            : call.initiatorUserId,
        ) ?? null,
    }));
  }

  async createToken(callId: string, userId: string) {
    await this.expireInvitations([userId]);
    const call = await this.prisma.callSession.findUnique({
      where: { id: callId },
    });
    if (!call) throw new NotFoundException("Call not found");
    if (call.initiatorUserId !== userId && call.targetUserId !== userId) {
      throw new ForbiddenException("You are not a participant of this call");
    }
    if (
      ["REJECTED", "CANCELLED", "MISSED", "ENDED", "FAILED"].includes(
        call.status,
      )
    ) {
      throw new ForbiddenException("Call is no longer active");
    }
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { nickname: true },
    });
    return this.liveKit.createJoinToken({
      roomName: call.livekitRoomName,
      userId,
      displayName: user.nickname,
    });
  }

  async accept(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can accept");
    if (["ACCEPTED", "CONNECTED"].includes(call.status)) {
      // Safe retry when the original HTTP response or accept signal was lost.
      await this.sendSignal(call, userId, call.initiatorUserId, "accept");
      return call;
    }
    if (!["INVITING", "RINGING"].includes(call.status)) {
      throw new ForbiddenException(
        "Call cannot be accepted in its current state",
      );
    }
    const updated = await this.transitionInvitation(call.id, {
      status: "ACCEPTED",
      answeredAt: new Date(),
    });
    await this.sendSignal(updated, userId, call.initiatorUserId, "accept");
    return updated;
  }

  async reject(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can reject");
    if (!["INVITING", "RINGING"].includes(call.status)) {
      throw new ForbiddenException(
        "Call cannot be rejected in its current state",
      );
    }
    const updated = await this.transitionInvitation(call.id, {
      status: "REJECTED",
      endedAt: new Date(),
      endReason: "REJECTED",
    });
    await this.sendSignal(updated, userId, call.initiatorUserId, "reject");
    return updated;
  }

  async busy(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can be busy");
    if (!["INVITING", "RINGING"].includes(call.status)) return call;
    const updated = await this.transitionInvitation(call.id, {
      status: "REJECTED",
      endedAt: new Date(),
      endReason: "BUSY",
    });
    await this.sendSignal(updated, userId, call.initiatorUserId, "busy");
    return updated;
  }

  async cancel(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.initiatorUserId !== userId)
      throw new ForbiddenException("Only the caller can cancel");
    if (!["INVITING", "RINGING"].includes(call.status)) {
      throw new ForbiddenException(
        "Call cannot be cancelled in its current state",
      );
    }
    const updated = await this.transitionInvitation(call.id, {
      status: "CANCELLED",
      endedAt: new Date(),
      endReason: "CANCELLED",
    });
    await this.sendSignal(updated, userId, call.targetUserId!, "cancel");
    return updated;
  }

  async miss(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.initiatorUserId !== userId) {
      throw new ForbiddenException("Only the caller can mark a call as missed");
    }
    if (!["INVITING", "RINGING"].includes(call.status)) return call;
    const updated = await this.transitionInvitation(call.id, {
      status: "MISSED",
      endedAt: new Date(),
      endReason: "NO_ANSWER",
    });
    await this.sendSignal(updated, userId, call.targetUserId!, "miss");
    return updated;
  }

  async end(callId: string, userId: string) {
    const call = await this.requireParticipant(callId, userId);
    if (["REJECTED", "CANCELLED", "MISSED", "ENDED", "FAILED"].includes(call.status)) {
      return call;
    }
    // The caller may not have received the accept signal yet. One endpoint
    // handles hangup on either side of that race without overwriting terminal states.
    const statuses = call.initiatorUserId === userId
      ? ["INVITING", "RINGING", "ACCEPTED", "CONNECTED"] as const
      : ["ACCEPTED", "CONNECTED"] as const;
    if (!(statuses as readonly string[]).includes(call.status)) {
      throw new ForbiddenException("Call is not active");
    }
    const result = await this.prisma.callSession.updateMany({
      where: { id: call.id, status: { in: [...statuses] } },
      data: { status: "ENDED", endedAt: new Date(), endReason: "HANGUP" },
    });
    const updated = await this.requireCall(call.id);
    if (!result.count) return updated;
    this.missingSince.delete(call.id);
    await this.liveKit.deleteRoom(call.livekitRoomName).catch(() => undefined);
    const recipient =
      userId === call.initiatorUserId
        ? call.targetUserId!
        : call.initiatorUserId;
    await this.sendSignal(updated, userId, recipient, "end");
    return updated;
  }

  private async requireCall(callId: string) {
    await this.prisma.callSession.updateMany({
      where: {
        id: callId,
        status: { in: ["INVITING", "RINGING"] },
        startedAt: { lte: new Date(Date.now() - CallsService.inviteTimeoutMs) },
      },
      data: { status: "MISSED", endedAt: new Date(), endReason: "NO_ANSWER" },
    });
    const call = await this.prisma.callSession.findUnique({
      where: { id: callId },
    });
    if (!call) throw new NotFoundException("Call not found");
    return call;
  }

  private async requireParticipant(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.initiatorUserId !== userId && call.targetUserId !== userId) {
      throw new ForbiddenException("You are not a participant of this call");
    }
    return call;
  }

  private sendSignal(
    call: { id: string; type: string; livekitRoomName: string },
    fromUserId: string,
    toUserId: string,
    action: string,
  ) {
    return this.wuKongIm.sendPersonalMessage({
      fromUserId,
      toUserId,
      payload: callSignalMessageSchema.parse({
        type: MessageType.CALL_SIGNAL,
        version: 1,
        clientMsgNo: randomUUID(),
        sentAt: Date.now(),
        callId: call.id,
        callType: call.type.toLowerCase(),
        action,
        roomName: call.livekitRoomName,
      }),
    });
  }
}
