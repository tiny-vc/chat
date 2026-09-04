import { Body, Controller, Delete, Get, Param, Patch, Post, Put, Query, UseGuards } from '@nestjs/common';
import { GroupJoinPageDto } from './dto/group-join-page.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { AddGroupMembersDto } from './dto/add-group-members.dto';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';
import { GroupsService } from './groups.service';
import { SetMemberRoleDto } from './dto/set-member-role.dto';
import { TransferOwnerDto } from './dto/transfer-owner.dto';
import { MuteMemberDto } from './dto/mute-member.dto';
import { SetGroupAvatarDto } from './dto/set-group-avatar.dto';
import { GroupJoinMessageDto } from './dto/group-join-message.dto';
import { InviteGroupMemberDto } from './dto/invite-group-member.dto';

@UseGuards(JwtAuthGuard)
@Controller('groups')
export class GroupsController {
  constructor(private readonly groupsService: GroupsService) {}

  @Post()
  create(@CurrentUser() user: JwtPayload, @Body() input: CreateGroupDto) {
    return this.groupsService.create(user.sub, input);
  }

  @Get()
  list(@CurrentUser() user: JwtPayload) {
    return this.groupsService.list(user.sub);
  }

  @Get('join-requests/me')
  listMyJoinRequests(@CurrentUser() user: JwtPayload, @Query() page: GroupJoinPageDto) {
    return this.groupsService.listMyJoinRequests(user.sub, page);
  }

  @Get('join-requests/actionable')
  listActionableJoinRequests(@CurrentUser() user: JwtPayload, @Query() page: GroupJoinPageDto) {
    return this.groupsService.listActionableJoinRequests(user.sub, page);
  }

  @Get('join-requests/pending-count')
  pendingJoinRequestCount(@CurrentUser() user: JwtPayload) {
    return this.groupsService.pendingJoinRequestCount(user.sub);
  }

  @Post('join-requests/:requestId/approve')
  approveJoinRequest(
    @CurrentUser() user: JwtPayload,
    @Param('requestId') requestId: string,
  ) {
    return this.groupsService.approveJoinRequest(requestId, user.sub);
  }

  @Post('join-requests/:requestId/reject')
  rejectJoinRequest(
    @CurrentUser() user: JwtPayload,
    @Param('requestId') requestId: string,
    @Body() input: GroupJoinMessageDto,
  ) {
    return this.groupsService.rejectJoinRequest(requestId, user.sub, input);
  }

  @Post('join-requests/:requestId/cancel')
  cancelJoinRequest(
    @CurrentUser() user: JwtPayload,
    @Param('requestId') requestId: string,
  ) {
    return this.groupsService.cancelJoinRequest(requestId, user.sub);
  }

  @Get(':groupId')
  get(@CurrentUser() user: JwtPayload, @Param('groupId') groupId: string) {
    return this.groupsService.get(groupId, user.sub);
  }

  @Post(':groupId/join-requests')
  applyToJoin(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: GroupJoinMessageDto,
  ) {
    return this.groupsService.applyToJoin(groupId, user.sub, input);
  }

  @Post(':groupId/invitations')
  inviteMember(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: InviteGroupMemberDto,
  ) {
    return this.groupsService.inviteMember(groupId, user.sub, input);
  }

  @Get(':groupId/join-requests')
  listPendingJoinRequests(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
  ) {
    return this.groupsService.listPendingJoinRequests(groupId, user.sub);
  }

  @Patch(':groupId')
  update(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: UpdateGroupDto,
  ) {
    return this.groupsService.update(groupId, user.sub, input);
  }

  @Post(':groupId/members')
  addMembers(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: AddGroupMembersDto,
  ) {
    return this.groupsService.addMembers(groupId, user.sub, input);
  }

  @Patch(':groupId/members/:memberId/role')
  setMemberRole(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
    @Body() input: SetMemberRoleDto,
  ) {
    return this.groupsService.setMemberRole(groupId, user.sub, memberId, input.role);
  }

  @Patch(':groupId/members/:memberId/mute')
  muteMember(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
    @Body() input: MuteMemberDto,
  ) {
    return this.groupsService.muteMember(groupId, user.sub, memberId, input);
  }

  @Post(':groupId/transfer-owner')
  transferOwner(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: TransferOwnerDto,
  ) {
    return this.groupsService.transferOwner(groupId, user.sub, input.userId);
  }

  @Put(':groupId/avatar')
  setAvatar(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Body() input: SetGroupAvatarDto,
  ) {
    return this.groupsService.setAvatar(groupId, user.sub, input.fileId);
  }

  @Delete(':groupId/avatar')
  removeAvatar(@CurrentUser() user: JwtPayload, @Param('groupId') groupId: string) {
    return this.groupsService.removeAvatar(groupId, user.sub);
  }

  @Delete(':groupId/members/:memberId')
  removeMember(
    @CurrentUser() user: JwtPayload,
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
  ) {
    return this.groupsService.removeMember(groupId, user.sub, memberId);
  }

  @Post(':groupId/leave')
  leave(@CurrentUser() user: JwtPayload, @Param('groupId') groupId: string) {
    return this.groupsService.leave(groupId, user.sub);
  }

  @Delete(':groupId')
  disband(@CurrentUser() user: JwtPayload, @Param('groupId') groupId: string) {
    return this.groupsService.disband(groupId, user.sub);
  }
}
