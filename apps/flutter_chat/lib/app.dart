import 'dart:async';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'config/app_config.dart';
import 'config/server_settings.dart';
import 'config/runtime_capability_interceptor.dart';
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
import 'core/theme/theme_mode_store.dart';
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
  late final _themeModeStore = ThemeModeStore();
  ThemeMode _themeMode = ThemeMode.system;
  String? _address;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    if (widget.tokenStore != null && widget.serverStore == null) {
      _address = AppConfig.resolvedApiBaseUrl;
    } else {
      _loadServer();
    }
  }

  Future<void> _loadThemeMode() async {
    try {
      final mode = await _themeModeStore.read();
      if (mounted) setState(() => _themeMode = mode);
    } catch (_) {
      // Appearance preferences must never block startup.
    }
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    setState(() => _themeMode = mode);
    try {
      await _themeModeStore.write(mode);
    } catch (_) {
      // Keep the selected in-memory theme even if local persistence fails.
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
        themeMode: _themeMode,
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
      themeMode: _themeMode,
      onThemeModeChanged: _setThemeMode,
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
    required this.themeMode,
    required this.onThemeModeChanged,
  });
  final String address;
  final TokenStore? tokenStore;
  final InstallationIdStore? installationIdStore;
  final ServerSettingsStore serverStore;
  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode) onThemeModeChanged;
  final Future<void> Function(String) onServerChanged;
  @override
  State<_ServerSessionApp> createState() => _ServerSessionAppState();
}

