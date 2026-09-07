import 'package:chat_api_client/chat_api_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../config/server_settings.dart';
import '../../../core/widgets/about_page.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/files/file_size.dart';
import '../../../core/calls/call_service.dart';
import '../../calls/presentation/call_history_page.dart';
import 'blocked_users_page.dart';
import 'security_privacy_page.dart';
import 'storage_page.dart';
import '../../auth/data/auth_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.controller,
    required this.fileTransferService,
    required this.callService,
    required this.authRepository,
    required this.onDeactivated,
    required this.onLogout,
    this.onRedial,
    this.allowAvatarUpload = true,
  });

  final HomeController controller;
  final FileTransferService fileTransferService;
  final CallService callService;
  final AuthRepository authRepository;
  final VoidCallback onDeactivated;
  final Future<void> Function() onLogout;
  final Future<void> Function(CallHistoryItem item)? onRedial;
  final bool allowAvatarUpload;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _working = false;
  double? _uploadProgress;
  Future<ResolvedUrl?>? _avatar;
  String? _avatarFileId;
  bool get _allowAvatarUpload =>
      ServerCapabilitiesScope.maybeOf(context)?.files ??
      widget.allowAvatarUpload;

  UserResponse? get _user => widget.controller.snapshot?.me;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerChanged);
    _syncAvatar();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerChanged);
    super.dispose();
  }

  void _controllerChanged() {
    if (!mounted) return;
    _syncAvatar();
    setState(() {});
  }

  void _syncAvatar() {
    final fileId = _user?.avatarFileId;
    if (fileId == _avatarFileId) return;
    _avatarFileId = fileId;
    _avatar = fileId == null
        ? Future<ResolvedUrl?>.value(null)
        : widget.fileTransferService.downloadUrl(fileId).then((url) => url);
  }

  Future<void> _pickAvatar() async {
    if (!_allowAvatarUpload) return;
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || !mounted) return;
    int size;
    try {
      size = await file.length();
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法读取头像大小，请重新选择');
      }
      return;
    }
    if (!mounted) return;
    final limit = ServerCapabilitiesScope.uploadLimitsOf(context).avatar;
    if (size > limit) {
      AppFeedback.show(
        context,
        '头像大小为 ${formatFileSize(size)}，服务器上限为 ${formatFileSize(limit)}',
        kind: FeedbackKind.error,
      );
      return;
    }
    await _run(() async {
      setState(() => _uploadProgress = 0);
      final uploaded = await widget.fileTransferService.uploadAvatar(
        file: file,
        onProgress: (sent, total) {
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
      );
      await widget.controller.setAvatar(uploaded.fileId);
    });
  }

  Future<void> _removeAvatar() async {
    if (!await _confirm('删除头像', '确定删除当前头像吗？')) return;
    await _run(widget.controller.removeAvatar);
  }

  Future<void> _editNickname() async {
    final input = TextEditingController(text: _user?.nickname ?? '');
    final nickname = await showAppFormDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改昵称'),
        content: TextField(
          controller: input,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(labelText: '昵称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, input.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    input.dispose();
    if (nickname == null || nickname.isEmpty || nickname == _user?.nickname) {
      return;
    }
    await _run(() => widget.controller.updateNickname(nickname));
  }

  Future<void> _changePassword() async {
    final current = TextEditingController();
    final next = TextEditingController();
    final confirmation = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final values = await showAppFormDialog<(String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改密码'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: current,
                obscureText: true,
                decoration: const InputDecoration(labelText: '当前密码'),
                validator: (value) =>
                    (value?.length ?? 0) < 8 ? '至少 8 位' : null,
              ),
              TextFormField(
                controller: next,
                obscureText: true,
                decoration: const InputDecoration(labelText: '新密码'),
                validator: (value) {
                  final password = value ?? '';
                  if (password.length < 10) return '至少 10 位';
                  if (!password.contains(RegExp('[A-Za-z]')) ||
                      !password.contains(RegExp('[0-9]'))) {
                    return '必须同时包含字母和数字';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmation,
                obscureText: true,
                decoration: const InputDecoration(labelText: '确认新密码'),
                validator: (value) => value != next.text ? '两次密码不一致' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.pop(context, (current.text, next.text));
              }
            },
            child: const Text('修改'),
          ),
        ],
      ),
    );
    current.dispose();
    next.dispose();
    confirmation.dispose();
    if (values == null) return;
    final success = await _run(
      () => widget.controller.changePassword(values.$1, values.$2),
    );
    if (mounted && success) _message('密码修改成功');
  }

  Future<bool> _run(Future<void> Function() operation) async {
    if (!mounted || _working) return false;
    setState(() => _working = true);
    try {
      await operation();
      return true;
    } catch (error) {
      if (mounted) AppFeedback.error(context, error);
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
          _uploadProgress = null;
        });
      }
    }
  }

  Future<bool> _confirm(String title, String content) async =>
      AppFeedback.confirm(
        context,
        title: title,
        message: content,
        confirmLabel: '确定',
        destructive: true,
      );

  void _message(String text) {
    AppFeedback.show(context, text, kind: FeedbackKind.success);
  }

  Future<void> _logout() async {
    if (!await _confirm('退出登录', '确定退出当前账号吗？')) return;
    await _run(widget.onLogout);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _ProfileAvatar(
                      nickname: user?.nickname ?? '?',
                      avatar: _avatar,
                    ),
                    IconButton.filled(
                      tooltip: _allowAvatarUpload ? '更换头像' : '服务器未提供文件上传功能',
                      onPressed: _working || !_allowAvatarUpload
                          ? null
                          : _pickAvatar,
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                  ],
                ),
                if (_uploadProgress != null) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: _uploadProgress),
                ],
                if (!_allowAvatarUpload) ...[
                  const SizedBox(height: 10),
                  Text(
                    '当前服务器未开放头像上传',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  user?.nickname ?? '加载中',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (user != null) Text('@${user.username}'),
                if (user?.avatarFileId != null)
                  TextButton(
                    onPressed: _working ? null : _removeAvatar,
                    child: const Text('删除头像'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('通话记录'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CallHistoryPage(
                callService: widget.callService,
                onRedial: widget.onRedial,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: const Text('修改昵称'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _working ? null : _editNickname,
        ),
        ListTile(
          leading: const Icon(Icons.block_outlined),
          title: const Text('黑名单'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BlockedUsersPage(controller: widget.controller),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('安全与隐私'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SecurityPrivacyPage(
                controller: widget.controller,
                authRepository: widget.authRepository,
                onDeactivated: widget.onDeactivated,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('修改密码'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _working ? null : _changePassword,
        ),
        ListTile(
          leading: const Icon(Icons.storage_outlined),
          title: const Text('存储空间'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => StoragePage(files: widget.fileTransferService),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('关于与使用说明'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const AboutPage())),
        ),
        OutlinedButton.icon(
          onPressed: _working ? null : _logout,
          icon: const Icon(Icons.logout),
          label: const Text('退出登录'),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.nickname, required this.avatar});

  final String nickname;
  final Future<ResolvedUrl?>? avatar;

  @override
  Widget build(BuildContext context) => FutureBuilder<ResolvedUrl?>(
    future: avatar,
    builder: (context, snapshot) {
      final resolved = snapshot.data;
      return CircleAvatar(
        radius: 52,
        foregroundImage: resolved == null
            ? null
            : NetworkImage(resolved.url.toString(), headers: resolved.headers),
        child: Text(
          nickname.trim().isEmpty ? '?' : nickname.trim().characters.first,
          style: const TextStyle(fontSize: 32),
        ),
      );
    },
  );
}
