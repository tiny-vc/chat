import { JobsService } from "../src/jobs/jobs.service";

const configValues: Record<string, string | number> = {
  JOBS_ENABLED: "false",
  CLEANUP_INTERVAL_MINUTES: 60,
  PENDING_UPLOAD_TTL_HOURS: 24,
  SESSION_RETENTION_DAYS: 30,
  LOGIN_THROTTLE_RETENTION_DAYS: 7,
};

describe("JobsService", () => {
  const config = { getOrThrow: jest.fn((key: string) => configValues[key]) };

  it("records a skipped run when another instance owns the lock", async () => {
    const update = jest.fn().mockResolvedValue({ status: "SKIPPED" });
    const prisma = {
      jobRun: { create: jest.fn().mockResolvedValue({ id: "run-1" }), update },
      $transaction: jest.fn((callback: (tx: unknown) => unknown) =>
        Promise.resolve(
          callback({
            $queryRaw: jest.fn().mockResolvedValue([{ acquired: false }]),
          }),
        ),
      ),
    };
    const service = new JobsService(
      prisma as never,
      {} as never,
      {} as never,
      config as never,
    );
    await expect(service.runCleanup("SCHEDULED")).resolves.toEqual({
      status: "SKIPPED",
    });
    expect(update).toHaveBeenCalledWith({
      where: { id: "run-1" },
      data: expect.objectContaining({ status: "SKIPPED" }),
    });
  });

  it("cleans stale records and stores metrics", async () => {
    const update = jest
      .fn()
      .mockImplementation(({ data }) => Promise.resolve(data));
    const prisma = {
      jobRun: { create: jest.fn().mockResolvedValue({ id: "run-2" }), update },
      storedFile: {
        findMany: jest.fn().mockResolvedValue([]),
        updateMany: jest.fn().mockResolvedValue({ count: 0 }),
      },
      deviceSession: { deleteMany: jest.fn().mockResolvedValue({ count: 2 }) },
      loginThrottle: { deleteMany: jest.fn().mockResolvedValue({ count: 3 }) },
      groupMember: {
        findMany: jest.fn().mockResolvedValue([]),
        updateMany: jest.fn().mockResolvedValue({ count: 0 }),
      },
      groupJoinRequest: {
        updateMany: jest.fn().mockResolvedValue({ count: 0 }),
      },
      $transaction: jest.fn(async (input: unknown) => {
        if (typeof input === "function") {
          const callback = input as (tx: unknown) => Promise<unknown>;
          return await callback({
            $queryRaw: jest.fn().mockResolvedValue([{ acquired: true }]),
          });
        }
        return await Promise.all(input as Promise<unknown>[]);
      }),
    };
    const files = {
      deleteStoredObjects: jest.fn().mockResolvedValue(undefined),
    };
    const service = new JobsService(
      prisma as never,
      files as never,
      {} as never,
      config as never,
    );
    const result = await service.runCleanup("MANUAL");
    expect(result).toMatchObject({
      status: "SUCCESS",
      metrics: { sessionsDeleted: 2, loginThrottlesDeleted: 3 },
    });
    expect(files.deleteStoredObjects).toHaveBeenCalledWith([]);
  });

  it("returns filtered job runs with a stable cursor", async () => {
    const findMany = jest
      .fn()
      .mockResolvedValue([{ id: "run-3" }, { id: "run-2" }, { id: "run-1" }]);
    const service = new JobsService(
      { jobRun: { findMany } } as never,
      {} as never,
      {} as never,
      config as never,
    );
    await expect(
      service.listRuns({ limit: 2, status: "FAILED" }),
    ).resolves.toEqual({
      items: [{ id: "run-3" }, { id: "run-2" }],
      nextCursor: "run-2",
    });
    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        take: 3,
        where: { status: "FAILED" },
        orderBy: [{ startedAt: "desc" }, { id: "desc" }],
      }),
    );
  });
});
