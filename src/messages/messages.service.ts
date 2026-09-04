import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { ZodError } from "zod";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";
import { PrismaService } from "../prisma/prisma.service";
import {
  RevokeImMessageDto,
  SyncImReceiptsDto,
  SyncImChannelMessagesDto,
  SyncImConversationsDto,
} from "./im-sync.dto";
import {
  MessageType,
  messageProtocolDescriptor,
  messageSchema,
} from "./message-protocol";

@Injectable()
export class MessagesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wukong: WuKongImService,
  ) {}

  describeProtocol() {
    return messageProtocolDescriptor;
  }

  validate(payload: unknown) {
    try {
      return { valid: true, message: messageSchema.parse(payload) };
    } catch (error) {
      if (error instanceof ZodError) {
        throw new BadRequestException({
          message: "Invalid message payload",
          issues: error.issues.map((issue) => ({
            path: issue.path.join("."),
            message: issue.message,
          })),
        });
      }
      throw error;
    }
  }

  async syncConversations(userId: string, input: SyncImConversationsDto) {
    const [raw, friendships, memberships, readCursors] = await Promise.all([
      this.wukong.syncConversations({
        userId,
        lastMsgSeqs: input.lastMsgSeqs,
        msgCount: input.msgCount,
        version: input.version,
      }),
      this.prisma.friendship.findMany({
        where: {
          status: "ACCEPTED",
          OR: [{ requesterId: userId }, { addresseeId: userId }],
        },
        select: { requesterId: true, addresseeId: true },
      }),
      this.prisma.groupMember.findMany({
        where: { userId, status: "ACTIVE", group: { status: "ACTIVE" } },
        select: { groupId: true },
      }),
      this.prisma.messageReadCursor.findMany({
        where: { userId },
        select: { channelId: true, channelType: true, lastMessageSeq: true },
      }),
    ]);
    const personalIds = new Set(
      friendships.map((item) =>
        item.requesterId === userId ? item.addresseeId : item.requesterId,
      ),
    );
    const groupIds = new Set(memberships.map((item) => item.groupId));
    const cursors = new Map(
      readCursors.map((item) => [
        `${item.channelType}:${item.channelId}`,
        item.lastMessageSeq,
      ]),
    );
    const rows = Array.isArray(raw) ? raw : [];
    return rows
      .filter((item) => {
        const row = this.asRecord(item);
        const type = Number(row.channel_type);
        const id = this.asString(row.channel_id);
        return type === 1
          ? personalIds.has(id)
          : type === 2 && groupIds.has(id);
      })
      .map((item) => {
        const conversation = this.normalizeConversation(this.asRecord(item));
        const cursor = cursors.get(
          `${Number(conversation.channel_type)}:${this.asString(conversation.channel_id)}`,
        );
        const lastSequence = this.asBigInt(conversation.last_msg_seq);
        return cursor !== undefined && cursor >= lastSequence
          ? { ...conversation, unread: 0 }
          : conversation;
      });
  }

  async syncChannelMessages(userId: string, input: SyncImChannelMessagesDto) {
    await this.assertCanReadChannel(userId, input.channelId, input.channelType);
    const raw = this.asRecord(
      await this.wukong.syncChannelMessages({
        userId,
        channelId: input.channelId,
        channelType: input.channelType,
        startMessageSeq: input.startMessageSeq,
        endMessageSeq: input.endMessageSeq,
        limit: input.limit,
        pullMode: input.pullMode,
      }),
    );
    return {
      start_message_seq: Number(raw.start_message_seq ?? 0),
      end_message_seq: Number(raw.end_message_seq ?? 0),
      more: Number(raw.more ?? 0),
      messages: Array.isArray(raw.messages)
        ? raw.messages.map((item) => this.normalizeMessage(this.asRecord(item)))
        : [],
    };
  }

  async markConversationRead(
    userId: string,
    channelId: string,
    channelType: 1 | 2,
    messageSeq: number,
  ) {
    await this.assertCanReadChannel(userId, channelId, channelType);
    if (messageSeq > 0) {
      await this.prisma.$executeRaw`
        INSERT INTO message_read_cursors
          (user_id, channel_id, channel_type, last_message_seq, updated_at)
        VALUES
          (${userId}::uuid, ${channelId}::uuid, ${channelType}, ${BigInt(messageSeq)}, NOW())
        ON CONFLICT (user_id, channel_id, channel_type)
        DO UPDATE SET
          last_message_seq = GREATEST(
            message_read_cursors.last_message_seq,
            EXCLUDED.last_message_seq
          ),
          updated_at = NOW()
      `;
    }
    await this.wukong.clearConversationUnread(userId, channelId, channelType);
    return { success: true };
  }

  async messageReceipts(userId: string, input: SyncImReceiptsDto) {
    await this.assertCanReadChannel(userId, input.channelId, input.channelType);
    if (input.messages.length === 0) return [];

    if (input.channelType === 1) {
      const cursor = await this.prisma.messageReadCursor.findUnique({
        where: {
          userId_channelId_channelType: {
            userId: input.channelId,
            channelId: userId,
            channelType: 1,
          },
        },
        select: { lastMessageSeq: true },
      });
      const lastRead = cursor?.lastMessageSeq ?? 0n;
      return input.messages.map((message) => ({
        messageId: message.messageId,
        readCount: lastRead >= BigInt(message.messageSeq) ? 1 : 0,
        unreadCount: lastRead >= BigInt(message.messageSeq) ? 0 : 1,
      }));
    }

    const [members, cursors] = await Promise.all([
      this.prisma.groupMember.count({
        where: {
          groupId: input.channelId,
          userId: { not: userId },
          status: "ACTIVE",
          group: { status: "ACTIVE" },
        },
      }),
      this.prisma.messageReadCursor.findMany({
        where: {
          channelId: input.channelId,
          channelType: 2,
          userId: { not: userId },
          user: {
            groupMemberships: {
              some: {
                groupId: input.channelId,
                status: "ACTIVE",
                group: { status: "ACTIVE" },
              },
            },
          },
        },
        select: { lastMessageSeq: true },
      }),
    ]);
    return input.messages.map((message) => {
      const sequence = BigInt(message.messageSeq);
      const readCount = cursors.reduce(
        (count, cursor) => count + (cursor.lastMessageSeq >= sequence ? 1 : 0),
        0,
      );
      return {
        messageId: message.messageId,
        readCount,
        unreadCount: Math.max(0, members - readCount),
      };
    });
  }

  async revokeMessage(userId: string, input: RevokeImMessageDto) {
    await this.assertCanReadChannel(userId, input.channelId, input.channelType);
    const original = this.asRecord(
      await this.wukong.findMessage({
        loginUserId: userId,
        channelId: input.channelId,
        channelType: input.channelType,
        clientMsgNo: input.clientMsgNo,
      }),
    );
    if (!this.asString(original.client_msg_no)) {
      throw new NotFoundException("Message not found");
    }
    if (this.asString(original.from_uid) !== userId) {
      throw new ForbiddenException("Only the sender can revoke a message");
    }
    const timestamp = Number(original.timestamp ?? 0);
    const now = Math.floor(Date.now() / 1000);
    if (timestamp <= 0 || now - timestamp > 120) {
      throw new ForbiddenException("The revoke window has expired");
    }
    await this.wukong.sendChannelMessage({
      fromUserId: userId,
      channelId: input.channelId,
      channelType: input.channelType,
      payload: {
        type: MessageType.REVOKE,
        originalClientMsgNo: input.clientMsgNo,
      },
    });
    return { success: true };
  }

  private async assertCanReadChannel(
    userId: string,
    channelId: string,
    channelType: 1 | 2,
  ) {
    const allowed =
      channelType === 1
        ? await this.prisma.friendship.findFirst({
            where: {
              status: "ACCEPTED",
              OR: [
                { requesterId: userId, addresseeId: channelId },
                { requesterId: channelId, addresseeId: userId },
              ],
            },
            select: { id: true },
          })
        : await this.prisma.groupMember.findFirst({
            where: {
              userId,
              groupId: channelId,
              status: "ACTIVE",
              group: { status: "ACTIVE" },
            },
            select: { userId: true },
          });
    if (!allowed)
      throw new ForbiddenException("Channel history is not available");
  }

  private normalizeConversation(
    row: Record<string, unknown>,
  ): Record<string, unknown> {
    return {
      ...row,
      recents: Array.isArray(row.recents)
        ? row.recents.map((item) => this.normalizeMessage(this.asRecord(item)))
        : [],
    };
  }

  private normalizeMessage(row: Record<string, unknown>) {
    const payload =
      typeof row.payload === "string"
        ? this.decodePayload(row.payload)
        : row.payload;
    return {
      ...row,
      message_id: this.asString(row.message_idstr ?? row.message_id),
      payload,
    };
  }

  private decodePayload(encoded: string): unknown {
    try {
      return JSON.parse(
        Buffer.from(encoded, "base64").toString("utf8"),
      ) as unknown;
    } catch {
      return { type: -1, content: "[无法解析的消息]" };
    }
  }

  private asRecord(value: unknown): Record<string, unknown> {
    return value && typeof value === "object"
      ? (value as Record<string, unknown>)
      : {};
  }

  private asString(value: unknown) {
    return typeof value === "string" || typeof value === "number"
      ? `${value}`
      : "";
  }

  private asBigInt(value: unknown) {
    try {
      return BigInt(this.asString(value) || "0");
    } catch {
      return 0n;
    }
  }
}
