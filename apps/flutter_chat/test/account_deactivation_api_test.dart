import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/auth/session_manager.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _Store implements TokenStore {
  StoredTokens? value;

  @override
  Future<StoredTokens?> read() async => value;

  @override
  Future<void> write(StoredTokens tokens) async => value = tokens;

  @override
  Future<void> clear() async => value = null;
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.success);

  final bool success;
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode({'success': success}),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

AuthSessionResponse _sessionResponse() => AuthSessionResponse(
  (builder) => builder
    ..accessToken = 'access'
    ..refreshToken = 'refresh'
    ..user.update(
      (user) => user
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
  for (final success in [true, false]) {
    test(
      'account deactivation clears session only when confirmed: $success',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://chat.example'));
        final adapter = _Adapter(success);
        dio.httpClientAdapter = adapter;
        final api = ChatApiClient(dio: dio, interceptors: const []);
        final store = _Store();
        final session = SessionManager(api: api, tokenStore: store);
        await session.saveSession(_sessionResponse());
        final repository = AuthRepository(
          api: api,
          session: session,
          installationIdStore: InstallationIdStore(),
        );

        if (success) {
          await repository.deactivateAccount('secret');
        } else {
          await expectLater(
            repository.deactivateAccount('secret'),
            throwsStateError,
          );
        }

        expect(adapter.request?.method, 'DELETE');
        expect(adapter.request?.path, '/api/v1/auth/account');
        expect(adapter.request?.data, {'currentPassword': 'secret'});
        expect(session.hasSession, !success);
        expect(store.value, success ? isNull : isNotNull);
        dio.close(force: true);
      },
    );
  }
}
