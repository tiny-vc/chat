import 'package:dio/dio.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class FixedInstallationIdStore extends InstallationIdStore {
  FixedInstallationIdStore(this.value);
  final String value;
  @override
  Future<String> getOrCreate() async => value;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const deviceId = String.fromEnvironment('PROBE_DEVICE_ID');
  testWidgets('holds one labelled WuKongIM device connection', (_) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
    final response = await dio.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {
        'username': 'alice_test',
        'password': 'secure-password-123',
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
    addTearDown(() {
      service.dispose();
      dio.close(force: true);
    });
    await service.updateSession(
      StoredTokens(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
        imUid: im['uid'] as String,
        imToken: im['token'] as String,
        imAddress: im['address'] as String,
      ),
    );
    for (var attempt = 0; attempt < 100; attempt++) {
      if (service.connectionState == ImConnectionState.connected) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    expect(service.connectionState, ImConnectionState.connected);
    // Keep the native socket alive long enough for the external probe to
    // inspect connz and exercise device_quit.
    await Future<void>.delayed(const Duration(seconds: 60));
  }, skip: deviceId.isEmpty);
}
