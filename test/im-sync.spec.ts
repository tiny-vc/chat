import { ForbiddenException } from "@nestjs/common";
import { MessagesService } from "../src/messages/messages.service";

describe("IM synchronization", () => {
  const userId = "00000000-0000-4000-8000-000000000001";
  const friendId = "00000000-0000-4000-8000-000000000002";
  const groupId = "00000000-0000-4000-8000-000000000003";

  it("filters conversations to authorized friends and groups and decodes payloads", async () => {
    const prisma = {
      friendship: {
        findMany: jest
          .fn()
          .mockResolvedValue([{ requesterId: userId, addresseeId: friendId }]),
      },
      groupMember: {
        findMany: jest.fn().mockResolvedValue([{ groupId }]),
      },
      messageReadCursor: { findMany: jest.fn().mockResolvedValue([]) },
    };
    const message = {
      message_id: 123,
      message_idstr: "9007199254740993123",
      channel_id: friendId,
      channel_type: 1,
      payload: Buffer.from(
        JSON.stringify({ type: 1, content: "hello" }),
      ).toString("base64"),
    };
    const wukong = {
      syncConversations: jest.fn().mockResolvedValue([
        { channel_id: friendId, channel_type: 1, recents: [message] },
        { channel_id: groupId, channel_type: 2, recents: [] },
        { channel_id: "not-a-friend", channel_type: 1, recents: [] },
      ]),
    };
    const service = new MessagesService(prisma as never, wukong as never);

    const result = await service.syncConversations(userId, {
      lastMsgSeqs: "",
      msgCount: 20,
      version: 0,
    });

    expect(result).toHaveLength(2);
    const first = result[0] as { recents: Record<string, unknown>[] };
    expect(first.recents[0]).toMatchObject({
      message_id: "9007199254740993123",
      payload: { type: 1, content: "hello" },
    });
  });

  it("uses the durable read cursor to clear unread on another device", async () => {
    const prisma = {
      friendship: {
        findMany: jest
          .fn()
          .mockResolvedValue([{ requesterId: userId, addresseeId: friendId }]),
      },
      groupMember: { findMany: jest.fn().mockResolvedValue([]) },
      messageReadCursor: {
        findMany: jest
          .fn()
          .mockResolvedValue([
            { channelId: friendId, channelType: 1, lastMessageSeq: 12n },
          ]),
      },
    };
    const wukong = {
      syncConversations: jest.fn().mockResolvedValue([
        {
          channel_id: friendId,
          channel_type: 1,
          last_msg_seq: 12,
          unread: 5,
          recents: [],
        },
      ]),
    };
    const service = new MessagesService(prisma as never, wukong as never);

    const result = await service.syncConversations(userId, {
      lastMsgSeqs: "",
      msgCount: 20,
      version: 0,
    });
    expect((result[0] as Record<string, unknown>).unread).toBe(0);
  });

  it("refuses message history for an unauthorized personal channel", async () => {
    const prisma = {
      friendship: { findFirst: jest.fn().mockResolvedValue(null) },
      groupMember: { findFirst: jest.fn() },
    };
    const wukong = { syncChannelMessages: jest.fn() };
    const service = new MessagesService(prisma as never, wukong as never);

    await expect(
      service.syncChannelMessages(userId, {
        channelId: friendId,
        channelType: 1,
        startMessageSeq: 0,
        endMessageSeq: 0,
        limit: 50,
        pullMode: 0,
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(wukong.syncChannelMessages).not.toHaveBeenCalled();
  });

  it("allows an active group member to synchronize message history", async () => {
    const prisma = {
      friendship: { findFirst: jest.fn() },
      groupMember: { findFirst: jest.fn().mockResolvedValue({ userId }) },
    };
    const wukong = {
      syncChannelMessages: jest.fn().mockResolvedValue({
        start_message_seq: 0,
        end_message_seq: 0,
        more: 0,
        messages: [],
      }),
      clearConversationUnread: jest.fn().mockResolvedValue(undefined),
    };
    const service = new MessagesService(prisma as never, wukong as never);

    const result = await service.syncChannelMessages(userId, {
      channelId: groupId,
      channelType: 2,
      startMessageSeq: 0,
      endMessageSeq: 0,
      limit: 50,
      pullMode: 0,
    });

    expect(result).toEqual({
      start_message_seq: 0,
      end_message_seq: 0,
      more: 0,
      messages: [],
    });
    await expect(
      service.markConversationRead(userId, groupId, 2, 0),
    ).resolves.toEqual({
      success: true,
    });
    expect(wukong.clearConversationUnread).toHaveBeenCalledWith(
      userId,
      groupId,
      2,
    );
  });

  it("reports personal messages read from the recipient cursor", async () => {
    const prisma = {
      friendship: {
        findFirst: jest.fn().mockResolvedValue({ id: "friendship-1" }),
      },
      groupMember: { findFirst: jest.fn() },
      messageReadCursor: {
        findUnique: jest.fn().mockResolvedValue({ lastMessageSeq: 8n }),
      },
    };
    const service = new MessagesService(prisma as never, {} as never);

    await expect(
      service.messageReceipts(userId, {
        channelId: friendId,
        channelType: 1,
        messages: [
          { messageId: "m7", messageSeq: 7 },
          { messageId: "m9", messageSeq: 9 },
        ],
      }),
    ).resolves.toEqual([
      { messageId: "m7", readCount: 1, unreadCount: 0 },
      { messageId: "m9", readCount: 0, unreadCount: 1 },
    ]);
  });

  it("counts active group member read cursors", async () => {
    const prisma = {
      friendship: { findFirst: jest.fn() },
      groupMember: {
        findFirst: jest.fn().mockResolvedValue({ userId }),
        count: jest.fn().mockResolvedValue(3),
      },
      messageReadCursor: {
        findMany: jest
          .fn()
          .mockResolvedValue([{ lastMessageSeq: 10n }, { lastMessageSeq: 6n }]),
      },
    };
    const service = new MessagesService(prisma as never, {} as never);

    await expect(
      service.messageReceipts(userId, {
        channelId: groupId,
        channelType: 2,
        messages: [{ messageId: "m8", messageSeq: 8 }],
      }),
    ).resolves.toEqual([{ messageId: "m8", readCount: 1, unreadCount: 2 }]);
  });

  it("validates ownership before sending a revoke event", async () => {
    const clientMsgNo = "original-client-message";
    const prisma = {
      friendship: {
        findFirst: jest.fn().mockResolvedValue({ id: "friendship-1" }),
      },
      groupMember: { findFirst: jest.fn() },
    };
    const wukong = {
      findMessage: jest.fn().mockResolvedValue({
        client_msg_no: clientMsgNo,
        from_uid: userId,
        timestamp: Math.floor(Date.now() / 1000),
      }),
      sendChannelMessage: jest.fn().mockResolvedValue(undefined),
    };
    const service = new MessagesService(prisma as never, wukong as never);

    await expect(
      service.revokeMessage(userId, {
        channelId: friendId,
        channelType: 1,
        clientMsgNo,
      }),
    ).resolves.toEqual({ success: true });
    expect(wukong.sendChannelMessage).toHaveBeenCalledWith({
      fromUserId: userId,
      channelId: friendId,
      channelType: 1,
      payload: { type: 9001, originalClientMsgNo: clientMsgNo },
    });
  });

  it("rejects revoking another user message", async () => {
    const prisma = {
      friendship: {
        findFirst: jest.fn().mockResolvedValue({ id: "friendship-1" }),
      },
      groupMember: { findFirst: jest.fn() },
    };
    const wukong = {
      findMessage: jest.fn().mockResolvedValue({
        client_msg_no: "other-message",
        from_uid: friendId,
        timestamp: Math.floor(Date.now() / 1000),
      }),
      sendChannelMessage: jest.fn(),
    };
    const service = new MessagesService(prisma as never, wukong as never);

    await expect(
      service.revokeMessage(userId, {
        channelId: friendId,
        channelType: 1,
        clientMsgNo: "other-message",
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);
    expect(wukong.sendChannelMessage).not.toHaveBeenCalled();
  });
});
