import 'package:flutter/foundation.dart';
import 'package:flutter_chat/core/calls/call_platform_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android foreground service start and stop are idempotent', () async {
    final calls = <String>[];
    final service = CallPlatformService(
      platform: TargetPlatform.android,
      invoke: (method, arguments) async {
        calls.add('$method:${arguments?['video']}');
      },
    );

    await service.start(video: true);
    await service.start(video: true);
    await service.stop();
    await service.stop();

    expect(calls, ['start:true', 'stop:null']);
  });

  test('non-Android platforms do not call Android service channel', () async {
    var calls = 0;
    final service = CallPlatformService(
      platform: TargetPlatform.iOS,
      invoke: (_, _) async {
        calls++;
      },
    );

    await service.start(video: false);
    await service.stop();

    expect(calls, 0);
  });

  test(
    'failed start can be retried and failed stop remains idempotent',
    () async {
      var starts = 0;
      var stops = 0;
      final service = CallPlatformService(
        platform: TargetPlatform.android,
        invoke: (method, _) async {
          if (method == 'start' && starts++ == 0) throw StateError('not ready');
          if (method == 'stop') {
            stops++;
            throw StateError('engine closing');
          }
        },
      );

      await expectLater(service.start(video: false), throwsStateError);
      await service.start(video: false);
      await expectLater(service.stop(), throwsStateError);
      await service.stop();

      expect(starts, 2);
      expect(stops, 1);
    },
  );
}
