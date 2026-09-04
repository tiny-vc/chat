import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth/presentation/login_page.dart';
import 'package:flutter_chat/app.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryTokenStore implements TokenStore {
  StoredTokens? tokens;

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<StoredTokens?> read() async => tokens;

  @override
  Future<void> write(StoredTokens tokens) async => this.tokens = tokens;
}

class FailingTokenStore extends MemoryTokenStore {
  bool fails = true;
  @override
  Future<StoredTokens?> read() async {
    if (fails) throw StateError('storage unavailable');
    return null;
  }
}

class PendingTokenStore extends MemoryTokenStore {
  final result = Completer<StoredTokens?>();
  @override
  Future<StoredTokens?> read() => result.future;
}

class FixedInstallationIdStore extends InstallationIdStore {
  @override
  Future<String> getOrCreate() async => 'test-installation';
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'pending restore fits short landscape with large text: $brightness',
      (tester) async {
        tester.view.physicalSize = const Size(640, 240);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        tester.platformDispatcher.platformBrightnessTestValue = brightness;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        final store = PendingTokenStore();
        await tester.pumpWidget(ChatApp(tokenStore: store));
        expect(find.text('正在恢复登录状态…'), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
  testWidgets('delayed stored credentials go directly to home without login', (
    tester,
  ) async {
    final store = PendingTokenStore();
    await tester.pumpWidget(
      ChatApp(
        tokenStore: store,
        installationIdStore: FixedInstallationIdStore(),
      ),
    );
    expect(find.byType(LoginPage), findsNothing);
    store.result.complete(
      const StoredTokens(
        accessToken: 'test-access',
        refreshToken: 'test-refresh',
        imUid: 'test-user',
        imToken: 'test-im',
        imAddress: '127.0.0.1:5100',
      ),
    );
    for (var frame = 0; frame < 20; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(LoginPage), findsNothing);
      if (find.byType(HomePage).evaluate().isNotEmpty) break;
    }
    expect(find.byType(HomePage), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  testWidgets(
    'restoring a session shows startup status, not a flashing login page',
    (tester) async {
      final store = PendingTokenStore();
      await tester.pumpWidget(ChatApp(tokenStore: store));
      expect(find.text('正在恢复登录状态…'), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
      store.result.complete(null);
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    },
  );
  testWidgets('logout overrides a restored session', (tester) async {
    final store = MemoryTokenStore()
      ..tokens = const StoredTokens(
        accessToken: 'test-access',
        refreshToken: 'test-refresh',
        imUid: 'test-user',
        imToken: 'test-im',
        imAddress: '127.0.0.1:5100',
      );
    await tester.pumpWidget(
      ChatApp(
        tokenStore: store,
        installationIdStore: FixedInstallationIdStore(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    // Exercise the routing callback after session cleanup, without a server.
    await store.clear();
    tester.widget<HomePage>(find.byType(HomePage)).onLoggedOut();
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsNothing);
    expect(find.text('欢迎回来'), findsOneWidget);
  });
  testWidgets('session restore error is visible and retry can reach login', (
    tester,
  ) async {
    final store = FailingTokenStore();
    await tester.pumpWidget(ChatApp(tokenStore: store));
    await tester.pumpAndSettle();
    expect(find.text('无法恢复登录状态'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    store.fails = false;
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
  });
  testWidgets('shows the login screen without a stored session', (
    tester,
  ) async {
    await tester.pumpWidget(ChatApp(tokenStore: MemoryTokenStore()));
    await tester.pumpAndSettle();

    expect(find.text('欢迎回来'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '登 录'), findsOneWidget);
    expect(find.text('没有账号？立即注册'), findsOneWidget);
  });

  testWidgets('switches to registration mode', (tester) async {
    await tester.pumpWidget(ChatApp(tokenStore: MemoryTokenStore()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('没有账号？立即注册'));
    await tester.tap(find.text('没有账号？立即注册'));
    await tester.pump();

    expect(find.text('创建账号'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '昵称'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '注册并登录'), findsOneWidget);
  });
}
