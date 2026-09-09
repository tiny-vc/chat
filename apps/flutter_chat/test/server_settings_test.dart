import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_chat/config/server_settings.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/conversation_draft_store.dart';
import 'package:flutter_chat/features/auth/presentation/server_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/common/options.dart' as wk;

Map<String, Object> get info => {
  'product': 'chat',
  'apiVersion': 1,
  'name': '测试服务器',
  'registrationEnabled': true,
  'capabilities': {
    'messaging': true,
    'files': true,
    'groups': true,
    'audioCalls': true,
    'videoCalls': true,
  },
  'uploadLimits': {
    'AVATAR': 5 * 1024 * 1024,
    'CHAT_IMAGE': 20 * 1024 * 1024,
    'CHAT_VOICE': 10 * 1024 * 1024,
    'CHAT_VIDEO': 100 * 1024 * 1024,
    'CHAT_FILE': 100 * 1024 * 1024,
  },
};

class InfoAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(info),
    200,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
  @override
  void close({bool force = false}) {}
}

ServerProbe probe({Object? body, void Function(RequestOptions)? inspect}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        inspect?.call(options);
        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: jsonEncode(body ?? info),
          ),
        );
      },
    ),
  );
  return ServerProbe(dio: dio);
}

void main() {
  test('server info refresh is stale-aware and handles clock rollback', () {
    final now = DateTime.utc(2026, 9, 4, 12);
    expect(shouldRefreshServerInfo(now: now), isTrue);
    expect(
      shouldRefreshServerInfo(
        now: now,
        lastAttempt: now.subtract(const Duration(minutes: 4)),
      ),
      isFalse,
    );
    expect(
      shouldRefreshServerInfo(
        now: now,
        lastAttempt: now.subtract(const Duration(minutes: 5)),
      ),
      isTrue,
    );
    expect(
      shouldRefreshServerInfo(
        now: now,
        lastAttempt: now.add(const Duration(minutes: 1)),
      ),
      isTrue,
    );
  });
  test('messaging capability gates sending, files and call signaling', () {
    const paused = ServerCapabilities(
      messaging: false,
      files: true,
      groups: true,
      audioCalls: true,
      videoCalls: true,
    );
    expect(paused.canSendFiles, isFalse);
    expect(paused.canAudioCall, isFalse);
    expect(paused.canVideoCall, isFalse);

    const limited = ServerCapabilities(
      messaging: true,
      files: false,
      groups: true,
      audioCalls: true,
      videoCalls: false,
    );
    expect(limited.canSendFiles, isFalse);
    expect(limited.canAudioCall, isTrue);
    expect(limited.canVideoCall, isFalse);
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'real Dio transformation preserves bounded JSON text for validation',
    () async {
      final dio = Dio()..httpClientAdapter = InfoAdapter();
      final service = ServerProbe(dio: dio);
      expect((await service.check('https://chat.example.com')).name, '测试服务器');
      service.dispose();
    },
  );
  test(
    'canonical origins reject credentials, paths, queries and insecure public hosts',
    () {
      expect(
        normalizeServerAddress(' https://CHAT.example.com/api/v1/ '),
        'https://chat.example.com',
      );
      expect(
        normalizeServerAddress('http://192.168.1.2:3000'),
        'http://192.168.1.2:3000',
      );
      for (final invalid in [
        'https://user:pass@chat.example.com',
        'https://chat.example.com?token=x',
        'https://chat.example.com/#x',
        'https://chat.example.com/other',
        'http://chat.example.com',
        'http://192.168.1.2.evil.example',
        'ftp://chat.example.com',
        'chat.example.com',
      ]) {
        expect(
          () => normalizeServerAddress(invalid),
          throwsFormatException,
          reason: invalid,
        );
      }
    },
  );
  test('probe has no authorization and disables redirects', () async {
    final service = probe(
      inspect: (request) {
        expect(request.uri.path, '/api/v1/server-info');
        expect(
          request.headers.keys.map((k) => k.toLowerCase()),
          isNot(contains('authorization')),
        );
        expect(request.followRedirects, isFalse);
      },
    );
    final checked = await service.check('https://chat.example.com');
    expect(checked.name, '测试服务器');
    expect(checked.uploadLimits.chatImage, 20 * 1024 * 1024);
    service.dispose();
  });
  test(
    'incompatible protocol and malformed response cannot pass detection',
    () async {
      for (final body in [
        {...info, 'apiVersion': 2},
        {...info, 'product': 'other'},
        {
          ...info,
          'capabilities': {'messaging': true},
        },
        {
          ...info,
          'uploadLimits': {'AVATAR': 1},
        },
        {
          ...info,
          'uploadLimits': {...(info['uploadLimits']! as Map), 'CHAT_FILE': -1},
        },
        {'name': 'Chat'},
        'html',
      ]) {
        final service = probe(body: body);
        await expectLater(
          service.check('https://chat.example.com'),
          throwsFormatException,
        );
        service.dispose();
      }
    },
  );
  test(
    'credentials, drafts and SDK database identities are server scoped without changing UID',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      final a = serverNamespace('https://a.example.com');
      final b = serverNamespace('https://b.example.com');
      expect(a, isNot(b));
      expect(a, serverNamespace('https://a.example.com/'));
      expect(
        scopedFileCacheKey('https://a.example.com', '../file'),
        isNot(contains('/')),
      );
      expect(
        scopedFileCacheKey('https://a.example.com', 'same'),
        isNot(scopedFileCacheKey('https://b.example.com', 'same')),
      );
      final tokensA = SecureTokenStore(namespace: a);
      final tokensB = SecureTokenStore(namespace: b);
      await tokensA.write(
        const StoredTokens(
          accessToken: 'a',
          refreshToken: 'r',
          imUid: 'same',
          imToken: 'im',
          imAddress: 'localhost:5100',
        ),
      );
      expect(await tokensB.read(), isNull);
      await tokensB.clear();
      expect((await tokensA.read())!.accessToken, 'a');
      await ConversationDraftStore(
        namespace: a,
      ).write('same', 'peer', 1, 'private draft');
      expect(
        await ConversationDraftStore(namespace: b).read('same', 'peer', 1),
        '',
      );
      final optsA = wk.Options.newDefault('same', 'token')
        ..databaseNamespace = a;
      final optsB = wk.Options.newDefault('same', 'token')
        ..databaseNamespace = b;
      expect(optsA.uid, optsB.uid);
      expect(optsA.databaseIdentity, isNot(optsB.databaseIdentity));
      expect(
        () => wk.Options.newDefault('../../outside', 'token').databaseIdentity,
        throwsArgumentError,
      );
    },
  );
  test('server selection survives storage reload', () async {
    FlutterSecureStorage.setMockInitialValues({});
    await ServerSettingsStore().save('https://a.example.com/api/v1');
    expect(await ServerSettingsStore().read(), 'https://a.example.com');
  });
  test('verified server metadata cache is isolated by server origin', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final store = ServerSettingsStore();
    const cached = ServerInfo(
      address: 'https://a.example.com',
      name: 'A 服务器',
      apiVersion: 1,
      registrationEnabled: false,
      capabilities: ServerCapabilities(
        messaging: true,
        files: false,
        groups: true,
        audioCalls: true,
        videoCalls: false,
      ),
      uploadLimits: UploadLimits.defaults,
    );
    await store.saveInfo(cached);

    final restored = await ServerSettingsStore().readInfo(
      'https://a.example.com/api/v1',
    );
    expect(restored?.name, 'A 服务器');
    expect(restored?.registrationEnabled, isFalse);
    expect(restored?.capabilities.files, isFalse);
    expect(restored?.capabilities.videoCalls, isFalse);
    expect(await store.readInfo('https://b.example.com'), isNull);
  });
  testWidgets(
    'failed detection or failed save never reports successful switching',
    (tester) async {
      final service = probe();
      addTearDown(service.dispose);
      var saves = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: ServerSettingsPage(
            currentAddress: 'http://public.example.com',
            probe: service,
            save: (_) async {
              saves++;
              throw StateError('storage unavailable');
            },
          ),
        ),
      );
      await tester.tap(find.text('检测连接'));
      await tester.pumpAndSettle();
      expect(find.textContaining('公网服务器必须'), findsOneWidget);
      expect(saves, 0);
      await tester.enterText(
        find.byType(TextField),
        'https://chat.example.com',
      );
      await tester.tap(find.text('检测连接'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('保存并使用'));
      await tester.tap(find.text('保存并使用'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认保存'));
      await tester.pumpAndSettle();
      expect(saves, 1);
      expect(find.byType(ServerSettingsPage), findsOneWidget);
      expect(find.textContaining('保存失败'), findsOneWidget);
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'detect, invalidate edited address, confirm and save at large text dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        String? saved;
        final service = probe();
        addTearDown(service.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? ThemeData.dark() : ThemeData.light(),
            home: ServerSettingsPage(
              currentAddress: 'https://a.example.com',
              probe: service,
              save: (address) async => saved = address,
            ),
          ),
        );
        expect(
          tester
              .widget<FilledButton>(find.widgetWithText(FilledButton, '保存并使用'))
              .onPressed,
          isNull,
        );
        await tester.ensureVisible(find.text('检测连接'));
        await tester.tap(find.text('检测连接'));
        await tester.pumpAndSettle();
        expect(find.text('连接正常'), findsOneWidget);
        expect(find.text('API v1 · 注册开放'), findsOneWidget);
        await tester.ensureVisible(find.byType(ExpansionTile));
        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();
        expect(find.text('文字消息 · 支持'), findsOneWidget);
        await tester.ensureVisible(find.text('上传大小上限'));
        expect(find.text('聊天图片'), findsOneWidget);
        expect(find.text('20.0 MB'), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'https://b.example.com');
        await tester.pumpAndSettle();
        expect(find.text('连接正常'), findsNothing);
        await tester.ensureVisible(find.text('检测连接'));
        await tester.tap(find.text('检测连接'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('保存并使用'));
        await tester.tap(find.text('保存并使用'));
        await tester.pumpAndSettle();
        expect(saved, isNull);
        await tester.tap(find.text('确认保存'));
        await tester.pumpAndSettle();
        expect(saved, 'https://b.example.com');
        expect(tester.takeException(), isNull);
      },
    );
  }
}
