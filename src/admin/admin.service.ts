import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { Prisma } from "@prisma/client";
import { WuKongImService } from "../integrations/wukongim/wukongim.service";
import { PrismaService } from "../prisma/prisma.service";
import { SetGroupPolicyDto } from "./dto/set-group-policy.dto";
import {
  AdminGroupListQueryDto,
  AdminGroupMemberListQueryDto,
  AdminUserListQueryDto,
} from "./dto/admin-list-query.dto";
import { AdminAuditQueryDto } from "./dto/admin-audit-query.dto";

@Injectable()
export class AdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wuKongIm: WuKongImService,
  ) {}

  async overview() {
    const dayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const [
      users,
      activeUsers,
      suspendedUsers,
      newUsers24h,
      groups,
      activeGroups,
      suspendedGroups,
      readyFiles,
      fileStorage,
      activeCalls,
      pendingJoinRequests,
    ] = await Promise.all([
      this.prisma.user.count({ where: { status: { not: "DELETED" } } }),
      this.prisma.user.count({ where: { status: "ACTIVE" } }),
      this.prisma.user.count({ where: { status: "SUSPENDED" } }),
      this.prisma.user.count({
        where: { createdAt: { gte: dayAgo }, status: { not: "DELETED" } },
      }),
      this.prisma.group.count({ where: { status: { not: "DISBANDED" } } }),
      this.prisma.group.count({ where: { status: "ACTIVE" } }),
      this.prisma.group.count({ where: { status: "SUSPENDED" } }),
      this.prisma.storedFile.count({ where: { status: "READY" } }),
      this.prisma.storedFile.aggregate({
        where: { status: "READY" },
        _sum: { sizeBytes: true },
      }),
      this.prisma.callSession.count({
        where: {
          status: { in: ["INVITING", "RINGING", "ACCEPTED", "CONNECTED"] },
        },
      }),
      this.prisma.groupJoinRequest.count({
        where: { status: "PENDING", expiresAt: { gt: new Date() } },
      }),
    ]);
    return {
      generatedAt: new Date().toISOString(),
      users: {
        total: users,
        active: activeUsers,
        suspended: suspendedUsers,
        new24h: newUsers24h,
      },
      groups: {
        total: groups,
        active: activeGroups,
        suspended: suspendedGroups,
      },
      files: {
        ready: readyFiles,
        storageBytes: (fileStorage._sum.sizeBytes ?? 0n).toString(),
      },
      calls: { active: activeCalls },
      moderation: { pendingGroupJoinRequests: pendingJoinRequests },
    };
  }

  async listUsers(query: AdminUserListQueryDto) {
    const search = query.search?.trim();
    const items = await this.prisma.user.findMany({
      take: query.limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      where: {
        ...(query.status ? { status: query.status } : {}),
        ...(query.role ? { role: query.role } : {}),
        ...(search
          ? {
              OR: [
                {
                  username: {
                    contains: search,
                    mode: Prisma.QueryMode.insensitive,
                  },
                },
                {
                  nickname: {
                    contains: search,
                    mode: Prisma.QueryMode.insensitive,
                  },
                },
              ],
            }
          : {}),
      },
      orderBy: [{ createdAt: "desc" }, { id: "desc" }],
      select: {
        id: true,
        username: true,
        nickname: true,
        avatarUrl: true,
        status: true,
        role: true,
        createdAt: true,
        updatedAt: true,
        _count: {
          select: { deviceSessions: true, groupMemberships: true, files: true },
        },
      },
    });
    return this.page(items, query.limit);
  }

  async getUser(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        username: true,
        nickname: true,
        avatarUrl: true,
        avatarFileId: true,
        status: true,
        role: true,
        createdAt: true,
        updatedAt: true,
        deviceSessions: {
          orderBy: { lastSeenAt: "desc" },
          take: 20,
          select: {
            id: true,
            deviceId: true,
            deviceType: true,
            deviceName: true,
            ipAddress: true,
            userAgent: true,
            lastSeenAt: true,
            expiresAt: true,
            revokedAt: true,
            createdAt: true,
          },
        },
        _count: { select: { groupMemberships: true, files: true } },
      },
    });
    if (!user) throw new NotFoundException("User not found");
    return user;
  }

  async listGroups(query: AdminGroupListQueryDto) {
    const search = query.search?.trim();
    const items = await this.prisma.group.findMany({
      take: query.limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      where: {
        ...(query.status ? { status: query.status } : {}),
        ...(search
          ? { name: { contains: search, mode: Prisma.QueryMode.insensitive } }
          : {}),
      },
      orderBy: [{ createdAt: "desc" }, { id: "desc" }],
      select: {
        id: true,
        name: true,
        avatarUrl: true,
        ownerId: true,
        memberLimit: true,
        muteAll: true,
        status: true,
        createdAt: true,
        updatedAt: true,
        owner: { select: { id: true, username: true, nickname: true } },
        _count: { select: { members: { where: { status: "ACTIVE" } } } },
      },
    });
    return this.page(items, query.limit);
  }

  async getGroup(groupId: string) {
    const group = await this.prisma.group.findUnique({
      where: { id: groupId },
      select: {
        id: true,
        name: true,
        avatarUrl: true,
        avatarFileId: true,
        ownerId: true,
        memberLimit: true,
        muteAll: true,
        status: true,
        createdAt: true,
        updatedAt: true,
        owner: {
          select: { id: true, username: true, nickname: true, status: true },
        },
        _count: {
          select: {
            members: { where: { status: "ACTIVE" } },
            joinRequests: true,
          },
        },
      },
    });
    if (!group) throw new NotFoundException("Group not found");
    return group;
  }

  async listGroupMembers(groupId: string, query: AdminGroupMemberListQueryDto) {
    const exists = await this.prisma.group.findUnique({
      where: { id: groupId },
      select: { id: true },
    });
    if (!exists) throw new NotFoundException("Group not found");
    const search = query.search?.trim();
    const items = await this.prisma.groupMember.findMany({
      take: query.limit + 1,
      ...(query.cursor
        ? {
            cursor: { groupId_userId: { groupId, userId: query.cursor } },
            skip: 1,
          }
        : {}),
      where: {
        groupId,
        ...(search
          ? {
              OR: [
                {
                  nickname: {
                    contains: search,
                    mode: Prisma.QueryMode.insensitive,
                  },
                },
                {
                  user: {
                    username: {
                      contains: search,
                      mode: Prisma.QueryMode.insensitive,
                    },
                  },
                },
                {
                  user: {
                    nickname: {
                      contains: search,
                      mode: Prisma.QueryMode.insensitive,
                    },
                  },
                },
              ],
            }
          : {}),
      },
      orderBy: [{ joinedAt: "desc" }, { userId: "desc" }],
      select: {
        groupId: true,
        userId: true,
        role: true,
        status: true,
        nickname: true,
        mutedUntil: true,
        joinedAt: true,
        user: {
          select: {
            id: true,
            username: true,
            nickname: true,
            avatarUrl: true,
            status: true,
          },
        },
      },
    });
    return this.page(items, query.limit, (item) => item.userId);
  }

  private page<T extends { id: string }>(
    items: T[],
    limit: number,
  ): { items: T[]; nextCursor: string | null };
  private page<T>(
    items: T[],
    limit: number,
    cursor: (item: T) => string,
  ): { items: T[]; nextCursor: string | null };
  private page<T extends { id?: string }>(
    items: T[],
    limit: number,
    cursor?: (item: T) => string,
  ) {
    const hasMore = items.length > limit;
    if (hasMore) items.pop();
    const last = items.at(-1);
    return {
      items,
      nextCursor: hasMore && last ? (cursor ? cursor(last) : last.id) : null,
    };
  }

  async setUserSuspended(actorId: string, userId: string, suspended: boolean) {
    if (actorId === userId && suspended)
      throw new ForbiddenException("Cannot suspend yourself");
    const target = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!target || target.status === "DELETED")
      throw new NotFoundException("User not found");
    const status = suspended ? "SUSPENDED" : "ACTIVE";
    const user = await this.prisma.$transaction(async (tx) => {
      const now = new Date();
      const updated = await tx.user.update({
        where: { id: userId },
        data: { status },
        select: {
          id: true,
          username: true,
          nickname: true,
          status: true,
          role: true,
        },
      });
      const revoked = suspended
        ? await tx.deviceSession.updateMany({
            where: { userId, revokedAt: null },
            data: { revokedAt: now },
          })
        : { count: 0 };
      await tx.auditLog.create({
        data: {
          actorUserId: actorId,
          action: suspended ? "USER_SUSPEND" : "USER_ACTIVATE",
          targetType: "USER",
          targetId: userId,
          metadata: { revokedSessions: revoked.count },
        },
      });
      return { ...updated, revokedSessions: revoked.count };
    });
    return user;
  }

  async revokeUserDevice(actorId: string, userId: string, sessionId: string) {
    const session = await this.prisma.deviceSession.findFirst({
      where: { id: sessionId, userId, revokedAt: null },
      select: { deviceId: true },
    });
    if (!session)
      throw new NotFoundException("Active device session not found");
    const result = await this.prisma.$transaction(async (tx) => {
      const revoked = await tx.deviceSession.updateMany({
        where: { id: sessionId, userId, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      if (revoked.count !== 1)
        throw new NotFoundException("Active device session not found");
      await tx.auditLog.create({
        data: {
          actorUserId: actorId,
          action: "DEVICE_SESSION_REVOKE_ADMIN",
          targetType: "DEVICE_SESSION",
          targetId: sessionId,
          metadata: { userId },
        },
      });
      return { success: true, revokedSessions: 1 };
    });
    await this.wuKongIm.disconnectDevice(userId, session.deviceId).catch(() => {
      // The durable API-session revocation remains successful when IM is down.
    });
    return result;
  }

  async setGroupPolicy(
    actorId: string,
    groupId: string,
    input: SetGroupPolicyDto,
  ) {
    if (input.suspended === undefined && input.muteAll === undefined) {
      throw new BadRequestException("At least one policy field is required");
    }
    const group = await this.prisma.group.findUnique({
      where: { id: groupId },
    });
    if (!group || group.status === "DISBANDED")
      throw new NotFoundException("Group not found");

    await this.wuKongIm.updateChannelPolicy(groupId, {
      banned: input.suspended,
      sendBanned: input.muteAll,
    });
    const data: Prisma.GroupUpdateInput = {};
    if (input.suspended !== undefined)
      data.status = input.suspended ? "SUSPENDED" : "ACTIVE";
    if (input.muteAll !== undefined) data.muteAll = input.muteAll;
    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.group.update({ where: { id: groupId }, data });
      await tx.auditLog.create({
        data: {
          actorUserId: actorId,
          action: "GROUP_POLICY_UPDATE",
          targetType: "GROUP",
          targetId: groupId,
          metadata: input as Prisma.InputJsonObject,
        },
      });
      return updated;
    });
  }

  async listAuditLogs(query: AdminAuditQueryDto) {
    if (query.from && query.to && query.from > query.to) {
      throw new BadRequestException("from must be before or equal to to");
    }
    const items = await this.prisma.auditLog.findMany({
      take: query.limit + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      where: {
        ...(query.action ? { action: query.action } : {}),
        ...(query.targetType ? { targetType: query.targetType } : {}),
        ...(query.targetId ? { targetId: query.targetId } : {}),
        ...(query.actorUserId ? { actorUserId: query.actorUserId } : {}),
        ...(query.from || query.to
          ? {
              createdAt: {
                ...(query.from ? { gte: query.from } : {}),
                ...(query.to ? { lte: query.to } : {}),
              },
            }
          : {}),
      },
      orderBy: [{ createdAt: "desc" }, { id: "desc" }],
      include: {
        actor: { select: { id: true, username: true, nickname: true } },
      },
    });
    return this.page(items, query.limit);
  }
}
