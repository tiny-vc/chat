import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native group avatar cancel, upload, decode and remove', (
    tester,
  ) async {
    const username = String.fromEnvironment('TEST_USERNAME');
    const groupId = String.fromEnvironment('TEST_GROUP_ID');
    const readOnly = bool.fromEnvironment('TEST_AVATAR_READ_ONLY');
    expect(username.startsWith('av_'), isTrue);
    expect(groupId, isNotEmpty);
    expect([
      'localhost',
      '127.0.0.1',
      '::1',
    ], contains(Uri.parse(AppConfig.resolvedApiBaseUrl).host));
    final api = ChatApiClient(basePathOverride: AppConfig.resolvedApiBaseUrl);
    final files = FileTransferService(api);
    final controller = HomeController(HomeRepository(api));
    var loggedIn = false;
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      try {
        if (loggedIn) await api.getAuthApi().authLogout();
      } finally {
        controller.dispose();
        files.dispose();
        api.dio.close(force: true);
      }
    });
    final session = (await api.getAuthApi().authLogin(
      loginDto: LoginDto(
        (b) => b
          ..username = username
          ..password = const String.fromEnvironment('TEST_PASSWORD')
          ..deviceId = 'native-avatar-test',
      ),
    )).data!;
    loggedIn = true;
    api.dio.options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    await controller.load();
    expect(controller.error, isNull);
    final original = await controller.getGroup(groupId);
    await tester.pumpWidget(
      MaterialApp(
        home: GroupSettingsPage(
          groupId: groupId,
          controller: controller,
          fileTransferService: files,
        ),
      ),
    );
    Future<void> waitFor(
      bool Function() ready,
      String stage, {
      int seconds = 30,
    }) async {
      final until = DateTime.now().add(Duration(seconds: seconds));
      while (!ready() && DateTime.now().isBefore(until)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(ready(), isTrue, reason: stage);
    }

    bool imageDecoded() => tester
        .widgetList<RawImage>(
          find.descendant(
            of: find.byType(AppAvatar),
            matching: find.byType(RawImage),
          ),
        )
        .any((w) => w.image?.width == 1024 && w.image?.height == 1024);
    await waitFor(
      () => find.byType(AppAvatar).evaluate().isNotEmpty,
      'group loaded',
    );
    if (readOnly) {
      await waitFor(imageDecoded, 'peer sees selected avatar');
      debugPrint('NATIVE_AVATAR_PEER_DECODED_1024');
      return;
    }
    expect(original.ownerId, controller.snapshot!.me.id);
    final label = original.avatarFileId == null ? '上传群头像' : '更换群头像';
    bool changeEnabled() {
      final buttons = find.ancestor(
        of: find.text(label),
        matching: find.byWidgetPredicate((widget) => widget is TextButton),
      );
      return buttons.evaluate().isNotEmpty &&
          tester.widget<TextButton>(buttons.first).onPressed != null;
    }

    await tester.tap(find.text(label));
    await tester.pump(const Duration(milliseconds: 500));
    debugPrint('NATIVE_AVATAR_CANCEL_READY');
    await waitFor(changeEnabled, 'native picker cancelled', seconds: 180);
    expect(
      (await controller.getGroup(groupId)).avatarFileId,
      original.avatarFileId,
    );
    await tester.tap(find.text(label));
    await tester.pump(const Duration(milliseconds: 500));
    debugPrint('NATIVE_AVATAR_SELECT_READY');
    await waitFor(
      () => controller.snapshot!.groups.any(
        (g) =>
            g.id == groupId &&
            g.avatarFileId != null &&
            g.avatarFileId != original.avatarFileId,
      ),
      'native selection uploaded and bound',
      seconds: 180,
    );
    final uploaded = (await controller.getGroup(groupId)).avatarFileId!;
    await waitFor(
      () =>
          tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId == uploaded &&
          imageDecoded(),
      'selected avatar decoded',
    );
    debugPrint('NATIVE_AVATAR_UPLOADED_AND_DECODED_1024');
    await waitFor(changeEnabled, 'upload controls restored');
    await tester.tap(find.text('移除群头像'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '移除群头像'));
    await waitFor(
      () => controller.snapshot!.groups.any(
        (g) => g.id == groupId && g.avatarFileId == null,
      ),
      'avatar removed',
    );
    await waitFor(
      () => tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId == null,
      'default avatar restored',
    );
    // Keep the newly selected image bound so the other test account can verify it.
    await controller.setGroupAvatar(groupId, uploaded);
    debugPrint('NATIVE_AVATAR_REMOVE_AND_REBIND_VERIFIED');
    expect(tester.takeException(), isNull);
  }, timeout: const Timeout(Duration(minutes: 8)));
}
