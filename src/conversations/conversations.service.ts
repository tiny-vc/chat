import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateConversationSettingDto } from './dto/update-conversation-setting.dto';

@Injectable()
export class ConversationsService {
  constructor(private readonly prisma: PrismaService) {}

  list(userId: string) {
    return this.prisma.conversationSetting.findMany({
      where: { userId },
      orderBy: [{ pinned: 'desc' }, { updatedAt: 'desc' }],
    });
  }

  async update(userId: string, input: UpdateConversationSettingDto) {
    if (input.pinned === undefined && input.muted === undefined && input.archived === undefined) {
      throw new BadRequestException('At least one setting is required');
    }
    await this.requireChannelAccess(userId, input.channelId, input.channelType);
    return this.prisma.conversationSetting.upsert({
      where: {
        userId_channelId_channelType: {
          userId,
          channelId: input.channelId,
          channelType: input.channelType,
        },
      },
      create: { userId, ...input },
      update: {
        ...(input.pinned === undefined ? {} : { pinned: input.pinned }),
        ...(input.muted === undefined ? {} : { muted: input.muted }),
        ...(input.archived === undefined ? {} : { archived: input.archived }),
      },
    });
  }

  async remove(userId: string, channelId: string, channelType: number) {
    if (![1, 2].includes(channelType)) throw new BadRequestException('Invalid channel type');
    await this.prisma.conversationSetting.deleteMany({ where: { userId, channelId, channelType } });
    return { success: true };
  }

  private async requireChannelAccess(userId: string, channelId: string, channelType: 1 | 2) {
    if (channelType === 1) {
      if (channelId === userId) throw new ForbiddenException('Self conversation is not supported');
      const user = await this.prisma.user.findFirst({ where: { id: channelId, status: 'ACTIVE' }, select: { id: true } });
      if (!user) throw new NotFoundException('User not found');
      return;
    }
    const member = await this.prisma.groupMember.findFirst({
      where: { groupId: channelId, userId, status: 'ACTIVE', group: { status: 'ACTIVE' } },
      select: { userId: true },
    });
    if (!member) throw new ForbiddenException('Not an active group member');
  }
}
