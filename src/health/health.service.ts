import { Injectable } from '@nestjs/common';
import { FilesService } from '../files/files.service';
import { LiveKitService } from '../integrations/livekit/livekit.service';
import { WuKongImService } from '../integrations/wukongim/wukongim.service';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class HealthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wuKongIm: WuKongImService,
    private readonly liveKit: LiveKitService,
    private readonly files: FilesService,
  ) {}

  async readiness() {
    const checks = await Promise.all([
      this.check('postgresql', async () => {
        await this.prisma.$queryRaw`SELECT 1`;
      }),
      this.check('wukongim', () => this.wuKongIm.healthCheck()),
      this.check('livekit', () => this.liveKit.healthCheck()),
      this.check('objectStorage', () => this.files.healthCheck()),
    ]);
    return {
      status: checks.every((check) => check.result.status === 'ok') ? 'ok' : 'degraded',
      timestamp: new Date().toISOString(),
      dependencies: Object.fromEntries(checks.map((check) => [check.name, check.result])),
    };
  }

  private async check(name: string, operation: () => Promise<unknown>) {
    const startedAt = Date.now();
    try {
      await operation();
      return { name, result: { status: 'ok', latencyMs: Date.now() - startedAt } };
    } catch {
      return {
        name,
        result: {
          status: 'error',
          latencyMs: Date.now() - startedAt,
          message: 'Dependency unavailable',
        },
      };
    }
  }
}
