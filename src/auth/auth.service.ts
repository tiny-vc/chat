import {
  ConflictException,
  HttpException,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { DeviceType, User } from "@prisma/client";
import { JwtService } from "@nestjs/jwt";
import { compare, hash } from "bcryptjs";
import {
  createHash,
  createHmac,
  randomBytes,
  randomUUID,
  timingSafeEqual,
} from "node:crypto";
import { PrismaService } from "../prisma/prisma.service";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";

type RequestContext = { ipAddress?: string; userAgent?: string };
type DeviceInput = {
  deviceId?: string;
  deviceType?: DeviceType;
  deviceName?: string;
};
const DUMMY_PASSWORD_HASH =
  "$2b$12$C6UzMDM.H6dfI/f/IKcEe.5Z/UnD8gG6J/uM7X1f6P2Jf0eR8Fq6m";

@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly wuKongIm: WuKongImService,
  ) {}

  async register(input: RegisterDto, context: RequestContext = {}) {
    const existing = await this.prisma.user.findUnique({
      where: { username: input.username.toLowerCase() },
      select: { id: true },
    });
    if (existing) throw new ConflictException("Username already exists");
    const user = await this.prisma.user.create({
      data: {
        username: input.username.toLowerCase(),
        nickname: input.nickname,
        passwordHash: await hash(input.password, 12),
      },
    });
    try {
      return await this.createSession(user, input, context);
    } catch (error) {
      await this.prisma.$transaction([
        this.prisma.deviceSession.deleteMany({ where: { userId: user.id } }),
        this.prisma.user.delete({ where: { id: user.id } }),
      ]);
      throw error;
    }
  }

  async login(input: LoginDto, context: RequestContext = {}) {
    const throttleKey = this.loginThrottleKey(
      input.username,
      context.ipAddress,
    );
    await this.assertLoginAllowed(throttleKey);
    const user = await this.prisma.user.findUnique({
      where: { username: input.username.toLowerCase() },
    });
    const passwordMatches = await compare(
      input.password,
      user?.passwordHash ?? DUMMY_PASSWORD_HASH,
    );
    if (!user || user.status !== "ACTIVE" || !passwordMatches) {
      await this.recordLoginFailure(
        throttleKey,
        input.username,
        context,
        user?.id,
      );
      throw new UnauthorizedException("Invalid credentials");
    }
    const response = await this.createSession(user, input, context);
    await this.prisma
      .$transaction([
        this.prisma.loginThrottle.deleteMany({ where: { key: throttleKey } }),
        this.prisma.auditLog.create({
          data: {
            actorUserId: user.id,
            action: "LOGIN_SUCCESS",
            targetType: "DEVICE_SESSION",
            targetId:
              input.deviceId ??
              `${(input.deviceType ?? DeviceType.APP).toLowerCase()}-default`,
            metadata: this.auditContext(context),
          },
        }),
      ])
      .catch(() => undefined);
    return response;
  }

  async refresh(refreshToken: string, context: RequestContext = {}) {
    const sessionId = refreshToken.split(".", 1)[0];
    if (!sessionId) throw new UnauthorizedException("Invalid refresh token");
    const session = await this.prisma.deviceSession.findFirst({
      where: {
        id: sessionId,
        revokedAt: null,
        expiresAt: { gt: new Date() },
        user: { status: "ACTIVE" },
      },
      include: { user: true },
    });
    if (!session || !this.matchesHash(refreshToken, session.refreshTokenHash)) {
      throw new UnauthorizedException("Invalid or expired refresh token");
    }

    const nextRefreshToken = this.createRefreshToken(session.id);
    const imToken = this.createImToken(session.userId, session.deviceType);
    await this.wuKongIm.upsertUserToken(
      session.userId,
      imToken,
      this.deviceFlag(session.deviceType),
    );
    await this.prisma.$transaction(async (tx) => {
      const rotated = await tx.deviceSession.updateMany({
        where: {
          id: session.id,
          refreshTokenHash: session.refreshTokenHash,
          revokedAt: null,
        },
        data: {
          refreshTokenHash: this.hashToken(nextRefreshToken),
          lastSeenAt: new Date(),
          ipAddress: context.ipAddress,
          userAgent: context.userAgent,
        },
      });
      if (rotated.count !== 1)
        throw new UnauthorizedException("Refresh token was already used");
      await tx.user.update({
        where: { id: session.userId },
        data: { imTokenHash: this.hashToken(imToken) },
      });
    });
    return this.sessionResponse(
      session.user,
      session.id,
      nextRefreshToken,
      imToken,
    );
  }

  async listDevices(userId: string, currentSessionId: string) {
    const items = await this.prisma.deviceSession.findMany({
      where: { userId, revokedAt: null, expiresAt: { gt: new Date() } },
      select: {
        id: true,
        deviceId: true,
        deviceType: true,
        deviceName: true,
        ipAddress: true,
        lastSeenAt: true,
        createdAt: true,
      },
      orderBy: { lastSeenAt: "desc" },
    });
    return items.map((item) => ({
      ...item,
      current: item.id === currentSessionId,
    }));
  }

  async revokeDevice(userId: string, sessionId: string) {
    const session = await this.prisma.deviceSession.findFirst({
      where: { id: sessionId, userId, revokedAt: null },
      select: { deviceId: true },
    });
    if (!session) throw new NotFoundException("Device session not found");
    const result = await this.prisma.deviceSession.updateMany({
      where: { id: sessionId, userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    if (result.count !== 1)
      throw new NotFoundException("Device session not found");
    await this.disconnectImDevice(userId, session.deviceId);
    return { success: true };
  }

  async logout(userId: string, sessionId: string) {
    const session = await this.prisma.deviceSession.findFirst({
      where: { id: sessionId, userId, revokedAt: null },
      select: { deviceId: true },
    });
    await this.prisma.deviceSession.updateMany({
      where: { id: sessionId, userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    if (session) await this.disconnectImDevice(userId, session.deviceId);
    return { success: true };
  }

  private async disconnectImDevice(userId: string, deviceId: string) {
    try {
      await this.wuKongIm.disconnectDevice(userId, deviceId);
    } catch (error) {
      this.logger.warn(
        `Device session revoked but WuKongIM disconnect failed for ${userId}/${deviceId}: ${String(error)}`,
      );
    }
  }

  async logoutAll(userId: string) {
    const result = await this.prisma.deviceSession.updateMany({
      where: { userId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
    await this.disconnectImUser(userId);
    return { success: true, revokedSessions: result.count };
  }

  async changePassword(
    userId: string,
    currentSessionId: string,
    currentPassword: string,
    newPassword: string,
    context: RequestContext = {},
  ) {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
    });
    if (!(await compare(currentPassword, user.passwordHash))) {
      throw new UnauthorizedException("Current password is incorrect");
    }
    if (await compare(newPassword, user.passwordHash)) {
      throw new ConflictException("New password must be different");
    }
    const passwordHash = await hash(newPassword, 12);
    const now = new Date();
    const revoked = await this.prisma.$transaction(async (tx) => {
      await tx.user.update({ where: { id: userId }, data: { passwordHash } });
      const result = await tx.deviceSession.updateMany({
        where: { userId, id: { not: currentSessionId }, revokedAt: null },
        data: { revokedAt: now },
      });
      await tx.auditLog.create({
        data: {
          actorUserId: userId,
          action: "PASSWORD_CHANGE",
          targetType: "USER",
          targetId: userId,
          metadata: {
            ...this.auditContext(context),
            revokedSessions: result.count,
          },
        },
      });
      return result.count;
    });
    return { success: true, revokedSessions: revoked };
  }

  async deactivateAccount(
    userId: string,
    currentPassword: string,
    context: RequestContext = {},
  ) {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
    });
    if (!(await compare(currentPassword, user.passwordHash))) {
      throw new UnauthorizedException("Current password is incorrect");
    }
    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      await tx.deviceSession.updateMany({
        where: { userId, revokedAt: null },
        data: { revokedAt: now },
      });
      await tx.user.update({
        where: { id: userId },
        data: { status: "DELETED", imTokenHash: null },
      });
      await tx.auditLog.create({
        data: {
          actorUserId: userId,
          action: "ACCOUNT_DEACTIVATED",
          targetType: "USER",
          targetId: userId,
          metadata: this.auditContext(context),
        },
      });
    });
    await this.disconnectImUser(userId);
    return { success: true };
  }

  private async disconnectImUser(userId: string) {
    try {
      await this.wuKongIm.disconnectUser(userId);
    } catch (error) {
      this.logger.warn(
        `User sessions revoked but WuKongIM disconnect failed for ${userId}: ${String(error)}`,
      );
    }
  }

  private async createSession(
    user: User,
    device: DeviceInput,
    context: RequestContext,
  ) {
    const deviceType = device.deviceType ?? DeviceType.APP;
    const deviceId = device.deviceId ?? `${deviceType.toLowerCase()}-default`;
    const deviceName =
      device.deviceName ??
      (deviceType === DeviceType.APP ? "Flutter App" : deviceType);
    const expiresAt = new Date(
      Date.now() +
        this.config.getOrThrow<number>("REFRESH_TOKEN_TTL_DAYS") * 86_400_000,
    );
    const existing = await this.prisma.deviceSession.findUnique({
      where: { userId_deviceId: { userId: user.id, deviceId } },
      select: { id: true },
    });
    const sessionId = existing?.id ?? randomUUID();
    const refreshToken = this.createRefreshToken(sessionId);
    const imToken = this.createImToken(user.id, deviceType);
    await this.wuKongIm.upsertUserToken(
      user.id,
      imToken,
      this.deviceFlag(deviceType),
    );
    const session = await this.prisma.deviceSession.upsert({
      where: { userId_deviceId: { userId: user.id, deviceId } },
      create: {
        id: sessionId,
        userId: user.id,
        deviceId,
        deviceType,
        deviceName,
        refreshTokenHash: this.hashToken(refreshToken),
        expiresAt,
        ...context,
      },
      update: {
        deviceType,
        deviceName,
        refreshTokenHash: this.hashToken(refreshToken),
        expiresAt,
        revokedAt: null,
        lastSeenAt: new Date(),
        ...context,
      },
    });
    await this.prisma.user.update({
      where: { id: user.id },
      data: { imTokenHash: this.hashToken(imToken) },
    });
    return this.sessionResponse(user, session.id, refreshToken, imToken);
  }

  private async sessionResponse(
    user: Pick<
      User,
      "id" | "username" | "nickname" | "avatarUrl" | "avatarFileId"
    >,
    sessionId: string,
    refreshToken: string,
    imToken: string,
  ) {
    const accessToken = await this.jwt.signAsync(
      { sub: user.id, username: user.username, sid: sessionId },
      { expiresIn: this.config.getOrThrow<string>("JWT_ACCESS_TTL") as never },
    );
    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        username: user.username,
        nickname: user.nickname,
        avatarUrl: user.avatarUrl,
        avatarFileId: user.avatarFileId,
      },
      im: {
        uid: user.id,
        token: imToken,
        address: this.config.getOrThrow<string>("WUKONGIM_TCP_ADDR"),
      },
    };
  }

  // WuKongIM token records are scoped by uid + device_flag rather than by our
  // device session. A stable derived token lets two phones reconnect without a
  // later login invalidating the earlier phone's credentials.
  private createImToken(userId: string, type: DeviceType) {
    return createHmac(
      "sha256",
      this.config.getOrThrow<string>("JWT_ACCESS_SECRET"),
    )
      .update(`wukong-im\0${userId}\0${this.deviceFlag(type)}`)
      .digest("base64url");
  }
  private createRefreshToken(sessionId: string) {
    return `${sessionId}.${randomBytes(48).toString("base64url")}`;
  }
  private hashToken(token: string) {
    return createHash("sha256").update(token).digest("hex");
  }
  private matchesHash(token: string, expectedHash: string) {
    const actual = Buffer.from(this.hashToken(token));
    const expected = Buffer.from(expectedHash);
    return (
      actual.length === expected.length && timingSafeEqual(actual, expected)
    );
  }
  private deviceFlag(type: DeviceType) {
    return type === DeviceType.APP ? 0 : type === DeviceType.WEB ? 1 : 2;
  }

  private loginThrottleKey(username: string, ipAddress?: string) {
    return this.hashToken(
      `${username.trim().toLowerCase()}\0${ipAddress ?? "unknown"}`,
    );
  }

  private async assertLoginAllowed(key: string) {
    const throttle = await this.prisma.loginThrottle.findUnique({
      where: { key },
    });
    if (throttle?.lockedUntil && throttle.lockedUntil > new Date()) {
      throw new HttpException(
        {
          message: "Too many login attempts",
          retryAfter: throttle.lockedUntil.toISOString(),
        },
        429,
      );
    }
  }

  private async recordLoginFailure(
    key: string,
    username: string,
    context: RequestContext,
    userId?: string,
  ) {
    const now = new Date();
    const windowMs =
      this.config.getOrThrow<number>("LOGIN_WINDOW_MINUTES") * 60_000;
    const maximum = this.config.getOrThrow<number>("LOGIN_MAX_ATTEMPTS");
    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.loginThrottle.findUnique({ where: { key } });
      const withinWindow =
        existing && existing.firstFailedAt.getTime() > now.getTime() - windowMs;
      const failedCount = withinWindow ? existing.failedCount + 1 : 1;
      await tx.loginThrottle.upsert({
        where: { key },
        create: {
          key,
          usernameHash: this.hashToken(username.trim().toLowerCase()),
          ipAddress: context.ipAddress ?? "unknown",
          failedCount,
          firstFailedAt: now,
          lastFailedAt: now,
          lockedUntil:
            failedCount >= maximum ? new Date(now.getTime() + windowMs) : null,
        },
        update: {
          failedCount,
          firstFailedAt: withinWindow ? existing.firstFailedAt : now,
          lastFailedAt: now,
          lockedUntil:
            failedCount >= maximum ? new Date(now.getTime() + windowMs) : null,
        },
      });
      await tx.auditLog.create({
        data: {
          actorUserId: userId,
          action: "LOGIN_FAILURE",
          targetType: "LOGIN_IDENTITY",
          targetId: this.hashToken(username.trim().toLowerCase()),
          metadata: {
            ...this.auditContext(context),
            failedCount,
            locked: failedCount >= maximum,
          },
        },
      });
    });
  }

  private auditContext(context: RequestContext) {
    return {
      ipAddress: context.ipAddress ?? null,
      userAgent: context.userAgent ?? null,
    };
  }
}
