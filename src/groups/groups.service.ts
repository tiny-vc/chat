import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  GoneException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { GroupRole, Prisma } from '@prisma/client';
import { ConfigService } from '@nestjs/config';
import { randomUUID } from 'node:crypto';
import { PrismaService } from '../prisma/prisma.service';
import { WuKongImService } from '../integrations/wukongim/wukongim.service';
import { AddGroupMembersDto } from './dto/add-group-members.dto';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';
import { SetMemberRoleDto } from './dto/set-member-role.dto';
import { MuteMemberDto } from './dto/mute-member.dto';
import { MessageType, systemMessageSchema } from '../messages/message-protocol';
import { GroupJoinMessageDto } from './dto/group-join-message.dto';
import { InviteGroupMemberDto } from './dto/invite-group-member.dto';
import { GroupJoinPageDto } from './dto/group-join-page.dto';

const memberInclude = {
  user: {
    select: { id: true, username: true, nickname: true, avatarUrl: true, avatarFileId: true },
  },
} as const;

@Injectable()
export class GroupsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wuKongIm: WuKongImService,
    private readonly config: ConfigService,
  ) {}

  async create(ownerId: string, input: CreateGroupDto) {
    const memberIds = [...new Set(input.memberIds.filter((id) => id !== ownerId))];
    const activeUsers = await this.prisma.user.count({
      where: { id: { in: memberIds }, status: 'ACTIVE' },
    });
    if (activeUsers !== memberIds.length) {
      throw new NotFoundException('One or more users do not exist');
    }

    const group = await this.prisma.group.create({
      data: {
        name: input.name,
        ownerId,
        members: {
          create: [
            { userId: ownerId, role: 'OWNER' },
            ...memberIds.map((userId) => ({ userId, role: GroupRole.MEMBER })),
          ],
        },
      },
      include: { members: { include: memberInclude } },
    });

    try {
      await this.wuKongIm.addChannelSubscribers(group.id, [ownerId, ...memberIds]);
    } catch (error) {
      await this.prisma.$transaction([
        this.prisma.groupMember.deleteMany({ where: { groupId: group.id } }),
        this.prisma.group.delete({ where: { id: group.id } }),
      ]);
      throw error;
    }
    return group;
  }

  async list(userId: string) {
    return this.prisma.group.findMany({
      where: { status: 'ACTIVE', members: { some: { userId, status: 'ACTIVE' } } },
      orderBy: { updatedAt: 'desc' },
    });
  }

  async get(groupId: string, userId: string) {
    await this.requireMember(groupId, userId);
    const group = await this.prisma.group.findFirst({
      where: { id: groupId, status: 'ACTIVE' },
      include: {
        members: {
          where: { status: 'ACTIVE' },
          include: memberInclude,
          orderBy: [{ role: 'asc' }, { joinedAt: 'asc' }],
        },
      },
    });
    if (!group) throw new NotFoundException('Group not found');
    return group;
  }

  async update(groupId: string, userId: string, input: UpdateGroupDto) {
    await this.requireRole(groupId, userId, ['OWNER', 'ADMIN']);
    if (input.muteAll !== undefined) {
      await this.wuKongIm.updateChannelPolicy(groupId, { sendBanned: input.muteAll });
    }
    return this.prisma.group.update({ where: { id: groupId }, data: input });
  }

  async setMemberRole(
    groupId: string,
    ownerId: string,
    memberId: string,
    role: SetMemberRoleDto['role'],
  ) {
    await this.requireRole(groupId, ownerId, ['OWNER']);
    const member = await this.requireMember(groupId, memberId);
    if (member.role === 'OWNER') throw new ForbiddenException('Cannot change owner role');
    const updated = await this.prisma.groupMember.update({
      where: { groupId_userId: { groupId, userId: memberId } }, data: { role },
      include: memberInclude,
    });
    await this.sendSystemNotice(groupId, ownerId, 'group.member_role_changed', {
      memberId, role,
    });
    return updated;
  }

  async transferOwner(groupId: string, ownerId: string, newOwnerId: string) {
    if (ownerId === newOwnerId) throw new ConflictException('User is already the owner');
    await this.requireRole(groupId, ownerId, ['OWNER']);
    await this.requireMember(groupId, newOwnerId);
    const group = await this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`
        SELECT pg_advisory_xact_lock(hashtext(${'group-owner:' + groupId}))::text AS locked
      `;
      const current = await tx.group.findFirst({ where: { id: groupId, ownerId, status: 'ACTIVE' } });
      if (!current) throw new ConflictException('Group ownership has already changed');
      await tx.groupMember.update({
        where: { groupId_userId: { groupId, userId: ownerId } }, data: { role: 'ADMIN' },
      });
      await tx.groupMember.update({
        where: { groupId_userId: { groupId, userId: newOwnerId } }, data: { role: 'OWNER' },
      });
      return tx.group.update({ where: { id: groupId }, data: { ownerId: newOwnerId } });
    });
    await this.sendSystemNotice(groupId, ownerId, 'group.owner_transferred', {
      previousOwnerId: ownerId, newOwnerId,
    });
    return group;
  }

  async muteMember(
    groupId: string,
    operatorId: string,
    memberId: string,
    input: MuteMemberDto,
  ) {
    const operator = await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const member = await this.requireMember(groupId, memberId);
    if (member.role === 'OWNER') throw new ForbiddenException('Cannot mute group owner');
    if (operator.role === 'ADMIN' && member.role === 'ADMIN') {
      throw new ForbiddenException('Admin cannot mute another admin');
    }
    if (input.muted) await this.wuKongIm.addChannelBlacklist(groupId, 2, [memberId]);
    else await this.wuKongIm.removeChannelBlacklist(groupId, 2, [memberId]);
    const mutedUntil = input.muted
      ? new Date(Date.now() + (input.durationMinutes ?? 60) * 60_000)
      : null;
    const updated = await this.prisma.groupMember.update({
      where: { groupId_userId: { groupId, userId: memberId } }, data: { mutedUntil },
      include: memberInclude,
    });
    await this.sendSystemNotice(groupId, operatorId, input.muted ? 'group.member_muted' : 'group.member_unmuted', {
      memberId, mutedUntil: mutedUntil?.toISOString() ?? null,
    });
    return updated;
  }

  async setAvatar(groupId: string, operatorId: string, fileId: string) {
    await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const file = await this.prisma.storedFile.findFirst({
      where: { id: fileId, ownerUserId: operatorId, status: 'READY' },
      include: { avatarFor: { select: { id: true } }, groupAvatarFor: { select: { id: true } } },
    });
    if (!file) throw new NotFoundException('Group avatar file not found');
    if (
      file.purpose !== 'AVATAR' ||
      file.scope !== 'PRIVATE' ||
      !file.mimeType.startsWith('image/') ||
      file.avatarFor ||
      (file.groupAvatarFor && file.groupAvatarFor.id !== groupId)
    ) {
      throw new ForbiddenException('Invalid or already-bound group avatar file');
    }
    const group = await this.prisma.group.update({
      where: { id: groupId }, data: { avatarFileId: file.id, avatarUrl: null },
    });
    await this.sendSystemNotice(groupId, operatorId, 'group.avatar_changed', {});
    return group;
  }

  async removeAvatar(groupId: string, operatorId: string) {
    await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const group = await this.prisma.group.update({
      where: { id: groupId }, data: { avatarFileId: null, avatarUrl: null },
    });
    await this.sendSystemNotice(groupId, operatorId, 'group.avatar_changed', {});
    return group;
  }

  async applyToJoin(groupId: string, userId: string, input: GroupJoinMessageDto) {
    const group = await this.prisma.group.findFirst({ where: { id: groupId, status: 'ACTIVE' } });
    if (!group) throw new NotFoundException('Group not found');
    const member = await this.prisma.groupMember.findFirst({
      where: { groupId, userId, status: 'ACTIVE' }, select: { userId: true },
    });
    if (member) throw new ConflictException('Already a group member');
    return this.createJoinRequest({
      groupId, userId, requestedById: userId, type: 'APPLY', message: input.message,
    });
  }

  async inviteMember(groupId: string, operatorId: string, input: InviteGroupMemberDto) {
    await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const user = await this.prisma.user.findFirst({
      where: { id: input.userId, status: 'ACTIVE' }, select: { id: true },
    });
    if (!user) throw new NotFoundException('User not found');
    const member = await this.prisma.groupMember.findFirst({
      where: { groupId, userId: input.userId, status: 'ACTIVE' }, select: { userId: true },
    });
    if (member) throw new ConflictException('Already a group member');
    return this.createJoinRequest({
      groupId, userId: input.userId, requestedById: operatorId,
      type: 'INVITE', message: input.message,
    });
  }

  private joinPageWhere(page: GroupJoinPageDto): Prisma.GroupJoinRequestWhereInput {
    if (Boolean(page.before) !== Boolean(page.beforeId)) {
      throw new BadRequestException('before and beforeId must be supplied together');
    }
    if (!page.before || !page.beforeId) return {};
    const before = new Date(page.before);
    if (!Number.isFinite(before.getTime())) throw new BadRequestException('Invalid before');
    return { OR: [
      { createdAt: { lt: before } },
      { createdAt: before, id: { lt: page.beforeId } },
    ] };
  }

  private actionableJoinWhere(userId: string): Prisma.GroupJoinRequestWhereInput {
    return {
      status: 'PENDING', group: { status: 'ACTIVE' }, expiresAt: { gt: new Date() },
      OR: [
        { type: 'INVITE', userId },
        { type: 'APPLY', group: { members: { some: {
          userId, status: 'ACTIVE', role: { in: ['OWNER', 'ADMIN'] },
        } } } },
      ],
    };
  }

  async listActionableJoinRequests(userId: string, page: GroupJoinPageDto = {}) {
    return this.listJoinPage(this.actionableJoinWhere(userId), page);
  }

  async listMyJoinRequests(userId: string, page: GroupJoinPageDto = {}) {
    return this.listJoinPage({ OR: [{ userId }, { requestedById: userId }] }, page);
  }

  private listJoinPage(where: Prisma.GroupJoinRequestWhereInput, page: GroupJoinPageDto) {
    return this.prisma.groupJoinRequest.findMany({
      where: { AND: [where, this.joinPageWhere(page)] },
      include: {
        group: {
          select: {
            id: true, name: true, avatarFileId: true, status: true,
            ownerId: true, memberLimit: true, muteAll: true,
          },
        },
        requestedBy: { select: { id: true, username: true, nickname: true } },
        user: { select: { id: true, username: true, nickname: true, avatarFileId: true } },
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: 100,
    });
  }

  async listPendingJoinRequests(groupId: string, operatorId: string) {
    await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    return this.prisma.groupJoinRequest.findMany({
      where: { groupId, status: 'PENDING', expiresAt: { gt: new Date() } },
      include: {
        user: { select: { id: true, username: true, nickname: true, avatarFileId: true } },
        requestedBy: { select: { id: true, username: true, nickname: true } },
      },
      orderBy: { createdAt: 'asc' },
    });
  }

  async pendingJoinRequestCount(userId: string) {
    const count = await this.prisma.groupJoinRequest.count({
      where: this.actionableJoinWhere(userId),
    });
    return { count };
  }

  async approveJoinRequest(requestId: string, actorId: string) {
    const request = await this.requirePendingJoinRequest(requestId);
    if (request.type === 'APPLY') {
      await this.requireRole(request.groupId, actorId, ['OWNER', 'ADMIN']);
    } else if (request.userId !== actorId) {
      throw new ForbiddenException('Only the invited user can accept this invitation');
    }
    let subscriberAdded = false;
    try {
      const updated = await this.prisma.$transaction(async (tx) => {
        await tx.$queryRaw`
          SELECT pg_advisory_xact_lock(hashtext(${'group-join:' + requestId}))::text AS locked
        `;
        const current = await tx.groupJoinRequest.findFirst({
          where: { id: requestId, status: 'PENDING', expiresAt: { gt: new Date() } },
        });
        if (!current) throw new ConflictException('Join request is no longer pending');
        const group = await tx.group.findFirst({ where: { id: current.groupId, status: 'ACTIVE' } });
        if (!group) throw new NotFoundException('Group not found');
        const memberCount = await tx.groupMember.count({
          where: { groupId: current.groupId, status: 'ACTIVE' },
        });
        if (memberCount >= group.memberLimit) throw new ConflictException('Group member limit exceeded');
        await this.wuKongIm.addChannelSubscribers(current.groupId, [current.userId]);
        subscriberAdded = true;
        await tx.groupMember.upsert({
          where: { groupId_userId: { groupId: current.groupId, userId: current.userId } },
          create: { groupId: current.groupId, userId: current.userId },
          update: { status: 'ACTIVE', role: 'MEMBER', joinedAt: new Date(), mutedUntil: null },
        });
        return tx.groupJoinRequest.update({
          where: { id: current.id },
          data: {
            status: 'APPROVED', activeKey: null, decidedById: actorId, decidedAt: new Date(),
          },
        });
      }, { timeout: 15_000 });
      await this.sendSystemNotice(request.groupId, actorId, 'group.join_request_approved', {
        userId: request.userId, requestId,
      });
      return updated;
    } catch (error) {
      if (subscriberAdded) {
        await this.wuKongIm.removeChannelSubscribers(request.groupId, [request.userId]).catch(() => undefined);
      }
      throw error;
    }
  }

  async rejectJoinRequest(requestId: string, actorId: string, input: GroupJoinMessageDto) {
    const request = await this.requirePendingJoinRequest(requestId);
    if (request.type === 'APPLY') {
      await this.requireRole(request.groupId, actorId, ['OWNER', 'ADMIN']);
    } else if (request.userId !== actorId) {
      throw new ForbiddenException('Only the invited user can reject this invitation');
    }
    return this.finishJoinRequest(requestId, actorId, 'REJECTED', input.message);
  }

  async cancelJoinRequest(requestId: string, actorId: string) {
    const request = await this.requirePendingJoinRequest(requestId);
    if (request.requestedById !== actorId) {
      throw new ForbiddenException('Only the requester can cancel this request');
    }
    return this.finishJoinRequest(requestId, actorId, 'CANCELLED');
  }

  async addMembers(groupId: string, operatorId: string, input: AddGroupMembersDto) {
    await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const group = await this.prisma.group.findUniqueOrThrow({ where: { id: groupId } });
    const userIds = [...new Set(input.userIds.filter((id) => id !== operatorId))];
    const currentCount = await this.prisma.groupMember.count({
      where: { groupId, status: 'ACTIVE' },
    });
    if (currentCount + userIds.length > group.memberLimit) {
      throw new ConflictException('Group member limit exceeded');
    }
    const activeCount = await this.prisma.user.count({
      where: { id: { in: userIds }, status: 'ACTIVE' },
    });
    if (activeCount !== userIds.length) {
      throw new NotFoundException('One or more users do not exist');
    }

    await this.prisma.$transaction(
      userIds.map((userId) =>
        this.prisma.groupMember.upsert({
          where: { groupId_userId: { groupId, userId } },
          create: { groupId, userId },
          update: { status: 'ACTIVE', role: 'MEMBER', joinedAt: new Date() },
        }),
      ),
    );
    try {
      await this.wuKongIm.addChannelSubscribers(groupId, userIds);
    } catch (error) {
      await this.prisma.groupMember.updateMany({
        where: { groupId, userId: { in: userIds } },
        data: { status: 'REMOVED' },
      });
      throw error;
    }
    return this.get(groupId, operatorId);
  }

  async removeMember(groupId: string, operatorId: string, memberId: string) {
    const operator = await this.requireRole(groupId, operatorId, ['OWNER', 'ADMIN']);
    const member = await this.requireMember(groupId, memberId);
    if (member.role === 'OWNER') throw new ForbiddenException('Cannot remove group owner');
    if (operator.role === 'ADMIN' && member.role === 'ADMIN') {
      throw new ForbiddenException('Admin cannot remove another admin');
    }
    await this.prisma.groupMember.update({
      where: { groupId_userId: { groupId, userId: memberId } },
      data: { status: 'REMOVED' },
    });
    try {
      await this.wuKongIm.removeChannelSubscribers(groupId, [memberId]);
    } catch (error) {
      await this.prisma.groupMember.update({
        where: { groupId_userId: { groupId, userId: memberId } },
        data: { status: 'ACTIVE' },
      });
      throw error;
    }
    return { success: true };
  }

  async leave(groupId: string, userId: string) {
    const member = await this.requireMember(groupId, userId);
    if (member.role === 'OWNER') {
      throw new ForbiddenException('Owner must disband or transfer the group');
    }
    await this.prisma.groupMember.update({
      where: { groupId_userId: { groupId, userId } },
      data: { status: 'LEFT' },
    });
    try {
      await this.wuKongIm.removeChannelSubscribers(groupId, [userId]);
    } catch (error) {
      await this.prisma.groupMember.update({
        where: { groupId_userId: { groupId, userId } },
        data: { status: 'ACTIVE' },
      });
      throw error;
    }
    return { success: true };
  }

  async disband(groupId: string, userId: string) {
    await this.requireRole(groupId, userId, ['OWNER']);
    const memberIds = (
      await this.prisma.groupMember.findMany({
        where: { groupId, status: 'ACTIVE' },
        select: { userId: true },
      })
    ).map((item) => item.userId);
    await this.wuKongIm.removeChannelSubscribers(groupId, memberIds);
    await this.prisma.$transaction([
      this.prisma.group.update({ where: { id: groupId }, data: { status: 'DISBANDED' } }),
      this.prisma.groupMember.updateMany({
        where: { groupId, status: 'ACTIVE' },
        data: { status: 'REMOVED' },
      }),
    ]);
    return { success: true };
  }

  private async requireMember(groupId: string, userId: string) {
    const member = await this.prisma.groupMember.findFirst({
      where: { groupId, userId, status: 'ACTIVE', group: { status: 'ACTIVE' } },
    });
    if (!member) throw new ForbiddenException('Not an active group member');
    return member;
  }

  private async requireRole(groupId: string, userId: string, roles: GroupRole[]) {
    const member = await this.requireMember(groupId, userId);
    if (!roles.includes(member.role)) throw new ForbiddenException('Insufficient group role');
    return member;
  }

  private async sendSystemNotice(
    groupId: string,
    fromUserId: string,
    event: string,
    data: Record<string, unknown>,
  ) {
    const payload = systemMessageSchema.parse({
      version: 1,
      type: MessageType.SYSTEM,
      clientMsgNo: randomUUID(),
      sentAt: Date.now(),
      event,
      data,
    });
    await this.wuKongIm.sendGroupMessage({ fromUserId, groupId, payload }).catch(() => undefined);
  }

  private async createJoinRequest(input: {
    groupId: string;
    userId: string;
    requestedById: string;
    type: 'APPLY' | 'INVITE';
    message?: string;
  }) {
    const expiresAt = new Date(
      Date.now() + this.config.getOrThrow<number>('GROUP_JOIN_REQUEST_TTL_HOURS') * 3_600_000,
    );
    try {
      return await this.prisma.groupJoinRequest.create({
        data: {
          ...input,
          activeKey: `${input.groupId}:${input.userId}`,
          expiresAt,
        },
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        throw new ConflictException('A pending join request already exists');
      }
      throw error;
    }
  }

  private async requirePendingJoinRequest(requestId: string) {
    const request = await this.prisma.groupJoinRequest.findUnique({ where: { id: requestId } });
    if (!request) throw new NotFoundException('Join request not found');
    if (request.status !== 'PENDING') throw new ConflictException('Join request is no longer pending');
    if (request.expiresAt <= new Date()) {
      await this.prisma.groupJoinRequest.update({
        where: { id: request.id }, data: { status: 'EXPIRED', activeKey: null },
      });
      throw new GoneException('Join request has expired');
    }
    return request;
  }

  private finishJoinRequest(
    requestId: string,
    actorId: string,
    status: 'REJECTED' | 'CANCELLED',
    decisionNote?: string,
  ) {
    return this.prisma.groupJoinRequest.update({
      where: { id: requestId },
      data: {
        status,
        activeKey: null,
        decidedById: actorId,
        decidedAt: new Date(),
        decisionNote,
      },
    });
  }
}
