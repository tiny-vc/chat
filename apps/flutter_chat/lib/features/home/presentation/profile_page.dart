import 'dart:io';
import 'dart:typed_data';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';

import '../../../config/server_settings.dart';
import '../../../core/widgets/about_page.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/files/file_size.dart';
import '../../../core/files/image_send_preparation.dart';
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
    this.serverAddress,
    this.serverName,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
  });

  final HomeController controller;
  final FileTransferService fileTransferService;
  final CallService callService;
  final AuthRepository authRepository;
  final VoidCallback onDeactivated;
  final Future<void> Function() onLogout;
  final Future<void> Function(CallHistoryItem item)? onRedial;
  final bool allowAvatarUpload;
  final String? serverAddress;
  final String? serverName;
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode)? onThemeModeChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _working = false;
  double? _uploadProgress;
  String? _uploadStatus;
  Future<File?>? _avatar;
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
    final value = _user?.avatarFileId?.trim();
    final fileId = value == null || value.isEmpty ? null : value;
    if (fileId == _avatarFileId) return;
    _avatarFileId = fileId;
    _avatar = fileId == null
        ? Future<File?>.value(null)
        : widget.fileTransferService.downloadAvatar(fileId);
  }

  void _retryAvatar() {
    setState(() {
      _avatarFileId = null;
      _syncAvatar();
    });
  }

  Future<void> _pickAvatar() async {
    if (!_allowAvatarUpload) return;
    final file = await pickPortableAvatar();
    if (file == null || !mounted) return;
    late final Uint8List bytes;
    try {
      bytes = await readPlatformFileBytes(file);
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法读取头像大小，请重新选择');
      }
      return;
    }
    if (!mounted) return;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _AvatarPreview(
        bytes: bytes,
        name: file.name,
        size: bytes.length,
        optimized: canCompressChatImage(file),
      ),
    );
    if (confirmed != true || !mounted) return;
    final limit = ServerCapabilitiesScope.uploadLimitsOf(context).avatar;
    await _run(() async {
      setState(() {
        _uploadProgress = -1;
        _uploadStatus = '正在优化头像…';
      });
      final prepared = await prepareChatImage(
        file,
        compress: canCompressChatImage(file),
        sourceBytes: bytes,
      );
      final size = await prepared.file.length();
      if (size > limit) {
        throw StateError(
          '头像大小为 ${formatFileSize(size)}，服务器上限为 ${formatFileSize(limit)}',
        );
      }
      if (mounted) {
        setState(() {
          _uploadProgress = 0;
          _uploadStatus = '正在上传头像…';
        });
      }
      final uploaded = await widget.fileTransferService.uploadAvatar(
        file: prepared.file,
        onProgress: (sent, total) {
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
      );
      if (mounted) setState(() => _uploadStatus = '正在更新个人资料…');
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
        content: SingleChildScrollView(
          child: Form(
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
          _uploadStatus = null;
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

  Future<void> _selectThemeMode() async {
    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('外观模式'),
                subtitle: const Text('可随时切换，不影响聊天和通话'),
                trailing: IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ),
              RadioGroup<ThemeMode>(
                groupValue: widget.themeMode,
                onChanged: (value) => Navigator.pop(context, value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final mode in ThemeMode.values)
                      RadioListTile<ThemeMode>(
                        value: mode,
                        title: Text(_themeModeLabel(mode)),
                        secondary: Icon(switch (mode) {
                          ThemeMode.system => Icons.brightness_auto_outlined,
                          ThemeMode.light => Icons.light_mode_outlined,
                          ThemeMode.dark => Icons.dark_mode_outlined,
                        }),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null) await widget.onThemeModeChanged?.call(selected);
  }

  String _themeModeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => '跟随系统',
    ThemeMode.light => '浅色模式',
    ThemeMode.dark => '深色模式',
  };

  @override
  Widget build(BuildContext context) {
    final user = _user;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              _ProfileAvatar(
                                nickname: user?.nickname ?? '?',
                                avatar: _avatar,
                                onRetry: _retryAvatar,
                              ),
                              IconButton.filled(
                                tooltip: _allowAvatarUpload
                                    ? '更换头像'
                                    : '服务器未提供文件上传功能',
                                onPressed: _working || !_allowAvatarUpload
                                    ? null
                                    : _pickAvatar,
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.nickname ?? '加载中',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                if (user != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '@${user.username}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 2,
                                  children: [
                                    TextButton(
                                      onPressed: _working
                                          ? null
                                          : _editNickname,
                                      child: const Text('编辑昵称'),
                                    ),
                                    if (user?.avatarFileId != null)
                                      TextButton(
                                        onPressed: _working
                                            ? null
                                            : _removeAvatar,
                                        child: const Text('删除头像'),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_uploadProgress != null) ...[
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: _uploadProgress! < 0 ? null : _uploadProgress,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _uploadStatus ?? '正在处理…',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ] else if (_working) ...[
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          label: '正在保存更改',
                          child: const LinearProgressIndicator(),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '正在保存更改…',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                      if (!_allowAvatarUpload) ...[
                        const SizedBox(height: 10),
                        Text(
                          '当前服务器未开放头像上传',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _SettingsSection(
                  title: '账号',
                  children: [
                    _SettingsTile(
                      icon: Icons.badge_outlined,
                      title: '昵称与资料',
                      subtitle: '修改聊天中展示的名称',
                      onTap: _working ? null : _editNickname,
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: '修改密码',
                      subtitle: '定期更新密码可以提高账号安全性',
                      onTap: _working ? null : _changePassword,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _SettingsSection(
                  title: '聊天与通话',
                  children: [
                    _SettingsTile(
                      icon: Icons.history,
                      title: '通话记录',
                      subtitle: '查看语音和视频通话记录',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CallHistoryPage(
                            callService: widget.callService,
                            onRedial: widget.onRedial,
                          ),
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.block_outlined,
                      title: '黑名单',
                      subtitle: '管理已屏蔽的用户',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlockedUsersPage(
                            controller: widget.controller,
                            fileTransferService: widget.fileTransferService,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _SettingsSection(
                  title: '设置与安全',
                  children: [
                    _SettingsTile(
                      icon: Icons.contrast_outlined,
                      title: '外观模式',
                      subtitle: _themeModeLabel(widget.themeMode),
                      onTap: widget.onThemeModeChanged == null
                          ? null
                          : _selectThemeMode,
                    ),
                    _SettingsTile(
                      icon: Icons.security_outlined,
                      title: '安全与隐私',
                      subtitle: '登录设备、权限说明和账号注销',
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
                    _SettingsTile(
                      icon: Icons.storage_outlined,
                      title: '存储空间',
                      subtitle: '查看并清理本地文件缓存',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              StoragePage(files: widget.fileTransferService),
                        ),
                      ),
                    ),
                    if (widget.serverAddress != null)
                      _SettingsTile(
                        icon: Icons.dns_outlined,
                        title: widget.serverName?.trim().isNotEmpty == true
                            ? widget.serverName!.trim()
                            : '当前服务器',
                        subtitle: _serverLabel(widget.serverAddress!),
                        trailingLabel: '登录后不可切换',
                      ),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: '关于与使用说明',
                      subtitle: '版本、协议政策和使用帮助',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AboutPage(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    enabled: !_working,
                    onTap: _working ? null : _logout,
                    title: Text(
                      '退出登录',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '切换业务服务器需要先退出登录。IM、通话和文件服务地址由业务服务器统一下发。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _serverLabel(String address) {
    final uri = Uri.tryParse(address);
    return uri?.host.isNotEmpty == true ? uri!.origin : address;
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text(
          title,
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
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index + 1 < children.length)
                const Divider(height: 1, indent: 60),
            ],
          ],
        ),
      ),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailingLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        icon,
        size: 20,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    ),
    title: Text(title),
    subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
    trailing: onTap != null
        ? const Icon(Icons.chevron_right)
        : trailingLabel == null
        ? null
        : Text(
            trailingLabel!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
    onTap: onTap,
  );
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.nickname,
    required this.avatar,
    required this.onRetry,
  });

  final String nickname;
  final Future<File?>? avatar;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<File?>(
    future: avatar,
    builder: (context, snapshot) {
      final file = snapshot.data;
      return CircleAvatar(
        radius: 42,
        foregroundImage: file == null ? null : FileImage(file),
        child: snapshot.connectionState == ConnectionState.waiting
            ? const SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : snapshot.hasError
            ? IconButton(
                tooltip: '头像加载失败，点击重试',
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
              )
            : Text(
                nickname.trim().isEmpty
                    ? '?'
                    : nickname.trim().characters.first,
                style: const TextStyle(fontSize: 26),
              ),
      );
    },
  );
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.bytes,
    required this.name,
    required this.size,
    required this.optimized,
  });

  final Uint8List bytes;
  final String name;
  final int size;
  final bool optimized;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('预览头像', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          Center(
            child: CircleAvatar(
              radius: 72,
              backgroundImage: MemoryImage(bytes),
              onBackgroundImageError: (_, _) {},
            ),
          ),
          const SizedBox(height: 16),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            optimized
                ? '${formatFileSize(size)} · 将自动优化大小以加快上传'
                : '${formatFileSize(size)} · 将保留原图格式',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('重新选择'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('使用此头像'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
