import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/widgets/app_avatar.dart';

import 'home_controller.dart';
import 'group_join_page.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/app_feedback.dart';

class GroupSettingsPage extends StatefulWidget {
  const GroupSettingsPage({
    super.key,
    required this.groupId,
    required this.controller,
    required this.fileTransferService,
    this.pickAvatar,
  });

  final String groupId;
  final HomeController controller;
  final FileTransferService fileTransferService;
  final Future<PlatformFile?> Function()? pickAvatar;

  @override
  State<GroupSettingsPage> createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  GroupResponse? _group;
  Object? _error;
  bool _loading = true;
  bool _working = false;
  double? _uploadProgress;
  int _remoteRevision = 0;
  bool _remoteRefreshPending = false;
  bool _fetching = false;
  bool get _canAct => mounted && !_working && !_loading && _error == null;

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
    if (!_canManage) return;
    await _run(() async {
      final file =
          await (widget.pickAvatar?.call() ??
              FilePicker.pickFile(type: FileType.image));
      if (file == null || !mounted) return;
      setState(() => _uploadProgress = 0);
      try {
        final uploaded = await widget.fileTransferService.uploadAvatar(
          file: file,
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
    String? selected;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('邀请群成员'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final friend in candidates)
                  ListTile(
                    trailing: selected == friend.user.id
                        ? const Icon(Icons.check)
                        : null,
                    title: Text(friend.user.nickname),
                    subtitle: Text('@${friend.user.username}'),
                    onTap: () =>
                        setDialogState(() => selected = friend.user.id),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: selected == null
                  ? null
                  : () => Navigator.pop(context, true),
              child: const Text('发送邀请'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      await _run(() async {
        await widget.controller.inviteToGroup(widget.groupId, selected!);
        if (mounted) _message('邀请已发送，等待对方接受');
      });
    }
  }

  Future<void> _removeMember(GroupMemberResponse member) async {
    final name = member.user?.nickname ?? member.userId;
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
    final name = member.user?.nickname ?? member.userId;
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
      body: _loading && _group == null
          ? const AppLoading(message: '正在加载群资料…')
          : _error != null && _group == null
          ? AppStatus(
              title: '群资料加载失败',
              message: '请检查网络后重试',
              icon: Icons.cloud_off_outlined,
              onRetry: _load,
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final group = _group!;
    final members = (group.members ?? const <GroupMemberResponse>[]).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                AppAvatar(
                  name: group.name,
                  fileId: group.avatarFileId,
                  resolveUrl: widget.fileTransferService.downloadUrl,
                  group: true,
                  size: 76,
                ),
                if (_canManage)
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _canAct ? _changeAvatar : null,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(
                          group.avatarFileId == null ? '上传群头像' : '更换群头像',
                        ),
                      ),
                      if (group.avatarFileId != null)
                        TextButton(
                          onPressed: _canAct ? _removeAvatar : null,
                          child: const Text('移除群头像'),
                        ),
                    ],
                  ),
                if (_uploadProgress != null)
                  LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 12),
                Text(
                  group.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 5),
                TextButton.icon(
                  onPressed: () async {
                    try {
                      await Clipboard.setData(
                        ClipboardData(text: widget.groupId),
                      );
                      if (mounted) _message('群 ID 已复制，可用于申请入群');
                    } catch (_) {
                      if (mounted) _message('复制失败，请重试');
                    }
                  },
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: const Text('复制群 ID'),
                ),
                Text(
                  '${members.length}/${group.memberLimit} 位成员 · ${_roleName(_me?.role ?? GroupMemberResponseRoleEnum.MEMBER)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                if (group.muteAll) ...[
                  const SizedBox(height: 10),
                  const Chip(
                    avatar: Icon(Icons.volume_off_outlined, size: 17),
                    label: Text('全员禁言中'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_error != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('群资料更新失败，暂时无法操作。请刷新后重试。'),
          ),
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
                                groupId: widget.groupId,
                              ),
                            ),
                          );
                          if (mounted) await _load();
                        },
                ),
              if (_canManage)
                SwitchListTile(
                  title: const Text('全员禁言'),
                  subtitle: const Text('由消息服务执行群发送限制'),
                  value: group.muteAll,
                  onChanged: _canAct ? _toggleMuteAll : null,
                ),
              if (_canManage)
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('修改群名称'),
                  subtitle: const Text('所有群成员都会看到新名称'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _canAct ? _rename : null,
                ),
              if (_canManage && members.length < group.memberLimit)
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('邀请好友入群'),
                  subtitle: Text('发送邀请，需对方确认后加入'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _canAct ? _invite : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                '群成员',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              '${members.length} 人',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < members.length; index++) ...[
                _MemberTile(
                  member: members[index],
                  isMe: members[index].userId == _myId,
                  canRemove: _canRemove(members[index]),
                  working: !_canAct,
                  isOwner: _isOwner,
                  muted: _isMuted(members[index]),
                  onAction: (action) => _memberAction(members[index], action),
                ),
                if (index != members.length - 1)
                  const Divider(height: 1, indent: 72),
              ],
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
        if (_working) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 6),
          const Center(child: Text('正在处理…')),
        ],
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

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.isMe,
    required this.canRemove,
    required this.working,
    required this.onAction,
    required this.isOwner,
    required this.muted,
  });

  final GroupMemberResponse member;
  final bool isMe;
  final bool canRemove;
  final bool working;
  final ValueChanged<String> onAction;
  final bool isOwner;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final name = member.user?.nickname ?? member.userId;
    final privileged =
        member.role == GroupMemberResponseRoleEnum.OWNER ||
        member.role == GroupMemberResponseRoleEnum.ADMIN;
    final role = member.role == GroupMemberResponseRoleEnum.OWNER
        ? '群主'
        : member.role == GroupMemberResponseRoleEnum.ADMIN
        ? '管理员'
        : '成员';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: privileged
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        child: Text(name.trim().isEmpty ? '?' : name.trim().characters.first),
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
          ? PopupMenuButton<String>(
              tooltip: '管理$name',
              enabled: !working,
              onSelected: onAction,
              itemBuilder: (_) => [
                if (isOwner)
                  PopupMenuItem(
                    value: 'role',
                    child: Text(
                      member.role == GroupMemberResponseRoleEnum.ADMIN
                          ? '取消管理员'
                          : '设置管理员',
                    ),
                  ),
                PopupMenuItem(
                  value: muted ? 'unmute' : 'mute',
                  child: Text(muted ? '解除禁言' : '禁言成员'),
                ),
                if (isOwner)
                  const PopupMenuItem(value: 'transfer', child: Text('转让群主')),
                const PopupMenuItem(value: 'remove', child: Text('移除成员')),
              ],
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
