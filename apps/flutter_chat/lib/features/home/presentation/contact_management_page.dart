import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';

import '../data/home_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';

class ContactManagementPage extends StatefulWidget {
  const ContactManagementPage({super.key, required this.controller});

  final HomeController controller;

  @override
  State<ContactManagementPage> createState() => _ContactManagementPageState();
}

class _ContactManagementPageState extends State<ContactManagementPage> {
  final _searchController = TextEditingController();
  List<UserSummary> _results = const [];
  List<FriendRequestSummary> _requests = const [];
  bool _searching = false;
  bool _loadingRequests = true;
  Object? _requestError;
  final Set<String> _requestedUsers = {};
  final Set<String> _pendingUsers = {};
  final Set<String> _pendingRequests = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _loadingRequests = true;
      _requestError = null;
    });
    try {
      final requests = await widget.controller.friendRequests();
      if (mounted) setState(() => _requests = requests);
    } catch (error) {
      if (mounted) setState(() => _requestError = error);
    } finally {
      if (mounted) setState(() => _loadingRequests = false);
    }
  }

  Future<void> _search() async {
    if (_searching) return;
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() => _searching = true);
    try {
      final results = await widget.controller.searchUsers(query);
      final me = widget.controller.snapshot?.me.id;
      final friendIds = {
        for (final friend
            in widget.controller.snapshot?.friends ?? const <FriendResponse>[])
          friend.user.id,
      };
      if (mounted) {
        setState(
          () => _results = results
              .where((user) => user.id != me && !friendIds.contains(user.id))
              .toList(),
        );
      }
    } catch (error) {
      if (mounted) _showError('搜索失败', error);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _requestFriend(UserSummary user) async {
    if (_pendingUsers.contains(user.id) || _requestedUsers.contains(user.id)) {
      return;
    }
    setState(() => _pendingUsers.add(user.id));
    try {
      await widget.controller.requestFriend(user.id);
      if (!mounted) return;
      setState(() => _requestedUsers.add(user.id));
      AppFeedback.show(
        context,
        '已向 ${user.nickname} 发送好友申请',
        kind: FeedbackKind.success,
      );
    } catch (error) {
      if (mounted) _showError('发送好友申请失败', error);
    } finally {
      if (mounted) setState(() => _pendingUsers.remove(user.id));
    }
  }

  Future<void> _respond(FriendRequestSummary request, bool accept) async {
    if (_pendingRequests.contains(request.id)) return;
    setState(() => _pendingRequests.add(request.id));
    try {
      await widget.controller.respondToFriendRequest(request.id, accept);
      if (!mounted) return;
      setState(() => _requests.removeWhere((item) => item.id == request.id));
      AppFeedback.show(
        context,
        accept ? '已添加好友' : '已拒绝好友申请',
        kind: FeedbackKind.success,
      );
    } catch (error) {
      if (mounted) _showError('处理好友申请失败', error);
    } finally {
      if (mounted) setState(() => _pendingRequests.remove(request.id));
    }
  }

  void _showError(String message, Object error) {
    AppFeedback.error(context, error, fallback: '$message，请稍后重试');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加好友'),
        actions: [
          IconButton(
            tooltip: '刷新好友申请',
            onPressed: _loadingRequests ? null : _loadRequests,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              labelText: '搜索用户名或昵称',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: _searching ? null : _search,
                icon: _searching
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          if (_results.isNotEmpty) ...[
            const _Heading('搜索结果'),
            for (final user in _results)
              ListTile(
                leading: _Avatar(user.nickname),
                title: Text(user.nickname),
                subtitle: Text('@${user.username}'),
                trailing: _requestedUsers.contains(user.id)
                    ? const Text('已申请')
                    : FilledButton.tonal(
                        onPressed: _pendingUsers.contains(user.id)
                            ? null
                            : () => _requestFriend(user),
                        child: Text(
                          _pendingUsers.contains(user.id) ? '发送中…' : '添加',
                        ),
                      ),
              ),
          ],
          const _Heading('收到的好友申请'),
          if (_loadingRequests)
            const AppLoading(message: '正在加载好友申请…')
          else if (_requestError != null)
            AppStatus(
              title: '好友申请加载失败',
              message: '请检查网络后重试',
              icon: Icons.cloud_off_outlined,
              onRetry: _loadRequests,
            )
          else if (_requests.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('暂无待处理申请')),
            )
          else
            for (final request in _requests)
              ListTile(
                leading: _Avatar(request.requester.nickname),
                title: Text(request.requester.nickname),
                subtitle: Text('@${request.requester.username}'),
                trailing: Wrap(
                  spacing: 6,
                  children: [
                    TextButton(
                      onPressed: _pendingRequests.contains(request.id)
                          ? null
                          : () => _respond(request, false),
                      child: const Text('拒绝'),
                    ),
                    FilledButton(
                      onPressed: _pendingRequests.contains(request.id)
                          ? null
                          : () => _respond(request, true),
                      child: Text(
                        _pendingRequests.contains(request.id) ? '处理中…' : '接受',
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

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key, required this.controller});

  final HomeController controller;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameController = TextEditingController();
  final Set<String> _selected = {};
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selected.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入群名称并至少选择一位好友')));
      return;
    }
    setState(() => _submitting = true);
    try {
      await widget.controller.createGroup(name, _selected);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('创建群聊失败：$error')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final friends =
        widget.controller.snapshot?.friends ?? const <FriendResponse>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建群聊'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('创建'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: '群聊名称',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: friends.isEmpty
                ? const Center(child: Text('请先添加好友'))
                : ListView(
                    children: [
                      const _Heading('选择群成员'),
                      for (final friend in friends)
                        CheckboxListTile(
                          value: _selected.contains(friend.user.id),
                          secondary: _Avatar(friend.user.nickname),
                          title: Text(friend.user.nickname),
                          subtitle: Text('@${friend.user.username}'),
                          onChanged: (checked) => setState(() {
                            if (checked == true) {
                              _selected.add(friend.user.id);
                            } else {
                              _selected.remove(friend.user.id);
                            }
                          }),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.name);
  final String name;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    child: Text(name.trim().isEmpty ? '?' : name.trim().characters.first),
  );
}
