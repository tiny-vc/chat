import { UnauthorizedException } from "@nestjs/common";
import { DeviceType } from "@prisma/client";
import { hash } from "bcryptjs";
import { AuthService } from "../src/auth/auth.service";

describe("administrator login", () => {
  it("rejects a valid ordinary account before creating a device session", async () => {
    const passwordHash = await hash("correct-password", 4);
    const transactionUser = {
      loginThrottle: {
        findUnique: jest.fn().mockResolvedValue(null),
        upsert: jest.fn().mockResolvedValue({}),
      },
      auditLog: { create: jest.fn().mockResolvedValue({}) },
    };
    const prisma = {
      runtimeSettings: { findUnique: jest.fn().mockResolvedValue(null) },
      loginThrottle: { findUnique: jest.fn().mockResolvedValue(null) },
      user: {
        findUnique: jest.fn().mockResolvedValue({
          id: "user-id",
          username: "ordinary",
          nickname: "Ordinary",
          passwordHash,
          status: "ACTIVE",
          role: "USER",
        }),
      },
      deviceSession: { upsert: jest.fn() },
      $transaction: jest.fn(
        (operation: (client: typeof transactionUser) => unknown) =>
          Promise.resolve(operation(transactionUser)),
      ),
    };
    const config = {
      getOrThrow: jest.fn((key: string) =>
        key === "LOGIN_WINDOW_MINUTES" ? 15 : 5,
      ),
    };
    const service = new AuthService(
      prisma as never,
      {} as never,
      config as never,
      { upsertUserToken: jest.fn() } as never,
    );

    await expect(
      service.adminLogin(
        { username: "ordinary", password: "correct-password" },
        { ipAddress: "127.0.0.1" },
      ),
    ).rejects.toBeInstanceOf(UnauthorizedException);
    expect(prisma.deviceSession.upsert).not.toHaveBeenCalled();
    expect(transactionUser.loginThrottle.upsert).toHaveBeenCalledTimes(1);
    expect(transactionUser.auditLog.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ action: "LOGIN_FAILURE" }),
      }),
    );
  });

  it("creates an administrator session with the shorter configured lifetime", async () => {
    jest.useFakeTimers().setSystemTime(new Date("2026-09-04T00:00:00.000Z"));
    const passwordHash = await hash("correct-password", 4);
    const deviceSession = {
      findUnique: jest.fn().mockResolvedValue(null),
      upsert: jest
        .fn()
        .mockImplementation(({ create }: { create: { expiresAt: Date } }) =>
          Promise.resolve(create),
        ),
    };
    const prisma = {
      runtimeSettings: {
        findUnique: jest.fn().mockResolvedValue({ messagingEnabled: true }),
      },
      loginThrottle: {
        findUnique: jest.fn().mockResolvedValue(null),
        deleteMany: jest.fn().mockResolvedValue({ count: 0 }),
      },
      user: {
        findUnique: jest.fn().mockResolvedValue({
          id: "admin-id",
          username: "admin",
          nickname: "Admin",
          avatarUrl: null,
          avatarFileId: null,
          passwordHash,
          status: "ACTIVE",
          role: "ADMIN",
        }),
        update: jest.fn().mockResolvedValue({}),
      },
      deviceSession,
      auditLog: { create: jest.fn().mockResolvedValue({}) },
      $transaction: jest.fn().mockResolvedValue([]),
    };
    const values: Record<string, unknown> = {
      ADMIN_REFRESH_TOKEN_TTL_HOURS: 12,
      REFRESH_TOKEN_TTL_DAYS: 30,
      JWT_ACCESS_SECRET: "a-secure-test-secret-with-32-characters",
      JWT_ACCESS_TTL: "15m",
    };
    const service = new AuthService(
      prisma as never,
      { signAsync: jest.fn().mockResolvedValue("access-token") } as never,
      { getOrThrow: jest.fn((key: string) => values[key]) } as never,
      { upsertUserToken: jest.fn().mockResolvedValue(undefined) } as never,
    );

    try {
      await service.adminLogin({
        username: "admin",
        password: "correct-password",
        deviceId: "admin-browser",
        deviceType: DeviceType.WEB,
      });
      const expiresAt = deviceSession.upsert.mock.calls[0][0].create.expiresAt;
      expect(expiresAt).toEqual(new Date("2026-09-04T12:00:00.000Z"));
      expect(prisma.auditLog.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ action: "ADMIN_LOGIN_SUCCESS" }),
        }),
      );
    } finally {
      jest.useRealTimers();
    }
  });
});
