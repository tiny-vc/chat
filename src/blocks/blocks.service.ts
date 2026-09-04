import { ConflictException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WuKongImService } from '../integrations/wukongim/wukongim.service';

const blockedUserSelect = {
  id: true,
  username: true,
  nickname: true,
  avatarUrl: true,
  avatarFileId: true,
} as const;

@Injectable()
export class BlocksService {
  constructor(private readonly prisma: PrismaService, private readonly wuKongIm: WuKongImService) {}

  async list(blockerId: string) {
    const rows = await this.prisma.userBlock.findMany({
      where: { blockerId },
      include: { blocked: { select: blockedUserSelect } },
      orderBy: { createdAt: 'desc' },
    });
    return rows.map((row) => ({ user: row.blocked, createdAt: row.createdAt }));
  }

  async block(blockerId: string, blockedId: string) {
    if (blockerId === blockedId) throw new ForbiddenException('Cannot block yourself');
    const target = await this.prisma.user.findFirst({ where: { id: blockedId, status: 'ACTIVE' }, select: { id: true } });
    if (!target) throw new NotFoundException('User not found');
    const existing = await this.prisma.userBlock.findUnique({ where: { blockerId_blockedId: { blockerId, blockedId } } });
    if (existing) throw new ConflictException('User is already blocked');

    await this.wuKongIm.addChannelBlacklist(blockerId, 1, [blockedId]);
    try {
      return await this.prisma.userBlock.create({
        data: { blockerId, blockedId },
        include: { blocked: { select: blockedUserSelect } },
      });
    } catch (error) {
      await this.wuKongIm.removeChannelBlacklist(blockerId, 1, [blockedId]).catch(() => undefined);
      throw error;
    }
  }

  async unblock(blockerId: string, blockedId: string) {
    const existing = await this.prisma.userBlock.findUnique({ where: { blockerId_blockedId: { blockerId, blockedId } } });
    if (!existing) throw new NotFoundException('Blocked user not found');
    await this.wuKongIm.removeChannelBlacklist(blockerId, 1, [blockedId]);
    await this.prisma.userBlock.delete({ where: { blockerId_blockedId: { blockerId, blockedId } } });
    return { success: true };
  }
}
