import 'package:flutter/material.dart';
import 'package:flutter_chat/app.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/config/server_settings.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/features/auth/presentation/server_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class EmptyTokens implements TokenStore {
  @override
  Future<StoredTokens?> read() async => null;
  @override
  Future<void> clear() async {}
  @override
  Future<void> write(StoredTokens tokens) async =>
      throw StateError('No login in this test');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'login server detection, persistence and switching with real local API',
    (tester) async {
      expect(Uri.parse(AppConfig.resolvedApiBaseUrl).host, 'localhost');
      final store = ServerSettingsStore();
      final original = await store.read();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        if (original == null) {
          await store.clear();
        } else {
          await store.save(original);
        }
      });
      await store.save('http://localhost:3000');
      await tester.pumpWidget(
        ChatApp(tokenStore: EmptyTokens(), serverStore: store),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('服务器设置'));
      await tester.pumpAndSettle();
      expect(find.byType(ServerSettingsPage), findsOneWidget);
      await tester.enterText(
        find.byType(TextField),
        'http://127.0.0.1:3000/api/v1',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(find.text('检测连接'));
      await tester.tap(find.text('检测连接'));
      final deadline = DateTime.now().add(const Duration(seconds: 20));
      while (find.textContaining('检测成功：').evaluate().isEmpty &&
          DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(find.textContaining('检测成功：'), findsOneWidget);
      await tester.ensureVisible(find.text('保存并使用'));
      await tester.tap(find.text('保存并使用'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确认保存'));
      await tester.pumpAndSettle();
      expect(find.byType(ServerSettingsPage), findsNothing);
      expect(find.text('http://127.0.0.1:3000'), findsOneWidget);
      expect(await ServerSettingsStore().read(), 'http://127.0.0.1:3000');
      // Recreate the complete app, not just the settings route.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        ChatApp(tokenStore: EmptyTokens(), serverStore: ServerSettingsStore()),
      );
      await tester.pumpAndSettle();
      expect(find.text('http://127.0.0.1:3000'), findsOneWidget);
      debugPrint('SERVER_SETTINGS_REAL_DETECT_SAVE_SWITCH_RESTORE_PASSED');
    },
  );
}
