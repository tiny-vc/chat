import { randomUUID } from "node:crypto";
import { BadRequestException } from "@nestjs/common";
import {
  callSignalMessageSchema,
  MessageType,
  messageSchema,
} from "../src/messages/message-protocol";
import { MessagesService } from "../src/messages/messages.service";

const base = () => ({
  version: 1 as const,
  clientMsgNo: randomUUID(),
  sentAt: Date.now(),
});

describe("message protocol", () => {
  it.each(["busy", "miss"])("accepts the %s terminal call action", (action) => {
    expect(() =>
      callSignalMessageSchema.parse({
        ...base(),
        type: MessageType.CALL_SIGNAL,
        callId: randomUUID(),
        callType: "audio",
        action,
        roomName: "call_room",
      }),
    ).not.toThrow();
  });

  it.each([
    { ...base(), type: MessageType.TEXT, text: "hello" },
    {
      ...base(),
      type: MessageType.IMAGE,
      fileId: randomUUID(),
      width: 800,
      height: 600,
    },
    {
      ...base(),
      type: MessageType.FILE,
      fileId: randomUUID(),
      name: "report.pdf",
      size: 1024,
      mimeType: "application/pdf",
    },
    {
      ...base(),
      type: MessageType.AUDIO,
      fileId: randomUUID(),
      durationMs: 2000,
      size: 4096,
      mimeType: "audio/mp4",
    },
    {
      ...base(),
      type: MessageType.VIDEO,
      fileId: randomUUID(),
      thumbnailFileId: randomUUID(),
      durationMs: 3000,
      width: 1920,
      height: 1080,
    },
    {
      ...base(),
      type: MessageType.STICKER,
      packId: "default",
      stickerId: "smile",
    },
    {
      ...base(),
      type: MessageType.CALL_SIGNAL,
      callId: randomUUID(),
      callType: "video",
      action: "invite",
      roomName: "call_room",
    },
    { ...base(), type: MessageType.REVOKE, originalClientMsgNo: randomUUID() },
    {
      ...base(),
      type: MessageType.SYSTEM,
      event: "group.member_joined",
      data: { count: 1 },
    },
  ])("accepts message type $type", (payload) => {
    expect(messageSchema.parse(payload)).toMatchObject(payload);
  });

  it("returns field-level validation errors", () => {
    const service = new MessagesService({} as never, {} as never);
    expect(() =>
      service.validate({ ...base(), type: MessageType.TEXT, text: "" }),
    ).toThrow(BadRequestException);
  });

  it("accepts a video without a poster for codecs lacking frame extraction", () => {
    expect(() =>
      messageSchema.parse({
        ...base(),
        type: MessageType.VIDEO,
        fileId: randomUUID(),
        durationMs: 3000,
        width: 1280,
        height: 720,
        name: "clip.mov",
        size: 1024,
      }),
    ).not.toThrow();
  });

  it("drops unknown fields for forward-compatible additions", () => {
    const result = messageSchema.parse({
      ...base(),
      type: MessageType.TEXT,
      text: "hello",
      futureField: true,
    });
    expect(result).not.toHaveProperty("futureField");
  });
});
