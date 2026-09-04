import { Body, Controller, Delete, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { CreateFriendRequestDto } from './dto/create-friend-request.dto';
import { FriendsService } from './friends.service';

@UseGuards(JwtAuthGuard)
@Controller('friends')
export class FriendsController {
  constructor(private readonly friendsService: FriendsService) {}

  @Post('requests')
  request(@CurrentUser() user: JwtPayload, @Body() input: CreateFriendRequestDto) {
    return this.friendsService.request(user.sub, input.userId);
  }

  @Get('requests')
  listRequests(@CurrentUser() user: JwtPayload) {
    return this.friendsService.listRequests(user.sub);
  }

  @Post('requests/:requestId/accept')
  accept(@CurrentUser() user: JwtPayload, @Param('requestId') requestId: string) {
    return this.friendsService.accept(user.sub, requestId);
  }

  @Post('requests/:requestId/reject')
  reject(@CurrentUser() user: JwtPayload, @Param('requestId') requestId: string) {
    return this.friendsService.reject(user.sub, requestId);
  }

  @Get()
  list(@CurrentUser() user: JwtPayload) {
    return this.friendsService.list(user.sub);
  }

  @Delete(':userId')
  remove(@CurrentUser() user: JwtPayload, @Param('userId') friendUserId: string) {
    return this.friendsService.remove(user.sub, friendUserId);
  }
}
