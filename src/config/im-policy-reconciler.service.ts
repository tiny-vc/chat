import {
  Injectable,
  Logger,
  OnApplicationBootstrap,
  OnModuleDestroy,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DeviceType } from "@prisma/client";
import { PrismaService } from "../prisma/prisma.service";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";
import {
  createDisabledWuKongImToken,
  createWuKongImToken,
} from "../integrations/wukongim/wukongim-token";

export const MESSAGING_POLICY_KEY = "wukongim.messaging";

@Injectable()
export class ImPolicyReconcilerService
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(ImPolicyReconcilerService.name);
  private timer?: NodeJS.Timeout;

  constructor(
    private readonly prisma: PrismaService,
    private readonly wuKongIm: WuKongImService,
    private readonly config: ConfigService,
  ) {}

  onApplicationBootstrap() {
    if (this.config.getOrThrow<string>("JOBS_ENABLED") !== "true") return;
    void this.reconcile();
    this.timer = setInterval(() => void this.reconcile(), 15_000);
    this.timer.unref();
  }

  onModuleDestroy() {
    if (this.timer) clearInterval(this.timer);
  }

  async reconcile() {
    const now = new Date();
    const claimed = await this.prisma.runtimePolicySync.updateMany({
      where: {
        key: MESSAGING_POLICY_KEY,
        status: { in: ["PENDING", "FAILED", "SYNCING"] },
        OR: [{ nextAttemptAt: null }, { nextAttemptAt: { lte: now } }],
      },
      data: {
        status: "SYNCING",
        nextAttemptAt: new Date(now.getTime() + 60_000),
      },
    });
    if (claimed.count !== 1) return false;

    const task = await this.prisma.runtimePolicySync.findUniqueOrThrow({
      where: { key: MESSAGING_POLICY_KEY },
    });
    try {
      await this.apply(task.desiredEnabled);
      await this.prisma.runtimePolicySync.update({
        where: { key: MESSAGING_POLICY_KEY },
        data: {
          status: "SYNCED",
          attempts: 0,
          nextAttemptAt: null,
          lastError: null,
          syncedAt: new Date(),
        },
      });
      return true;
    } catch (error) {
      const attempts = task.attempts + 1;
      const delay = Math.min(300_000, 10_000 * 2 ** Math.min(attempts - 1, 5));
      const message = String(error).slice(0, 1000);
      this.logger.error(`WuKongIM messaging policy reconciliation failed: ${message}`);
      await this.prisma.runtimePolicySync.update({
        where: { key: MESSAGING_POLICY_KEY },
        data: {
          status: "FAILED",
          attempts,
          nextAttemptAt: new Date(Date.now() + delay),
          lastError: message,
        },
      });
      return false;
    }
  }

  private async apply(enabled: boolean) {
    const sessions = await this.prisma.deviceSession.findMany({
      where: {
        revokedAt: null,
        expiresAt: { gt: new Date() },
        user: { status: "ACTIVE" },
      },
      select: { userId: true, deviceType: true },
      distinct: ["userId", "deviceType"],
    });
    const secret = this.config.getOrThrow<string>("JWT_ACCESS_SECRET");
    await this.runInBatches(sessions, async (session) => {
      const flag = this.deviceFlag(session.deviceType);
      await this.wuKongIm.upsertUserToken(
        session.userId,
        enabled
          ? createWuKongImToken(secret, session.userId, flag)
          : createDisabledWuKongImToken(),
        flag,
      );
    });
    if (!enabled) {
      await this.runInBatches(
        [...new Set(sessions.map((session) => session.userId))],
        (userId) =>
          this.wuKongIm.disconnectUser(userId).then(() => undefined),
      );
    }
  }

  private async runInBatches<T>(items: T[], operation: (item: T) => Promise<void>) {
    for (let offset = 0; offset < items.length; offset += 20) {
      await Promise.all(items.slice(offset, offset + 20).map(operation));
    }
  }

  private deviceFlag(type: DeviceType) {
    return type === DeviceType.APP ? 0 : type === DeviceType.WEB ? 1 : 2;
  }
}
