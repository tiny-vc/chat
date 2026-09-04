import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/app.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Run only on a dedicated test installation, against the development backend.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('real login, IM connection, session restoration and logout', (
    tester,
  ) async {
    const username = String.fromEnvironment('TEST_USERNAME');
    const password = String.fromEnvironment('TEST_PASSWORD');
    expect(username, isNotEmpty, reason: 'Provide a dedicated TEST_USERNAME');
    expect(password, isNotEmpty, reason: 'Provide TEST_PASSWORD');
    final store = SecureTokenStore();
    final existing = await store.read();
    if (existing != null && const bool.fromEnvironment('TEST_RESET_SESSION')) {
      final api = Dio(
        BaseOptions(
          baseUrl: AppConfig.resolvedApiBaseUrl,
          headers: {'Authorization': 'Bearer ${existing.accessToken}'},
        ),
      );
      try {
        final me = await api.get<Map<String, dynamic>>('/api/v1/users/me');
        expect(
          me.data?['username'],
          username,
          reason: 'Only reset this test account, never another user',
        );
        await api.post<void>('/api/v1/auth/logout');
        await store.clear();
      } finally {
        api.close(force: true);
      }
    }
    expect(
      await store.read(),
      isNull,
      reason: 'Use a logged-out test installation; do not overwrite a session',
    );
    addTearDown(() async {
      final remaining = await store.read();
      if (remaining == null) return;
      final api = Dio(
        BaseOptions(
          baseUrl: AppConfig.resolvedApiBaseUrl,
          headers: {'Authorization': 'Bearer ${remaining.accessToken}'},
        ),
      );
      try {
        await api.post<void>('/api/v1/auth/logout');
      } finally {
        api.close(force: true);
        await store.clear();
      }
    });

    await tester.pumpWidget(const ChatApp());
    await waitFor(tester, () => find.text('欢迎回来').evaluate().isNotEmpty);
    await tester.enterText(find.byType(TextFormField).at(0), username);
    await tester.enterText(find.byType(TextFormField).at(1), password);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.ensureVisible(find.widgetWithText(FilledButton, '登 录'));
    await tester.tap(find.widgetWithText(FilledButton, '登 录'));
    await waitFor(tester, () => find.byType(HomePage).evaluate().isNotEmpty);
    final home = tester.widget<HomePage>(find.byType(HomePage));
    await waitFor(tester, () => home.controller.snapshot != null);
    expect(home.controller.snapshot!.me.username, username);
    expect(await store.read(), isNotNull);
    await waitFor(
      tester,
      () => home.imService.connectionState == ImConnectionState.connected,
    );

    // Recreate the app state, reading the real platform Keychain/Keystore.
    // This is session restoration, not an OS process-kill test.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const ChatApp());
    await waitFor(tester, () => find.byType(HomePage).evaluate().isNotEmpty);
    final restored = tester.widget<HomePage>(find.byType(HomePage));
    await waitFor(tester, () => restored.controller.snapshot != null);
    expect(restored.controller.snapshot!.me.username, username);

    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.scrollUntilVisible(
      find.text('退出登录'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('退出登录'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(FilledButton, '确定'));
    await waitFor(tester, () => find.text('欢迎回来').evaluate().isNotEmpty);
    expect(await store.read(), isNull);
    expect(find.byType(HomePage), findsNothing);
  });
}

Future<void> waitFor(WidgetTester tester, bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 30));
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  expect(condition(), isTrue, reason: 'Expected app state within 30 seconds');
}
