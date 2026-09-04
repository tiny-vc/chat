import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_feedback.dart';
import 'home_controller.dart';

class GroupJoinReminder extends StatelessWidget {
  const GroupJoinReminder({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.notifications_none),
    title: Text(
      controller.pendingJoinLoading
          ? '正在更新待处理数量…'
          : controller.pendingJoinError != null
          ? '待处理提醒更新失败'
          : controller.pendingJoinCount == null
          ? '待处理数量尚未获取'
          : '需要你处理：${controller.pendingJoinCount} 条',
    ),
    subtitle: const Text('“待我处理”包含收到的邀请和管理群的申请。'),
    trailing: IconButton(
      tooltip: '刷新待处理提醒',
      onPressed: controller.pendingJoinLoading
          ? null
          : controller.refreshPendingJoins,
      icon: const Icon(Icons.refresh),
    ),
  );
}

bool pendingGroupJoin(GroupJoinRequestResponse item) =>
    item.status == GroupJoinRequestResponseStatusEnum.PENDING &&
    item.expiresAt.isAfter(DateTime.now());

List<String> groupJoinActions(
  GroupJoinRequestResponse item,
  String? me,
  String? managedGroupId,
) {
  if (me == null || !pendingGroupJoin(item)) return [];
  final canDecide = item.type == GroupJoinRequestResponseTypeEnum.INVITE
      ? item.userId == me
      : managedGroupId == item.groupId;
  return [
    if (canDecide) ...['approve', 'reject'],
    if (item.requestedById == me) 'cancel',
  ];
}

class GroupJoinPage extends StatefulWidget {
  const GroupJoinPage({
    super.key,
    required this.controller,
    this.groupId,
    this.actionable = false,
  });
  final bool actionable;
  final HomeController controller;

  /// Only supplied from the group manager entry; the server enforces roles.
  final String? groupId;
  @override
  State<GroupJoinPage> createState() => _GroupJoinPageState();
}

class _GroupJoinPageState extends State<GroupJoinPage> {
  List<GroupJoinRequestResponse> _items = [];
  bool _loading = true;
  bool _busy = false;
  Object? _error;
  bool _actionable = false;
  bool _moreLoading = false;
  bool _hasMore = false;
  Object? _moreError;
  GroupJoinRequestResponse? _cursor;
  @override
  void initState() {
    super.initState();
    _actionable = widget.actionable;
    _load();
  }

