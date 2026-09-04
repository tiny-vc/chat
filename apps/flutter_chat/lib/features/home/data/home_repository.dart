import 'package:chat_api_client/chat_api_client.dart';

class UserSummary {
  const UserSummary({
    required this.id,
    required this.username,
    required this.nickname,
  });

  final String id;
  final String username;
  final String nickname;

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    id: json['id'] as String,
    username: json['username'] as String? ?? '',
    nickname: json['nickname'] as String? ?? '',
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
}

class BlockedUserSummary {
  const BlockedUserSummary({required this.user, required this.createdAt});
  final UserSummary user;
  final DateTime? createdAt;
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
    final response = await _api.dio.get<Object>(
      '/api/v1/users/search',
      queryParameters: {'q': query.trim()},
    );
    return _jsonList(
      response.data,
    ).map((row) => UserSummary.fromJson(row)).toList();
  }

  Future<void> requestFriend(String userId) async {
    await _api.dio.post<Object>(
      '/api/v1/friends/requests',
      data: {'userId': userId},
    );
  }

  Future<List<FriendRequestSummary>> friendRequests() async {
    final responses = await Future.wait([
      _api.dio.get<Object>('/api/v1/friends/requests'),
      _api.dio.get<Object>('/api/v1/users/me'),
    ]);
    final response = responses[0];
    final me = Map<String, dynamic>.from(responses[1].data! as Map);
    final requests = _jsonList(response.data)
        .where(
          (row) => row['status'] == 'PENDING' && row['addresseeId'] == me['id'],
        )
        .toList();
    return Future.wait(
      requests.map((row) async {
        final requesterId = row['requesterId'] as String;
        final userResponse = await _api.dio.get<Object>(
          '/api/v1/users/$requesterId',
        );
        final user = UserSummary.fromJson(
          Map<String, dynamic>.from(userResponse.data! as Map),
        );
        return FriendRequestSummary(
          id: row['id'] as String,
          requesterId: requesterId,
          status: row['status'] as String,
          requester: user,
        );
      }),
    );
  }

  Future<void> respondToFriendRequest(String requestId, bool accept) async {
    await _api.dio.post<Object>(
      '/api/v1/friends/requests/$requestId/${accept ? 'accept' : 'reject'}',
    );
  }

  Future<void> createGroup(String name, Iterable<String> memberIds) async {
    await _api.dio.post<Object>(
      '/api/v1/groups',
      data: {'name': name.trim(), 'memberIds': memberIds.toList()},
    );
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
    await _api.dio.patch<Object>(
      '/api/v1/groups/$groupId',
      data: {'name': name.trim()},
    );
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
    await _api.dio.post<Object>(
      '/api/v1/groups/$groupId/members',
      data: {'userIds': userIds.toList()},
    );
  }

  Future<void> removeGroupMember(String groupId, String userId) async {
    await _api.dio.delete<Object>('/api/v1/groups/$groupId/members/$userId');
  }

  Future<void> leaveGroup(String groupId) async {
    await _api.dio.post<Object>('/api/v1/groups/$groupId/leave');
  }

  Future<void> disbandGroup(String groupId) async {
    await _api.dio.delete<Object>('/api/v1/groups/$groupId');
  }

  Future<void> updateNickname(String nickname) async {
    await _api.dio.patch<Object>(
      '/api/v1/users/me',
      data: {'nickname': nickname.trim()},
    );
  }

  Future<void> setAvatar(String fileId) async {
    await _api.dio.put<Object>(
      '/api/v1/users/me/avatar',
      data: {'fileId': fileId},
    );
  }

  Future<void> removeAvatar() async {
    await _api.dio.delete<Object>('/api/v1/users/me/avatar');
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _api.dio.post<Object>(
      '/api/v1/auth/change-password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<void> removeFriend(String userId) async {
    await _api.dio.delete<Object>('/api/v1/friends/$userId');
  }

  Future<void> blockUser(String userId) async {
    await _api.dio.post<Object>('/api/v1/blocks/$userId');
  }

  Future<void> unblockUser(String userId) async {
    await _api.dio.delete<Object>('/api/v1/blocks/$userId');
  }

  Future<List<BlockedUserSummary>> blockedUsers() async {
    final response = await _api.dio.get<Object>('/api/v1/blocks');
    return _jsonList(response.data).map((row) {
      final user = UserSummary.fromJson(
        Map<String, dynamic>.from(row['user'] as Map),
      );
      return BlockedUserSummary(
        user: user,
        createdAt: DateTime.tryParse(
          row['createdAt']?.toString() ?? '',
        )?.toLocal(),
      );
    }).toList();
  }

  Future<List<DeviceSummary>> devices() async {
    final response = await _api.dio.get<Object>('/api/v1/auth/devices');
    return _jsonList(response.data)
        .map(
          (row) => DeviceSummary(
            id: row['id']?.toString() ?? '',
            name: row['deviceName']?.toString() ?? '未知设备',
            type: row['deviceType']?.toString() ?? '',
            ipAddress: row['ipAddress']?.toString(),
            lastSeenAt: DateTime.tryParse(
              row['lastSeenAt']?.toString() ?? '',
            )?.toLocal(),
            current: row['current'] == true,
          ),
        )
        .toList();
  }

  Future<void> revokeDevice(String sessionId) async {
    await _api.dio.delete<Object>('/api/v1/auth/devices/$sessionId');
  }

  Future<void> reportUser(String userId, String reason, String? details) async {
    await _api.dio.post<Object>(
      '/api/v1/users/$userId/report',
      data: {
        'reason': reason,
        if (details?.trim().isNotEmpty == true) 'details': details!.trim(),
      },
    );
  }

  List<Map<String, dynamic>> _jsonList(Object? data) => (data as List)
      .map((item) => Map<String, dynamic>.from(item as Map))
      .toList();
}
