import 'package:flutter/material.dart';

import '../../auth/data/auth_repository.dart';
import '../data/home_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';

class SecurityPrivacyPage extends StatefulWidget {
  const SecurityPrivacyPage({
    super.key,
    required this.controller,
    required this.authRepository,
    required this.onDeactivated,
  });

  final HomeController controller;
  final AuthRepository authRepository;
  final VoidCallback onDeactivated;

  @override
  State<SecurityPrivacyPage> createState() => _SecurityPrivacyPageState();
}

class _SecurityPrivacyPageState extends State<SecurityPrivacyPage> {
  List<DeviceSummary> _devices = const [];
  bool _loading = true;
  bool _deactivating = false;
  Object? _loadError;
  final Set<String> _revoking = {};

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final devices = await widget.controller.devices();
      if (mounted) setState(() => _devices = devices);
    } catch (error) {
      if (mounted) setState(() => _loadError = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _revoke(DeviceSummary device) async {
    if (_revoking.contains(device.id) || _deactivating) return;
    setState(() => _revoking.add(device.id));
    try {
      final confirmed = await AppFeedback.confirm(
        context,
        title: '下线设备',
        message: '确定让“${device.name}”下线吗？该设备需要重新登录。',
        confirmLabel: '下线',
        destructive: true,
      );
      if (!confirmed || !mounted) return;
      await widget.controller.revokeDevice(device.id);
      if (!mounted) return;
      AppFeedback.show(context, '设备已下线', kind: FeedbackKind.success);
      await _loadDevices();
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '设备下线失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _revoking.remove(device.id));
    }
  }

  Future<void> _deactivate() async {
    if (_deactivating || _revoking.isNotEmpty) return;
    setState(() => _deactivating = true);
    final password = TextEditingController();
    final formKey = GlobalKey<FormState>();
    try {
      final value = await showAppFormDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('注销账号'),
          scrollable: true,
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('账号注销后将无法登录，所有设备会话都会失效。此操作不可恢复。'),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  validator: (value) =>
                      (value?.length ?? 0) < 8 ? '请输入至少 8 位的当前密码' : null,
                  decoration: const InputDecoration(labelText: '输入当前密码确认'),
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
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  Navigator.pop(context, password.text);
                }
              },
              child: const Text('确认注销'),
            ),
          ],
        ),
      );
      if (value == null || !mounted) return;
      await widget.authRepository.deactivateAccount(value);
      if (mounted) widget.onDeactivated();
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '注销失败，请确认密码后重试');
      }
    } finally {
      password.dispose();
      if (mounted) setState(() => _deactivating = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('安全与隐私')),
    body: ListView(
      children: [
        const ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('隐私说明'),
          subtitle: Text('聊天内容用于消息同步；文件存储于私有对象存储，不向第三方出售个人信息。'),
        ),
        const ListTile(
          leading: Icon(Icons.mic_none),
          title: Text('麦克风权限'),
          subtitle: Text('仅在录制语音消息或语音/视频通话时使用。'),
        ),
        const ListTile(
          leading: Icon(Icons.camera_alt_outlined),
          title: Text('相机权限'),
          subtitle: Text('仅在视频通话时使用。'),
        ),
        const ListTile(
          leading: Icon(Icons.folder_outlined),
          title: Text('文件与照片'),
          subtitle: Text('仅在你主动选择图片、视频或文件时访问。'),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('登录设备', style: Theme.of(context).textTheme.titleMedium),
        ),
        if (_loading)
          const AppLoading(message: '正在加载登录设备…')
        else if (_loadError != null)
          AppStatus(
            title: '设备列表加载失败',
            message: '请检查网络后重试',
            icon: Icons.cloud_off_outlined,
            onRetry: _loadDevices,
          )
        else if (_devices.isEmpty)
          const AppStatus(
            title: '暂无登录设备',
            message: '设备登录后会显示在这里',
            icon: Icons.devices_outlined,
          )
        else
          for (final device in _devices)
            ListTile(
              leading: Icon(
                device.type == 'WEB' ? Icons.language : Icons.smartphone,
              ),
              title: Text('${device.name}${device.current ? '（当前）' : ''}'),
              subtitle: Text(device.ipAddress ?? '未知 IP'),
              trailing: device.current
                  ? null
                  : TextButton(
                      onPressed: _deactivating || _revoking.contains(device.id)
                          ? null
                          : () => _revoke(device),
                      child: Text(
                        _revoking.contains(device.id) ? '处理中…' : '下线',
                      ),
                    ),
            ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: _deactivating || _revoking.isNotEmpty
                ? null
                : _deactivate,
            icon: const Icon(Icons.delete_forever),
            label: Text(_deactivating ? '处理中…' : '注销账号'),
          ),
        ),
      ],
    ),
  );
}
