import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/auth/session_manager.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_test/flutter_test.dart';

class _Store implements TokenStore {
  StoredTokens? value;
  bool failWrite = false;
  @override
  Future<StoredTokens?> read() async => value;
  @override
  Future<void> clear() async => value = null;
  @override
  Future<void> write(StoredTokens tokens) async {
    if (failWrite) throw StateError('storage failure');
    value = tokens;
  }
}

AuthSessionResponse _response() => AuthSessionResponse(
  (b) => b
    ..accessToken = 'access'
    ..refreshToken = 'refresh'
    ..user.update(
      (u) => u
        ..id = 'user-id'
        ..username = 'test'
        ..nickname = 'Test',
    )
    ..im.update(
      (im) => im
        ..uid = 'user-id'
        ..token = 'im-token'
        ..address = 'localhost:5100',
    ),
);

void main() {
  test(
    'raw API requests get auth but public and external requests do not',
    () async {
      final api = ChatApiClient(basePathOverride: 'http://localhost:3000');
      addTearDown(() => api.dio.close(force: true));
      final manager = SessionManager(api: api, tokenStore: _Store());
      await manager.saveSession(_response());
      api.dio.interceptors.add(
        RefreshTokenInterceptor(dio: api.dio, sessionManager: manager),
      );
      final headers = <String?>[];
      api.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            headers.add(request.headers['Authorization'] as String?);
            handler.resolve(Response(requestOptions: request, statusCode: 200));
          },
        ),
      );
      await api.dio.get<void>('/api/v1/conversations/settings');
      await api.dio.post<void>('/api/v1/auth/login');
      await api.dio.post<void>('/api/v1/auth/refresh');
      await api.dio.get<void>('https://files.example/api/v1/file');
      await api.dio.get<void>('http://localhost:9000/api/v1/file');
      expect(headers, ['Bearer access', null, null, null, null]);
    },
  );
  test(
    'token refresh persists credentials without reentering IM setup',
    () async {
      final api = ChatApiClient();
      addTearDown(() => api.dio.close(force: true));
      var prepared = 0;
      var requests = 0;
      api.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            expect(
              prepared,
              1,
              reason: 'suspend IM before rotating server token',
            );
            requests++;
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'accessToken': 'refreshed-access',
                  'refreshToken': 'refreshed-refresh',
                  'user': {
                    'id': 'user-id',
                    'username': 'test',
                    'nickname': 'Test',
                  },
                  'im': {
                    'uid': 'user-id',
                    'token': 'refreshed-im-token',
                    'address': 'localhost:5100',
                  },
                },
              ),
            );
          },
        ),
      );
      final store = _Store();
      var notifications = 0;
      final refreshed = <StoredTokens>[];
      final manager = SessionManager(
        api: api,
        tokenStore: store,
        onSessionChanged: (_) async {
          notifications++;
        },
        onCredentialsRefreshing: (tokens) {
          expect(tokens, same(store.value));
          prepared++;
        },
        onCredentialsRefreshed: (tokens) {
          expect(store.value, same(tokens));
          refreshed.add(tokens);
        },
      );
      await manager.saveSession(_response());
      expect(
        await Future.wait([manager.refreshOnce(), manager.refreshOnce()]),
        [true, true],
      );
      expect(requests, 1);
      expect(prepared, 1);
      expect(manager.accessToken, 'refreshed-access');
      expect(store.value?.refreshToken, 'refreshed-refresh');
      expect(notifications, 1);
      expect(refreshed.single.imToken, 'refreshed-im-token');
    },
  );
  for (final status in [200, 401]) {
    test(
      'empty/failed refresh ($status) clears session without resuming IM',
      () async {
        final api = ChatApiClient();
        addTearDown(() => api.dio.close(force: true));
        final events = <String>[];
        api.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              events.add('request');
              if (status == 200) {
                handler.resolve(
                  Response(requestOptions: request, statusCode: 200),
                );
                return;
              }
              handler.reject(
                DioException(
                  requestOptions: request,
                  type: DioExceptionType.badResponse,
                  response: Response(requestOptions: request, statusCode: 401),
                ),
              );
            },
          ),
        );
        final manager = SessionManager(
          api: api,
          tokenStore: _Store(),
          onCredentialsRefreshing: (_) => events.add('suspend'),
          onCredentialsRefreshed: (_) => events.add('resume'),
          onSessionChanged: (tokens) async {
            if (tokens == null) events.add('clear');
          },
        );
        await manager.saveSession(_response());
        expect(await manager.refreshOnce(), isFalse);
        expect(manager.hasSession, isFalse);
        expect(events, ['suspend', 'request', 'clear']);
      },
    );
  }
  test(
    'new login notifies IM only after credentials are stored and applied',
    () async {
      final api = ChatApiClient();
      addTearDown(() => api.dio.close(force: true));
      final store = _Store();
      final changes = <StoredTokens?>[];
      late SessionManager manager;
      manager = SessionManager(
        api: api,
        tokenStore: store,
        onSessionChanged: (tokens) async {
          expect(store.value, same(tokens));
          expect(manager.accessToken, tokens?.accessToken);
          changes.add(tokens);
        },
      );
      await manager.saveSession(_response());
      expect(changes.single?.imUid, 'user-id');
      expect(manager.hasSession, isTrue);
      await manager.clear();
      expect(changes, hasLength(2));
      expect(changes.last, isNull);
      expect(manager.hasSession, isFalse);
    },
  );

  test(
    'failed credential write does not start IM or mark user logged in',
    () async {
      final api = ChatApiClient();
      addTearDown(() => api.dio.close(force: true));
      var notifications = 0;
      final manager = SessionManager(
        api: api,
        tokenStore: _Store()..failWrite = true,
        onSessionChanged: (_) async {
          notifications++;
        },
      );
      await expectLater(manager.saveSession(_response()), throwsStateError);
      expect(notifications, 0);
      expect(manager.hasSession, isFalse);
    },
  );
}
