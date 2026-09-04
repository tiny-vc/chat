import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_avatar.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/im/im_service.dart';
import '../../calls/presentation/call_page.dart';
import '../../chat/presentation/chat_page.dart';
import 'home_controller.dart';

class FriendProfilePage extends StatefulWidget {
  const FriendProfilePage({
    super.key,
    required this.friend,
    required this.controller,
    required this.imService,
    required this.fileTransferService,
    required this.callService,
    required this.forwardTargets,
  });

  final FriendResponse friend;
  final HomeController controller;
  final ImService imService;
  final FileTransferService fileTransferService;
  final CallService callService;
  final List<ForwardTarget> forwardTargets;

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  bool _working = false;

  Future<void> _startCall(bool video) async {
    setState(() => _working = true);
    try {
      final call = await widget.callService.create(
        widget.friend.user.id,
        video: video,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CallPage(
            callId: call.id,
            title: widget.friend.user.nickname,
            video: video,
            incoming: false,
            callService: widget.callService,
            imService: widget.imService,
          ),
        ),
      );
    } catch (error) {
      if (mounted) _message('无法发起通话：$error');
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
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('举报用户'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: reason,
                items: const [
                  DropdownMenuItem(value: 'SPAM', child: Text('垃圾信息')),
                  DropdownMenuItem(value: 'HARASSMENT', child: Text('骚扰')),
                  DropdownMenuItem(value: 'FRAUD', child: Text('诈骗')),
                  DropdownMenuItem(value: 'INAPPROPRIATE', child: Text('不当内容')),
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
    if (submitted != true) return;
    try {
      await widget.controller.reportUser(widget.friend.user.id, reason, text);
      if (mounted) _message('举报已提交');
    } catch (error) {
      if (mounted) _message('举报失败：$error');
    }
  }

  Future<void> _finish(Future<void> Function() operation) async {
    setState(() => _working = true);
    try {
      await operation();
      await widget.imService.deleteConversation(widget.friend.user.id, 1);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _message('操作失败：$error');
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<bool> _confirm(String title, String content) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(title),
            ),
          ],
        ),
      ) ??
      false;

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.friend.user;
    return Scaffold(
      appBar: AppBar(title: const Text('好友资料')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppAvatar(
                    name: user.nickname,
                    fileId: user.avatarFileId,
                    size: 88,
                    resolveUrl: widget.fileTransferService.downloadUrl,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.nickname,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('@${user.username}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _working
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ChatPage(
                              channelId: user.id,
                              channelType: 1,
                              title: user.nickname,
                              imService: widget.imService,
                              fileTransferService: widget.fileTransferService,
                              forwardTargets: widget.forwardTargets,
                              callService: widget.callService,
                            ),
                          ),
                        ),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('发消息'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: '语音通话',
                onPressed: _working ? null : () => _startCall(false),
                icon: const Icon(Icons.call_outlined),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: '视频通话',
                onPressed: _working ? null : () => _startCall(true),
                icon: const Icon(Icons.videocam_outlined),
              ),
            ],
          ),
          const Divider(height: 36),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined),
            title: const Text('删除好友'),
            onTap: _working ? null : _remove,
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('举报用户'),
            onTap: _working ? null : _report,
          ),
          ListTile(
            leading: Icon(
              Icons.block,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              '加入黑名单',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: _working ? null : _block,
          ),
        ],
      ),
    );
  }
}
