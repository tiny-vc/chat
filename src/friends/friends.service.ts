import {
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

const friendUserSelect = {
  id: true,
  username: true,
  nickname: true,
  avatarUrl: true,
  avatarFileId: true,
} as const;

@Injectable()
export class FriendsService {
  constructor(private readonly prisma: PrismaService) {}

  async request(requesterId: string, addresseeId: string) {
    if (requesterId === addresseeId) {
      throw new ForbiddenException('Cannot add yourself');
    }
    const target = await this.prisma.user.findFirst({
      where: { id: addresseeId, status: 'ACTIVE' },
      select: { id: true },
    });
    if (!target) throw new NotFoundException('User not found');
    if (await this.isBlockedEitherWay(requesterId, addresseeId)) {
      throw new ForbiddenException('Friend request is not allowed');
    }

    const pairKey = this.pairKey(requesterId, addresseeId);
    const existing = await this.prisma.friendship.findUnique({ where: { pairKey } });
    if (existing?.status === 'ACCEPTED') {
      throw new ConflictException('Already friends');
    }
    if (existing?.status === 'PENDING') {
      throw new ConflictException('Friend request already pending');
    }
    if (existing?.status === 'BLOCKED') {
      throw new ForbiddenException('Friend request is not allowed');
    }

    return this.prisma.friendship.upsert({
      where: { pairKey },
      create: { pairKey, requesterId, addresseeId },
      update: { requesterId, addresseeId, status: 'PENDING' },
    });
  }

  async listRequests(userId: string) {
    return this.prisma.friendship.findMany({
      where: { addresseeId: userId, status: 'PENDING' },
      include: { requester: { select: friendUserSelect } },
      orderBy: { createdAt: 'desc' },
    });
  }

  async accept(userId: string, requestId: string) {
    const request = await this.getIncomingRequest(userId, requestId);
    if (await this.isBlockedEitherWay(request.requesterId, request.addresseeId)) {
      throw new ForbiddenException('Friend request is not allowed');
    }
    return this.prisma.friendship.update({
      where: { id: request.id },
      data: { status: 'ACCEPTED' },
    });
  }

  async reject(userId: string, requestId: string) {
    const request = await this.getIncomingRequest(userId, requestId);
    return this.prisma.friendship.update({
      where: { id: request.id },
      data: { status: 'REJECTED' },
    });
  }

  async list(userId: string) {
    const [rows, blocks] = await Promise.all([
      this.prisma.friendship.findMany({
      where: {
        status: 'ACCEPTED',
        OR: [{ requesterId: userId }, { addresseeId: userId }],
      },
      include: {
        requester: { select: friendUserSelect },
        addressee: { select: friendUserSelect },
      },
      orderBy: { updatedAt: 'desc' },
      }),
      this.prisma.userBlock.findMany({
        where: { OR: [{ blockerId: userId }, { blockedId: userId }] },
        select: { blockerId: true, blockedId: true },
      }),
    ]);
    const blockedIds = new Set(blocks.map((block) => block.blockerId === userId ? block.blockedId : block.blockerId));
    return rows.filter((row) => !blockedIds.has(row.requesterId === userId ? row.addresseeId : row.requesterId)).map((row) => ({
      friendshipId: row.id,
      user: row.requesterId === userId ? row.addressee : row.requester,
      createdAt: row.updatedAt,
    }));
  }

  async remove(userId: string, friendUserId: string) {
    const pairKey = this.pairKey(userId, friendUserId);
    const friendship = await this.prisma.friendship.findUnique({ where: { pairKey } });
    if (!friendship || friendship.status !== 'ACCEPTED') {
      throw new NotFoundException('Friendship not found');
    }
    await this.prisma.friendship.delete({ where: { id: friendship.id } });
    return { success: true };
  }

  async areFriends(firstUserId: string, secondUserId: string) {
    const [friendship, block] = await Promise.all([
      this.prisma.friendship.findFirst({
        where: { pairKey: this.pairKey(firstUserId, secondUserId), status: 'ACCEPTED' },
        select: { id: true },
      }),
      this.prisma.userBlock.findFirst({
        where: {
          OR: [
            { blockerId: firstUserId, blockedId: secondUserId },
            { blockerId: secondUserId, blockedId: firstUserId },
          ],
        },
        select: { blockerId: true },
      }),
    ]);
    return Boolean(friendship && !block);
  }

  private async getIncomingRequest(userId: string, requestId: string) {
    const request = await this.prisma.friendship.findFirst({
      where: { id: requestId, addresseeId: userId, status: 'PENDING' },
    });
    if (!request) throw new NotFoundException('Friend request not found');
    return request;
  }

  private pairKey(first: string, second: string) {
    return [first, second].sort().join(':');
  }

  private async isBlockedEitherWay(firstUserId: string, secondUserId: string) {
    return Boolean(
      await this.prisma.userBlock.findFirst({
        where: {
          OR: [
            { blockerId: firstUserId, blockedId: secondUserId },
            { blockerId: secondUserId, blockedId: firstUserId },
          ],
        },
        select: { blockerId: true },
      }),
    );
  }
}
