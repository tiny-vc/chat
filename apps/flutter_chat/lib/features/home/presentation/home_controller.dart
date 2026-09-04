import 'package:flutter/foundation.dart';
import 'package:chat_api_client/chat_api_client.dart';

import '../data/home_repository.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._repository);

  final HomeRepository _repository;

  HomeSnapshot? snapshot;
  Object? error;
  bool loading = false;
  int? pendingJoinCount;
  Object? pendingJoinError;
  bool pendingJoinLoading = false;
  bool _disposed = false;
  bool _reloadRequested = false;
  final Map<String, int> groupRevisions = {};

  Future<void> refreshRemoteGroup(String groupId) async {
    if (_disposed) return;
    groupRevisions[groupId] = (groupRevisions[groupId] ?? 0) + 1;
    notifyListeners();
    await load();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> refreshPendingJoins() async {
    if (_disposed || pendingJoinLoading) return;
    pendingJoinLoading = true;
    pendingJoinError = null;
    notifyListeners();
    try {
      final count = await _repository.pendingGroupJoinCount();
      if (!_disposed) pendingJoinCount = count;
    } catch (caught) {
      if (!_disposed) pendingJoinError = caught;
    } finally {
      pendingJoinLoading = false;
      notifyListeners();
    }
  }

  Future<void> load() async {
    if (_disposed) return;
    if (loading) {
      _reloadRequested = true;
      return;
    }
    loading = true;
    error = null;
    notifyListeners();
    try {
      snapshot = await _repository.load();
      await refreshPendingJoins();
    } catch (caught) {
      error = caught;
    } finally {
      loading = false;
      notifyListeners();
      if (_reloadRequested && !_disposed) {
        _reloadRequested = false;
        await load();
      }
    }
  }

  Future<List<UserSummary>> searchUsers(String query) =>
      _repository.searchUsers(query);

  Future<void> requestFriend(String userId) =>
      _repository.requestFriend(userId);

  Future<List<FriendRequestSummary>> friendRequests() =>
      _repository.friendRequests();

  Future<void> respondToFriendRequest(String requestId, bool accept) async {
    await _repository.respondToFriendRequest(requestId, accept);
    await load();
  }

  Future<void> createGroup(String name, Iterable<String> memberIds) async {
    await _repository.createGroup(name, memberIds);
    await load();
  }

  Future<GroupResponse> getGroup(String groupId) =>
      _repository.getGroup(groupId);

  Future<List<GroupJoinRequestResponse>> groupJoinRequests({
    required String groupId,
  }) => _repository.groupJoinRequests(groupId: groupId);
  Future<void> applyToGroup(String groupId, String message) =>
      _repository.applyToGroup(groupId, message);
  Future<List<GroupJoinRequestResponse>> groupJoinPage({
    required bool actionable,
    GroupJoinRequestResponse? before,
  }) => _repository.groupJoinPage(actionable: actionable, before: before);
  Future<void> inviteToGroup(String groupId, String userId) =>
      _repository.inviteToGroup(groupId, userId);
  Future<void> decideGroupJoin(
    String requestId,
    String action, {
    String message = '',
  }) async {
    await _repository.decideGroupJoin(requestId, action, message: message);
    await load();
  }

  Future<void> setGroupAdmin(String groupId, String userId, bool admin) async {
    await _repository.setGroupAdmin(groupId, userId, admin);
    await load();
  }

  Future<void> transferGroupOwner(String groupId, String userId) async {
    await _repository.transferGroupOwner(groupId, userId);
    await load();
  }

  Future<void> muteGroupMember(
    String groupId,
    String userId,
    bool muted, {
    int? minutes,
  }) async {
    await _repository.muteGroupMember(groupId, userId, muted, minutes: minutes);
    await load();
  }

  Future<void> setGroupMuteAll(String groupId, bool muted) async {
    await _repository.setGroupMuteAll(groupId, muted);
    await load();
  }

  Future<void> setGroupAvatar(String groupId, String fileId) async {
    await _repository.setGroupAvatar(groupId, fileId);
    await load();
  }

  Future<void> removeGroupAvatar(String groupId) async {
    await _repository.removeGroupAvatar(groupId);
    await load();
  }

  Future<void> renameGroup(String groupId, String name) async {
    await _repository.renameGroup(groupId, name);
    await load();
  }

  Future<void> addGroupMembers(String groupId, Iterable<String> userIds) async {
    await _repository.addGroupMembers(groupId, userIds);
    await load();
  }

  Future<void> removeGroupMember(String groupId, String userId) async {
    await _repository.removeGroupMember(groupId, userId);
    await load();
  }

  Future<void> leaveGroup(String groupId) async {
    await _repository.leaveGroup(groupId);
    await load();
  }

  Future<void> disbandGroup(String groupId) async {
    await _repository.disbandGroup(groupId);
    await load();
  }

  Future<void> updateNickname(String nickname) async {
    await _repository.updateNickname(nickname);
    await load();
  }

  Future<void> setAvatar(String fileId) async {
    await _repository.setAvatar(fileId);
    await load();
  }

  Future<void> removeAvatar() async {
    await _repository.removeAvatar();
    await load();
  }

  Future<void> changePassword(String currentPassword, String newPassword) =>
      _repository.changePassword(currentPassword, newPassword);

  Future<void> removeFriend(String userId) async {
    await _repository.removeFriend(userId);
    await load();
  }

  Future<void> blockUser(String userId) async {
    await _repository.blockUser(userId);
    await load();
  }

  Future<void> unblockUser(String userId) => _repository.unblockUser(userId);

  Future<List<BlockedUserSummary>> blockedUsers() => _repository.blockedUsers();

  Future<List<DeviceSummary>> devices() => _repository.devices();
  Future<void> revokeDevice(String sessionId) =>
      _repository.revokeDevice(sessionId);
  Future<void> reportUser(String userId, String reason, String? details) =>
      _repository.reportUser(userId, reason, details);
}
