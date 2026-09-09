import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/wkim.dart';

void main() {
  test('only terminal offline states require an app-level reconnect', () {
    expect(ImService.shouldReconnect(ImConnectionState.noNetwork), isTrue);
    expect(ImService.shouldReconnect(ImConnectionState.disconnected), isTrue);
    expect(ImService.shouldReconnect(ImConnectionState.connecting), isFalse);
    expect(ImService.shouldReconnect(ImConnectionState.connected), isFalse);
    expect(ImService.shouldReconnect(ImConnectionState.kicked), isFalse);
  });

  test(
    'available network event reconnects a stale offline transport once',
    () async {
      final changes = StreamController<List<ConnectivityResult>>.broadcast();
      var clears = 0;
      var connects = 0;
      final service = ImService(
        Dio(),
        networkChanges: changes.stream,
        hasCredentials: () => true,
        clearNetworkUnavailable: () => clears++,
        connectTransport: () => connects++,
      )..connectionState = ImConnectionState.noNetwork;
      addTearDown(() async {
        service.dispose();
        await changes.close();
      });

      changes.add(const [ConnectivityResult.none]);
      await Future<void>.delayed(Duration.zero);
      expect(connects, 0);

      changes.add(const [ConnectivityResult.wifi]);
      await Future<void>.delayed(Duration.zero);
      expect(service.connectionState, ImConnectionState.connecting);
      expect(clears, 1);
      expect(connects, 1);

      changes.add(const [ConnectivityResult.mobile]);
      await Future<void>.delayed(Duration.zero);
      expect(connects, 1);
    },
  );

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
