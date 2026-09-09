import 'package:chat_api_client/chat_api_client.dart';

class UserSummary {
  const UserSummary({
    required this.id,
    required this.username,
    required this.nickname,
    required this.avatarFileId,
  });

  final String id;
  final String username;
  final String nickname;
  final String? avatarFileId;

  factory UserSummary.fromApi(UserResponse value) => UserSummary(
    id: value.id,
    username: value.username,
    nickname: value.nickname,
    avatarFileId: value.avatarFileId,
  );
}

class FriendRequestSummary {
  const FriendRequestSummary({
    required this.id,
    required this.requesterId,
    required this.status,
    required this.requester,
  });

  final String id;
  final String requesterId;
  final String status;
  final UserSummary requester;

  factory FriendRequestSummary.fromApi(FriendRequestResponse value) =>
      FriendRequestSummary(
        id: value.id,
        requesterId: value.requesterId,
        status: value.status.name,
        requester: UserSummary.fromApi(value.requester),
      );
}

class BlockedUserSummary {
  const BlockedUserSummary({required this.user, required this.createdAt});
  final UserSummary user;
  final DateTime? createdAt;

  factory BlockedUserSummary.fromApi(BlockedUserResponse value) =>
      BlockedUserSummary(
        user: UserSummary.fromApi(value.user),
        createdAt: value.createdAt.toLocal(),
      );
}

class DeviceSummary {
  const DeviceSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.ipAddress,
    required this.lastSeenAt,
    required this.current,
  });
  final String id;
  final String name;
  final String type;
  final String? ipAddress;
  final DateTime? lastSeenAt;
  final bool current;

  factory DeviceSummary.fromApi(DeviceSessionResponse value) => DeviceSummary(
    id: value.id,
    name: value.deviceName,
    type: value.deviceType.name,
    ipAddress: value.ipAddress,
    lastSeenAt: value.lastSeenAt.toLocal(),
    current: value.current,
  );
}

class HomeSnapshot {
  const HomeSnapshot({
    required this.me,
    required this.friends,
    required this.groups,
  });

  final UserResponse me;
  final List<FriendResponse> friends;
  final List<GroupResponse> groups;
}

class HomeRepository {
  const HomeRepository(this._api);

  final ChatApiClient _api;

  Future<int> pendingGroupJoinCount() async {
    final result =
        (await _api.getGroupsApi().groupsPendingJoinRequestCount()).data;
    if (result == null || result.count < 0) {
      throw const FormatException('Invalid pending join count');
    }
    return result.count;
  }

  Future<HomeSnapshot> load() async {
    UserResponse? me;
    List<FriendResponse>? friends;
    List<GroupResponse>? groups;

    await Future.wait([
      _api.getUsersApi().usersGetMe().then((response) => me = response.data),
      _api.getFriendsApi().friendsList().then(
        (response) => friends = response.data?.toList(),
      ),
      _api.getGroupsApi().groupsList().then(
        (response) => groups = response.data?.toList(),
      ),
    ]);

    if (me == null || friends == null || groups == null) {
      throw StateError('服务器返回的数据不完整');
    }
    return HomeSnapshot(me: me!, friends: friends!, groups: groups!);
  }

  Future<List<UserSummary>> searchUsers(String query) async {
    final response = await _api.getUsersApi().usersSearch(q: query.trim());
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回用户搜索结果。');
    return data.map(UserSummary.fromApi).toList(growable: false);
  }

  Future<void> requestFriend(String userId) async {
    final response = await _api.getFriendsApi().friendsRequest(
      createFriendRequestDto: CreateFriendRequestDto(
        (builder) => builder.userId = userId,
      ),
    );
    if (response.data == null) throw const FormatException('服务器未确认好友申请。');
  }

  Future<List<FriendRequestSummary>> friendRequests() async {
    final response = await _api.getFriendsApi().friendsListRequests();
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回好友申请。');
    return data.map(FriendRequestSummary.fromApi).toList(growable: false);
  }

  Future<void> respondToFriendRequest(String requestId, bool accept) async {
    final api = _api.getFriendsApi();
    final response = accept
        ? await api.friendsAccept(requestId: requestId)
        : await api.friendsReject(requestId: requestId);
    if (response.data == null) throw const FormatException('服务器未确认好友申请处理结果。');
  }

  Future<GroupResponse> createGroup(
    String name,
    Iterable<String> memberIds,
  ) async {
    final response = await _api.getGroupsApi().groupsCreate(
      createGroupDto: CreateGroupDto(
        (builder) => builder
          ..name = name.trim()
          ..memberIds.addAll(memberIds),
      ),
    );
    return response.data ?? (throw const FormatException('服务器未确认建群结果。'));
  }

  Future<GroupResponse> getGroup(String groupId) async {
    final response = await _api.getGroupsApi().groupsGet(groupId: groupId);
    return response.data ?? (throw StateError('服务器未返回群资料'));
  }

