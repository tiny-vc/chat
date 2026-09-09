import 'dart:typed_data';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../config/server_settings.dart';
import '../../../core/files/file_size.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/files/image_send_preparation.dart';
import '../../../core/widgets/app_avatar.dart';
import '../data/home_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';

class ContactManagementPage extends StatefulWidget {
  const ContactManagementPage({
    super.key,
    required this.controller,
    required this.fileTransferService,
  });

  final HomeController controller;
  final FileTransferService fileTransferService;

  @override
  State<ContactManagementPage> createState() => _ContactManagementPageState();
}

class _ContactManagementPageState extends State<ContactManagementPage> {
  final _searchController = TextEditingController();
  List<UserSummary> _results = const [];
  List<FriendRequestSummary> _requests = const [];
  bool _searching = false;
  bool _searchAttempted = false;
  bool _loadingRequests = true;
  Object? _requestError;
  String? _completedMessage;
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
    setState(() {
      _searching = true;
      _searchAttempted = true;
    });
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
    } on DioException catch (error) {
      if (!mounted) return;
      if (error.response?.statusCode != 409) {
        _showError('发送好友申请失败', error);
        return;
      }
      await widget.controller.load();
      if (!mounted) return;
      final isFriend =
          widget.controller.snapshot?.friends.any(
            (friend) => friend.user.id == user.id,
          ) ??
          false;
      setState(() {
        _results.removeWhere((item) => isFriend && item.id == user.id);
        if (!isFriend) _requestedUsers.add(user.id);
      });
      AppFeedback.show(
        context,
        isFriend ? '${user.nickname} 已经是你的好友' : '好友申请已发送，正在等待对方处理',
        kind: FeedbackKind.info,
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
      setState(() {
        _requests.removeWhere((item) => item.id == request.id);
        _completedMessage = accept
            ? '已添加 ${request.requester.nickname}，返回通讯录即可开始聊天。'
            : '已拒绝 ${request.requester.nickname} 的好友申请。';
      });
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
          Text(
            '输入对方的用户名或昵称',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              labelText: '搜索用户名或昵称',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: _searching ? '正在搜索' : '搜索',
                onPressed: _searching ? null : _search,
                icon: _searching
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
              ),
            ),
          ),
          if (_searchAttempted && !_searching && _results.isEmpty)
            const AppStatus(
              icon: Icons.person_search_outlined,
              title: '未找到新联系人',
              message: '请检查用户名或昵称；已成为好友的用户不会重复显示',
            ),
          if (_results.isNotEmpty) ...[
            const _Heading('搜索结果'),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var index = 0; index < _results.length; index++) ...[
                    ListTile(
                      leading: AppAvatar(
                        name: _results[index].nickname,
                        fileId: _results[index].avatarFileId,
                        resolveUrl: widget.fileTransferService.downloadUrl,
                        resolveFile: widget.fileTransferService.downloadAvatar,
                      ),
                      title: Text(_results[index].nickname),
                      subtitle: Text('@${_results[index].username}'),
                      trailing: _requestedUsers.contains(_results[index].id)
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 18),
                                SizedBox(width: 4),
                                Text('已申请'),
                              ],
                            )
                          : FilledButton.tonal(
                              onPressed:
                                  _pendingUsers.contains(_results[index].id)
                                  ? null
                                  : () => _requestFriend(_results[index]),
                              child: Text(
                                _pendingUsers.contains(_results[index].id)
                                    ? '发送中…'
                                    : '添加',
                              ),
                            ),
                    ),
                    if (index + 1 < _results.length)
                      const Divider(height: 1, indent: 72),
                  ],
                ],
              ),
            ),
          ],
          const _Heading('待处理的好友申请'),
          if (_completedMessage != null)
            Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(_completedMessage!),
                trailing: IconButton(
                  tooltip: '关闭提示',
                  onPressed: () => setState(() => _completedMessage = null),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
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
            const AppStatus(
              icon: Icons.mark_email_read_outlined,
              title: '暂无待处理申请',
              message: '新的好友申请会显示在这里',
            )
          else
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var index = 0; index < _requests.length; index++) ...[
                    _FriendRequestTile(
                      request: _requests[index],
                      fileTransferService: widget.fileTransferService,
                      busy: _pendingRequests.contains(_requests[index].id),
                      onReject: () => _respond(_requests[index], false),
                      onAccept: () => _respond(_requests[index], true),
                    ),
                    if (index + 1 < _requests.length)
                      const Divider(height: 1, indent: 72),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({
    super.key,
    required this.controller,
    required this.fileTransferService,
    this.allowAvatarUpload = true,
    this.pickAvatar,
  });

  final HomeController controller;
  final FileTransferService fileTransferService;
  final bool allowAvatarUpload;
  final Future<PlatformFile?> Function()? pickAvatar;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameController = TextEditingController();
  final _memberSearchController = TextEditingController();
  final Set<String> _selected = {};
  bool _submitting = false;
  bool _showValidation = false;
  PlatformFile? _avatar;
  Uint8List? _avatarBytes;
  double? _uploadProgress;

  bool get _canSubmit => !_submitting && _nameController.text.trim().isNotEmpty;

  bool get _allowAvatarUpload =>
      ServerCapabilitiesScope.maybeOf(context)?.files ??
      widget.allowAvatarUpload;

  @override
  void dispose() {
    _nameController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _showValidation = true);
      return;
    }
    final avatarLimit = _avatar == null
        ? null
        : ServerCapabilitiesScope.uploadLimitsOf(context).avatar;
    setState(() => _submitting = true);
    try {
      final group = await widget.controller.createGroup(name, _selected);
      Object? avatarError;
      if (_avatar != null && _avatarBytes != null) {
        try {
          final prepared = await prepareChatImage(
            _avatar!,
            compress: canCompressChatImage(_avatar!),
            sourceBytes: _avatarBytes,
          );
          final size = await prepared.file.length();
          if (size > avatarLimit!) {
            throw StateError(
              '群头像大小为 ${formatFileSize(size)}，服务器上限为 ${formatFileSize(avatarLimit)}',
            );
          }
          if (mounted) setState(() => _uploadProgress = 0);
          final uploaded = await widget.fileTransferService.uploadAvatar(
            file: prepared.file,
            onProgress: (sent, total) {
              if (mounted && total > 0) {
                setState(() => _uploadProgress = sent / total);
              }
            },
          );
          await widget.controller.setGroupAvatar(group.id, uploaded.fileId);
        } catch (error) {
          avatarError = error;
        }
      }
      if (mounted) {
        if (avatarError == null) {
          AppFeedback.show(
            context,
            _selected.isEmpty ? '群聊已创建，可稍后邀请成员' : '群聊已创建',
          );
        } else {
          AppFeedback.error(
            context,
            avatarError,
            fallback: '群聊已创建，但头像设置失败，可在群设置中重试',
          );
        }
        Navigator.pop(context, group);
      }
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '创建群聊失败，请稍后重试');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickAvatar() async {
    if (_submitting || !_allowAvatarUpload) return;
    final file = await (widget.pickAvatar?.call() ?? pickPortableAvatar());
    if (file == null || !mounted) return;
    try {
      final bytes = await readPlatformFileBytes(file);
      if (!mounted) return;
      final limit = ServerCapabilitiesScope.uploadLimitsOf(context).avatar;
      if (bytes.length > limit && !canCompressChatImage(file)) {
        AppFeedback.show(
          context,
          '群头像大小为 ${formatFileSize(bytes.length)}，服务器上限为 ${formatFileSize(limit)}',
          kind: FeedbackKind.error,
        );
        return;
      }
      setState(() {
        _avatar = file;
        _avatarBytes = bytes;
      });
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法读取图片，请重新选择');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final friends =
        widget.controller.snapshot?.friends ?? const <FriendResponse>[];
    final query = _memberSearchController.text.trim().toLowerCase();
    final visibleFriends = friends.where((friend) {
      if (query.isEmpty) return true;
      return friend.user.nickname.toLowerCase().contains(query) ||
          friend.user.username.toLowerCase().contains(query);
    }).toList();
    final selectedFriends = friends
        .where((friend) => _selected.contains(friend.user.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('创建群聊')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: _canSubmit ? _submit : null,
          icon: _submitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.group_add_outlined),
          label: Text(
            _submitting
                ? '正在创建…'
                : _selected.isEmpty
                ? '创建群聊'
                : '创建群聊（${_selected.length}）',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: _allowAvatarUpload ? _pickAvatar : null,
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                              image: _avatarBytes == null
                                  ? null
                                  : DecorationImage(
                                      image: MemoryImage(_avatarBytes!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: _avatarBytes == null
                                ? const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 26,
                                  )
                                : null,
                          ),
                        ),
                        if (_avatarBytes != null)
                          Positioned(
                            right: -10,
                            top: -10,
                            child: IconButton.filledTonal(
                              tooltip: '移除群头像',
                              onPressed: _submitting
                                  ? null
                                  : () => setState(() {
                                      _avatar = null;
                                      _avatarBytes = null;
                                    }),
                              icon: const Icon(Icons.close, size: 17),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        maxLength: 50,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: '群聊名称',
                          hintText: '例如：项目讨论组',
                          errorText:
                              _showValidation &&
                                  _nameController.text.trim().isEmpty
                              ? '请输入群聊名称'
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 86),
                  child: Text(
                    _allowAvatarUpload
                        ? (_avatarBytes == null ? '头像可选，点击左侧添加' : '点击头像可更换')
                        : '当前服务器未启用头像上传',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (_uploadProgress != null) ...[
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: _uploadProgress),
                ],
                const SizedBox(height: 14),
                TextField(
                  controller: _memberSearchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: '搜索昵称或用户名',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: '清空搜索',
                            onPressed: () {
                              _memberSearchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (selectedFriends.isNotEmpty)
            SizedBox(
              height: 76,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: selectedFriends.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final friend = selectedFriends[index];
                  return InputChip(
                    avatar: AppAvatar(
                      name: friend.user.nickname,
                      fileId: friend.user.avatarFileId,
                      size: 24,
                      resolveUrl: widget.fileTransferService.downloadUrl,
                      resolveFile: widget.fileTransferService.downloadAvatar,
                    ),
                    label: Text(friend.user.nickname),
                    onDeleted: _submitting
                        ? null
                        : () =>
                              setState(() => _selected.remove(friend.user.id)),
                  );
                },
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: friends.isEmpty
                ? const AppStatus(
                    title: '还没有可选择的好友',
                    message: '可以先创建群聊，再从群设置中邀请成员',
                    icon: Icons.people_outline,
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selected.isEmpty
                                    ? '选择群成员（可稍后邀请）'
                                    : '选择群成员 · 已选 ${_selected.length}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: visibleFriends.isEmpty || _submitting
                                  ? null
                                  : () => setState(() {
                                      final ids = visibleFriends
                                          .map((friend) => friend.user.id)
                                          .toSet();
                                      if (ids.every(_selected.contains)) {
                                        _selected.removeAll(ids);
                                      } else {
                                        _selected.addAll(ids);
                                      }
                                    }),
                              child: Text(
                                visibleFriends.isNotEmpty &&
                                        visibleFriends.every(
                                          (friend) => _selected.contains(
                                            friend.user.id,
                                          ),
                                        )
                                    ? '取消全选'
                                    : '全选',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (visibleFriends.isEmpty)
                        const AppStatus(
                          icon: Icons.person_search_outlined,
                          title: '没有匹配的好友',
                          message: '请尝试其他昵称或用户名',
                        ),
                      for (final friend in visibleFriends)
                        CheckboxListTile(
                          value: _selected.contains(friend.user.id),
                          secondary: AppAvatar(
                            name: friend.user.nickname,
                            fileId: friend.user.avatarFileId,
                            resolveUrl: widget.fileTransferService.downloadUrl,
                            resolveFile:
                                widget.fileTransferService.downloadAvatar,
                          ),
                          title: Text(friend.user.nickname),
                          subtitle: Text('@${friend.user.username}'),
                          enabled: !_submitting,
                          onChanged: (checked) => setState(() {
                            if (checked == true) {
                              _selected.add(friend.user.id);
                            } else {
                              _selected.remove(friend.user.id);
                            }
                            _showValidation = false;
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

class _FriendRequestTile extends StatelessWidget {
  const _FriendRequestTile({
    required this.request,
    required this.fileTransferService,
    required this.busy,
    required this.onReject,
    required this.onAccept,
  });

  final FriendRequestSummary request;
  final FileTransferService fileTransferService;
  final bool busy;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      children: [
        ListTile(
          leading: AppAvatar(
            name: request.requester.nickname,
            fileId: request.requester.avatarFileId,
            resolveUrl: fileTransferService.downloadUrl,
            resolveFile: fileTransferService.downloadAvatar,
          ),
          title: Text(request.requester.nickname),
          subtitle: Text('@${request.requester.username} 想添加你为好友'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 72, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: busy ? null : onReject,
                child: const Text('拒绝'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: busy ? null : onAccept,
                child: Text(busy ? '处理中…' : '接受'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
