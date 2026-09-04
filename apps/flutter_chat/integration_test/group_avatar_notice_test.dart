import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/auth/session_manager.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/features/auth/data/auth_repository.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class MemoryTokens implements TokenStore {
  StoredTokens? value;
  @override
  Future<StoredTokens?> read() async => value;
  @override
  Future<void> write(StoredTokens tokens) async => value = tokens;
  @override
  Future<void> clear() async => value = null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('real group avatar notice updates an already open peer page', (
    tester,
  ) async {
    const ownerName = String.fromEnvironment('TEST_OWNER');
    const peerName = String.fromEnvironment('TEST_PEER');
    const groupId = String.fromEnvironment('TEST_GROUP_ID');
    expect(ownerName.startsWith('av_'), isTrue);
    expect(peerName.startsWith('av_'), isTrue);
    expect(groupId, isNotEmpty);
    expect([
      'localhost',
      '127.0.0.1',
      '::1',
    ], contains(Uri.parse(AppConfig.resolvedApiBaseUrl).host));
    final owner = ChatApiClient(basePathOverride: AppConfig.resolvedApiBaseUrl);
    final peer = ChatApiClient(basePathOverride: AppConfig.resolvedApiBaseUrl);
    final im = ImService(peer.dio);
    final files = FileTransferService(peer);
    final controller = HomeController(HomeRepository(peer));
    final session = SessionManager(
      api: peer,
      tokenStore: MemoryTokens(),
      onSessionChanged: im.updateSession,
    );
    String? original;
    var changed = false;
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      try {
        if (changed && original != null) {
            await HomeRepository(owner).setGroupAvatar(groupId, original);
        }
      } finally {
        try {
          await owner.getAuthApi().authLogout();
          await peer.getAuthApi().authLogout();
        } finally {
          await session.clear();
          controller.dispose();
          im.dispose();
          files.dispose();
          owner.dio.close(force: true);
          peer.dio.close(force: true);
        }
      }
    });
    Future<AuthSessionResponse> login(
      ChatApiClient api,
      String username,
    ) async {
      final response = await api.getAuthApi().authLogin(
        loginDto: LoginDto(
          (b) => b
            ..username = username
            ..password = const String.fromEnvironment('TEST_PASSWORD')
            ..deviceId = 'avatar-notice-$username'
            ..deviceType = LoginDtoDeviceTypeEnum.APP,
        ),
      );
      api.dio.options.headers['Authorization'] =
          'Bearer ${response.data!.accessToken}';
      return response.data!;
    }

    await login(owner, ownerName);
    await session.saveSession(await login(peer, peerName));
    original = (await HomeRepository(owner).getGroup(groupId)).avatarFileId;
    expect(
      original,
      isNotNull,
      reason: 'Use the existing isolated avatar fixture',
    );
    final navigation = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigation,
        home: HomePage(
          controller: controller,
          imService: im,
          fileTransferService: files,
          callService: CallService(peer),
          authRepository: AuthRepository(
            api: peer,
            session: session,
            installationIdStore: InstallationIdStore(),
          ),
          onLoggedOut: () {},
        ),
      ),
    );
    Future<void> waitFor(bool Function() condition, String description) async {
      final deadline = DateTime.now().add(const Duration(seconds: 30));
      while (!condition() && DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(condition(), isTrue, reason: description);
    }

    await waitFor(
      () =>
          im.connectionState == ImConnectionState.connected &&
          controller.snapshot != null,
      'peer IM connected',
    );
    navigation.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => GroupSettingsPage(
          groupId: groupId,
          controller: controller,
          fileTransferService: files,
        ),
      ),
    );
    String? visibleAvatar() => find.byType(AppAvatar).evaluate().length == 1
        ? tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId
        : 'not-ready';
    await waitFor(() => visibleAvatar() == original, 'original avatar loaded');
    changed = true;
    await HomeRepository(owner).removeGroupAvatar(groupId);
    await waitFor(
      () =>
          visibleAvatar() == null &&
          (controller.groupRevisions[groupId] ?? 0) > 0,
      'IM notice removes peer avatar without manual refresh',
    );
    debugPrint('AVATAR_NOTICE_PEER_REMOVAL_PASSED');
    await HomeRepository(owner).setGroupAvatar(groupId, original!);
    await waitFor(
      () =>
          visibleAvatar() == original &&
          (controller.groupRevisions[groupId] ?? 0) >= 2,
      'IM notice restores peer avatar without manual refresh',
    );
    changed = false;
    await waitFor(
      () => tester
          .widgetList<RawImage>(
            find.descendant(
              of: find.byType(AppAvatar),
              matching: find.byType(RawImage),
            ),
          )
          .any((image) => image.image != null),
      'restored image decoded',
    );
    debugPrint('AVATAR_NOTICE_PEER_RESTORE_DECODED_PASSED');
  }, timeout: const Timeout(Duration(minutes: 4)));
}