  Future<List<GroupJoinRequestResponse>> groupJoinRequests({
    required String groupId,
  }) async {
    final response = await _api.getGroupsApi().groupsListPendingJoinRequests(
      groupId: groupId,
    );
    return response.data?.toList() ?? (throw StateError('入群记录为空响应'));
  }

  Future<List<GroupJoinRequestResponse>> groupJoinPage({
    required bool actionable,
    GroupJoinRequestResponse? before,
  }) async {
    final api = _api.getGroupsApi();
    final response = actionable
        ? await api.groupsListActionableJoinRequests(
            before: before?.createdAt.toUtc().toIso8601String(),
            beforeId: before?.id,
          )
        : await api.groupsListMyJoinRequests(
            before: before?.createdAt.toUtc().toIso8601String(),
            beforeId: before?.id,
          );
    return response.data?.toList() ?? (throw StateError('入群记录为空响应'));
  }

  Future<void> applyToGroup(String groupId, String message) async {
    await _api.getGroupsApi().groupsApplyToJoin(
      groupId: groupId,
      groupJoinMessageDto: GroupJoinMessageDto(
        (b) => b.message = message.trim(),
      ),
    );
  }

  Future<void> inviteToGroup(String groupId, String userId) async {
    await _api.getGroupsApi().groupsInviteMember(
      groupId: groupId,
      inviteGroupMemberDto: InviteGroupMemberDto((b) => b.userId = userId),
    );
  }

  Future<void> decideGroupJoin(
    String requestId,
    String action, {
    String message = '',
  }) async {
    final api = _api.getGroupsApi();
    switch (action) {
      case 'approve':
        await api.groupsApproveJoinRequest(requestId: requestId);
      case 'reject':
        await api.groupsRejectJoinRequest(
          requestId: requestId,
          groupJoinMessageDto: GroupJoinMessageDto(
            (b) => b.message = message.trim(),
          ),
        );
      case 'cancel':
        await api.groupsCancelJoinRequest(requestId: requestId);
      default:
        throw ArgumentError.value(action, 'action');
    }
  }

  Future<void> setGroupAvatar(String groupId, String fileId) async {
    await _api.getGroupsApi().groupsSetAvatar(
      groupId: groupId,
      setGroupAvatarDto: SetGroupAvatarDto((b) => b.fileId = fileId),
    );
  }

  Future<void> removeGroupAvatar(String groupId) async {
    await _api.getGroupsApi().groupsRemoveAvatar(groupId: groupId);
  }

  Future<void> renameGroup(String groupId, String name) async {
    final response = await _api.getGroupsApi().groupsUpdate(
      groupId: groupId,
      updateGroupDto: UpdateGroupDto((builder) => builder.name = name.trim()),
    );
    if (response.data == null) throw const FormatException('服务器未确认群名修改。');
  }

  Future<void> updateGroupAnnouncement(
    String groupId,
    String announcement,
  ) async {
    final response = await _api.getGroupsApi().groupsUpdate(
      groupId: groupId,
      updateGroupDto: UpdateGroupDto(
        (builder) => builder.announcement = announcement.trim(),
      ),
    );
    if (response.data == null) throw const FormatException('服务器未确认群公告修改。');
  }

  Future<void> updateMyGroupNickname(String groupId, String nickname) async {
    final response = await _api.getGroupsApi().groupsUpdateMyNickname(
      groupId: groupId,
      updateGroupNicknameDto: UpdateGroupNicknameDto(
        (builder) => builder.nickname = nickname.trim(),
      ),
    );
    if (response.data == null) throw const FormatException('服务器未确认群昵称修改。');
  }

  Future<void> setGroupAdmin(String groupId, String userId, bool admin) async {
    await _api.getGroupsApi().groupsSetMemberRole(
      groupId: groupId,
      memberId: userId,
      setMemberRoleDto: SetMemberRoleDto(
        (b) => b.role = admin
            ? SetMemberRoleDtoRoleEnum.ADMIN
            : SetMemberRoleDtoRoleEnum.MEMBER,
      ),
    );
  }

  Future<void> transferGroupOwner(String groupId, String userId) async {
    await _api.getGroupsApi().groupsTransferOwner(
      groupId: groupId,
      transferOwnerDto: TransferOwnerDto((b) => b.userId = userId),
    );
  }

  Future<void> muteGroupMember(
    String groupId,
    String userId,
    bool muted, {
    int? minutes,
  }) async {
    await _api.getGroupsApi().groupsMuteMember(
      groupId: groupId,
      memberId: userId,
      muteMemberDto: MuteMemberDto(
        (b) => b
          ..muted = muted
          ..durationMinutes = muted ? minutes : null,
      ),
    );
  }

