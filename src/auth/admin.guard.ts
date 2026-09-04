import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Request } from 'express';
import { PrismaService } from '../prisma/prisma.service';
import { JwtPayload } from './jwt-payload';

@Injectable()
export class AdminGuard implements CanActivate {
  constructor(private readonly prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request & { user?: JwtPayload }>();
    if (!request.user) throw new ForbiddenException('Authentication required');
    const admin = await this.prisma.user.findFirst({
      where: { id: request.user.sub, status: 'ACTIVE', role: 'ADMIN' },
      select: { id: true },
    });
    if (!admin) throw new ForbiddenException('Administrator permission required');
    return true;
  }
}
