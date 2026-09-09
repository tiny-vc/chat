import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/brand_header.dart';
import '../../../core/widgets/about_page.dart';
import 'auth_controller.dart';

enum ServerMetadataState { checking, available, unavailable }

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.controller,
    required this.onLoggedIn,
    this.onServerSettings,
    this.serverAddress,
    this.notice,
    this.registrationEnabled = true,
    this.serverName,
    this.serverMetadataState,
    this.onRetryServerInfo,
    super.key,
  });
  final AuthController controller;
  final VoidCallback onLoggedIn;
  final VoidCallback? onServerSettings;
  final String? serverAddress;
  final String? notice;
  final bool registrationEnabled;
  final String? serverName;
  final ServerMetadataState? serverMetadataState;
  final VoidCallback? onRetryServerInfo;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _nickname = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _registering = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    for (final controller in [_username, _nickname, _password, _confirmation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.controller.isLoading || !_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final success = _registering
        ? await widget.controller.register(
            _username.text,
            _nickname.text,
            _password.text,
          )
        : await widget.controller.login(_username.text, _password.text);
    if (success && mounted) {
      TextInput.finishAutofillContext();
      widget.onLoggedIn();
    }
  }

  void _switchMode() {
    if (widget.controller.isLoading) return;
    TextInput.finishAutofillContext(shouldSave: false);
    FocusManager.instance.primaryFocus?.unfocus();
    final username = _username.text;
    _formKey.currentState?.reset();
    _username.text = username;
    _password.clear();
    _confirmation.clear();
    widget.controller.clearError();
    setState(() {
      _registering = !_registering;
      _obscurePassword = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, _) {
                  final busy = widget.controller.isLoading;
                  return AutofillGroup(
                    key: ValueKey(_registering),
                    onDisposeAction: AutofillContextAction.cancel,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const BrandHeader(compact: true),
                          if (widget.notice case final notice?) ...[
                            const SizedBox(height: 20),
                            Material(
                              color: colors.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: colors.onErrorContainer,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(notice)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (widget.onServerSettings != null) ...[
                            const SizedBox(height: 16),
                            ListTile(
                              key: const ValueKey('server-settings-entry'),
                              contentPadding: EdgeInsets.zero,
                              onTap: busy ? null : widget.onServerSettings,
                              leading: Icon(
                                Icons.dns_outlined,
                                color: colors.primary,
                              ),
                              title: Text(widget.serverName ?? '当前业务服务器'),
                              subtitle:
                                  widget.serverMetadataState ==
                                      ServerMetadataState.unavailable
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '配置读取失败，仍可尝试登录',
                                          style: TextStyle(color: colors.error),
                                        ),
                                        Text(
                                          widget.serverAddress ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.serverAddress ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              trailing:
                                  widget.serverMetadataState ==
                                          ServerMetadataState.unavailable &&
                                      widget.onRetryServerInfo != null
                                  ? IconButton(
                                      tooltip: '重新读取服务器配置',
                                      onPressed: busy
                                          ? null
                                          : widget.onRetryServerInfo,
                                      icon: const Icon(Icons.refresh),
                                    )
                                  : widget.serverMetadataState ==
                                        ServerMetadataState.checking
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.chevron_right),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            _registering ? '创建账号' : '欢迎回来',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _registering ? '设置账号信息，开始与朋友联系' : '登录后，继续你的对话',
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _username,
                            enabled: !busy,
                            autocorrect: false,
                            enableSuggestions: false,
                            autofillHints: [
                              _registering
                                  ? AutofillHints.newUsername
                                  : AutofillHints.username,
                            ],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: '用户名',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              final name = value?.trim() ?? '';
                              if (name.runes.length < 3 ||
                                  name.runes.length > 40) {
                                return '用户名需为 3–40 个字符';
                              }
                              if (_registering &&
                                  !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(name)) {
                                return '仅支持字母、数字和下划线';
                              }
                              return null;
                            },
                          ),
                          if (_registering) ...[
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _nickname,
                              enabled: !busy,
                              autofillHints: const [AutofillHints.nickname],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: '昵称',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: (value) =>
                                  (value?.trim().isEmpty ?? true)
                                  ? '请输入昵称'
                                  : value!.trim().runes.length > 80
                                  ? '昵称最多 80 个字符'
                                  : null,
                            ),
                          ],
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _password,
                            enabled: !busy,
                            obscureText: _obscurePassword,
                            autocorrect: false,
                            enableSuggestions: false,
                            autofillHints: [
                              _registering
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            textInputAction: _registering
                                ? TextInputAction.next
                                : TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: '密码',
                              helperText: _registering ? '8–72 个字符' : null,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword ? '显示密码' : '隐藏密码',
                                onPressed: busy
                                    ? null
                                    : () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) =>
                                (value?.runes.length ?? 0) < 8 ||
                                    (value?.runes.length ?? 0) > 72
                                ? '密码需为 8–72 个字符'
                                : null,
                            onFieldSubmitted: _registering
                                ? null
                                : (_) => _submit(),
                          ),
                          if (_registering) ...[
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _confirmation,
                              enabled: !busy,
                              obscureText: _obscurePassword,
                              autocorrect: false,
                              enableSuggestions: false,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: '确认密码',
                                prefixIcon: Icon(Icons.lock_outline),
                              ),
                              validator: (value) =>
                                  value != _password.text ? '两次密码不一致' : null,
                              onFieldSubmitted: (_) => _submit(),
                            ),
                          ],
                          if (widget.controller.errorMessage
                              case final message?) ...[
                            const SizedBox(height: 16),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                message,
                                style: TextStyle(color: colors.error),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: busy ? null : _submit,
                            child: busy
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(_registering ? '注册并登录' : '登 录'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed:
                                busy ||
                                    (!widget.registrationEnabled &&
                                        !_registering)
                                ? null
                                : _switchMode,
                            child: Text(
                              _registering
                                  ? '已有账号？返回登录'
                                  : widget.registrationEnabled
                                  ? '没有账号？立即注册'
                                  : '服务器暂未开放注册',
                            ),
                          ),
                          TextButton(
                            onPressed: busy
                                ? null
                                : () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const AboutPage(),
                                    ),
                                  ),
                            child: const Text('关于与使用说明'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