class _ServerSessionAppState extends State<_ServerSessionApp>
    with WidgetsBindingObserver {
  late final ChatApiClient _api;
  late final SessionManager _session;
  late final ImService _imService;
  late final FileTransferService _fileTransferService;
  late final CallService _callService;
  late final AuthRepository _repository;
  late final AuthController _authController;
  late final HomeController _homeController;
  late final ServerProbe _serverProbe;
  late Future<bool> _restoreSession;
  // Once the user logs in/out, that choice overrides the startup snapshot.
  bool? _loggedIn;
  bool _handlingDeviceKick = false;
  String? _loginNotice;
  ServerInfo? _serverInfo;
  bool _serverInfoLoading = false;
  bool _serverInfoFailed = false;
  DateTime? _serverInfoLastAttempt;
  Timer? _pausedCapabilityRefreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _api = ChatApiClient(basePathOverride: widget.address);
    _serverProbe = ServerProbe();
    _api.dio.options.followRedirects = false;
    _api.dio.options.connectTimeout = const Duration(seconds: 15);
    _api.dio.options.receiveTimeout = const Duration(seconds: 20);
    _api.dio.options.sendTimeout = const Duration(seconds: 20);
    _imService = ImService(
      _api.dio,
      installationIdStore: widget.installationIdStore,
      networkChanges: Connectivity().onConnectivityChanged,
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
    _api.dio.interceptors.add(
      RuntimeCapabilityInterceptor(onCapabilitiesChanged: _loadServerInfo),
    );
    _repository = AuthRepository(
      api: _api,
      session: _session,
      installationIdStore: InstallationIdStore(),
    );
    _authController = AuthController(repository: _repository);
    _homeController = HomeController(HomeRepository(_api));
    _imService.addListener(_handleImState);
    _restoreSession = _session.restore();
    _restoreSession.then((_) {
      if (mounted) unawaited(_restoreServerInfo());
    }, onError: (_) {});
  }

  Future<void> _restoreServerInfo() async {
    try {
      final cached = await widget.serverStore.readInfo(widget.address);
      if (mounted && cached != null) setState(() => _serverInfo = cached);
    } catch (_) {
      // A cache failure must not block login or the network refresh.
    }
    if (mounted) await _loadServerInfo();
  }

  Future<void> _loadServerInfo() async {
    if (!mounted || _serverInfoLoading) return;
    _serverInfoLastAttempt = DateTime.now();
    setState(() {
      _serverInfoLoading = true;
      _serverInfoFailed = false;
    });
    try {
      final info = await _serverProbe.check(widget.address);
      final messagingWasPaused = _serverInfo?.capabilities.messaging == false;
      if (mounted) {
        setState(() {
          _serverInfo = info;
          _serverInfoFailed = false;
        });
      }
      try {
        await widget.serverStore.saveInfo(info);
      } catch (_) {
        // The verified in-memory value remains usable if persistence fails.
      }
      if (info.capabilities.messaging) {
        _pausedCapabilityRefreshTimer?.cancel();
        _pausedCapabilityRefreshTimer = null;
      } else {
        _schedulePausedCapabilityRefresh();
      }
      if (messagingWasPaused &&
          info.capabilities.messaging &&
          _session.hasSession) {
        if (await _session.refreshOnce()) {
          await _session.reapplySession();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _serverInfoFailed = true);
    } finally {
      if (mounted) setState(() => _serverInfoLoading = false);
    }
  }

  void _schedulePausedCapabilityRefresh() {
    if (_pausedCapabilityRefreshTimer != null) return;
    _pausedCapabilityRefreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (mounted && !_serverInfoLoading) unawaited(_loadServerInfo());
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        shouldRefreshServerInfo(
          now: DateTime.now(),
          lastAttempt: _serverInfoLastAttempt,
        )) {
      unawaited(_loadServerInfo());
    }
  }

  void _handleImState() {
    if (_imService.connectionState != ImConnectionState.kicked ||
        _handlingDeviceKick) {
      return;
    }
    _handlingDeviceKick = true;
    unawaited(_resolveImKick());
  }

  Future<void> _resolveImKick() async {
    try {
      final info = await _serverProbe.check(widget.address);
      if (!info.capabilities.messaging) {
        if (!mounted) return;
        setState(() {
          _serverInfo = info;
          _serverInfoFailed = false;
          _serverInfoLastAttempt = DateTime.now();
          _handlingDeviceKick = false;
        });
        try {
          await widget.serverStore.saveInfo(info);
        } catch (_) {
          // The verified in-memory pause state is enough to retain the session.
        }
        _schedulePausedCapabilityRefresh();
        return;
      }
    } catch (_) {
      // Fail closed: an unverifiable kick still revokes the local session.
    }
    await _clearKickedSession();
  }

  Future<void> _clearKickedSession() async {
    try {
      await _repository.logout();
    } catch (_) {
      // AuthRepository always clears the local session in finally.
    }
    if (!mounted) return;
    _homeController.reset();
    setState(() {
      _loginNotice = '当前设备已被下线，请重新登录。';
      _loggedIn = false;
      _handlingDeviceKick = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _imService.removeListener(_handleImState);
    _authController.dispose();
    _homeController.dispose();
    _imService.dispose();
    _fileTransferService.dispose();
    _serverProbe.dispose();
    _pausedCapabilityRefreshTimer?.cancel();
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
      themeMode: widget.themeMode,
      builder: (context, child) => ServerCapabilitiesScope(
        capabilities: _serverInfo?.capabilities ?? ServerCapabilities.all,
        uploadLimits: _serverInfo?.uploadLimits ?? UploadLimits.defaults,
        child: child!,
      ),
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
              onLoggedOut: () {
                _homeController.reset();
                setState(() => _loggedIn = false);
              },
              capabilities: _serverInfo?.capabilities ?? ServerCapabilities.all,
              serverAddress: widget.address,
              serverName: _serverInfo?.name,
              themeMode: widget.themeMode,
              onThemeModeChanged: widget.onThemeModeChanged,
            );
          }
          return LoginPage(
            controller: _authController,
            notice: _loginNotice,
            onLoggedIn: () {
              _homeController.reset();
              setState(() {
                _loginNotice = null;
                _loggedIn = true;
              });
            },
            serverAddress: widget.address,
            serverName: _serverInfo?.name,
            serverMetadataState: _serverInfoLoading
                ? ServerMetadataState.checking
                : _serverInfo != null
                ? ServerMetadataState.available
                : _serverInfoFailed
                ? ServerMetadataState.unavailable
                : null,
            onRetryServerInfo: () => unawaited(_loadServerInfo()),
            registrationEnabled: _serverInfo?.registrationEnabled ?? true,
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
