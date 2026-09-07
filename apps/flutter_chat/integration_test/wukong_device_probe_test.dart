import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/auth/session_manager.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';

class FixedInstallationIdStore extends InstallationIdStore {
  FixedInstallationIdStore(this.value);
  final String value;
  @override
  Future<String> getOrCreate() async => value;
}

class MemoryTokenStore implements TokenStore {
  MemoryTokenStore(this.value);
  StoredTokens? value;

  @override
  Future<void> clear() async => value = null;

  @override
  Future<StoredTokens?> read() async => value;

  @override
  Future<void> write(StoredTokens tokens) async => value = tokens;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const deviceId = String.fromEnvironment('PROBE_DEVICE_ID');
  const username = String.fromEnvironment(
    'PROBE_USERNAME',
    defaultValue: 'alice_test',
  );
  const password = String.fromEnvironment(
    'PROBE_PASSWORD',
    defaultValue: 'secure-password-123',
  );
  const peerUsername = String.fromEnvironment('PROBE_PEER');
  const runId = String.fromEnvironment('PROBE_RUN_ID');
  const expectPolicyCycle = bool.fromEnvironment('EXPECT_MESSAGE_POLICY_CYCLE');
  testWidgets('holds one labelled WuKongIM device connection', (_) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {
        'username': username,
        'password': password,
        'deviceId': deviceId,
        'deviceType': 'APP',
        'deviceName': deviceId,
      },
    );
    final body = response.data!;
    final im = Map<String, dynamic>.from(body['im'] as Map);
    dio.options.headers['authorization'] =
        'Bearer ${body['accessToken'] as String}';
    final service = ImService(
      dio,
      installationIdStore: FixedInstallationIdStore(deviceId),
    );
    final api = ChatApiClient(basePathOverride: 'http://localhost:3000');
    final session = SessionManager(
      api: api,
      tokenStore: MemoryTokenStore(
        StoredTokens(
          accessToken: body['accessToken'] as String,
          refreshToken: body['refreshToken'] as String,
          imUid: im['uid'] as String,
          imToken: im['token'] as String,
          imAddress: im['address'] as String,
        ),
      ),
      onSessionChanged: service.updateSession,
      onCredentialsRefreshing: service.prepareCredentialsRefresh,
      onCredentialsRefreshed: service.updateCredentials,
    );
    addTearDown(() {
      WKIM.shared.messageManager.removeNewMsgListener('policy-probe-$deviceId');
      service.dispose();
      dio.close(force: true);
      api.dio.close(force: true);
    });
    expect(await session.restore(), isTrue);
    final incoming = <String>[];
    WKIM.shared.messageManager.addOnNewMsgListener('policy-probe-$deviceId', (
      messages,
    ) {
      for (final message in messages) {
        if (message.messageContent case WKTextContent content) {
          incoming.add(content.content);
        }
      }
    });
    for (var attempt = 0; attempt < 100; attempt++) {
      if (service.connectionState == ImConnectionState.connected) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    expect(service.connectionState, ImConnectionState.connected);
    if (expectPolicyCycle) {
      Future<bool> messagingEnabled() async {
        final result = await dio.get<Map<String, dynamic>>(
          '/api/v1/server-info',
        );
        final capabilities = Map<String, dynamic>.from(
          result.data!['capabilities'] as Map,
        );
        return capabilities['messaging'] as bool;
      }

      for (var attempt = 0; attempt < 1800; attempt++) {
        if (!await messagingEnabled()) break;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(await messagingEnabled(), isFalse);
      for (var attempt = 0; attempt < 100; attempt++) {
        if (service.connectionState != ImConnectionState.connected) break;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(service.connectionState, isNot(ImConnectionState.connected));
      await Future<void>.delayed(const Duration(seconds: 3));
      expect(service.connectionState, isNot(ImConnectionState.connected));

      for (var attempt = 0; attempt < 1800; attempt++) {
        if (await messagingEnabled()) break;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(await messagingEnabled(), isTrue);
      expect(await session.refreshOnce(), isTrue);
      await session.reapplySession();
      for (var attempt = 0; attempt < 100; attempt++) {
        if (service.connectionState == ImConnectionState.connected) break;
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      expect(service.connectionState, ImConnectionState.connected);
      if (peerUsername.isNotEmpty && runId.isNotEmpty) {
        final friends = await api.getFriendsApi().friendsList();
        final peer = friends.data!
            .singleWhere((item) => item.user.username == peerUsername)
            .user;
        final marker = 'policy-recovery:$runId:$username';
        final expected = 'policy-recovery:$runId:$peerUsername';
        await WKIM.shared.messageManager.sendMessage(
          WKTextContent(marker),
          WKChannel(peer.id, 1),
        );
        for (var attempt = 0; attempt < 300; attempt++) {
          if (incoming.contains(expected)) break;
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
        expect(incoming, contains(expected));
      }
      return;
    }
    // Keep the native socket alive long enough for the external probe to
    // inspect connz and exercise device_quit.
    await Future<void>.delayed(const Duration(seconds: 60));
  }, skip: deviceId.isEmpty);
}
