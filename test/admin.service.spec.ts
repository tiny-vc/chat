import { AdminService } from "../src/admin/admin.service";
import { PrismaService } from "../src/prisma/prisma.service";
import { WuKongImService } from "../src/integrations/wukongim/wukongim.service";

describe("AdminService", () => {
  const prisma = {
    user: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      count: jest.fn(),
    },
    group: { findMany: jest.fn(), findUnique: jest.fn(), count: jest.fn() },
    groupMember: { findMany: jest.fn() },
    storedFile: { count: jest.fn(), aggregate: jest.fn() },
    callSession: { count: jest.fn() },
    groupJoinRequest: { count: jest.fn() },
    auditLog: { findMany: jest.fn(), create: jest.fn() },
    deviceSession: { findFirst: jest.fn(), updateMany: jest.fn() },
    $transaction: jest.fn(),
  };
  const wuKongIm = {
    updateChannelPolicy: jest.fn(),
    disconnectDevice: jest.fn(),
  };
  const service = new AdminService(
    prisma as unknown as PrismaService,
    wuKongIm as unknown as WuKongImService,
  );

  beforeEach(() => {
    jest.clearAllMocks();
    wuKongIm.disconnectDevice.mockResolvedValue(1);
    prisma.$transaction.mockImplementation(
      (operation: (client: typeof prisma) => unknown) => operation(prisma),
    );
  });

  it("returns a bounded cursor page for users", async () => {
    prisma.user.findMany.mockResolvedValue([
      { id: "user-3" },
      { id: "user-2" },
      { id: "user-1" },
    ]);

    await expect(
      service.listUsers({ limit: 2, search: "Alice" }),
    ).resolves.toEqual({
      items: [{ id: "user-3" }, { id: "user-2" }],
      nextCursor: "user-2",
    });
    expect(prisma.user.findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        take: 3,
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
      }),
    );
  });

  it("selects safe user detail fields without credential hashes", async () => {
    prisma.user.findUnique.mockResolvedValue({
      id: "user-1",
      username: "alice",
    });
    await service.getUser("user-1");

    const call = prisma.user.findUnique.mock.calls[0][0] as {
      select: Record<string, unknown>;
    };
    expect(call.select).not.toHaveProperty("passwordHash");
    expect(call.select).not.toHaveProperty("imTokenHash");
    expect(call.select.deviceSessions).toEqual(
      expect.objectContaining({
        select: expect.not.objectContaining({ refreshTokenHash: true }),
      }),
    );
  });

  it("uses the member user ID as the next cursor", async () => {
    prisma.group.findUnique.mockResolvedValue({ id: "group-1" });
    prisma.groupMember.findMany.mockResolvedValue([
      { userId: "user-3" },
      { userId: "user-2" },
      { userId: "user-1" },
    ]);

    await expect(
      service.listGroupMembers("group-1", { limit: 2 }),
    ).resolves.toEqual({
      items: [{ userId: "user-3" }, { userId: "user-2" }],
      nextCursor: "user-2",
    });
  });

  it("serializes storage bytes in the management overview", async () => {
    prisma.user.count
      .mockResolvedValueOnce(10)
      .mockResolvedValueOnce(8)
      .mockResolvedValueOnce(2)
      .mockResolvedValueOnce(1);
    prisma.group.count
      .mockResolvedValueOnce(4)
      .mockResolvedValueOnce(3)
      .mockResolvedValueOnce(1);
    prisma.storedFile.count.mockResolvedValue(7);
    prisma.storedFile.aggregate.mockResolvedValue({
      _sum: { sizeBytes: 9007199254740993n },
    });
    prisma.callSession.count.mockResolvedValue(2);
    prisma.groupJoinRequest.count.mockResolvedValue(5);

    await expect(service.overview()).resolves.toEqual(
      expect.objectContaining({
        users: { total: 10, active: 8, suspended: 2, new24h: 1 },
        groups: { total: 4, active: 3, suspended: 1 },
        files: { ready: 7, storageBytes: "9007199254740993" },
        calls: { active: 2 },
        moderation: { pendingGroupJoinRequests: 5 },
      }),
    );
  });

  it("rejects an inverted audit time range", async () => {
    await expect(
      service.listAuditLogs({
        limit: 50,
        from: new Date("2026-02-02T00:00:00Z"),
        to: new Date("2026-02-01T00:00:00Z"),
      }),
    ).rejects.toThrow("from must be before or equal to to");
    expect(prisma.auditLog.findMany).not.toHaveBeenCalled();
  });

  it("revokes every active device session when suspending a user", async () => {
    prisma.user.findUnique.mockResolvedValue({
      id: "user-1",
      status: "ACTIVE",
    });
    prisma.user.update.mockResolvedValue({ id: "user-1", status: "SUSPENDED" });
    prisma.deviceSession.updateMany.mockResolvedValue({ count: 3 });
    prisma.auditLog.create.mockResolvedValue({ id: "audit-1" });

    await expect(
      service.setUserSuspended("admin-1", "user-1", true),
    ).resolves.toEqual({
      id: "user-1",
      status: "SUSPENDED",
      revokedSessions: 3,
    });
    expect(prisma.deviceSession.updateMany).toHaveBeenCalledWith({
      where: { userId: "user-1", revokedAt: null },
      data: { revokedAt: expect.any(Date) },
    });
  });

  it("allows an administrator to revoke one user device", async () => {
    prisma.deviceSession.findFirst.mockResolvedValue({ deviceId: "device-a" });
    prisma.deviceSession.updateMany.mockResolvedValue({ count: 1 });
    prisma.auditLog.create.mockResolvedValue({ id: "audit-2" });

    await expect(
      service.revokeUserDevice("admin-1", "user-1", "session-1"),
    ).resolves.toEqual({
      success: true,
      revokedSessions: 1,
    });
    expect(prisma.auditLog.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        action: "DEVICE_SESSION_REVOKE_ADMIN",
        targetId: "session-1",
        metadata: { userId: "user-1" },
      }),
    });
    expect(wuKongIm.disconnectDevice).toHaveBeenCalledWith(
      "user-1",
      "device-a",
    );
  });
});
