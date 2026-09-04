import {
  Injectable,
  Logger,
  OnApplicationBootstrap,
  OnModuleDestroy,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { JobRunStatus, Prisma } from "@prisma/client";
import { FilesService } from "../files/files.service";
import { PrismaService } from "../prisma/prisma.service";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";

const CLEANUP_JOB = "maintenance.cleanup";

@Injectable()
export class JobsService implements OnApplicationBootstrap, OnModuleDestroy {
  private readonly logger = new Logger(JobsService.name);
  private timer?: NodeJS.Timeout;

  constructor(
    private readonly prisma: PrismaService,
    private readonly files: FilesService,
    private readonly wuKongIm: WuKongImService,
    private readonly config: ConfigService,
  ) {}

  onApplicationBootstrap() {
    if (this.config.getOrThrow<string>("JOBS_ENABLED") !== "true") return;
    const interval =
      this.config.getOrThrow<number>("CLEANUP_INTERVAL_MINUTES") * 60_000;
    this.timer = setInterval(() => void this.runCleanup("SCHEDULED"), interval);
    this.timer.unref();
  }

  onModuleDestroy() {
    if (this.timer) clearInterval(this.timer);
  }

  async runCleanup(trigger: "SCHEDULED" | "MANUAL") {
    const run = await this.prisma.jobRun.create({
      data: { jobName: CLEANUP_JOB, trigger },
      select: { id: true },
    });
    try {
      const result = await this.prisma.$transaction(
        async (tx) => {
          const [lock] = await tx.$queryRaw<Array<{ acquired: boolean }>>`
          SELECT pg_try_advisory_xact_lock(hashtext(${CLEANUP_JOB})) AS acquired
        `;
          if (!lock?.acquired) return null;
          return this.cleanup();
        },
        { timeout: 60_000 },
      );
      if (!result) {
        return this.finish(run.id, "SKIPPED", {
          reason: "another_instance_is_running",
        });
      }
      return this.finish(run.id, "SUCCESS", result);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      this.logger.error(`Cleanup failed: ${message}`);
      await this.prisma.jobRun.update({
        where: { id: run.id },
        data: {
          status: "FAILED",
          error: message.slice(0, 1000),
          finishedAt: new Date(),
        },
      });
      throw error;
    }
  }

  async listRuns(query: {
    limit: number;
    cursor?: string;
    status?: JobRunStatus;
  }) {
    const items = await this.prisma.jobRun.findMany({
      take: query.limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      ...(query.status ? { where: { status: query.status } } : {}),
      orderBy: [{ startedAt: "desc" }, { id: "desc" }],
    });
    const hasMore = items.length > query.limit;
    if (hasMore) items.pop();
    return { items, nextCursor: hasMore ? (items.at(-1)?.id ?? null) : null };
  }

  private async cleanup() {
    const now = Date.now();
    const uploadCutoff = new Date(
      now -
        this.config.getOrThrow<number>("PENDING_UPLOAD_TTL_HOURS") * 3_600_000,
    );
    const sessionCutoff = new Date(
      now -
        this.config.getOrThrow<number>("SESSION_RETENTION_DAYS") * 86_400_000,
    );
    const throttleCutoff = new Date(
      now -
        this.config.getOrThrow<number>("LOGIN_THROTTLE_RETENTION_DAYS") *
          86_400_000,
    );
    const staleFiles = await this.prisma.storedFile.findMany({
      where: {
        status: { in: ["PENDING", "REJECTED"] },
        createdAt: { lt: uploadCutoff },
      },
      take: 500,
      select: { id: true, objectKey: true },
    });
    const expiredMutes = await this.prisma.groupMember.findMany({
      where: { status: "ACTIVE", mutedUntil: { lte: new Date(now) } },
      take: 500,
      select: { groupId: true, userId: true },
    });
    for (const mute of expiredMutes) {
      await this.wuKongIm.removeChannelBlacklist(mute.groupId, 2, [
        mute.userId,
      ]);
    }
    await this.files.deleteStoredObjects(
      staleFiles.map((file) => file.objectKey),
    );
    const [files, sessions, throttles, mutes, joinRequests] =
      await this.prisma.$transaction([
        this.prisma.storedFile.updateMany({
          where: { id: { in: staleFiles.map((file) => file.id) } },
          data: { status: "DELETED" },
        }),
        this.prisma.deviceSession.deleteMany({
          where: {
            OR: [
              { revokedAt: { lt: sessionCutoff } },
              { expiresAt: { lt: sessionCutoff } },
            ],
          },
        }),
        this.prisma.loginThrottle.deleteMany({
          where: { updatedAt: { lt: throttleCutoff } },
        }),
        this.prisma.groupMember.updateMany({
          where: {
            OR: expiredMutes.map((mute) => ({
              groupId: mute.groupId,
              userId: mute.userId,
            })),
          },
          data: { mutedUntil: null },
        }),
        this.prisma.groupJoinRequest.updateMany({
          where: { status: "PENDING", expiresAt: { lte: new Date(now) } },
          data: { status: "EXPIRED", activeKey: null },
        }),
      ]);
    return {
      filesDeleted: files.count,
      objectsDeleted: staleFiles.length,
      sessionsDeleted: sessions.count,
      loginThrottlesDeleted: throttles.count,
      groupMutesExpired: mutes.count,
      groupJoinRequestsExpired: joinRequests.count,
    };
  }

  private finish(
    id: string,
    status: "SUCCESS" | "SKIPPED",
    metrics: Prisma.InputJsonObject,
  ) {
    return this.prisma.jobRun.update({
      where: { id },
      data: { status, metrics, finishedAt: new Date() },
    });
  }
}
