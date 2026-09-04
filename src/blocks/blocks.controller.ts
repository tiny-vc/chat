import { Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { BlocksService } from './blocks.service';

@UseGuards(JwtAuthGuard)
@Controller('blocks')
export class BlocksController {
  constructor(private readonly service: BlocksService) {}

  @Get()
  list(@CurrentUser() user: JwtPayload) {
    return this.service.list(user.sub);
  }

  @Post(':userId')
  block(@CurrentUser() user: JwtPayload, @Param('userId') blockedId: string) {
    return this.service.block(user.sub, blockedId);
  }

  @Delete(':userId')
  unblock(@CurrentUser() user: JwtPayload, @Param('userId') blockedId: string) {
    return this.service.unblock(user.sub, blockedId);
  }
}
