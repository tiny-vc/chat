import { RuntimeSettingsService } from "../src/config/runtime-settings.service";

describe("RuntimeSettingsService", () => {
  const policy = {
    status: "SYNCED",
    attempts: 0,
    lastError: null,
    syncedAt: new Date("2026-09-04T12:00:01.000Z"),
  };
  const imPolicy = { reconcile: jest.fn().mockResolvedValue(true) };
  const row = {
    id: 1,
    registrationEnabled: true,
    messagingEnabled: true,
    filesEnabled: true,
    groupsEnabled: true,
    audioCallsEnabled: true,
    videoCallsEnabled: true,
    updatedAt: new Date("2026-09-04T12:00:00.000Z"),
  };

  it("returns the singleton as the public capability shape", async () => {
    const prisma = {
      runtimeSettings: { upsert: jest.fn().mockResolvedValue(row) },
      runtimePolicySync: { upsert: jest.fn().mockResolvedValue(policy) },
    };
    const service = new RuntimeSettingsService(
      prisma as never,
      imPolicy as never,
    );
    await expect(service.get()).resolves.toEqual({
      registrationEnabled: true,
      capabilities: {
        messaging: true,
        files: true,
        groups: true,
        audioCalls: true,
        videoCalls: true,
      },
      updatedAt: "2026-09-04T12:00:00.000Z",
      messagingPolicy: {
        status: "SYNCED",
        attempts: 0,
        lastError: null,
        syncedAt: "2026-09-04T12:00:01.000Z",
      },
    });
  });

  it("updates all flags atomically and records before/after audit data", async () => {
    const tx = {
      runtimeSettings: {
        upsert: jest.fn().mockResolvedValue(row),
        update: jest.fn().mockResolvedValue({
          ...row,
          registrationEnabled: false,
          filesEnabled: false,
        }),
      },
      auditLog: { create: jest.fn().mockResolvedValue({}) },
      runtimePolicySync: { upsert: jest.fn().mockResolvedValue({}) },
    };
    const prisma = {
      $transaction: jest.fn((operation: (value: typeof tx) => unknown) =>
        Promise.resolve(operation(tx)),
      ),
      runtimeSettings: {
        upsert: jest.fn().mockResolvedValue({
          ...row,
          registrationEnabled: false,
          filesEnabled: false,
        }),
      },
      runtimePolicySync: { upsert: jest.fn().mockResolvedValue(policy) },
    };
    const service = new RuntimeSettingsService(
      prisma as never,
      imPolicy as never,
    );
    const result = await service.update("actor", {
      registrationEnabled: false,
      messaging: true,
      files: false,
      groups: true,
      audioCalls: true,
      videoCalls: true,
    });

    expect(result.registrationEnabled).toBe(false);
    expect(result.capabilities.files).toBe(false);
    expect(tx.runtimeSettings.update).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { id: 1 },
        data: expect.objectContaining({ filesEnabled: false }),
      }),
    );
    expect(tx.auditLog.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        actorUserId: "actor",
        action: "RUNTIME_SETTINGS_UPDATED",
        targetType: "RUNTIME_SETTINGS",
      }),
    });
    expect(tx.runtimePolicySync.upsert).toHaveBeenCalledWith(
      expect.objectContaining({
        update: expect.objectContaining({ status: "PENDING" }),
      }),
    );
    expect(imPolicy.reconcile).toHaveBeenCalled();
  });
});
