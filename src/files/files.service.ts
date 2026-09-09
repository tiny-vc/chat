import {
  BadGatewayException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { FileScope, FileStatus } from "@prisma/client";
import {
  CreateBucketCommand,
  CopyObjectCommand,
  DeleteObjectsCommand,
  GetObjectCommand,
  HeadBucketCommand,
  HeadObjectCommand,
  HeadObjectCommandOutput,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { randomUUID } from "node:crypto";
import { extname } from "node:path";
import { PrismaService } from "../prisma/prisma.service";
import { CreateUploadDto, FilePurpose } from "./dto/create-upload.dto";
import { ForwardFileDto } from "./dto/forward-file.dto";

import { fileSizeLimits as limits } from "./file-limits";

@Injectable()
export class FilesService {
  private readonly client: S3Client;
  private readonly signingClient: S3Client;
  private readonly bucket: string;
  private readonly autoCreateBucket: boolean;
  private readonly quotaBytes: bigint;
  private bucketReady?: Promise<void>;

  constructor(
    private readonly prisma: PrismaService,
    config: ConfigService,
  ) {
    this.bucket = config.getOrThrow<string>("S3_BUCKET");
    this.autoCreateBucket =
      config.getOrThrow<string>("S3_AUTO_CREATE_BUCKET") === "true";
    this.quotaBytes =
      BigInt(config.getOrThrow<number>("USER_STORAGE_QUOTA_MB")) *
      1024n *
      1024n;
    const endpoint = config.get<string>("S3_ENDPOINT");
    const publicEndpoint = config.get<string>("S3_PUBLIC_ENDPOINT");
    const clientOptions = {
      region: config.getOrThrow<string>("S3_REGION"),
      forcePathStyle:
        config.getOrThrow<string>("S3_FORCE_PATH_STYLE") === "true",
      credentials: {
        accessKeyId: config.getOrThrow<string>("S3_ACCESS_KEY"),
        secretAccessKey: config.getOrThrow<string>("S3_SECRET_KEY"),
      },
    };
    this.client = new S3Client({ ...clientOptions, endpoint });
    this.signingClient = new S3Client({
      ...clientOptions,
      endpoint: publicEndpoint ?? endpoint,
    });
  }

  async createUpload(userId: string, input: CreateUploadDto) {
    this.validateUpload(input);
    await this.validateUploadScope(userId, input.scope, input.scopeId);
    await this.ensureBucket();

    const extension = extname(input.fileName)
      .toLowerCase()
      .replace(/[^.a-z0-9]/g, "")
      .slice(0, 12);
    const objectKey = `${input.purpose.toLowerCase()}/${userId}/${randomUUID()}${extension}`;
    const file = await this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`
        SELECT pg_advisory_xact_lock(hashtext(${"storage:" + userId}))::text AS locked
      `;
      const usage = await tx.storedFile.aggregate({
        where: {
          ownerUserId: userId,
          status: { in: ["PENDING", "UPLOADED", "READY"] },
        },
        _sum: { sizeBytes: true },
      });
      if ((usage._sum.sizeBytes ?? 0n) + BigInt(input.size) > this.quotaBytes) {
        throw new ConflictException("User storage quota exceeded");
      }
      return tx.storedFile.create({
        data: {
          ownerUserId: userId,
          objectKey,
          originalName: input.fileName,
          mimeType: input.mimeType,
          sizeBytes: BigInt(input.size),
          sha256: input.sha256,
          purpose: input.purpose,
          scope: input.scope,
          scopeId: input.scopeId,
        },
      });
    });
    const checksumBase64 = Buffer.from(input.sha256, "hex").toString("base64");
    const uploadUrl = await getSignedUrl(
      this.signingClient,
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: objectKey,
        ContentType: input.mimeType,
        ContentLength: input.size,
        ChecksumSHA256: checksumBase64,
        Metadata: { sha256: input.sha256 },
      }),
      { expiresIn: 10 * 60 },
    );
    return {
      fileId: file.id,
      uploadUrl,
      method: "PUT",
      headers: {
        "content-type": input.mimeType,
        "x-amz-checksum-sha256": checksumBase64,
        "x-amz-meta-sha256": input.sha256,
      },
      expiresIn: 600,
    };
  }

  async complete(userId: string, fileId: string) {
    const file = await this.requireOwnedPendingFile(userId, fileId);
    await this.ensureBucket();
    let object: HeadObjectCommandOutput;
    try {
      object = await this.client.send(
        new HeadObjectCommand({
          Bucket: this.bucket,
          Key: file.objectKey,
          ChecksumMode: "ENABLED",
        }),
      );
    } catch {
      throw new BadGatewayException("Uploaded object was not found");
    }
    if (object.ContentLength !== Number(file.sizeBytes)) {
      await this.prisma.storedFile.update({
        where: { id: file.id },
        data: { status: "REJECTED" },
      });
      throw new ForbiddenException("Uploaded file size does not match");
    }
    if (object.ContentType && object.ContentType !== file.mimeType) {
      await this.prisma.storedFile.update({
        where: { id: file.id },
        data: { status: "REJECTED" },
      });
      throw new ForbiddenException("Uploaded file type does not match");
    }
    const expectedChecksum = Buffer.from(file.sha256 ?? "", "hex").toString(
      "base64",
    );
    if (
      object.ChecksumSHA256 !== expectedChecksum ||
      object.Metadata?.sha256 !== file.sha256
    ) {
      await this.prisma.storedFile.update({
        where: { id: file.id },
        data: { status: "REJECTED" },
      });
      throw new ForbiddenException("Uploaded file checksum does not match");
    }
    if (
      [FilePurpose.AVATAR, FilePurpose.CHAT_IMAGE].includes(
        file.purpose as FilePurpose,
      )
    ) {
      const detected = await this.detectImageType(file.objectKey);
      if (!detected || !this.imageTypeMatches(file.mimeType, detected)) {
        await this.prisma.storedFile.update({
          where: { id: file.id },
          data: { status: "REJECTED" },
        });
        throw new ForbiddenException(
          "Uploaded image content does not match its type",
        );
      }
    }
    if (
      [FilePurpose.CHAT_VOICE, FilePurpose.CHAT_VIDEO].includes(
        file.purpose as FilePurpose,
      )
    ) {
      const detected = await this.detectMediaContainer(file.objectKey);
      if (!detected || !this.mediaTypeMatches(file.mimeType, detected)) {
        await this.prisma.storedFile.update({
          where: { id: file.id },
          data: { status: "REJECTED" },
        });
        throw new ForbiddenException(
          "Uploaded media content does not match its type",
        );
      }
    }
    const updated = await this.prisma.storedFile.update({
      where: { id: file.id },
      data: { status: "READY", uploadedAt: new Date() },
    });
    return this.serialize(updated);
  }

  async createDownload(userId: string, fileId: string) {
    const file = await this.prisma.storedFile.findFirst({
      where: { id: fileId, status: "READY" },
    });
    if (!file) throw new NotFoundException("File not found");
    if (
      file.purpose === "AVATAR" &&
      file.scope === "PRIVATE" &&
      userId !== file.ownerUserId
    ) {
      await this.requireAvatarAccess(userId, file.id);
    } else {
      await this.requireScopeAccess(
        userId,
        file.scope,
        file.scopeId ?? undefined,
        file.ownerUserId,
      );
    }
    const downloadUrl = await getSignedUrl(
      this.signingClient,
      new GetObjectCommand({
        Bucket: this.bucket,
        Key: file.objectKey,
        ResponseContentDisposition: `attachment; filename*=UTF-8''${encodeURIComponent(file.originalName)}`,
      }),
      { expiresIn: 10 * 60 },
    );
    return { downloadUrl, expiresIn: 600, file: this.serialize(file) };
  }

  async forward(userId: string, fileId: string, input: ForwardFileDto) {
    if (input.scope === "PRIVATE") {
      throw new ForbiddenException("Forward destination must be a chat");
    }
    await this.validateUploadScope(userId, input.scope, input.scopeId);
    const source = await this.prisma.storedFile.findFirst({
      where: { id: fileId, status: "READY" },
    });
    if (!source) throw new NotFoundException("File not found");
    await this.requireScopeAccess(
      userId,
      source.scope,
      source.scopeId ?? undefined,
      source.ownerUserId,
    );
    await this.ensureBucket();

    const extension = extname(source.objectKey)
      .toLowerCase()
      .replace(/[^.a-z0-9]/g, "")
      .slice(0, 12);
    const objectKey = `${source.purpose.toLowerCase()}/${userId}/${randomUUID()}${extension}`;
    await this.client.send(
      new CopyObjectCommand({
        Bucket: this.bucket,
        Key: objectKey,
        CopySource: encodeURIComponent(
          `${this.bucket}/${source.objectKey}`,
        ).replace(/%2F/g, "/"),
        ContentType: source.mimeType,
        ChecksumAlgorithm: "SHA256",
        Metadata: source.sha256 ? { sha256: source.sha256 } : undefined,
        MetadataDirective: "REPLACE",
      }),
    );

    try {
      const forwarded = await this.prisma.$transaction(async (tx) => {
        await tx.$queryRaw`
          SELECT pg_advisory_xact_lock(hashtext(${"storage:" + userId}))::text AS locked
        `;
        const usage = await tx.storedFile.aggregate({
          where: {
            ownerUserId: userId,
            status: { in: ["PENDING", "UPLOADED", "READY"] },
          },
          _sum: { sizeBytes: true },
        });
        if ((usage._sum.sizeBytes ?? 0n) + source.sizeBytes > this.quotaBytes) {
          throw new ConflictException("User storage quota exceeded");
        }
        return tx.storedFile.create({
          data: {
            ownerUserId: userId,
            objectKey,
            originalName: source.originalName,
            mimeType: source.mimeType,
            sizeBytes: source.sizeBytes,
            sha256: source.sha256,
            purpose: source.purpose,
            scope: input.scope,
            scopeId: input.scopeId,
            status: "READY",
            uploadedAt: new Date(),
          },
        });
      });
      return this.serialize(forwarded);
    } catch (error) {
      await this.deleteStoredObjects([objectKey]);
      throw error;
    }
  }

  async usage(userId: string) {
    const aggregate = await this.prisma.storedFile.aggregate({
      where: {
        ownerUserId: userId,
        status: { in: ["PENDING", "UPLOADED", "READY"] },
      },
      _sum: { sizeBytes: true },
      _count: { id: true },
    });
    const usedBytes = aggregate._sum.sizeBytes ?? 0n;
    return {
      usedBytes: usedBytes.toString(),
      quotaBytes: this.quotaBytes.toString(),
      remainingBytes: (this.quotaBytes - usedBytes > 0n
        ? this.quotaBytes - usedBytes
        : 0n
      ).toString(),
      fileCount: aggregate._count.id,
    };
  }

  async setThumbnail(userId: string, fileId: string, thumbnailFileId: string) {
    if (fileId === thumbnailFileId)
      throw new ForbiddenException("File cannot be its own thumbnail");
    const [file, thumbnail] = await Promise.all([
      this.prisma.storedFile.findFirst({
        where: { id: fileId, ownerUserId: userId, status: "READY" },
      }),
      this.prisma.storedFile.findFirst({
        where: { id: thumbnailFileId, ownerUserId: userId, status: "READY" },
      }),
    ]);
    if (!file || !thumbnail)
      throw new NotFoundException("File or thumbnail not found");
    if (!["CHAT_IMAGE", "CHAT_VIDEO"].includes(file.purpose)) {
      throw new ForbiddenException(
        "This file type does not support thumbnails",
      );
    }
    if (
      thumbnail.purpose !== "CHAT_IMAGE" ||
      !thumbnail.mimeType.startsWith("image/")
    ) {
      throw new ForbiddenException("Thumbnail must be a chat image");
    }
    if (file.scope !== thumbnail.scope || file.scopeId !== thumbnail.scopeId) {
      throw new ForbiddenException(
        "Thumbnail scope must match the source file",
      );
    }
    const updated = await this.prisma.storedFile.update({
      where: { id: file.id },
      data: { thumbnailFileId: thumbnail.id },
    });
    return this.serialize(updated);
  }

  async deleteFile(userId: string, fileId: string) {
    const file = await this.prisma.storedFile.findFirst({
      where: { id: fileId, ownerUserId: userId, status: { not: "DELETED" } },
      include: {
        avatarFor: { select: { id: true } },
        groupAvatarFor: { select: { id: true } },
        thumbnailOf: { select: { id: true }, take: 1 },
      },
    });
    if (!file) throw new NotFoundException("File not found");
    if (file.avatarFor || file.groupAvatarFor || file.thumbnailOf.length > 0) {
      throw new ConflictException("File is currently in use");
    }
    if (file.status === "READY" && file.scope !== "PRIVATE") {
      throw new ConflictException("Shared chat files cannot be deleted");
    }
    await this.prisma.storedFile.update({
      where: { id: file.id },
      data: { status: "DELETE_PENDING", thumbnailFileId: null },
    });
    await this.deleteStoredObjects([file.objectKey]);
    await this.prisma.storedFile.update({
      where: { id: file.id },
      data: { status: "DELETED" },
    });
    return { success: true };
  }

  async deleteStoredObjects(objectKeys: string[]) {
    if (objectKeys.length === 0) return;
    await this.ensureBucket();
    const result = await this.client.send(
      new DeleteObjectsCommand({
        Bucket: this.bucket,
        Delete: { Objects: objectKeys.map((Key) => ({ Key })), Quiet: true },
      }),
    );
    if (result.Errors?.length) {
      const failedKeys = result.Errors.map((error) => error.Key)
        .filter(Boolean)
        .join(', ');
      throw new BadGatewayException(
        `Object storage failed to delete ${result.Errors.length} object(s)${failedKeys ? `: ${failedKeys}` : ''}`,
      );
    }
  }

  async healthCheck() {
    await this.ensureBucket();
    await this.client.send(new HeadBucketCommand({ Bucket: this.bucket }));
  }

  private validateUpload(input: CreateUploadDto) {
    const mimeType = input.mimeType.toLowerCase().split(";", 1)[0].trim();
    if (input.size > limits[input.purpose]) {
      throw new ForbiddenException(
        "File exceeds the size limit for this purpose",
      );
    }
    if (
      [FilePurpose.AVATAR, FilePurpose.CHAT_IMAGE].includes(input.purpose) &&
      !["image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"].includes(
        mimeType,
      )
    ) {
      throw new ForbiddenException(
        "Images require a JPEG, PNG, GIF or WebP format",
      );
    }
    if (
      input.purpose === FilePurpose.CHAT_VOICE &&
      mimeType !== "audio/mp4"
    ) {
      throw new ForbiddenException("Voice messages require AAC in an M4A/MP4 container");
    }
    if (
      input.purpose === FilePurpose.CHAT_VIDEO &&
      mimeType !== "video/mp4"
    ) {
      throw new ForbiddenException("Video messages require an MP4 container");
    }
  }

  private async detectImageType(objectKey: string) {
    const object = await this.client.send(
      new GetObjectCommand({
        Bucket: this.bucket,
        Key: objectKey,
        Range: "bytes=0-511",
      }),
    );
    const bytes = await object.Body?.transformToByteArray();
    if (!bytes || bytes.length < 4) return undefined;
    if (bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff)
      return "image/jpeg";
    if (
      bytes
        .slice(0, 8)
        .every(
          (value, index) =>
            value === [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a][index],
        )
    )
      return "image/png";
    const ascii = Buffer.from(bytes).toString("ascii");
    if (ascii.startsWith("GIF87a") || ascii.startsWith("GIF89a"))
      return "image/gif";
    if (ascii.startsWith("RIFF") && ascii.slice(8, 12) === "WEBP")
      return "image/webp";
    if (
      ascii.slice(4, 8) === "ftyp" &&
      /^(heic|heix|hevc|hevx|mif1|msf1)$/.test(ascii.slice(8, 12))
    )
      return "image/heic";
    return undefined;
  }

  private imageTypeMatches(declared: string, detected: string) {
    const normalized = declared.toLowerCase();
    if (detected === "image/jpeg")
      return normalized === "image/jpeg" || normalized === "image/jpg";
    if (detected === "image/heic")
      return normalized === "image/heic" || normalized === "image/heif";
    return normalized === detected;
  }

  private async detectMediaContainer(objectKey: string) {
    const object = await this.client.send(
      new GetObjectCommand({
        Bucket: this.bucket,
        Key: objectKey,
        Range: "bytes=0-511",
      }),
    );
    const bytes = await object.Body?.transformToByteArray();
    if (!bytes || bytes.length < 4) return undefined;
    const ascii = Buffer.from(bytes).toString("ascii");
    if (ascii.slice(4, 8) === "ftyp") return "iso-bmff";
    if (ascii.startsWith("RIFF") && ascii.slice(8, 12) === "AVI ") return "avi";
    if (ascii.startsWith("RIFF") && ascii.slice(8, 12) === "WAVE") return "wav";
    if (ascii.startsWith("OggS")) return "ogg";
    if (
      bytes[0] === 0x1a &&
      bytes[1] === 0x45 &&
      bytes[2] === 0xdf &&
      bytes[3] === 0xa3
    )
      return "ebml";
    if (
      ascii.startsWith("ID3") ||
      (bytes[0] === 0xff && (bytes[1] & 0xe0) === 0xe0)
    )
      return "mpeg-audio";
    return undefined;
  }

  private mediaTypeMatches(declared: string, detected: string) {
    const normalized = declared.toLowerCase().split(";", 1)[0].trim();
    if (detected === "iso-bmff") {
      return [
        "video/mp4",
        "video/quicktime",
        "video/x-m4v",
        "audio/mp4",
        "audio/x-m4a",
      ].includes(normalized);
    }
    if (detected === "ebml")
      return normalized === "video/webm" || normalized === "video/x-matroska";
    if (detected === "avi") return normalized === "video/x-msvideo";
    if (detected === "wav")
      return normalized === "audio/wav" || normalized === "audio/x-wav";
    if (detected === "ogg")
      return normalized === "audio/ogg" || normalized === "video/ogg";
    if (detected === "mpeg-audio") return normalized === "audio/mpeg";
    return false;
  }

  private async requireAvatarAccess(userId: string, fileId: string) {
    // Only the current binding grants access; old/unbound private images stay private.
    const profile = await this.prisma.user.findFirst({
      where: { avatarFileId: fileId, status: "ACTIVE" },
      select: { id: true },
    });
    if (profile) {
      const blocked = await this.prisma.userBlock.findFirst({
        where: {
          OR: [
            { blockerId: userId, blockedId: profile.id },
            { blockerId: profile.id, blockedId: userId },
          ],
        },
        select: { blockerId: true },
      });
      const friend = await this.prisma.friendship.findFirst({
        where: {
          pairKey: [userId, profile.id].sort().join(":"),
          status: "ACCEPTED",
        },
        select: { id: true },
      });
      if (!blocked && friend) return;
      throw new ForbiddenException("Avatar access denied");
    }
    const membership = await this.prisma.groupMember.findFirst({
      where: {
        userId,
        status: "ACTIVE",
        group: { avatarFileId: fileId, status: "ACTIVE" },
      },
      select: { userId: true },
    });
    if (!membership) throw new ForbiddenException("Avatar access denied");
  }

  private async requireScopeAccess(
    userId: string,
    scope: FileScope,
    scopeId?: string,
    ownerUserId = userId,
  ) {
    if (userId === ownerUserId) return;
    if (scope === "PRIVATE" || !scopeId)
      throw new ForbiddenException("File access denied");
    if (scope === "DIRECT") {
      if (userId !== scopeId)
        throw new ForbiddenException("Direct file access denied");
      const pairKey = [ownerUserId, userId].sort().join(":");
      const friendship = await this.prisma.friendship.findFirst({
        where: { pairKey, status: "ACCEPTED" },
        select: { id: true },
      });
      if (!friendship)
        throw new ForbiddenException("Direct file access denied");
      return;
    }
    const membership = await this.prisma.groupMember.findFirst({
      where: {
        groupId: scopeId,
        userId,
        status: "ACTIVE",
        group: { status: "ACTIVE" },
      },
      select: { userId: true },
    });
    if (!membership) throw new ForbiddenException("Group file access denied");
  }

  private async validateUploadScope(
    userId: string,
    scope: FileScope,
    scopeId?: string,
  ) {
    if (scope === "PRIVATE") {
      if (scopeId)
        throw new ForbiddenException("Private files cannot have a scope ID");
      return;
    }
    if (!scopeId) throw new ForbiddenException("A scope ID is required");
    if (scope === "DIRECT") {
      const pairKey = [userId, scopeId].sort().join(":");
      const friendship = await this.prisma.friendship.findFirst({
        where: { pairKey, status: "ACCEPTED" },
        select: { id: true },
      });
      if (!friendship)
        throw new ForbiddenException("Direct upload requires friendship");
      return;
    }
    const membership = await this.prisma.groupMember.findFirst({
      where: {
        groupId: scopeId,
        userId,
        status: "ACTIVE",
        group: { status: "ACTIVE" },
      },
      select: { userId: true },
    });
    if (!membership)
      throw new ForbiddenException("Group upload requires membership");
  }

  private async requireOwnedPendingFile(userId: string, fileId: string) {
    const file = await this.prisma.storedFile.findFirst({
      where: { id: fileId, ownerUserId: userId, status: FileStatus.PENDING },
    });
    if (!file) throw new NotFoundException("Pending file not found");
    return file;
  }

  private ensureBucket() {
    this.bucketReady ??= this.ensureBucketOnce().catch((error: unknown) => {
      this.bucketReady = undefined;
      throw error;
    });
    return this.bucketReady;
  }

  private async ensureBucketOnce() {
    try {
      await this.client.send(new HeadBucketCommand({ Bucket: this.bucket }));
    } catch (error) {
      if (!this.autoCreateBucket) {
        throw new BadGatewayException(
          `Storage bucket is unavailable: ${String(error)}`,
        );
      }
      await this.client.send(new CreateBucketCommand({ Bucket: this.bucket }));
    }
  }

  private serialize(file: { sizeBytes: bigint; [key: string]: unknown }) {
    return { ...file, sizeBytes: file.sizeBytes.toString() };
  }
}
