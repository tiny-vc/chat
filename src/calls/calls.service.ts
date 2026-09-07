import {
  BadRequestException,
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
import { CallHistoryPageDto } from "./dto/call-history-page.dto";
import {
  MessageType,
  callSignalMessageSchema,
} from "../messages/message-protocol";

const CALL_MAINTENANCE_JOB = "maintenance.calls";

@Injectable()
export class CallsService implements OnApplicationBootstrap, OnModuleDestroy {
  private readonly logger = new Logger(CallsService.name);
  private timer?: NodeJS.Timeout;
  private sweeping = false;
  private static readonly inviteTimeoutMs = 45_000;
  private static readonly mediaGraceMs = 90_000;

  private publicCall<
    T extends {
      initiatorSessionId?: string | null;
      targetSessionId?: string | null;
    },
  >(call: T): Omit<T, "initiatorSessionId" | "targetSessionId"> {
    const { initiatorSessionId, targetSessionId, ...publicCall } = call;
    void initiatorSessionId;
    void targetSessionId;
    return publicCall;
  }

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
      await this.prisma.$transaction(
        async (tx) => {
          const [lock] = await tx.$queryRaw<Array<{ acquired: boolean }>>`
            SELECT pg_try_advisory_xact_lock(hashtext(${CALL_MAINTENANCE_JOB})) AS acquired
          `;
          if (!lock?.acquired) return;
          await this.expireInvitations(undefined, tx);
          await this.reconcileMediaSessions(tx);
        },
        { timeout: 120_000 },
      );
    } catch {
      this.logger.warn("Call maintenance failed; will retry on the next sweep");
    } finally {
      this.sweeping = false;
    }
  }

  async expireInvitations(
    participants?: string[],
    db: Prisma.TransactionClient | PrismaService = this.prisma,
  ) {
    const now = new Date();
    return db.callSession.updateMany({
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

  async reconcileMediaSessions(
    db: Prisma.TransactionClient | PrismaService = this.prisma,
  ) {
    const calls = await db.callSession.findMany({
      where: { status: { in: ["ACCEPTED", "CONNECTED"] } },
      select: {
        id: true,
        initiatorUserId: true,
        targetUserId: true,
        livekitRoomName: true,
        type: true,
        mediaMissingSince: true,
      },
    });
    for (const call of calls) {
      try {
        const participants = await this.liveKit.participantIdentities(
          call.livekitRoomName,
        );
        if (
          this.hasUserParticipant(participants, call.initiatorUserId) &&
          call.targetUserId &&
          this.hasUserParticipant(participants, call.targetUserId)
        ) {
          if (call.mediaMissingSince) {
            await db.callSession.updateMany({
              where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
              data: { mediaMissingSince: null },
            });
          }
          continue;
        }
        const now = Date.now();
        const missingAt = call.mediaMissingSince?.getTime();
        if (missingAt === undefined) {
          await db.callSession.updateMany({
            where: {
              id: call.id,
              status: { in: ["ACCEPTED", "CONNECTED"] },
              mediaMissingSince: null,
            },
            data: { mediaMissingSince: new Date(now) },
          });
          continue;
        }
        if (now - missingAt < CallsService.mediaGraceMs) continue;
        const result = await db.callSession.updateMany({
          where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
          data: {
            status: "ENDED",
            endedAt: new Date(now),
            endReason: "MEDIA_DISCONNECTED",
            mediaMissingSince: null,
          },
        });
        if (!result.count) continue;
        await this.liveKit
          .deleteRoom(call.livekitRoomName)
          .catch(() => undefined);
        if (call.targetUserId) {
          await Promise.all([
            this.sendSignal(
              call,
              call.initiatorUserId,
              call.targetUserId,
              "end",
            ).catch(() => undefined),
            this.sendSignal(
              call,
              call.targetUserId,
              call.initiatorUserId,
              "end",
            ).catch(() => undefined),
          ]);
        }
      } catch {
        // Require a fresh grace window after an unobservable interval.
        await db.callSession
          .updateMany({
            where: { id: call.id, status: { in: ["ACCEPTED", "CONNECTED"] } },
            data: { mediaMissingSince: null },
          })
          .catch(() => undefined);
        this.logger.warn(
          "Unable to reconcile call media; preserving active state",
        );
      }
    }
  }

  async endFromMedia(roomName: string) {
    const call = await this.prisma.callSession.findUnique({
      where: { livekitRoomName: roomName },
    });
    if (!call || !call.targetUserId) return false;

    let shouldNotify =
      call.status === "ENDED" && call.endReason === "MEDIA_DISCONNECTED";
    if (["ACCEPTED", "CONNECTED"].includes(call.status)) {
      const result = await this.prisma.callSession.updateMany({
        where: {
          id: call.id,
          status: { in: ["ACCEPTED", "CONNECTED"] },
        },
        data: {
          status: "ENDED",
          endedAt: new Date(),
          endReason: "MEDIA_DISCONNECTED",
        },
      });
      shouldNotify = result.count > 0;
    }
    if (!shouldNotify) return false;

    // Send in both directions so every device of both accounts receives the
    // authoritative terminal state. Re-delivery is intentionally harmless.
    await Promise.all([
      this.sendSignal(call, call.initiatorUserId, call.targetUserId, "end"),
      this.sendSignal(call, call.targetUserId, call.initiatorUserId, "end"),
    ]);
    return true;
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

  async create(
    initiatorUserId: string,
    initiatorSessionId: string,
    input: CreateCallDto,
  ) {
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
        initiatorSessionId,
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
      return this.publicCall(await this.requireCall(call.id));
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

  async list(userId: string, page: CallHistoryPageDto = {}) {
    await this.expireInvitations([userId]);
    if (Boolean(page.before) !== Boolean(page.beforeId)) {
      throw new BadRequestException(
        "before and beforeId must be supplied together",
      );
    }
    const before = page.before ? new Date(page.before) : null;
    if (before && !Number.isFinite(before.getTime())) {
      throw new BadRequestException("Invalid before");
    }
    const calls = await this.prisma.callSession.findMany({
      where: {
        AND: [
          { OR: [{ initiatorUserId: userId }, { targetUserId: userId }] },
          ...(before && page.beforeId
            ? [
                {
                  OR: [
                    { startedAt: { lt: before } },
                    { startedAt: before, id: { lt: page.beforeId } },
                  ],
                },
              ]
            : []),
        ],
      },
      orderBy: [{ startedAt: "desc" }, { id: "desc" }],
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
    return calls.map((call) => {
      const publicCall = this.publicCall(call);
      return {
        ...publicCall,
        outgoing: call.initiatorUserId === userId,
        peer:
          usersById.get(
            call.initiatorUserId === userId
              ? call.targetUserId!
              : call.initiatorUserId,
          ) ?? null,
      };
    });
  }

  async get(callId: string, userId: string) {
    return this.publicCall(await this.requireParticipant(callId, userId));
  }

  async createToken(callId: string, userId: string, sessionId: string) {
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
    if (
      call.targetUserId === userId &&
      !["ACCEPTED", "CONNECTED"].includes(call.status)
    ) {
      throw new ForbiddenException(
        "The recipient must accept before joining media",
      );
    }
    const assignedSessionId =
      call.initiatorUserId === userId
        ? call.initiatorSessionId
        : call.targetSessionId;
    if (assignedSessionId !== sessionId) {
      throw new ForbiddenException("Call belongs to another device session");
    }
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { nickname: true },
    });
    return this.liveKit.createJoinToken({
      roomName: call.livekitRoomName,
      userId,
      sessionId,
      displayName: user.nickname,
      callType: call.type,
    });
  }

  async accept(callId: string, userId: string, sessionId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can accept");
    if (["ACCEPTED", "CONNECTED"].includes(call.status)) {
      if (call.targetSessionId !== sessionId) {
        throw new ForbiddenException("Call was accepted on another device");
      }
      // Safe retry when the original HTTP response or accept signal was lost.
      await Promise.all([
        this.sendSignal(call, userId, call.initiatorUserId, "accept"),
        this.sendSignal(call, userId, userId, "answered_elsewhere"),
      ]);
      return this.publicCall(call);
    }
    if (!["INVITING", "RINGING"].includes(call.status)) {
      throw new ForbiddenException(
        "Call cannot be accepted in its current state",
      );
    }
    const updated = await this.transitionInvitation(call.id, {
      status: "ACCEPTED",
      answeredAt: new Date(),
      targetSessionId: sessionId,
    });
    await Promise.all([
      this.sendSignal(updated, userId, call.initiatorUserId, "accept"),
      this.sendSignal(updated, userId, userId, "answered_elsewhere"),
    ]);
    return this.publicCall(updated);
  }

  async reject(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can reject");
    if (call.status === "REJECTED" && call.endReason === "REJECTED") {
      await this.sendSignal(call, userId, call.initiatorUserId, "reject");
      return this.publicCall(call);
    }
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
    return this.publicCall(updated);
  }

  async busy(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.targetUserId !== userId)
      throw new ForbiddenException("Only the recipient can be busy");
    if (call.status === "REJECTED" && call.endReason === "BUSY") {
      await this.sendSignal(call, userId, call.initiatorUserId, "busy");
      return this.publicCall(call);
    }
    if (!["INVITING", "RINGING"].includes(call.status))
      return this.publicCall(call);
    const updated = await this.transitionInvitation(call.id, {
      status: "REJECTED",
      endedAt: new Date(),
      endReason: "BUSY",
    });
    await this.sendSignal(updated, userId, call.initiatorUserId, "busy");
    return this.publicCall(updated);
  }

  async cancel(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.initiatorUserId !== userId)
      throw new ForbiddenException("Only the caller can cancel");
    if (call.status === "CANCELLED") {
      await this.sendSignal(call, userId, call.targetUserId!, "cancel");
      return this.publicCall(call);
    }
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
    return this.publicCall(updated);
  }

  async miss(callId: string, userId: string) {
    const call = await this.requireCall(callId);
    if (call.initiatorUserId !== userId) {
      throw new ForbiddenException("Only the caller can mark a call as missed");
    }
    if (call.status === "MISSED") {
      await this.sendSignal(call, userId, call.targetUserId!, "miss");
      return this.publicCall(call);
    }
    if (!["INVITING", "RINGING"].includes(call.status))
      return this.publicCall(call);
    const updated = await this.transitionInvitation(call.id, {
      status: "MISSED",
      endedAt: new Date(),
      endReason: "NO_ANSWER",
    });
    await this.sendSignal(updated, userId, call.targetUserId!, "miss");
    return this.publicCall(updated);
  }

  async end(callId: string, userId: string) {
    let call = await this.requireParticipant(callId, userId);
    if (await this.resendTerminalEndSignal(call, userId))
      return this.publicCall(call);

    // A caller leaving an unanswered invitation is a cancellation. Keep this
    // as a separate conditional update: if acceptance wins concurrently, the
    // update affects zero rows and we continue below as an active hangup.
    if (
      call.initiatorUserId === userId &&
      ["INVITING", "RINGING"].includes(call.status)
    ) {
      const cancelled = await this.prisma.callSession.updateMany({
        where: { id: call.id, status: { in: ["INVITING", "RINGING"] } },
        data: {
          status: "CANCELLED",
          endedAt: new Date(),
          endReason: "CANCELLED",
        },
      });
      if (cancelled.count) {
        const updated = await this.requireCall(call.id);
        await this.liveKit
          .deleteRoom(call.livekitRoomName)
          .catch(() => undefined);
        await this.sendSignal(updated, userId, call.targetUserId!, "cancel");
        return this.publicCall(updated);
      }
      call = await this.requireCall(call.id);
      if (await this.resendTerminalEndSignal(call, userId))
        return this.publicCall(call);
    }

    const activeStatuses = ["ACCEPTED", "CONNECTED"] as const;
    if (!(activeStatuses as readonly string[]).includes(call.status)) {
      throw new ForbiddenException("Call is not active");
    }
    const result = await this.prisma.callSession.updateMany({
      where: { id: call.id, status: { in: [...activeStatuses] } },
      data: { status: "ENDED", endedAt: new Date(), endReason: "HANGUP" },
    });
    const updated = await this.requireCall(call.id);
    if (!result.count) return this.publicCall(updated);
    await this.liveKit.deleteRoom(call.livekitRoomName).catch(() => undefined);
    const recipient =
      userId === call.initiatorUserId
        ? call.targetUserId!
        : call.initiatorUserId;
    await this.sendSignal(updated, userId, recipient, "end");
    return this.publicCall(updated);
  }

  private async resendTerminalEndSignal(
    call: {
      id: string;
      status: string;
      endReason: string | null;
      initiatorUserId: string;
      targetUserId: string | null;
      type: string;
      livekitRoomName: string;
    },
    userId: string,
  ) {
    const terminal = [
      "REJECTED",
      "CANCELLED",
      "MISSED",
      "ENDED",
      "FAILED",
    ].includes(call.status);
    if (!terminal) return false;

    if (
      call.status === "CANCELLED" &&
      call.initiatorUserId === userId &&
      call.targetUserId
    ) {
      await this.sendSignal(call, userId, call.targetUserId, "cancel");
    } else if (call.status === "ENDED" && call.targetUserId) {
      const recipient =
        userId === call.initiatorUserId
          ? call.targetUserId
          : call.initiatorUserId;
      await this.sendSignal(call, userId, recipient, "end");
    }
    return true;
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

  hasUserParticipant(identities: string[], userId: string) {
    const prefix = `${userId}:`;
    return identities.some((identity) => identity.startsWith(prefix));
  }
}
