import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'config/server_settings.dart';
import 'features/auth/presentation/server_settings_page.dart';
import 'package:wukongimfluttersdk/db/wk_db_helper.dart';
import 'config/app_identity.dart';
import 'core/widgets/brand_header.dart';
import 'core/auth/session_manager.dart';
import 'core/auth/token_store.dart';
import 'core/calls/call_service.dart';
import 'core/files/file_transfer_service.dart';
import 'core/im/im_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/home/data/home_repository.dart';
import 'features/home/presentation/home_controller.dart';
import 'features/home/presentation/home_page.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_feedback.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({
    super.key,
    this.tokenStore,
    this.serverStore,
    this.installationIdStore,
  });

  final TokenStore? tokenStore;
  final ServerSettingsStore? serverStore;
  final InstallationIdStore? installationIdStore;

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  late final _serverStore = widget.serverStore ?? ServerSettingsStore();
  String? _address;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (widget.tokenStore != null && widget.serverStore == null) {
      _address = AppConfig.resolvedApiBaseUrl;
    } else {
      _loadServer();
    }
  }

  Future<void> _loadServer() async {
    try {
      final saved = await _serverStore.read();
      final address = normalizeServerAddress(
        saved ?? AppConfig.resolvedApiBaseUrl,
      );
      if (mounted) {
        setState(() {
          _address = address;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  Future<void> _switchServer(String address) async {
    if (!mounted || address == _address) return;
    setState(() => _address = null);
    // Dispose the old SDK listeners/Dio before mounting a new session tree.
    try {
      await WidgetsBinding.instance.endOfFrame;
      await WKDBHelper.shared.close();
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      if (mounted) setState(() => _address = address);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = _address;
    if (address == null) {
      return MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: Scaffold(
          body: _error == null
              ? const AppLoading(message: '正在读取服务器设置…')
              : AppStatus(
                  title: '无法读取服务器设置',
                  message: '为避免连接错误的服务器，请重试。',
                  onRetry: _loadServer,
                ),
        ),
      );
    }
    return _ServerSessionApp(
      key: ValueKey(address),
      address: address,
      tokenStore: widget.tokenStore,
      serverStore: _serverStore,
      onServerChanged: _switchServer,
      installationIdStore: widget.installationIdStore,
    );
  }
}

class _ServerSessionApp extends StatefulWidget {
  const _ServerSessionApp({
    super.key,
    required this.address,
    required this.serverStore,
    required this.onServerChanged,
    this.tokenStore,
    this.installationIdStore,
  });
  final String address;
  final TokenStore? tokenStore;
  final InstallationIdStore? installationIdStore;
  final ServerSettingsStore serverStore;
  final Future<void> Function(String) onServerChanged;
  @override
  State<_ServerSessionApp> createState() => _ServerSessionAppState();
}

class _ServerSessionAppState extends State<_ServerSessionApp> {
  late final ChatApiClient _api;
  late final SessionManager _session;
  late final ImService _imService;
  late final FileTransferService _fileTransferService;
  late final CallService _callService;
  late final AuthRepository _repository;
  late final AuthController _authController;
  late final HomeController _homeController;
  late Future<bool> _restoreSession;
  // Once the user logs in/out, that choice overrides the startup snapshot.
  bool? _loggedIn;

  @override
  void initState() {
    super.initState();
    _api = ChatApiClient(basePathOverride: widget.address);
    _api.dio.options.followRedirects = false;
    _api.dio.options.connectTimeout = const Duration(seconds: 15);
    _api.dio.options.receiveTimeout = const Duration(seconds: 20);
    _api.dio.options.sendTimeout = const Duration(seconds: 20);
    _imService = ImService(
      _api.dio,
      installationIdStore: widget.installationIdStore,
    );
    _fileTransferService = FileTransferService(_api);
    _callService = CallService(_api);
    _session = SessionManager(
      api: _api,
      tokenStore:
          widget.tokenStore ??
          SecureTokenStore(namespace: serverNamespace(widget.address)),
      onSessionChanged: _imService.updateSession,
      onCredentialsRefreshing: _imService.prepareCredentialsRefresh,
      onCredentialsRefreshed: _imService.updateCredentials,
    );
    _api.dio.interceptors.add(
      RefreshTokenInterceptor(dio: _api.dio, sessionManager: _session),
    );
    _repository = AuthRepository(
      api: _api,
      session: _session,
      installationIdStore: InstallationIdStore(),
    );
    _authController = AuthController(repository: _repository);
    _homeController = HomeController(HomeRepository(_api));
    _restoreSession = _session.restore();
  }

  @override
  void dispose() {
    _authController.dispose();
    _homeController.dispose();
    _imService.dispose();
    _fileTransferService.dispose();
    _api.dio.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppIdentity.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: FutureBuilder<bool>(
        future: _restoreSession,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: AppStatus(
                title: '无法恢复登录状态',
                message: '读取本机登录信息失败，请重试。若持续失败，请重新启动 App。',
                icon: Icons.lock_outline,
                onRetry: () {
                  final restore = _session.restore();
                  setState(() {
                    _restoreSession = restore;
                  });
                },
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BrandHeader(),
                        SizedBox(height: 32),
                        SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(height: 12),
                        Text('正在恢复登录状态…'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if (_loggedIn ?? snapshot.data!) {
            return HomePage(
              controller: _homeController,
              imService: _imService,
              fileTransferService: _fileTransferService,
              callService: _callService,
              authRepository: _repository,
              onLoggedOut: () => setState(() => _loggedIn = false),
            );
          }
          return LoginPage(
            controller: _authController,
            onLoggedIn: () => setState(() => _loggedIn = true),
            serverAddress: widget.address,
            onServerSettings: () async {
              if (_session.hasSession || _authController.isLoading) return;
              final address = await Navigator.of(context).push<String>(
                MaterialPageRoute(
                  builder: (_) => ServerSettingsPage(
                    currentAddress: widget.address,
                    save: (address) async {
                      if (_session.hasSession) {
                        throw StateError('Log out before switching servers');
                      }
                      await widget.serverStore.save(address);
                    },
                  ),
                ),
              );
              if (address != null && mounted) {
                await widget.onServerChanged(address);
              }
            },
          );
        },
      ),
    );
  }
}
