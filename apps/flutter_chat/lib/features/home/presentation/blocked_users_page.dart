import 'package:flutter/material.dart';

import '../../../core/files/file_transfer_service.dart';
import '../../../core/widgets/app_avatar.dart';
import '../data/home_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({
    super.key,
    required this.controller,
    required this.fileTransferService,
  });
  final HomeController controller;
  final FileTransferService fileTransferService;

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  List<BlockedUserSummary> _items = const [];
  bool _loading = true;
  Object? _error;
  final Set<String> _unblocking = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.controller.blockedUsers();
      if (mounted) setState(() => _items = items);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unblock(BlockedUserSummary item) async {
    if (_unblocking.contains(item.user.id)) return;
    final confirmed = await AppFeedback.confirm(
      context,
      title: '移出黑名单',
      message: '移出后，对方可以再次向你发送好友申请和消息。',
      confirmLabel: '移出',
    );
    if (!confirmed || !mounted) return;
    setState(() => _unblocking.add(item.user.id));
    try {
      await widget.controller.unblockUser(item.user.id);
      if (mounted) {
        setState(() => _items.remove(item));
        AppFeedback.show(context, '已移出黑名单', kind: FeedbackKind.success);
      }
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '移出黑名单失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _unblocking.remove(item.user.id));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('黑名单'),
      actions: [
        IconButton(
          tooltip: '刷新黑名单',
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: _loading
        ? const AppLoading(message: '正在加载黑名单…')
        : _error != null
        ? AppStatus(
            title: '黑名单加载失败',
            message: '请检查网络后重试',
            icon: Icons.cloud_off_outlined,
            onRetry: _load,
          )
        : _items.isEmpty
        ? const AppStatus(
            title: '黑名单为空',
            message: '被屏蔽的用户会显示在这里',
            icon: Icons.person_off_outlined,
          )
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Text(
                    '已屏蔽的用户',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var index = 0; index < _items.length; index++) ...[
                        _BlockedUserTile(
                          item: _items[index],
                          fileTransferService: widget.fileTransferService,
                          busy: _unblocking.contains(_items[index].user.id),
                          onUnblock: () => _unblock(_items[index]),
                        ),
                        if (index + 1 < _items.length)
                          const Divider(height: 1, indent: 72),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
                  child: Text(
                    '移出后，对方可以再次向你发送好友申请和消息。',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}

class _BlockedUserTile extends StatelessWidget {
  const _BlockedUserTile({
    required this.item,
    required this.fileTransferService,
    required this.busy,
    required this.onUnblock,
  });

  final BlockedUserSummary item;
  final FileTransferService fileTransferService;
  final bool busy;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final name = item.user.nickname.trim();
    final date = item.createdAt;
    return ListTile(
      leading: AppAvatar(
        name: name,
        fileId: item.user.avatarFileId,
        resolveUrl: fileTransferService.downloadUrl,
        resolveFile: fileTransferService.downloadAvatar,
      ),
      title: Text(name.isEmpty ? item.user.username : name),
      subtitle: Text(
        '@${item.user.username}${date == null ? '' : ' · ${date.year}/${date.month}/${date.day} 加入'}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: TextButton(
        onPressed: busy ? null : onUnblock,
        child: Text(busy ? '处理中…' : '移出'),
      ),
    );
  }
}
