import 'package:dio/dio.dart' show Dio;
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/wkim.dart';

void main() {
  test('refresh updates the current SDK credentials without reconnecting', () {
    final previous = WKIM.shared.options;
    final dio = Dio();
    final service = ImService(dio);
    addTearDown(() {
      service.dispose();
      WKIM.shared.options = previous;
      dio.close(force: true);
    });
    final options = Options.newDefault(
      'current-user',
      'old',
      addr: 'localhost:5100',
    );
    WKIM.shared.options = options;
    options.deviceId = 'installation-a';
    service.updateCredentials(
      const StoredTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        imUid: 'current-user',
        imToken: 'new',
        imAddress: 'localhost:5201',
      ),
    );
    expect(WKIM.shared.options, same(options));
    expect(options.token, 'new');
    // Flutter unit tests default to Android; localhost is mapped for its emulator.
    expect(options.addr, '10.0.2.2:5201');
    expect(options.deviceId, 'installation-a');
    expect(service.connectionState, ImConnectionState.disconnected);
    service.updateCredentials(
      const StoredTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        imUid: 'different-user',
        imToken: 'wrong',
        imAddress: 'localhost:6000',
      ),
    );
    expect(options.uid, 'current-user');
    expect(options.token, 'new');
    expect(options.addr, '10.0.2.2:5201');
  });
}
