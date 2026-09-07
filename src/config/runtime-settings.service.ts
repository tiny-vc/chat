import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { UpdateRuntimeSettingsDto } from "./dto/update-runtime-settings.dto";
import {
  ImPolicyReconcilerService,
  MESSAGING_POLICY_KEY,
} from "./im-policy-reconciler.service";

@Injectable()
export class RuntimeSettingsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly imPolicy: ImPolicyReconcilerService,
  ) {}

  async get() {
    const value = await this.prisma.runtimeSettings.upsert({
      where: { id: 1 },
      create: { id: 1 },
      update: {},
    });
    const policy = await this.prisma.runtimePolicySync.upsert({
      where: { key: MESSAGING_POLICY_KEY },
      create: {
        key: MESSAGING_POLICY_KEY,
        desiredEnabled: value.messagingEnabled,
        status: "PENDING",
        nextAttemptAt: new Date(),
      },
      update: {},
    });
    return this.present(value, policy);
  }

  async update(actorUserId: string, input: UpdateRuntimeSettingsDto) {
    await this.prisma.$transaction(async (tx) => {
      const previous = await tx.runtimeSettings.upsert({
        where: { id: 1 },
        create: { id: 1 },
        update: {},
      });
      const next = await tx.runtimeSettings.update({
        where: { id: 1 },
        data: {
          registrationEnabled: input.registrationEnabled,
          messagingEnabled: input.messaging,
          filesEnabled: input.files,
          groupsEnabled: input.groups,
          audioCallsEnabled: input.audioCalls,
          videoCallsEnabled: input.videoCalls,
        },
      });
      await tx.auditLog.create({
        data: {
          actorUserId,
          action: "RUNTIME_SETTINGS_UPDATED",
          targetType: "RUNTIME_SETTINGS",
          targetId: "1",
          metadata: {
            previous: this.present(previous),
            next: this.present(next),
          },
        },
      });
      await tx.runtimePolicySync.upsert({
        where: { key: MESSAGING_POLICY_KEY },
        create: {
          key: MESSAGING_POLICY_KEY,
          desiredEnabled: input.messaging,
          status: "PENDING",
          nextAttemptAt: new Date(),
        },
        update: {
          desiredEnabled: input.messaging,
          status: "PENDING",
          attempts: 0,
          nextAttemptAt: new Date(),
          lastError: null,
        },
      });
      return next;
    });
    await this.imPolicy.reconcile();
    return this.get();
  }

  private present(value: {
    registrationEnabled: boolean;
    messagingEnabled: boolean;
    filesEnabled: boolean;
    groupsEnabled: boolean;
    audioCallsEnabled: boolean;
    videoCallsEnabled: boolean;
    updatedAt: Date;
  }, policy?: {
    status: string;
    attempts: number;
    lastError: string | null;
    syncedAt: Date | null;
  }) {
    return {
      registrationEnabled: value.registrationEnabled,
      capabilities: {
        messaging: value.messagingEnabled,
        files: value.filesEnabled,
        groups: value.groupsEnabled,
        audioCalls: value.audioCallsEnabled,
        videoCalls: value.videoCallsEnabled,
      },
      messagingPolicy: {
        status: policy?.status ?? "PENDING",
        attempts: policy?.attempts ?? 0,
        lastError: policy?.lastError ?? null,
        syncedAt: policy?.syncedAt?.toISOString() ?? null,
      },
      updatedAt: value.updatedAt.toISOString(),
    };
  }
}
