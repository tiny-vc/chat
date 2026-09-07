import { ImPolicyReconcilerService } from "../src/config/im-policy-reconciler.service";

describe("ImPolicyReconcilerService", () => {
  const config = {
    getOrThrow: jest.fn((key: string) =>
      key === "JOBS_ENABLED"
        ? "false"
        : "test-secret-at-least-32-characters",
    ),
  };

  function prisma(enabled: boolean) {
    return {
      runtimePolicySync: {
        updateMany: jest.fn().mockResolvedValue({ count: 1 }),
        findUniqueOrThrow: jest.fn().mockResolvedValue({
          desiredEnabled: enabled,
          attempts: 0,
        }),
        update: jest.fn().mockResolvedValue({}),
      },
      deviceSession: {
        findMany: jest.fn().mockResolvedValue([
          { userId: "user-1", deviceType: "APP" },
          { userId: "user-1", deviceType: "WEB" },
        ]),
      },
    };
  }

  it("invalidates credentials, disconnects once and marks the task synced", async () => {
    const db = prisma(false);
    const im = {
      upsertUserToken: jest.fn().mockResolvedValue(undefined),
      disconnectUser: jest.fn().mockResolvedValue(2),
    };
    const service = new ImPolicyReconcilerService(
      db as never,
      im as never,
      config as never,
    );

    await expect(service.reconcile()).resolves.toBe(true);
    expect(im.upsertUserToken).toHaveBeenCalledTimes(2);
    expect(im.upsertUserToken.mock.calls[0][1]).not.toBe(
      im.upsertUserToken.mock.calls[1][1],
    );
    expect(im.disconnectUser).toHaveBeenCalledTimes(1);
    expect(db.runtimePolicySync.update).toHaveBeenLastCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: "SYNCED", attempts: 0 }),
      }),
    );
  });

  it("persists failure and an automatic retry deadline", async () => {
    const db = prisma(true);
    const im = {
      upsertUserToken: jest.fn().mockRejectedValue(new Error("IM unavailable")),
      disconnectUser: jest.fn(),
    };
    const service = new ImPolicyReconcilerService(
      db as never,
      im as never,
      config as never,
    );

    await expect(service.reconcile()).resolves.toBe(false);
    expect(db.runtimePolicySync.update).toHaveBeenLastCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          status: "FAILED",
          attempts: 1,
          lastError: expect.stringContaining("IM unavailable") as string,
          nextAttemptAt: expect.any(Date) as Date,
        }),
      }),
    );
  });
});
