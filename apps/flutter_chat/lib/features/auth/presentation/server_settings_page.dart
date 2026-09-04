import 'package:flutter/material.dart';
import '../../../config/server_settings.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({
    super.key,
    required this.currentAddress,
    required this.save,
    this.probe,
  });
  final String currentAddress;
  final Future<void> Function(String) save;
  final ServerProbe? probe;
  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  late final _address = TextEditingController(text: widget.currentAddress);
  late final _probe = widget.probe ?? ServerProbe();
  ServerInfo? _info;
  String? _error;
  bool _busy = false;
  @override
  void dispose() {
    _address.dispose();
    if (widget.probe == null) _probe.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _busy = true;
      _info = null;
      _error = null;
    });
    try {
      final info = await _probe.check(_address.text);
      if (mounted) setState(() => _info = info);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is FormatException
              ? error.message.toString()
              : '连接检测失败，请检查地址、证书及网络。不会跳过证书校验或跟随跳转。',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final info = _info;
    if (_busy || info == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('使用此服务器？'),
        content: SingleChildScrollView(
          child: Text(
            '${info.name}\n${info.address}\n\n登录凭据将发送到此地址，请只使用你信任的服务器。不同服务器的账号和聊天数据相互独立。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认保存'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.save(info.address);
      if (mounted) Navigator.pop(context, info.address);
    } catch (_) {
      if (mounted) setState(() => _error = '保存失败，原服务器未切换，请重试。');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: AppBar(title: const Text('服务器设置')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('只需填写业务服务器地址，聊天、通话和文件地址由服务器提供。'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _address,
                    enabled: !_busy,
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      labelText: '服务器地址',
                      hintText: 'https://chat.example.com',
                    ),
                    onChanged: (_) => setState(() {
                      _info = null;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '本机调试可用 HTTP；真机请填写电脑的局域网 IP，不能使用 localhost。检测成功不代表服务器可信。',
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _busy ? null : _check,
                    child: const Text('检测连接'),
                  ),
                  if (_busy)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_info case final info?)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        '检测成功：${info.name}\n协议版本：1\n注册：${info.registrationEnabled ? "开放" : "关闭"}',
                      ),
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  FilledButton(
                    onPressed: !_busy && _info != null ? _save : null,
                    child: const Text('保存并使用'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
