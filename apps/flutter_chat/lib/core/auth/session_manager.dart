import 'dart:async';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';

import 'token_store.dart';

class SessionManager {
  SessionManager({
    required this.api,
    required TokenStore tokenStore,
    this.onSessionChanged,
    this.onCredentialsRefreshing,
    this.onCredentialsRefreshed,
  }) : _tokenStore = tokenStore;

  static const bearerName = 'access-token';
  static const skipRefreshKey = 'skipAuthRefresh';

  final ChatApiClient api;
  final TokenStore _tokenStore;
  final Future<void> Function(StoredTokens? session)? onSessionChanged;
  final void Function(StoredTokens session)? onCredentialsRefreshing;
  final void Function(StoredTokens session)? onCredentialsRefreshed;
  StoredTokens? _tokens;
  Future<bool>? _refreshing;

  bool get hasSession => _tokens != null;
  String? get accessToken => _tokens?.accessToken;

  Future<bool> restore() async {
    _tokens = await _tokenStore.read();
    _applyAccessToken();
    await onSessionChanged?.call(_tokens);
    return hasSession;
  }

  Future<void> saveSession(AuthSessionResponse session) async {
    await _persistSession(session);
    await onSessionChanged?.call(_tokens);
  }

  Future<void> _persistSession(AuthSessionResponse session) async {
    final tokens = StoredTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      imUid: session.im.uid,
      imToken: session.im.token,
      imAddress: session.im.address,
    );
    await _tokenStore.write(tokens);
    _tokens = tokens;
    _applyAccessToken();
  }

  Future<void> clear() async {
    _tokens = null;
    api.removeBearerAuth(bearerName);
    await _tokenStore.clear();
    await onSessionChanged?.call(null);
  }

  Future<bool> refreshOnce() => _refreshing ??= _refresh().whenComplete(() {
    _refreshing = null;
  });

  Future<bool> _refresh() async {
    final current = _tokens;
    if (current == null) return false;
    try {
      // Token rotation may kick the old IM socket. Suspend it before the HTTP
      // request, without reentering HTTP/database setup from this interceptor.
      onCredentialsRefreshing?.call(current);
      final response = await api.getAuthApi().authRefresh(
        refreshTokenDto: RefreshTokenDto(
          (builder) => builder.refreshToken = current.refreshToken,
        ),
        extra: const {skipRefreshKey: true},
      );
      final session = response.data;
      if (session == null) {
        await clear();
        return false;
      }
      // Refresh already runs inside the HTTP interceptor. Reinitializing IM
      // here could issue requests that wait for this same refresh to finish.
      await _persistSession(session);
      onCredentialsRefreshed?.call(_tokens!);
      return true;
    } on DioException {
      await clear();
      return false;
    }
  }

  void _applyAccessToken() {
    final accessToken = _tokens?.accessToken;
    if (accessToken == null) {
      api.removeBearerAuth(bearerName);
    } else {
      api.setBearerAuth(bearerName, accessToken);
    }
  }
}

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({required this.dio, required this.sessionManager});

  final Dio dio;
  final SessionManager sessionManager;

  bool _isProtectedApiRequest(RequestOptions request) {
    final base = Uri.parse(dio.options.baseUrl);
    final uri = request.uri;
    return uri.origin == base.origin &&
        uri.path.startsWith('/api/v1/') &&
        !const {
          '/api/v1/auth/login',
          '/api/v1/auth/register',
          '/api/v1/auth/refresh',
        }.contains(uri.path);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Raw Dio endpoints lack the generated client's security metadata.
    // Apply auth to our API only, never to external upload/download URLs.
    final token = sessionManager.accessToken;
    if (token != null && _isProtectedApiRequest(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == 401 &&
        _isProtectedApiRequest(request) &&
        request.extra[SessionManager.skipRefreshKey] != true &&
        request.extra['retriedAfterRefresh'] != true;
    if (!shouldRefresh || !await sessionManager.refreshOnce()) {
      handler.next(err);
      return;
    }

    request.extra['retriedAfterRefresh'] = true;
    request.headers['Authorization'] = 'Bearer ${sessionManager.accessToken}';
    try {
      handler.resolve(await dio.fetch<Object?>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
