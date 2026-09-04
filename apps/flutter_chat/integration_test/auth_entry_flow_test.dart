import 'package:flutter/material.dart';
import 'package:flutter_chat/app.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/features/auth/presentation/login_page.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class _MemoryStore implements TokenStore {
  StoredTokens? tokens;
  @override
  Future<StoredTokens?> read() async => tokens;
  @override
  Future<void> write(StoredTokens value) async => tokens = value;
  @override
  Future<void> clear() async => tokens = null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real login submission and logout return to welcome form', (
    tester,
  ) async {
    final store = _MemoryStore();
    addTearDown(() async {
      final homes = find.byType(HomePage);
      if (homes.evaluate().isNotEmpty && store.tokens != null) {
        await tester.widget<HomePage>(homes).authRepository.logout();
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
    await tester.pumpWidget(ChatApp(tokenStore: store));
    Future<void> wait(bool Function() ready) async {
      final deadline = DateTime.now().add(const Duration(seconds: 40));
      while (!ready() && DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(ready(), isTrue);
    }

    await wait(() => find.byType(LoginPage).evaluate().isNotEmpty);
    await tester.enterText(
      find.widgetWithText(TextFormField, '用户名'),
      const String.fromEnvironment('TEST_USERNAME'),
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, '密码'),
      const String.fromEnvironment('TEST_PASSWORD'),
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await wait(() => find.byType(HomePage).evaluate().isNotEmpty);
    expect(store.tokens, isNotNull);
    // Recreate the app with the same saved credentials. This covers session
    // restoration, not OS process death or native secure-storage persistence.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(ChatApp(tokenStore: store));
    expect(find.byType(LoginPage), findsNothing);
    final restoreDeadline = DateTime.now().add(const Duration(seconds: 40));
    while (find.byType(HomePage).evaluate().isEmpty &&
        DateTime.now().isBefore(restoreDeadline)) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LoginPage), findsNothing);
    }
    expect(find.byType(HomePage), findsOneWidget);
    debugPrint('AUTH_SESSION_RESTORED');
    final home = tester.widget<HomePage>(find.byType(HomePage));
    await home.authRepository.logout();
    home.onLoggedOut();
    await wait(() => find.byType(LoginPage).evaluate().isNotEmpty);
    expect(store.tokens, isNull);
    expect(
      tester
          .widget<TextFormField>(find.widgetWithText(TextFormField, '密码'))
          .controller!
          .text,
      isEmpty,
    );
    debugPrint('AUTH_ENTRY_READY');
    final until = DateTime.now().add(const Duration(seconds: 20));
    while (DateTime.now().isBefore(until)) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
