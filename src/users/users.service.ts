import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { ReportUserDto } from './dto/report-user.dto';

const publicUserSelect = {
  id: true,
  username: true,
  nickname: true,
  avatarUrl: true,
  avatarFileId: true,
} as const;

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async getMe(userId: string) {
    return this.getById(userId);
  }

  async getById(userId: string) {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, status: 'ACTIVE' },
      select: publicUserSelect,
    });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async updateMe(userId: string, input: UpdateProfileDto) {
    return this.prisma.user.update({
      where: { id: userId },
      data: input,
      select: publicUserSelect,
    });
  }

  async setAvatar(userId: string, fileId: string) {
    const file = await this.prisma.storedFile.findFirst({
      where: { id: fileId, ownerUserId: userId, status: 'READY' },
    });
    if (!file) throw new NotFoundException('Avatar file not found');
    if (file.purpose !== 'AVATAR' || file.scope !== 'PRIVATE' || !file.mimeType.startsWith('image/')) {
      throw new ForbiddenException('Avatar must be a private image uploaded for avatar use');
    }
    return this.prisma.user.update({
      where: { id: userId },
      data: { avatarFileId: file.id, avatarUrl: null },
      select: publicUserSelect,
    });
  }

  async removeAvatar(userId: string) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { avatarFileId: null, avatarUrl: null },
      select: publicUserSelect,
    });
  }

  async search(query: string, currentUserId: string) {
    const normalized = query.trim();
    if (normalized.length < 2) return [];
    return this.prisma.user.findMany({
      where: {
        id: { not: currentUserId },
        status: 'ACTIVE',
        OR: [
          { username: { contains: normalized.toLowerCase(), mode: 'insensitive' } },
          { nickname: { contains: normalized, mode: 'insensitive' } },
        ],
      },
      select: publicUserSelect,
      take: 20,
    });
  }

  async report(reporterId: string, targetUserId: string, input: ReportUserDto) {
    if (reporterId === targetUserId) throw new ForbiddenException('Cannot report yourself');
    const target = await this.prisma.user.findFirst({
      where: { id: targetUserId, status: 'ACTIVE' },
      select: { id: true },
    });
    if (!target) throw new NotFoundException('User not found');
    await this.prisma.auditLog.create({
      data: {
        actorUserId: reporterId,
        action: 'USER_REPORT',
        targetType: 'USER',
        targetId: targetUserId,
        metadata: { reason: input.reason, details: input.details ?? null },
      },
    });
    return { success: true };
  }
}