  Future<void> _load() async {
    if (!mounted || _moreLoading) return;
    setState(() {
      _loading = true;
      _error = null;
      _moreError = null;
    });
    try {
      final items = widget.groupId == null
          ? await widget.controller.groupJoinPage(actionable: _actionable)
          : await widget.controller.groupJoinRequests(groupId: widget.groupId!);
      if (mounted) {
        setState(() {
          _items = items;
          _cursor = items.lastOrNull;
          _hasMore = widget.groupId == null && items.length == 100;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
      await widget.controller.refreshPendingJoins();
    }
  }

  Future<void> _loadMore() async {
    if (_moreLoading || _loading || _busy || !_hasMore || _cursor == null) {
      return;
    }
    setState(() {
      _moreLoading = true;
      _moreError = null;
    });
    try {
      final rows = await widget.controller.groupJoinPage(
        actionable: _actionable,
        before: _cursor,
      );
      if (!mounted) return;
      setState(() {
        final ids = _items.map((item) => item.id).toSet();
        _items = [..._items, ...rows.where((item) => ids.add(item.id))];
        _cursor = rows.lastOrNull;
        _hasMore = rows.length == 100;
      });
    } catch (error) {
      if (mounted) setState(() => _moreError = error);
    } finally {
      if (mounted) setState(() => _moreLoading = false);
    }
  }

  String? _managedGroupFor(GroupJoinRequestResponse item) =>
      widget.groupId ?? (_actionable ? item.groupId : null);

  Future<void> _apply() async {
    if (_busy || _loading || _moreLoading) return;
    final id = TextEditingController();
    final message = TextEditingController();
    final form = GlobalKey<FormState>();
    final accepted = await showAppFormDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('申请加入群聊'),
        content: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: id,
                  decoration: const InputDecoration(
                    labelText: '群 ID',
                    helperText: '请向群成员获取群 ID',
                  ),
                  validator: (value) =>
                      RegExp(
                        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                      ).hasMatch(value?.trim() ?? '')
                      ? null
                      : '请输入有效的群 ID',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: message,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '申请说明（选填）'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('提交申请'),
          ),
        ],
      ),
    );
    final groupId = id.text.trim();
    final note = message.text.trim();
    id.dispose();
    message.dispose();
    if (accepted != true || !mounted) return;
    await _run(
      () => widget.controller.applyToGroup(groupId, note),
      '申请已提交，等待群管理员审批',
    );
  }

  Future<void> _decide(GroupJoinRequestResponse item, String action) async {
    if (_busy || _loading || _moreLoading || _error != null) return;
    if (!groupJoinActions(
      item,
      widget.controller.snapshot?.me.id,
      _managedGroupFor(item),
    ).contains(action)) {
      AppFeedback.show(context, '记录状态已变化，请刷新后重试');
      await _load();
      return;
    }
    final title = _actionLabel(item, action);
    if (!await AppFeedback.confirm(
      context,
      title: title,
      message: '确定$title吗？操作后将更新该入群记录。',
      confirmLabel: title,
    )) {
      return;
    }
    if (!mounted || _busy) return;
    if (!pendingGroupJoin(item)) {
      await _load();
      return;
    }
    await _run(
      () => widget.controller.decideGroupJoin(item.id, action),
      '操作成功',
    );
  }

  Future<void> _run(Future<void> Function() operation, String success) async {
    if (_busy || !mounted) return;
    setState(() => _busy = true);
    try {
      await operation();
      if (mounted) AppFeedback.show(context, success);
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '操作失败，请刷新后重试');
    } finally {
      // Reconcile expired/conflicting records after both success and failure.
      await _load();
      if (mounted) setState(() => _busy = false);
    }
  }

  String _actionLabel(
    GroupJoinRequestResponse item,
    String action,
  ) => switch (action) {
    'approve' =>
      item.type == GroupJoinRequestResponseTypeEnum.INVITE ? '接受邀请' : '同意申请',
    'reject' =>
      item.type == GroupJoinRequestResponseTypeEnum.INVITE ? '拒绝邀请' : '拒绝申请',
    _ => '撤回',
  };
  String _status(GroupJoinRequestResponse item) {
    if (item.status == GroupJoinRequestResponseStatusEnum.PENDING &&
        !pendingGroupJoin(item)) {
      return '已过期';
    }
    return switch (item.status) {
      GroupJoinRequestResponseStatusEnum.PENDING => '待处理',
      GroupJoinRequestResponseStatusEnum.APPROVED => '已通过',
      GroupJoinRequestResponseStatusEnum.REJECTED => '已拒绝',
      GroupJoinRequestResponseStatusEnum.CANCELLED => '已撤回',
      _ => '已过期',
    };
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.groupId == null ? '入群申请与邀请' : '群入群审批'),
      actions: [
        IconButton(
          tooltip: '刷新',
          onPressed: _busy || _loading || _moreLoading ? null : _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: Column(
      children: [
        if (widget.groupId == null)
          Wrap(
            spacing: 8,
            children: [
              for (final value in [false, true])
                ChoiceChip(
                  label: Text(value ? '待我处理' : '我的记录'),
                  selected: _actionable == value,
                  onSelected: _busy || _loading || _moreLoading
                      ? null
                      : (_) {
                          if (_actionable == value) return;
                          setState(() => _actionable = value);
                          _load();
                        },
                ),
            ],
          ),
        if (widget.groupId == null)
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) =>
                GroupJoinReminder(controller: widget.controller),
          ),
        if (widget.groupId == null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _busy || _loading || _moreLoading ? null : _apply,
                icon: const Icon(Icons.group_add_outlined),
                label: const Text('申请加入群聊'),
              ),
            ),
          ),
        if (_busy) const LinearProgressIndicator(),
        Expanded(
          child: _loading
              ? const AppLoading(message: '正在读取入群记录…')
              : _error != null
              ? AppStatus(
                  title: '入群记录加载失败',
                  message: '请检查网络或群管理权限后重试',
                  onRetry: _load,
                )
              : _items.isEmpty
              ? const AppStatus(title: '暂无入群记录', message: '新的申请或邀请会显示在这里')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _items.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: widget.groupId == null
                            ? Column(
                                children: [
                                  if (_moreError != null)
                                    const Text('加载更多失败，已有记录已保留。'),
                                  if (_hasMore)
                                    TextButton(
                                      onPressed: _moreLoading || _busy
                                          ? null
                                          : _loadMore,
                                      child: Text(
                                        _moreLoading
                                            ? '正在加载…'
                                            : _moreError != null
                                            ? '重试加载更多'
                                            : '加载更多',
                                      ),
                                    )
                                  else
                                    const Text('已显示全部记录'),
                                ],
                              )
                            : Text('邀请需由被邀请人处理，群管理员只能审批入群申请。'),
                      );
                    }
                    final item = _items[index];
                    final actions = groupJoinActions(
                      item,
                      widget.controller.snapshot?.me.id,
                      _managedGroupFor(item),
                    );
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.group?.name ?? '群 ID：${item.groupId}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${item.type == GroupJoinRequestResponseTypeEnum.APPLY ? '入群申请' : '入群邀请'} · ${_status(item)}',
                            ),
                            Text('对象：${item.user?.nickname ?? item.userId}'),
                            if (item.message?.isNotEmpty ?? false)
                              Text(item.message!),
                            if (item.decisionNote?.isNotEmpty ?? false)
                              Text('处理说明：${item.decisionNote}'),
                            Text(
                              '有效期至 ${item.expiresAt.toLocal().toString().substring(0, 16)}',
                            ),
                            if (actions.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                children: [
                                  for (final action in actions)
                                    TextButton(
                                      onPressed: _busy || _moreLoading
                                          ? null
                                          : () => _decide(item, action),
                                      child: Text(_actionLabel(item, action)),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
