import { Body, Controller, Delete, Get, Param, Patch, Post, Put, Query, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UsersService } from './users.service';
import { SetAvatarDto } from './dto/set-avatar.dto';
import { ReportUserDto } from './dto/report-user.dto';

@UseGuards(JwtAuthGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  getMe(@CurrentUser() user: JwtPayload) {
    return this.usersService.getMe(user.sub);
  }

  @Patch('me')
  updateMe(@CurrentUser() user: JwtPayload, @Body() input: UpdateProfileDto) {
    return this.usersService.updateMe(user.sub, input);
  }

  @Put('me/avatar')
  setAvatar(@CurrentUser() user: JwtPayload, @Body() input: SetAvatarDto) {
    return this.usersService.setAvatar(user.sub, input.fileId);
  }

  @Delete('me/avatar')
  removeAvatar(@CurrentUser() user: JwtPayload) {
    return this.usersService.removeAvatar(user.sub);
  }

  @Get('search')
  search(@CurrentUser() user: JwtPayload, @Query('q') query = '') {
    return this.usersService.search(query, user.sub);
  }

  @Post(':userId/report')
  report(
    @CurrentUser() user: JwtPayload,
    @Param('userId') userId: string,
    @Body() input: ReportUserDto,
  ) {
    return this.usersService.report(user.sub, userId, input);
  }

  @Get(':userId')
  getById(@Param('userId') userId: string) {
    return this.usersService.getById(userId);
  }
}
