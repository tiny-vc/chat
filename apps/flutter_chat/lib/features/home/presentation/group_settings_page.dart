import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/files/file_size.dart';
import '../../../core/files/image_send_preparation.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/im/im_service.dart';

import 'home_controller.dart';
import 'group_join_page.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../config/server_settings.dart';

class GroupSettingsPage extends StatefulWidget {
  const GroupSettingsPage({
    super.key,
    required this.groupId,
    required this.controller,
    required this.fileTransferService,
    this.pickAvatar,
    this.allowAvatarUpload = true,
    this.imService,
  });

  final String groupId;
  final HomeController controller;
  final FileTransferService fileTransferService;
  final Future<PlatformFile?> Function()? pickAvatar;
  final bool allowAvatarUpload;
  final ImService? imService;

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  GroupResponse? _group;
  Object? _error;
  bool _loading = true;
  bool _working = false;
  bool _showAllMembers = false;
  double? _uploadProgress;
  int _remoteRevision = 0;
  bool _remoteRefreshPending = false;
  bool _fetching = false;
  bool get _canAct => mounted && !_working && !_loading && _error == null;
  bool get _allowAvatarUpload =>
      ServerCapabilitiesScope.maybeOf(context)?.files ??
      widget.allowAvatarUpload;

  String? get _myId => widget.controller.snapshot?.me.id;

  GroupMemberResponse? get _me {
    for (final member in _group?.members ?? const <GroupMemberResponse>[]) {
      if (member.userId == _myId) return member;
    }
    return null;
  }

  bool get _isOwner => _me?.role == GroupMemberResponseRoleEnum.OWNER;
  bool get _canManage =>
      _isOwner || _me?.role == GroupMemberResponseRoleEnum.ADMIN;

