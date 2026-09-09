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
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionTitle('数据与权限'),
        const Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _InfoTile(
                icon: Icons.privacy_tip_outlined,
                title: '隐私说明',
                subtitle: '账号、消息和文件由当前连接的业务服务器处理，具体规则请查看隐私政策。',
              ),
              Divider(height: 1, indent: 56),
              _InfoTile(
                icon: Icons.mic_none,
                title: '麦克风',
                subtitle: '仅在语音消息或通话时请求使用。',
              ),
              Divider(height: 1, indent: 56),
              _InfoTile(
                icon: Icons.camera_alt_outlined,
                title: '相机',
                subtitle: '仅在视频通话时请求使用。',
              ),
              Divider(height: 1, indent: 56),
              _InfoTile(
                icon: Icons.photo_library_outlined,
                title: '照片与文件',
                subtitle: '仅在你主动选择内容时访问。',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('登录设备'),
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
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var index = 0; index < _devices.length; index++) ...[
                  _DeviceTile(
                    device: _devices[index],
                    busy:
                        _deactivating || _revoking.contains(_devices[index].id),
                    onRevoke: () => _revoke(_devices[index]),
                  ),
                  if (index + 1 < _devices.length)
                    const Divider(height: 1, indent: 56),
                ],
              ],
            ),
          ),
        const SizedBox(height: 24),
        const _SectionTitle('账号管理'),
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            key: const ValueKey('deactivate-account'),
            enabled: !_deactivating && _revoking.isEmpty,
            onTap: _deactivating || _revoking.isNotEmpty ? null : _deactivate,
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              _deactivating ? '处理中…' : '注销账号',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: const Text('永久停用账号并使所有设备退出'),
            trailing: Icon(
              _deactivating ? Icons.hourglass_top_rounded : Icons.chevron_right,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.busy,
    required this.onRevoke,
  });
  final DeviceSummary device;
  final bool busy;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(device.type == 'WEB' ? Icons.language : Icons.smartphone),
    title: Text(device.name),
    subtitle: Text(
      device.current
          ? '当前设备 · ${device.ipAddress ?? "未知 IP"}'
          : device.ipAddress ?? '未知 IP',
    ),
    trailing: device.current
        ? Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            semanticLabel: '当前设备',
          )
        : TextButton(
            onPressed: busy ? null : onRevoke,
            child: Text(busy ? '处理中…' : '下线'),
          ),
  );
}
