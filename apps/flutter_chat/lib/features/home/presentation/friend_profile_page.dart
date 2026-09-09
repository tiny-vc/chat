import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_avatar.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/im/im_service.dart';
import '../../calls/presentation/outgoing_call_launcher.dart';
import '../../chat/presentation/chat_page.dart';
import 'home_controller.dart';
import '../../../config/server_settings.dart';
import '../../../core/widgets/app_feedback.dart';

class FriendProfilePage extends StatefulWidget {
  const FriendProfilePage({
    super.key,
    required this.friend,
    required this.controller,
    required this.imService,
    required this.fileTransferService,
    required this.callService,
    required this.forwardTargets,
    this.capabilities = ServerCapabilities.all,
  });

  final FriendResponse friend;
  final HomeController controller;
  final ImService imService;
  final FileTransferService fileTransferService;
  final CallService callService;
  final List<ForwardTarget> forwardTargets;
  final ServerCapabilities capabilities;

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  bool _working = false;
  ServerCapabilities get _capabilities =>
      ServerCapabilitiesScope.maybeOf(context) ?? widget.capabilities;

  Future<void> _startCall(bool video) async {
    setState(() => _working = true);
    try {
      await launchOutgoingCall(
        context: context,
        targetUserId: widget.friend.user.id,
        title: widget.friend.user.nickname,
        video: video,
        callService: widget.callService,
        imService: widget.imService,
        capabilities: _capabilities,
      );
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _remove() async {
    if (!await _confirm('删除好友', '删除后需要重新发送好友申请才能聊天和通话。')) return;
    await _finish(() => widget.controller.removeFriend(widget.friend.user.id));
  }

  Future<void> _block() async {
    if (!await _confirm('加入黑名单', '对方将无法向你发送消息或发起通话。')) return;
    await _finish(() => widget.controller.blockUser(widget.friend.user.id));
  }

  Future<void> _report() async {
    var reason = 'SPAM';
    final details = TextEditingController();
    final submitted = await showAppFormDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('举报用户'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: reason,
                  items: const [
                    DropdownMenuItem(value: 'SPAM', child: Text('垃圾信息')),
                    DropdownMenuItem(value: 'HARASSMENT', child: Text('骚扰')),
                    DropdownMenuItem(value: 'FRAUD', child: Text('诈骗')),
                    DropdownMenuItem(
                      value: 'INAPPROPRIATE',
                      child: Text('不当内容'),
                    ),
                    DropdownMenuItem(value: 'OTHER', child: Text('其他')),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => reason = value ?? reason),
                ),
                TextField(
                  controller: details,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '补充说明（可选）'),
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
              onPressed: () => Navigator.pop(context, true),
              child: const Text('提交'),
            ),
          ],
        ),
      ),
    );
    final text = details.text;
    details.dispose();
    if (submitted != true || _working) return;
    setState(() => _working = true);
    try {
      await widget.controller.reportUser(widget.friend.user.id, reason, text);
      if (mounted) {
        AppFeedback.show(context, '举报已提交', kind: FeedbackKind.success);
      }
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '举报失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _finish(Future<void> Function() operation) async {
    setState(() => _working = true);
    try {
      await operation();
      await widget.imService.deleteConversation(widget.friend.user.id, 1);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) AppFeedback.error(context, error);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<bool> _confirm(String title, String content) async =>
      AppFeedback.confirm(
        context,
        title: title,
        message: content,
        confirmLabel: title,
        destructive: true,
      );

  @override
  Widget build(BuildContext context) {
    final user = widget.friend.user;
    return Scaffold(
      appBar: AppBar(title: const Text('好友资料')),
      body: Column(
        children: [
          if (_working)
            Semantics(
              liveRegion: true,
              label: '正在处理好友操作',
              child: const LinearProgressIndicator(),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                          child: Row(
                            children: [
                              AppAvatar(
                                name: user.nickname,
                                fileId: user.avatarFileId,
                                size: 76,
                                resolveUrl:
                                    widget.fileTransferService.downloadUrl,
                                resolveFile:
                                    widget.fileTransferService.downloadAvatar,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.nickname,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      '@${user.username}',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          size: 17,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 5),
                                        const Text('已添加为好友'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 14,
                            runSpacing: 12,
                            children: [
                              _ProfileAction(
                                icon: Icons.chat_bubble_outline,
                                label: '发消息',
                                primary: true,
                                onPressed: _working
                                    ? null
                                    : () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => ChatPage(
                                            channelId: user.id,
                                            channelType: 1,
                                            title: user.nickname,
                                            imService: widget.imService,
                                            fileTransferService:
                                                widget.fileTransferService,
                                            forwardTargets:
                                                widget.forwardTargets,
                                            callService: widget.callService,
                                            capabilities: _capabilities,
                                          ),
                                        ),
                                      ),
                              ),
                              if (_capabilities.canAudioCall)
                                _ProfileAction(
                                  icon: Icons.call_outlined,
                                  label: '语音通话',
                                  onPressed: _working
                                      ? null
                                      : () => _startCall(false),
                                ),
                              if (_capabilities.canVideoCall)
                                _ProfileAction(
                                  icon: Icons.videocam_outlined,
                                  label: '视频通话',
                                  onPressed: _working
                                      ? null
                                      : () => _startCall(true),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          '关系与安全',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.flag_outlined),
                                title: const Text('举报用户'),
                                subtitle: const Text('举报垃圾信息、骚扰、诈骗或不当内容'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: _working ? null : _report,
                              ),
                              const Divider(height: 1, indent: 56),
                              ListTile(
                                leading: Icon(
                                  Icons.person_remove_outlined,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                title: Text(
                                  '删除好友',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                subtitle: const Text('删除后需要重新申请才能恢复好友关系'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: _working ? null : _remove,
                              ),
                              const Divider(height: 1, indent: 56),
                              ListTile(
                                leading: Icon(
                                  Icons.block,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                title: Text(
                                  '加入黑名单',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                subtitle: const Text('同时阻止对方发送消息和发起通话'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: _working ? null : _block,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      child: SizedBox(
        width: 88,
        child: InkWell(
          key: ValueKey('friend-action-$label'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary ? colors.primary : colors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: primary
                        ? colors.onPrimary
                        : colors.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
