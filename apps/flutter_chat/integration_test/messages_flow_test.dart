import 'dart:async';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/auth/session_manager.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/chat/presentation/chat_page.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';

import 'media_checks.dart';
import 'voice_checks.dart';
import 'call_checks.dart';
import 'connected_call_checks.dart';

class _Store implements TokenStore {
  StoredTokens? tokens;
  @override
  Future<StoredTokens?> read() async => tokens;
  @override
  Future<void> write(StoredTokens value) async => tokens = value;
  @override
  Future<void> clear() async => tokens = null;
}

// Start role A first, then B on a second simulator with the same TEST_RUN_ID.
// Accounts must already be friends. Leaves labelled test messages as evidence.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('two-device text, history and refresh/reconnect', (tester) async {
    const role = String.fromEnvironment('TEST_ROLE');
    const run = String.fromEnvironment('TEST_RUN_ID');
    const username = String.fromEnvironment('TEST_USERNAME');
    const password = String.fromEnvironment('TEST_PASSWORD');
    const peerName = String.fromEnvironment('TEST_PEER');
    const offlineGroup = bool.fromEnvironment('TEST_OFFLINE_GROUP');
    const joinApproval = bool.fromEnvironment('TEST_JOIN_APPROVAL');
    const archiveUi = bool.fromEnvironment('TEST_ARCHIVE_UI');
    expect(!joinApproval || offlineGroup, isTrue);
    const media = bool.fromEnvironment('TEST_MEDIA');
    const voice = bool.fromEnvironment('TEST_VOICE');
    const calls = bool.fromEnvironment('TEST_CALLS');
    const connectedCalls = bool.fromEnvironment('TEST_CONNECTED_CALLS');
    expect(
      connectedCalls &&
          (calls ||
              voice ||
              media ||
              offlineGroup ||
              const bool.fromEnvironment('TEST_TRANSPORT_BURST')),
      isFalse,
    );
    expect(
      calls &&
          (voice ||
              media ||
              offlineGroup ||
              const bool.fromEnvironment('TEST_TRANSPORT_BURST')),
      isFalse,
      reason: 'Run call signalling checks separately',
    );
    expect(
      voice &&
          (media ||
              offlineGroup ||
              const bool.fromEnvironment('TEST_TRANSPORT_BURST')),
      isFalse,
      reason:
          'Run voice checks separately from other optional media/burst phases',
    );
    const transportBurst = bool.fromEnvironment('TEST_TRANSPORT_BURST');
    const refreshRounds = int.fromEnvironment(
      'TEST_REFRESH_ROUNDS',
      defaultValue: 1,
    );
    expect(refreshRounds, inInclusiveRange(1, 10));
    final syncFailures = <int?>[];
    expect(
      media && offlineGroup,
      isFalse,
      reason: 'Run direct media and offline group checks separately',
    );
    const directCount = int.fromEnvironment(
      'TEST_OFFLINE_DIRECT_COUNT',
      defaultValue: 3,
    );
    expect(directCount, inInclusiveRange(3, 30));
    expect(['A', 'B'], contains(role));
    for (final value in [run, username, password, peerName]) {
      expect(value, isNotEmpty);
    }
    final api = ChatApiClient(basePathOverride: AppConfig.resolvedApiBaseUrl);
    expect([
      'localhost',
      '127.0.0.1',
      '::1',
    ], contains(Uri.parse(AppConfig.resolvedApiBaseUrl).host));
    api.dio.options.connectTimeout = const Duration(seconds: 15);
    api.dio.options.receiveTimeout = const Duration(seconds: 15);
    final im = ImService(api.dio);
    final files = FileTransferService(api);
    final store = _Store();
    final session = SessionManager(
      api: api,
      tokenStore: store,
      onSessionChanged: im.updateSession,
      onCredentialsRefreshing: im.prepareCredentialsRefresh,
      onCredentialsRefreshed: im.updateCredentials,
    );
    api.dio.interceptors.add(
      RefreshTokenInterceptor(dio: api.dio, sessionManager: session),
    );
    api.dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Diagnose failures without printing tokens, headers or response bodies.
          debugPrint(
            'TEST_HTTP_ERROR ${error.requestOptions.uri.path} '
            '${error.type.name} status=${error.response?.statusCode}',
          );
          if (error.requestOptions.uri.path == '/api/v1/im/messages/sync') {
            syncFailures.add(error.response?.statusCode);
            final data = error.requestOptions.data as Map;
            debugPrint(
              'TEST_SYNC_PARAMETERS ${{
                for (final key in ['channelType', 'startMessageSeq', 'endMessageSeq', 'limit', 'pullMode']) key: data[key],
              }}',
            );
          }
          handler.next(error);
        },
      ),
    );
    addTearDown(() async {
      // Stop page timers/listeners before disposing their services on failures.
      await tester.pumpWidget(const SizedBox.shrink());
      WKIM.shared.messageManager.removeNewMsgListener('device-test');
      try {
        if (session.hasSession) await api.getAuthApi().authLogout();
      } finally {
        await session.clear();
        im.dispose();
        files.dispose();
        api.dio.close(force: true);
      }
    });
    final response = await api.getAuthApi().authLogin(
      loginDto: LoginDto(
        (b) => b
          ..username = username
          ..password = password
          ..deviceId = 'message-integration-$role'
          ..deviceType = LoginDtoDeviceTypeEnum.APP
          ..deviceName = 'Message integration $role',
      ),
    );
    await session.saveSession(response.data!);
    final friends = await api.getFriendsApi().friendsList();
    final peer = friends.data!
        .singleWhere((f) => f.user.username == peerName)
        .user;
    final incoming = <String>[];
    final receivedMedia = <WKMsg>[];
    WKIM.shared.messageManager.addOnNewMsgListener('device-test', (messages) {
      for (final message in messages) {
        if (message.fromUID == peer.id &&
            (message.messageContent is ChatFileContent ||
                message.messageContent is ChatImageContent ||
                message.messageContent is ChatAudioContent)) {
          receivedMedia.add(message);
        }
        if (message.fromUID == peer.id &&
            message.messageContent is WKTextContent) {
          incoming.add((message.messageContent as WKTextContent).content);
        }
      }
    });
    Future<void> wait(bool Function() condition, String stage) async {
      final deadline = DateTime.now().add(const Duration(minutes: 3));
      while (!condition() && DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      expect(condition(), isTrue, reason: '$role: $stage');
    }

    String text(String step) => 'integration:$run:$step';
    Future<void> visible(String step) async {
      // A socket callback can run before the next frame/scroll animation.
      await wait(
        () => find.text(text(step)).evaluate().isNotEmpty,
        'render $step',
      );
      expect(find.text(text(step)), findsOneWidget);
    }

    Future<void> send(String step) async {
      await tester.enterText(find.byType(TextField).first, text(step));
      await tester.pump();
      await tester.tap(find.byTooltip('发送'));
    }

    Widget page({String? groupId}) => MaterialApp(
      home: ChatPage(
        channelId: groupId ?? peer.id,
        channelType: groupId == null ? 1 : 2,
        title: groupId == null ? peerName : 'Integration group',
        imService: im,
        fileTransferService: files,
        forwardTargets: const [],
        callService: CallService(api),
      ),
    );
    Future<void> openGroup(String groupId) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(page(groupId: groupId));
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<List<dynamic>> historyOf(String channelId, int channelType) async {
      final response = await api.dio.post<Map<String, dynamic>>(
        '/api/v1/im/messages/sync',
        data: {
          'channelId': channelId,
          'channelType': channelType,
          'startMessageSeq': 0,
          'endMessageSeq': 0,
          'limit': 100,
          'pullMode': 0,
        },
      );
      return response.data!['messages'] as List;
    }

    bool hasMessage(List<dynamic> rows, String step) => rows.any(
      (row) => row['payload'] is Map && row['payload']['content'] == text(step),
    );
    Future<void> checkTransportBurst() async {
      if (!transportBurst) return;
      final other = role == 'A' ? 'B' : 'A';
      // B must not flood A's viewport while A is still checking baseline
      // history. Start only after both sides reach this phase.
      if (role == 'B') {
        await wait(
          () => incoming.contains(text('BURST_READY_A')),
          'A ready for burst',
        );
      }
      await WKIM.shared.messageManager.sendMessage(
        WKTextContent(text('BURST_READY_$role')),
        WKChannel(peer.id, 1),
      );
      if (role == 'A') {
        await wait(
          () => incoming.contains(text('BURST_READY_B')),
          'B ready for burst',
        );
      }
      final expected = List.generate(40, (i) => text('BURST_${other}_$i'));
      await Future.wait(
        List.generate(40, (i) async {
          await WKIM.shared.messageManager.sendMessage(
            WKTextContent(text('BURST_${role}_$i')),
            WKChannel(peer.id, 1),
          );
        }),
      );
      await wait(
        () => expected.every(incoming.contains),
        '40 peer burst messages received',
      );
      debugPrint('TRANSPORT_BURST_${role}_RECEIVED');
      // Last observed missing ACK caused a retransmission roughly a minute later.
      final until = DateTime.now().add(const Duration(seconds: 70));
      while (DateTime.now().isBefore(until)) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      for (final message in expected) {
        expect(
          incoming.where((m) => m == message),
          hasLength(1),
          reason: 'no duplicate delivery after observation: $message',
        );
      }
      expect(im.connectionState, ImConnectionState.connected);
      debugPrint('TRANSPORT_BURST_${role}_VERIFIED');
    }

    Future<void> checkVoice() async {
      if (!voice) return;
      await runVoiceChecks(
        tester: tester,
        role: role,
        run: run,
        peerId: peer.id,
        files: files,
        incoming: incoming,
        receivedMedia: receivedMedia,
        wait: wait,
      );
    }

    Future<void> checkCalls() async {
      if (connectedCalls) {
        await runConnectedCallChecks(
          tester: tester,
          role: role,
          run: run,
          im: im,
          calls: CallService(api),
          peerId: peer.id,
          incoming: incoming,
          wait: wait,
        );
      }
      if (!calls) return;
      await runCallChecks(
        tester: tester,
        role: role,
        run: run,
        peerId: peer.id,
        im: im,
        calls: CallService(api),
        incoming: incoming,
        wait: wait,
      );
    }

    await tester.pumpWidget(page());
    await wait(
      () => im.connectionState == ImConnectionState.connected,
      'IM connected',
    );
    if (role == 'A') {
      debugPrint('MESSAGE_TEST_A_READY');
      await wait(() => incoming.contains(text('READY')), 'peer ready');
      await send('HELLO');
      await wait(() => incoming.contains(text('REPLY')), 'reply received');
      await visible('REPLY');
      for (var round = 0; round < refreshRounds; round++) {
        final previousToken = store.tokens!.imToken;
        expect(
          await session.refreshOnce(),
          isTrue,
          reason: 'HTTP token refresh succeeds',
        );
        expect(
          store.tokens!.imToken == previousToken,
          isFalse,
          reason: 'refresh rotates stored IM token',
        );
        expect(
          WKIM.shared.options.token == store.tokens!.imToken,
          isTrue,
          reason: 'SDK credentials match refreshed session',
        );
        await wait(
          () => im.connectionState == ImConnectionState.connected,
          'automatic reconnect after refresh $round',
        );
        expect(WKIM.shared.options.uid, store.tokens!.imUid);
        await tester.pump(const Duration(milliseconds: 300));
      }
      debugPrint('REFRESH_ROUNDS_VERIFIED=$refreshRounds');
      await send('AGAIN');
      await wait(
        () => incoming.contains(text('DONE')),
        'reply after reconnect',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(page());
      await wait(
        () => find.text(text('DONE')).evaluate().isNotEmpty,
        'local history restored',
      );
      expect(find.text(text('HELLO')), findsOneWidget);
      expect(find.text(text('REPLY')), findsOneWidget);
      expect(find.text(text('AGAIN')), findsOneWidget);
      final history = await api.dio.post<Map<String, dynamic>>(
        '/api/v1/im/messages/sync',
        data: {
          'channelId': peer.id,
          'channelType': 1,
          'startMessageSeq': 0,
          'endMessageSeq': 0,
          'limit': 100,
          'pullMode': 0,
        },
      );
      final rows = history.data!['messages'] as List;
      for (final step in ['HELLO', 'REPLY', 'AGAIN', 'DONE']) {
        expect(
          rows.where(
            (m) =>
                (m as Map)['payload'] is Map &&
                m['payload']['content'] == text(step),
          ),
          hasLength(1),
          reason: 'server history $step',
        );
      }
      if (offlineGroup) {
        // Keep the direct chat mounted while IM is offline; HTTP stays online
        // solely to coordinate and verify persistence, not to fill its history.
        WKIM.shared.connectionManager.disconnect(false);
        expect(im.connectionState, ImConnectionState.disconnected);
        final created = await api.dio.post<Map<String, dynamic>>(
          '/api/v1/groups',
          data: {
            'name': text('OFFLINE_GROUP'),
            'memberIds': joinApproval ? <String>[] : [peer.id],
          },
        );
        final groupId = created.data!['id'] as String;
        if (joinApproval) {
          await api.dio.post<Object>(
            '/api/v1/groups/$groupId/invitations',
            data: {'userId': peer.id},
          );
        }
        var persisted = false;
        final deadline = DateTime.now().add(const Duration(minutes: 3));
        while (!persisted && DateTime.now().isBefore(deadline)) {
          final direct = await historyOf(peer.id, 1);
          final group = await historyOf(groupId, 2);
          persisted =
              List.generate(
                directCount,
                (i) => i + 1,
              ).every((i) => hasMessage(direct, 'OFFLINE_DIRECT_$i')) &&
              [1, 2, 3].every((i) => hasMessage(group, 'OFFLINE_GROUP_$i'));
          if (!persisted) await tester.pump(const Duration(milliseconds: 500));
        }
        expect(persisted, isTrue, reason: 'all offline messages persisted');
        expect(incoming.where((m) => m.startsWith(text('OFFLINE_'))), isEmpty);
        expect(find.text(text('OFFLINE_DIRECT_$directCount')), findsNothing);
        await im.reconnect();
        await wait(
          () => im.connectionState == ImConnectionState.connected,
          'offline reconnect',
        );
        await wait(
          () => find
              .text(text('OFFLINE_DIRECT_$directCount'))
              .evaluate()
              .isNotEmpty,
          'mounted chat recovers offline messages',
        );
        for (final i in [directCount - 2, directCount - 1, directCount]) {
          expect(find.text(text('OFFLINE_DIRECT_$i')), findsOneWidget);
        }
        final local = Completer<List<WKMsg>>();
        WKIM.shared.messageManager.getOrSyncHistoryMessages(
          peer.id,
          1,
          0,
          false,
          0,
          50,
          0,
          (messages) {
            if (!local.isCompleted) local.complete(messages);
          },
          () {},
        );
        final recovered =
            (await local.future.timeout(const Duration(seconds: 15)))
                .where(
                  (m) =>
                      m.messageContent is WKTextContent &&
                      (m.messageContent as WKTextContent).content.startsWith(
                        text('OFFLINE_DIRECT_'),
                      ),
                )
                .toList()
              ..sort((a, b) => a.messageSeq.compareTo(b.messageSeq));
        expect(
          recovered
              .map((m) => (m.messageContent as WKTextContent).content)
              .toList(),
          List.generate(directCount, (i) => text('OFFLINE_DIRECT_${i + 1}')),
          reason: 'complete ordered local backlog without duplicates',
        );
        await openGroup(groupId);
        await wait(
          () => find.text(text('OFFLINE_GROUP_3')).evaluate().isNotEmpty,
          'group offline history recovered',
        );
        for (final i in [1, 2, 3]) {
          expect(find.text(text('OFFLINE_GROUP_$i')), findsOneWidget);
        }
        await send('GROUP_REPLY');
        await wait(
          () => incoming.contains(text('GROUP_ACK')),
          'group reply received',
        );
        await visible('GROUP_ACK');
        final groupHistory = await historyOf(groupId, 2);
        for (final step in [
          'OFFLINE_GROUP_1',
          'OFFLINE_GROUP_2',
          'OFFLINE_GROUP_3',
          'GROUP_REPLY',
          'GROUP_ACK',
        ]) {
          expect(
            groupHistory.where(
              (m) =>
                  m['payload'] is Map && m['payload']['content'] == text(step),
            ),
            hasLength(1),
            reason: 'unique group history $step',
          );
        }
      }
      await checkTransportBurst();
      await checkVoice();
      await checkCalls();
      if (media) {
        await runMediaChecks(
          tester: tester,
          role: role,
          run: run,
          peerId: peer.id,
          files: files,
          incoming: incoming,
          receivedMedia: receivedMedia,
          wait: wait,
        );
      }
      await WKIM.shared.messageManager.sendMessage(
        WKTextContent(text('FINISH')),
        WKChannel(peer.id, 1),
      );
      await tester.pump(const Duration(seconds: 1));
    } else {
      await WKIM.shared.messageManager.sendMessage(
        WKTextContent(text('READY')),
        WKChannel(peer.id, 1),
      );
      await wait(() => incoming.contains(text('HELLO')), 'hello received');
      await visible('HELLO');
      await send('REPLY');
      await wait(
        () => incoming.contains(text('AGAIN')),
        'message after reconnect',
      );
      await send('DONE');
      if (offlineGroup) {
        String? groupId;
        final deadline = DateTime.now().add(const Duration(minutes: 3));
        while (groupId == null && DateTime.now().isBefore(deadline)) {
          if (joinApproval) {
            final inbox =
                (await api.getGroupsApi().groupsListActionableJoinRequests())
                    .data!;
            final invitations = inbox.where(
              (item) =>
                  item.type == GroupJoinRequestResponseTypeEnum.INVITE &&
                  item.group?.name == text('OFFLINE_GROUP'),
            );
            if (invitations.isNotEmpty) {
              await api.getGroupsApi().groupsApproveJoinRequest(
                requestId: invitations.single.id,
              );
              debugPrint('JOIN_INVITATION_ACCEPTED_BEFORE_GROUP_MESSAGES');
            }
          }
          final groups = await api.dio.get<List<dynamic>>('/api/v1/groups');
          final matches = groups.data!.where(
            (g) => g['name'] == text('OFFLINE_GROUP'),
          );
          if (matches.isNotEmpty) groupId = matches.single['id'] as String;
          if (groupId == null) {
            await tester.pump(const Duration(milliseconds: 500));
          }
        }
        expect(
          groupId,
          isNotNull,
          reason: 'peer disconnected and created test group',
        );
        for (var i = 1; i <= directCount; i++) {
          await send('OFFLINE_DIRECT_$i');
        }
        await openGroup(groupId!);
        for (final i in [1, 2, 3]) {
          await send('OFFLINE_GROUP_$i');
        }
        await wait(
          () => incoming.contains(text('GROUP_REPLY')),
          'group reply after offline recovery',
        );
        await visible('GROUP_REPLY');
        await send('GROUP_ACK');
      }
      await checkTransportBurst();
      await checkVoice();
      await checkCalls();
      if (media) {
        await runMediaChecks(
          tester: tester,
          role: role,
          run: run,
          peerId: peer.id,
          files: files,
          incoming: incoming,
          receivedMedia: receivedMedia,
          wait: wait,
        );
      }
      await wait(
        () => incoming.contains(text('FINISH')),
        'peer history verified',
      );
    }
    expect(
      syncFailures,
      isEmpty,
      reason: 'history sync must not silently fail',
    );
    if (archiveUi) {
      final snapshot = await HomeRepository(api).load();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConversationsView(
              imService: im,
              fileTransferService: files,
              callService: CallService(api),
              snapshot: snapshot,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final historyBefore = await historyOf(peer.id, 1);
      await tester.ensureVisible(find.text(peer.nickname));
      await tester.longPress(find.text(peer.nickname));
      await tester.pumpAndSettle();
      await tester.tap(find.text('归档会话'));
      await wait(() => im.settingFor(peer.id, 1).archived, 'archive saved');
      await tester.pumpAndSettle();
      expect(find.text(peer.nickname), findsNothing);
      await tester.tap(find.text('已归档会话'));
      await tester.pumpAndSettle();
      expect(find.text(peer.nickname), findsOneWidget);
      await tester.longPress(find.text(peer.nickname));
      await tester.pumpAndSettle();
      await tester.tap(find.text('恢复到会话列表'));
      await wait(() => !im.settingFor(peer.id, 1).archived, 'restore saved');
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text(peer.nickname), findsOneWidget);
      expect((await historyOf(peer.id, 1)).length, historyBefore.length);
      debugPrint('ARCHIVE_UI_RESTORE_PRESERVED_HISTORY_$role');
    }
    await tester.pumpWidget(const SizedBox.shrink());
  }, timeout: const Timeout(Duration(minutes: 8)));
}
