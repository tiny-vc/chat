import {
  BadGatewayException,
  ConflictException,
  ForbiddenException,
} from "@nestjs/common";
import { FilesService } from "../src/files/files.service";
import { UsersService } from "../src/users/users.service";

describe("media asset rules", () => {
  it("accepts only matching audio and video container families", () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    const matches = (
      service as unknown as {
        mediaTypeMatches: (mime: string, container: string) => boolean;
      }
    ).mediaTypeMatches.bind(service);
    expect(matches("video/quicktime", "iso-bmff")).toBe(true);
    expect(matches("audio/mp4", "iso-bmff")).toBe(true);
    expect(matches("video/webm", "ebml")).toBe(true);
    expect(matches("video/mp4", "mpeg-audio")).toBe(false);
    expect(matches("application/octet-stream", "iso-bmff")).toBe(false);
  });

  it("rejects video containers that are not portable across mobile clients", () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    const validate = (
      service as unknown as {
        validateUpload: (input: Record<string, unknown>) => void;
      }
    ).validateUpload.bind(service);
    expect(() =>
      validate({
        fileName: "clip.webm",
        mimeType: "video/webm",
        size: 1024,
        purpose: "CHAT_VIDEO",
        scope: "DIRECT",
      }),
    ).toThrow(ForbiddenException);
    expect(() =>
      validate({
        fileName: "clip.mov",
        mimeType: "video/quicktime",
        size: 1024,
        purpose: "CHAT_VIDEO",
        scope: "DIRECT",
      }),
    ).toThrow(ForbiddenException);
    expect(() =>
      validate({
        fileName: "clip.mp4",
        mimeType: "video/mp4",
        size: 1024,
        purpose: "CHAT_VIDEO",
        scope: "DIRECT",
      }),
    ).not.toThrow();
  });

  it("accepts only the normalized image and voice formats", () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    const validate = (
      service as unknown as {
        validateUpload: (input: Record<string, unknown>) => void;
      }
    ).validateUpload.bind(service);
    const base = { size: 1024, scope: "DIRECT" };
    expect(() =>
      validate({
        ...base,
        fileName: "photo.heic",
        mimeType: "image/heic",
        purpose: "CHAT_IMAGE",
      }),
    ).toThrow(ForbiddenException);
    expect(() =>
      validate({
        ...base,
        fileName: "photo.webp",
        mimeType: "image/webp",
        purpose: "CHAT_IMAGE",
      }),
    ).not.toThrow();
    expect(() =>
      validate({
        ...base,
        fileName: "voice.ogg",
        mimeType: "audio/ogg",
        purpose: "CHAT_VOICE",
      }),
    ).toThrow(ForbiddenException);
  });

  it("rejects a non-avatar file as a profile avatar", async () => {
    const service = new UsersService({
      storedFile: {
        findFirst: jest.fn().mockResolvedValue({
          id: "file-id",
          purpose: "CHAT_FILE",
          scope: "PRIVATE",
          mimeType: "image/png",
        }),
      },
    } as never);
    await expect(
      service.setAvatar("user-id", "file-id"),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });

  it("does not delete files referenced by an avatar or thumbnail", async () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    Object.assign(service, {
      prisma: {
        storedFile: {
          findFirst: jest.fn().mockResolvedValue({
            id: "file-id",
            avatarFor: { id: "user-id" },
            thumbnailOf: [],
          }),
        },
      },
    });
    await expect(
      service.deleteFile("user-id", "file-id"),
    ).rejects.toBeInstanceOf(ConflictException);
  });

  it("rejects forwarding a file to private storage", async () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    await expect(
      service.forward("user-id", "file-id", {
        scope: "PRIVATE",
        scopeId: "00000000-0000-4000-8000-000000000001",
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });

  it("does not hide partial object-storage deletion failures", async () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    Object.assign(service, {
      bucket: "chat",
      ensureBucket: jest.fn().mockResolvedValue(undefined),
      client: {
        send: jest.fn().mockResolvedValue({
          Errors: [{ Key: "files/orphan", Code: "InternalError" }],
        }),
      },
    });
    await expect(
      service.deleteStoredObjects(["files/orphan"]),
    ).rejects.toBeInstanceOf(BadGatewayException);
  });

  it("persists delete-pending before object removal so cleanup can retry", async () => {
    const updates: string[] = [];
    const service = Object.create(FilesService.prototype) as FilesService;
    Object.assign(service, {
      prisma: {
        storedFile: {
          findFirst: jest.fn().mockResolvedValue({
            id: "file-id",
            ownerUserId: "user-id",
            objectKey: "files/object",
            status: "READY",
            scope: "PRIVATE",
            avatarFor: null,
            groupAvatarFor: null,
            thumbnailOf: [],
          }),
          update: jest.fn().mockImplementation(({ data }) => {
            updates.push(String(data.status));
            return Promise.resolve(undefined);
          }),
        },
      },
      deleteStoredObjects: jest
        .fn()
        .mockRejectedValue(new BadGatewayException("storage unavailable")),
    });

    await expect(service.deleteFile("user-id", "file-id")).rejects.toBeInstanceOf(
      BadGatewayException,
    );
    expect(updates).toEqual(["DELETE_PENDING"]);
  });
});
