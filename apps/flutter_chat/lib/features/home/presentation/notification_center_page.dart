import 'package:flutter/material.dart';

import '../../../core/files/file_transfer_service.dart';
import 'contact_management_page.dart';
import 'group_join_page.dart';
import 'home_controller.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({
    super.key,
    required this.controller,
    required this.groupsEnabled,
    required this.fileTransferService,
  });

  final HomeController controller;
  final bool groupsEnabled;
  final FileTransferService fileTransferService;

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
    _refresh();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  Future<void> _refresh() async {
    await Future.wait([
      widget.controller.refreshPendingFriends(),
      if (widget.groupsEnabled) widget.controller.refreshPendingJoins(),
    ]);
  }

  Future<void> _openFriends() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ContactManagementPage(
          controller: widget.controller,
          fileTransferService: widget.fileTransferService,
        ),
      ),
    );
    await _refresh();
  }

  Future<void> _openGroups() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GroupJoinPage(
          controller: widget.controller,
          fileTransferService: widget.fileTransferService,
          actionable: true,
        ),
      ),
    );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final total =
        (controller.pendingFriendCount ?? 0) +
        (widget.groupsEnabled ? controller.pendingJoinCount ?? 0 : 0);
    final busy =
        controller.pendingFriendLoading ||
        (widget.groupsEnabled && controller.pendingJoinLoading);
    final hasError =
        controller.pendingFriendError != null ||
        (widget.groupsEnabled && controller.pendingJoinError != null);
    final summaryTitle = busy
        ? '正在同步通知…'
        : hasError
        ? '部分通知未能更新'
        : total > 0
        ? '$total 项待处理'
        : '暂无待处理通知';
    final summaryMessage = busy
        ? '正在获取最新的好友和群聊申请'
        : hasError
        ? '可下拉刷新，或进入对应分类重试'
        : total > 0
        ? '请及时处理好友或群聊申请'
        : '新的申请和邀请会集中显示在这里';
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知中心'),
        actions: [
          IconButton(
            tooltip: '刷新通知',
            onPressed: busy ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            Material(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: hasError
                          ? Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.primaryContainer,
                      child: busy
                          ? const Padding(
                              padding: EdgeInsets.all(11),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              hasError
                                  ? Icons.sync_problem_outlined
                                  : total > 0
                                  ? Icons.notifications_active_outlined
                                  : Icons.notifications_none_outlined,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summaryTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            summaryMessage,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _NotificationTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: '好友申请',
                    subtitle: controller.pendingFriendError != null
                        ? '加载失败，点击进入后重试'
                        : '查看想添加你的用户',
                    count: controller.pendingFriendCount,
                    loading: controller.pendingFriendLoading,
                    error: controller.pendingFriendError != null,
                    onTap: _openFriends,
                  ),
                  if (widget.groupsEnabled) ...[
                    const Divider(height: 1, indent: 64),
                    _NotificationTile(
                      icon: Icons.group_add_outlined,
                      title: '群聊申请与邀请',
                      subtitle: controller.pendingJoinError != null
                          ? '加载失败，点击进入后重试'
                          : '处理入群申请和收到的邀请',
                      count: controller.pendingJoinCount,
                      loading: controller.pendingJoinLoading,
                      error: controller.pendingJoinError != null,
                      onTap: _openGroups,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.loading,
    required this.error,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int? count;
  final bool loading;
  final bool error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    minVerticalPadding: 14,
    leading: CircleAvatar(child: Icon(icon)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(subtitle),
    ),
    trailing: loading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (error)
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                )
              else if ((count ?? 0) > 0)
                Badge(label: Text((count ?? 0) > 99 ? '99+' : '$count')),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
    onTap: onTap,
  );
}
