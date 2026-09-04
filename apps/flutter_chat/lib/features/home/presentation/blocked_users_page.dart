import 'package:flutter/material.dart';

import '../data/home_repository.dart';
import 'home_controller.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key, required this.controller});
  final HomeController controller;

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  List<BlockedUserSummary> _items = const [];
  bool _loading = true;
  Object? _error;

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
    try {
      await widget.controller.unblockUser(item.user.id);
      if (mounted) setState(() => _items.remove(item));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('移出黑名单失败：$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('黑名单')),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: FilledButton(onPressed: _load, child: const Text('加载失败，重试')),
          )
        : _items.isEmpty
        ? const Center(child: Text('黑名单为空'))
        : ListView.separated(
            itemCount: _items.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final item = _items[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    item.user.nickname.trim().isEmpty
                        ? '?'
                        : item.user.nickname.characters.first,
                  ),
                ),
                title: Text(item.user.nickname),
                subtitle: Text('@${item.user.username}'),
                trailing: TextButton(
                  onPressed: () => _unblock(item),
                  child: const Text('移出'),
                ),
              );
            },
          ),
  );
}
