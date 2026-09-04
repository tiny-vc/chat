import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_chat/features/home/presentation/group_join_page.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real friend and group avatars decode in contacts and profile', (
    tester,
  ) async {
    const username = String.fromEnvironment('TEST_USERNAME');
    expect(username.startsWith('av_'), isTrue);
    expect([
      'localhost',
      '127.0.0.1',
      '::1',
    ], contains(Uri.parse(AppConfig.resolvedApiBaseUrl).host));
    final api = ChatApiClient(basePathOverride: AppConfig.resolvedApiBaseUrl);
    final files = FileTransferService(api);
    final im = ImService(api.dio);
    final controller = HomeController(HomeRepository(api));
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      try {
        await api.getAuthApi().authLogout();
      } finally {
        controller.dispose();
        im.dispose();
        files.dispose();
        api.dio.close(force: true);
      }
    });
    final session = (await api.getAuthApi().authLogin(
      loginDto: LoginDto(
        (b) => b
          ..username = username
          ..password = const String.fromEnvironment('TEST_PASSWORD')
          ..deviceId = 'avatar-device-test',
      ),
    )).data!;
    api.dio.options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    await controller.load();
    expect(controller.error, isNull);
    expect(controller.snapshot!.friends, hasLength(1));
    expect(controller.snapshot!.groups, hasLength(1));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: AppBar(title: const Text('通讯录')),
          body: ContactsView(
            controller: controller,
            snapshot: controller.snapshot,
            imService: im,
            fileTransferService: files,
            callService: CallService(api),
          ),
        ),
      ),
    );
    Future<void> decoded(int count) async {
      final deadline = DateTime.now().add(const Duration(seconds: 20));
      while (DateTime.now().isBefore(deadline)) {
        final images = tester
            .widgetList<RawImage>(
              find.descendant(
                of: find.byType(AppAvatar),
                matching: find.byType(RawImage),
              ),
            )
            .where((w) => w.image != null)
            .toList();
        if (images.length == count) {
          for (final image in images) {
            expect(image.image!.width, 64);
            expect(image.image!.height, 64);
          }
          return;
        }
        await tester.pump(const Duration(milliseconds: 200));
      }
      fail('Expected $count decoded real avatar images');
    }

    await decoded(2);
    await tester.tap(find.byTooltip('好友资料'));
    await tester.pumpAndSettle();
    await decoded(1);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await decoded(2);
    if (const bool.fromEnvironment('TEST_JOIN_INBOX')) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: GroupJoinPage(controller: controller, actionable: true),
        ),
      );
      final deadline = DateTime.now().add(const Duration(seconds: 20));
      while (find.text('同意申请').evaluate().isEmpty &&
          DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(
        find.text('UI-${const String.fromEnvironment('TEST_FIXTURE_RUN')}'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('同意申请'));
      await tester.tap(find.text('同意申请'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, '同意申请'));
      final done = DateTime.now().add(const Duration(seconds: 20));
      while (find.text('暂无入群记录').evaluate().isEmpty &&
          DateTime.now().isBefore(done)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(find.text('暂无入群记录'), findsOneWidget);
      await controller.refreshPendingJoins();
      expect(controller.pendingJoinCount, 0);
      debugPrint('JOIN_INBOX_UI_APPROVED');
    }
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: GroupSettingsPage(
          groupId: controller.snapshot!.groups.single.id,
          controller: controller,
          fileTransferService: files,
        ),
      ),
    );
    await decoded(1);
    debugPrint('GROUP_AVATAR_UI_DECODED');
    debugPrint('AVATAR_UI_READY $username');
    // Leave the real page visible briefly for a read-only simulator screenshot.
    final until = DateTime.now().add(const Duration(seconds: 30));
    while (DateTime.now().isBefore(until)) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(tester.takeException(), isNull);
  });
}