  @override
  void initState() {
    super.initState();
    _remoteRevision = widget.controller.groupRevisions[widget.groupId] ?? 0;
    widget.controller.addListener(_onRemoteChange);
    _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onRemoteChange);
    super.dispose();
  }

  void _onRemoteChange() {
    final revision = widget.controller.groupRevisions[widget.groupId] ?? 0;
    if (revision == _remoteRevision) return;
    _remoteRevision = revision;
    _remoteRefreshPending = true;
    if (!_working && !_fetching) _load();
  }

  Future<void> _load() async {
    if (_fetching) return;
    _fetching = true;
    _remoteRefreshPending = false;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final group = await widget.controller.getGroup(widget.groupId);
      if (mounted) setState(() => _group = group);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      _fetching = false;
      if (mounted) setState(() => _loading = false);
      if (mounted && _remoteRefreshPending && !_working) await _load();
    }
  }

  Future<void> _changeAvatar() async {
    if (!_canManage || !_allowAvatarUpload) return;
    await _run(() async {
      final file = await (widget.pickAvatar?.call() ?? pickPortableAvatar());
      if (file == null || !mounted) return;
      final uploadFile = widget.pickAvatar == null
          ? (await prepareChatImage(
              file,
              compress: canCompressChatImage(file),
            )).file
          : file;
      final size = await uploadFile.length();
      if (!mounted) return;
      final limit = ServerCapabilitiesScope.uploadLimitsOf(context).avatar;
      if (size > limit) {
        AppFeedback.show(
          context,
          '群头像大小为 ${formatFileSize(size)}，服务器上限为 ${formatFileSize(limit)}',
          kind: FeedbackKind.error,
        );
        return;
      }
      setState(() => _uploadProgress = 0);
      try {
        final uploaded = await widget.fileTransferService.uploadAvatar(
          file: uploadFile,
          onProgress: (sent, total) {
            if (mounted && total > 0) {
              setState(() => _uploadProgress = (sent / total).clamp(0, 1));
            }
          },
        );
        if (!mounted) return;
        await widget.controller.setGroupAvatar(widget.groupId, uploaded.fileId);
      } finally {
        if (mounted) setState(() => _uploadProgress = null);
      }
    });
  }

  Future<void> _removeAvatar() async {
    if (!_canAct || !_canManage) return;
    if (!await _confirm('移除群头像', '恢复默认群头像，不会删除聊天中的图片。')) return;
    await _run(() => widget.controller.removeGroupAvatar(widget.groupId));
  }

  Future<void> _rename() async {
    final controller = TextEditingController(text: _group!.name);
    final name = await showAppFormDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改群名称'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 50,
          decoration: const InputDecoration(labelText: '群名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == _group!.name) return;
    await _run(() => widget.controller.renameGroup(widget.groupId, name));
  }

  Future<void> _editAnnouncement() async {
    final controller = TextEditingController(text: _group?.announcement ?? '');
    final value = await showAppFormDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑群公告'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 6,
          maxLength: 1000,
          decoration: const InputDecoration(
            hintText: '填写群规则、通知或重要信息',
            helperText: '留空并保存可清除公告',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.trim() == (_group?.announcement ?? '')) return;
    await _run(
      () => widget.controller.updateGroupAnnouncement(widget.groupId, value),
    );
    if (mounted) _message(value.trim().isEmpty ? '群公告已清除' : '群公告已更新');
  }

  Future<void> _editMyNickname() async {
    final controller = TextEditingController(text: _me?.nickname ?? '');
    final value = await showAppFormDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('我在本群的昵称'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 80,
          decoration: InputDecoration(
            hintText: _me?.user?.nickname ?? '使用账号昵称',
            helperText: '留空时显示账号昵称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.trim() == (_me?.nickname ?? '')) return;
    await _run(
      () => widget.controller.updateMyGroupNickname(widget.groupId, value),
    );
    if (mounted) _message('群昵称已更新');
  }

  Future<void> _invite() async {
    final memberIds = {
      for (final member in _group?.members ?? const <GroupMemberResponse>[])
        member.userId,
    };
    final candidates =
        (widget.controller.snapshot?.friends ?? const <FriendResponse>[])
            .where((friend) => !memberIds.contains(friend.user.id))
            .toList();
    if (candidates.isEmpty) {
      _message('没有可邀请的好友');
      return;
    }
    final selected = <String>{};
    final searchController = TextEditingController();
    var query = '';
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final visible = candidates.where((friend) {
            if (query.isEmpty) return true;
            return friend.user.nickname.toLowerCase().contains(query) ||
                friend.user.username.toLowerCase().contains(query);
          }).toList();
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * .72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '邀请好友入群',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Text(
                          '已选 ${selected.length} 人',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: searchController,
                      autofocus: candidates.length > 8,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => setDialogState(
                        () => query = value.trim().toLowerCase(),
                      ),
                      decoration: InputDecoration(
                        hintText: '搜索昵称或用户名',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: '清空搜索',
                                onPressed: () {
                                  searchController.clear();
                                  setDialogState(() => query = '');
                                },
                                icon: const Icon(Icons.close),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: visible.isEmpty
                          ? const AppStatus(
                              icon: Icons.person_search_outlined,
                              title: '没有匹配的好友',
                              message: '请尝试其他昵称或用户名',
                            )
                          : ListView.builder(
                              itemCount: visible.length,
                              itemBuilder: (context, index) {
                                final friend = visible[index];
                                return CheckboxListTile(
                                  value: selected.contains(friend.user.id),
                                  secondary: AppAvatar(
                                    name: friend.user.nickname,
                                    fileId: friend.user.avatarFileId,
                                    resolveUrl:
                                        widget.fileTransferService.downloadUrl,
                                    resolveFile: widget
                                        .fileTransferService
                                        .downloadAvatar,
                                  ),
                                  title: Text(friend.user.nickname),
                                  subtitle: Text('@${friend.user.username}'),
                                  onChanged: (checked) => setDialogState(() {
                                    if (checked == true) {
                                      selected.add(friend.user.id);
                                    } else {
                                      selected.remove(friend.user.id);
                                    }
                                  }),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: selected.isEmpty
                                ? null
                                : () => Navigator.pop(context, true),
                            child: Text('发送邀请（${selected.length}）'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    searchController.dispose();
    if (confirmed == true) {
      if (!_canAct) return;
      setState(() => _working = true);
      final failures = <String>[];
      var sent = 0;
      try {
        for (final userId in selected) {
          final friend = candidates
              .where((item) => item.user.id == userId)
              .firstOrNull;
          final displayName = friend?.user.nickname ?? userId;
          try {
            await widget.controller.inviteToGroup(widget.groupId, userId);
            sent++;
          } catch (_) {
            failures.add(displayName);
          }
        }
        if (!mounted) return;
        await _load();
        if (!mounted) return;
        if (failures.isEmpty) {
          _message('已发送 $sent 份邀请，等待对方接受');
        } else {
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('邀请结果'),
              content: Text(
                '成功 $sent 人，失败 ${failures.length} 人。\n\n'
                '未发送：${failures.join('、')}\n\n'
                '可稍后重新邀请失败的好友。',
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('知道了'),
                ),
              ],
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _working = false);
      }
    }
  }

  Future<void> _removeMember(GroupMemberResponse member) async {
    final name = member.nickname ?? member.user?.nickname ?? member.userId;
    final confirmed = await _confirm(
      '移除群成员',
      '确定将 $name 移出群聊吗？',
      destructive: true,
    );
    if (!confirmed) return;
    await _run(
      () => widget.controller.removeGroupMember(widget.groupId, member.userId),
    );
  }

  Future<void> _exitGroup() async {
    if (!_canAct) return;
    final action = _isOwner ? '解散群聊' : '退出群聊';
    final description = _isOwner ? '解散后所有成员都将退出，且无法恢复。' : '退出后将不再收到该群消息。';
    if (!await _confirm(action, description, destructive: true)) return;
    if (!_canAct) return;
    setState(() => _working = true);
    try {
      if (_isOwner) {
        await widget.controller.disbandGroup(widget.groupId);
      } else {
        await widget.controller.leaveGroup(widget.groupId);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '$action失败，请稍后重试');
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _run(Future<void> Function() operation) async {
    if (!_canAct) return;
    setState(() => _working = true);
    try {
      await operation();
      if (!mounted) return;
      await _load();
    } catch (error) {
      if (mounted) AppFeedback.error(context, error);
    } finally {
      if (mounted) setState(() => _working = false);
      if (mounted && _remoteRefreshPending) await _load();
    }
  }

  bool _isMuted(GroupMemberResponse member) =>
      member.mutedUntil?.isAfter(DateTime.now()) ?? false;

  Future<void> _memberAction(GroupMemberResponse member, String action) async {
    if (!_canAct || !_canRemove(member)) return;
    final name = member.nickname ?? member.user?.nickname ?? member.userId;
    if (action == 'remove') return _removeMember(member);
    if (action == 'role') {
      if (!_isOwner) return;
      final admin = member.role != GroupMemberResponseRoleEnum.ADMIN;
      final title = admin ? '设置管理员' : '取消管理员';
      if (!await _confirm(title, '确定对 $name 执行$title吗？')) return;
      await _run(
        () => widget.controller.setGroupAdmin(
          widget.groupId,
          member.userId,
          admin,
        ),
      );
    } else if (action == 'transfer') {
      if (!_isOwner) return;
      if (!await _confirm(
        '转让群主',
        '确定将群主转让给 $name 吗？你将变为管理员，无法自行撤回转让。',
        destructive: true,
      )) {
        return;
      }
      await _run(
        () =>
            widget.controller.transferGroupOwner(widget.groupId, member.userId),
      );
    } else if (action == 'unmute') {
      if (!await _confirm('解除禁言', '确定解除 $name 的禁言吗？')) return;
      await _run(
        () => widget.controller.muteGroupMember(
          widget.groupId,
          member.userId,
          false,
        ),
      );
    } else if (action == 'mute') {
      final minutes = await showDialog<int>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('禁言 $name'),
          children: [
            for (final item in {15: '15 分钟', 60: '1 小时', 1440: '24 小时'}.entries)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, item.key),
                child: Text(item.value),
              ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
          ],
        ),
      );
      if (minutes == null || !mounted) return;
      if (!await _confirm('确认禁言', '确定禁言 $name $minutes 分钟吗？')) return;
      await _run(
        () => widget.controller.muteGroupMember(
          widget.groupId,
          member.userId,
          true,
          minutes: minutes,
        ),
      );
    }
  }

  Future<void> _toggleMuteAll(bool muted) async {
    if (!_canAct || !_canManage) return;
    final title = muted ? '开启全员禁言' : '关闭全员禁言';
    if (!await _confirm(
      title,
      muted ? '全员禁言会由消息服务限制该群发送消息，确定开启吗？' : '确定恢复该群发送消息吗？',
    )) {
      return;
    }
    await _run(() => widget.controller.setGroupMuteAll(widget.groupId, muted));
  }

  Future<void> _toggleNotifications(bool muted) async {
    final imService = widget.imService;
    if (!_canAct || imService == null) return;
    await _run(
      () => imService.updateConversationSetting(
        channelId: widget.groupId,
        channelType: 2,
        muted: muted,
      ),
    );
  }

  Future<bool> _confirm(
    String title,
    String content, {
    bool destructive = false,
  }) async => AppFeedback.confirm(
    context,
    title: title,
    message: content,
    confirmLabel: title,
    destructive: destructive,
  );

  void _message(String text) {
    AppFeedback.show(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群聊资料'),
        actions: [
          IconButton(
            tooltip: '刷新',
            onPressed: _working || _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_working)
            Semantics(
              liveRegion: true,
              label: '正在更新群资料',
              child: const LinearProgressIndicator(),
            ),
          Expanded(
            child: _loading && _group == null
                ? const AppLoading(message: '正在加载群资料…')
                : _error != null && _group == null
                ? AppStatus(
                    title: '群资料加载失败',
                    message: '请检查网络后重试',
                    icon: Icons.cloud_off_outlined,
                    onRetry: _load,
                  )
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final group = _group!;
    final members = (group.members ?? const <GroupMemberResponse>[]).toList();
    final visibleMembers = _showAllMembers || members.length <= 8
        ? members
        : members.take(8).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppAvatar(
                        key: const ValueKey('group-avatar'),
                        name: group.name,
                        fileId: group.avatarFileId,
                        resolveUrl: widget.fileTransferService.downloadUrl,
                        resolveFile: widget.fileTransferService.downloadAvatar,
                        group: true,
                        size: 76,
                      ),
                      if (_canManage)
                        Positioned(
                          right: -9,
                          bottom: -8,
                          child: IconButton.filled(
                            tooltip: group.avatarFileId == null
                                ? '添加群头像'
                                : '更换群头像',
                            onPressed: _canAct && _allowAvatarUpload
                                ? _changeAvatar
                                : null,
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              _roleName(
                                _me?.role ?? GroupMemberResponseRoleEnum.MEMBER,
                              ),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${members.length}/${group.memberLimit} 人',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (group.muteAll)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.volume_off_outlined,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(width: 3),
                                  const Text('全员禁言'),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                try {
                                  await Clipboard.setData(
                                    ClipboardData(text: widget.groupId),
                                  );
                                  if (mounted) {
                                    _message('群 ID 已复制，可用于申请入群');
                                  }
                                } catch (_) {
                                  if (mounted) _message('复制失败，请重试');
                                }
                              },
                              icon: const Icon(Icons.copy_outlined, size: 17),
                              label: const Text('复制群 ID'),
                            ),
                            if (_canManage && group.avatarFileId != null)
                              TextButton(
                                onPressed: _canAct ? _removeAvatar : null,
                                child: const Text('移除群头像'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_canManage && !_allowAvatarUpload) ...[
                const SizedBox(height: 10),
                Text(
                  '当前服务器未开放群头像上传',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (_uploadProgress != null) ...[
                const SizedBox(height: 10),
                LinearProgressIndicator(value: _uploadProgress),
              ],
              if ((group.announcement ?? '').isNotEmpty) ...[
                const SizedBox(height: 14),
                Material(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.campaign_outlined, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            group.announcement!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_error != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('群资料更新失败，暂时无法操作。请刷新后重试。'),
          ),
        const _SectionTitle(title: '我的群聊设置'),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('我在本群的昵称'),
                subtitle: Text(
                  (_me?.nickname ?? '').isEmpty ? '未设置，显示账号昵称' : _me!.nickname!,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _canAct ? _editMyNickname : null,
              ),
              if (widget.imService case final imService?)
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.notifications_off_outlined),
                  title: const Text('消息免打扰'),
                  subtitle: const Text('仍会接收消息，但不会主动提醒'),
                  value: imService.settingFor(widget.groupId, 2).muted,
                  onChanged: _canAct ? _toggleNotifications : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        if (_canManage) ...[
          const _SectionTitle(title: '群资料'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('修改群名称'),
                  subtitle: const Text('所有群成员都会看到新名称'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _canAct ? _rename : null,
                ),
                ListTile(
                  leading: const Icon(Icons.campaign_outlined),
                  title: const Text('群公告'),
                  subtitle: Text(
                    (group.announcement ?? '').isEmpty
                        ? '暂未设置群公告'
                        : group.announcement!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _canAct ? _editAnnouncement : null,
                ),
              ],
            ),
          ),
        ],
        if (_canManage) ...[
          const SizedBox(height: 22),
          const _SectionTitle(title: '入群与权限'),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                if (_canManage)
                  ListTile(
                    leading: const Icon(Icons.fact_check_outlined),
                    title: const Text('入群审批'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: !_canAct
                        ? null
                        : () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => GroupJoinPage(
                                  controller: widget.controller,
                                  fileTransferService:
                                      widget.fileTransferService,
                                  groupId: widget.groupId,
                                ),
                              ),
                            );
                            if (mounted) await _load();
                          },
                  ),
                if (members.length < group.memberLimit)
                  ListTile(
                    leading: const Icon(Icons.person_add_outlined),
                    title: const Text('邀请好友入群'),
                    subtitle: const Text('发送邀请，需对方确认后加入'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _canAct ? _invite : null,
                  ),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_off_outlined),
                  title: const Text('全员禁言'),
                  subtitle: const Text('由消息服务执行群发送限制'),
                  value: group.muteAll,
                  onChanged: _canAct ? _toggleMuteAll : null,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 22),
        _SectionTitle(title: '群成员', trailing: '${members.length} 人'),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < visibleMembers.length; index++) ...[
                _MemberTile(
                  member: visibleMembers[index],
                  fileTransferService: widget.fileTransferService,
                  isMe: visibleMembers[index].userId == _myId,
                  canRemove: _canRemove(visibleMembers[index]),
                  working: !_canAct,
                  isOwner: _isOwner,
                  muted: _isMuted(visibleMembers[index]),
                  onAction: (action) =>
                      _memberAction(visibleMembers[index], action),
                ),
                if (index != visibleMembers.length - 1 ||
                    visibleMembers.length != members.length)
                  const Divider(height: 1, indent: 72),
              ],
              if (members.length > 8)
                ListTile(
                  leading: Icon(
                    _showAllMembers ? Icons.expand_less : Icons.groups_outlined,
                  ),
                  title: Text(
                    _showAllMembers ? '收起成员列表' : '查看全部 ${members.length} 位成员',
                  ),
                  trailing: Icon(
                    _showAllMembers
                        ? Icons.keyboard_arrow_up
                        : Icons.chevron_right,
                  ),
                  onTap: () =>
                      setState(() => _showAllMembers = !_showAllMembers),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '危险操作',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: Icon(
              _isOwner ? Icons.delete_forever_outlined : Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              _isOwner ? '解散群聊' : '退出群聊',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: Text(_isOwner ? '解散后无法恢复' : '退出后将不再收到该群消息'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _canAct ? _exitGroup : null,
          ),
        ),
      ],
    );
  }

  bool _canRemove(GroupMemberResponse member) {
    if (!_canManage || member.userId == _myId) return false;
    if (member.role == GroupMemberResponseRoleEnum.OWNER) return false;
    return _isOwner || member.role == GroupMemberResponseRoleEnum.MEMBER;
  }

  String _roleName(GroupMemberResponseRoleEnum role) {
    if (role == GroupMemberResponseRoleEnum.OWNER) return '群主';
    if (role == GroupMemberResponseRoleEnum.ADMIN) return '管理员';
    return '成员';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
    ],
  );
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.fileTransferService,
    required this.isMe,
    required this.canRemove,
    required this.working,
    required this.onAction,
    required this.isOwner,
    required this.muted,
  });

  final GroupMemberResponse member;
  final FileTransferService fileTransferService;
  final bool isMe;
  final bool canRemove;
  final bool working;
  final ValueChanged<String> onAction;
  final bool isOwner;
  final bool muted;

  Future<void> _showActions(BuildContext context, String name) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: AppAvatar(
                  name: name,
                  fileId: member.user?.avatarFileId,
                  resolveUrl: fileTransferService.downloadUrl,
                  resolveFile: fileTransferService.downloadAvatar,
                ),
                title: Text(name),
                subtitle: Text('@${member.user?.username ?? member.userId}'),
              ),
              const Divider(height: 1),
              if (isOwner)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: Text(
                    member.role == GroupMemberResponseRoleEnum.ADMIN
                        ? '取消管理员'
                        : '设置管理员',
                  ),
                  onTap: () => Navigator.pop(context, 'role'),
                ),
              ListTile(
                leading: Icon(
                  muted
                      ? Icons.record_voice_over_outlined
                      : Icons.voice_over_off_outlined,
                ),
                title: Text(muted ? '解除禁言' : '禁言成员'),
                onTap: () => Navigator.pop(context, muted ? 'unmute' : 'mute'),
              ),
              if (isOwner)
                ListTile(
                  leading: const Icon(Icons.manage_accounts_outlined),
                  title: const Text('转让群主'),
                  subtitle: const Text('转让后你将变为管理员'),
                  onTap: () => Navigator.pop(context, 'transfer'),
                ),
              ListTile(
                leading: Icon(
                  Icons.person_remove_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  '移出群聊',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action != null) onAction(action);
  }

  @override
  Widget build(BuildContext context) {
    final name = member.nickname ?? member.user?.nickname ?? member.userId;
    final privileged =
        member.role == GroupMemberResponseRoleEnum.OWNER ||
        member.role == GroupMemberResponseRoleEnum.ADMIN;
    final role = member.role == GroupMemberResponseRoleEnum.OWNER
        ? '群主'
        : member.role == GroupMemberResponseRoleEnum.ADMIN
        ? '管理员'
        : '成员';
    return ListTile(
      leading: AppAvatar(
        name: name,
        fileId: member.user?.avatarFileId,
        resolveUrl: fileTransferService.downloadUrl,
        resolveFile: fileTransferService.downloadAvatar,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          if (isMe) ...[
            const SizedBox(width: 6),
            Text(
              '我',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        muted
            ? '$role · 禁言至 ${member.mutedUntil!.toLocal().toString().substring(0, 16)}'
            : role,
      ),
      trailing: canRemove
          ? IconButton(
              tooltip: '管理$name',
              onPressed: working ? null : () => _showActions(context, name),
              icon: const Icon(Icons.more_horiz),
            )
          : privileged
          ? Icon(
              Icons.verified_outlined,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }
}