  Future<void> setGroupMuteAll(String groupId, bool muted) async {
    await _api.getGroupsApi().groupsUpdate(
      groupId: groupId,
      updateGroupDto: UpdateGroupDto((b) => b.muteAll = muted),
    );
  }

  Future<void> addGroupMembers(String groupId, Iterable<String> userIds) async {
    final response = await _api.getGroupsApi().groupsAddMembers(
      groupId: groupId,
      addGroupMembersDto: AddGroupMembersDto(
        (builder) => builder.userIds.addAll(userIds),
      ),
    );
    if (response.data == null) throw const FormatException('服务器未确认添加群成员。');
  }

  Future<void> removeGroupMember(String groupId, String userId) async {
    final response = await _api.getGroupsApi().groupsRemoveMember(
      groupId: groupId,
      memberId: userId,
    );
    _requireSuccess(response.data, '服务器未确认移除群成员。');
  }

  Future<void> leaveGroup(String groupId) async {
    final response = await _api.getGroupsApi().groupsLeave(groupId: groupId);
    _requireSuccess(response.data, '服务器未确认退出群聊。');
  }

  Future<void> disbandGroup(String groupId) async {
    final response = await _api.getGroupsApi().groupsDisband(groupId: groupId);
    _requireSuccess(response.data, '服务器未确认解散群聊。');
  }

  Future<void> updateNickname(String nickname) async {
    final response = await _api.getUsersApi().usersUpdateMe(
      updateProfileDto: UpdateProfileDto(
        (builder) => builder.nickname = nickname.trim(),
      ),
    );
    if (response.data == null) throw const FormatException('服务器未确认昵称修改。');
  }

  Future<UserResponse> setAvatar(String fileId) async {
    final response = await _api.getUsersApi().usersSetAvatar(
      setAvatarDto: SetAvatarDto((builder) => builder.fileId = fileId),
    );
    final user = response.data;
    if (user == null) throw const FormatException('服务器未确认头像修改。');
    return user;
  }

  Future<UserResponse> removeAvatar() async {
    final response = await _api.getUsersApi().usersRemoveAvatar();
    final user = response.data;
    if (user == null) throw const FormatException('服务器未确认移除头像。');
    return user;
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _api.getAuthApi().authChangePassword(
      changePasswordDto: ChangePasswordDto(
        (builder) => builder
          ..currentPassword = currentPassword
          ..newPassword = newPassword,
      ),
    );
    _requireSuccess(response.data, '服务器未确认密码修改。');
  }

  Future<void> removeFriend(String userId) async {
    final response = await _api.getFriendsApi().friendsRemove(userId: userId);
    _requireSuccess(response.data, '服务器未确认删除好友。');
  }

  Future<void> blockUser(String userId) async {
    final response = await _api.getBlocksApi().blocksBlock(userId: userId);
    if (response.data == null) {
      throw const FormatException('服务器未确认加入黑名单。');
    }
  }

  Future<void> unblockUser(String userId) async {
    final response = await _api.getBlocksApi().blocksUnblock(userId: userId);
    if (response.data?.success != true) {
      throw const FormatException('服务器未确认移出黑名单。');
    }
  }

  Future<List<BlockedUserSummary>> blockedUsers() async {
    final response = await _api.getBlocksApi().blocksList();
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回黑名单。');
    return data.map(BlockedUserSummary.fromApi).toList(growable: false);
  }

  Future<List<DeviceSummary>> devices() async {
    final response = await _api.getAuthApi().authDevices();
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回设备列表。');
    return data.map(DeviceSummary.fromApi).toList(growable: false);
  }

  Future<void> revokeDevice(String sessionId) async {
    final response = await _api.getAuthApi().authRevokeDevice(
      sessionId: sessionId,
    );
    if (response.data?.success != true) {
      throw const FormatException('服务器未确认设备下线。');
    }
  }

  Future<void> reportUser(String userId, String reason, String? details) async {
    final reportReason = switch (reason) {
      'SPAM' => ReportUserDtoReasonEnum.SPAM,
      'HARASSMENT' => ReportUserDtoReasonEnum.HARASSMENT,
      'FRAUD' => ReportUserDtoReasonEnum.FRAUD,
      'INAPPROPRIATE' => ReportUserDtoReasonEnum.INAPPROPRIATE,
      'OTHER' => ReportUserDtoReasonEnum.OTHER,
      _ => throw ArgumentError.value(reason, 'reason', '不支持的举报原因'),
    };
    final normalizedDetails = details?.trim();
    final response = await _api.getUsersApi().usersReport(
      userId: userId,
      reportUserDto: ReportUserDto(
        (builder) => builder
          ..reason = reportReason
          ..details = normalizedDetails?.isNotEmpty == true
              ? normalizedDetails
              : null,
      ),
    );
    _requireSuccess(response.data, '服务器未确认举报提交。');
  }

  void _requireSuccess(SuccessResponse? response, String message) {
    if (response?.success != true) throw FormatException(message);
  }
}
