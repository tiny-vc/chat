import 'dart:async';

import 'package:flutter_chat/core/calls/call_room_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart';

class _RecordingRoom extends Room {
  final calls = <String>[];
  final prepare = Completer<void>();

  @override
  Future<void> prepareConnection(String url, String? token) async {
    calls.add('prepare');
    await prepare.future;
  }

  @override
  Future<void> connect(
    String url,
    String token, {
    ConnectOptions? connectOptions,
    RoomOptions? roomOptions,
    FastConnectOptions? fastConnectOptions,
  }) async {
    calls.add('connect');
  }

  @override
  Future<void> disconnect() async {
    calls.add('disconnect');
  }

  // Fake native resource; calling Room.dispose would dispose its real engine.
  @override
  // ignore: must_call_super
  Future<bool> dispose() async {
    calls.add('dispose');
    return true;
  }
}

void main() {
  test('room defaults enable scalable video adaptation', () {
    const options = CallRoomSession.defaultRoomOptions;
    expect(options.adaptiveStream, isTrue);
    expect(options.dynacast, isTrue);
    expect(options.defaultVideoPublishOptions.simulcast, isTrue);
    expect(options.defaultAudioCaptureOptions.echoCancellation, isTrue);
    expect(options.defaultAudioCaptureOptions.noiseSuppression, isTrue);
    expect(options.defaultAudioCaptureOptions.autoGainControl, isTrue);
    expect(options.defaultAudioCaptureOptions.highPassFilter, isTrue);
    expect(options.defaultAudioCaptureOptions.voiceIsolation, isTrue);
    expect(options.defaultAudioPublishOptions.encoding?.maxBitrate, 32000);
    expect(
      options.defaultAudioPublishOptions.encoding?.bitratePriority,
      Priority.high,
    );
    expect(options.defaultAudioPublishOptions.dtx, isTrue);
    expect(options.defaultAudioPublishOptions.red, isTrue);
  });

  test('initial connection failure remains retryable rather than terminal', () {
    final session = CallRoomSession();
    addTearDown(session.dispose);

    session.resetForConnection();
    session.markConnectionFailed();

    expect(session.connected, isFalse);
    expect(session.phase, CallRoomPhase.connectionFailed);
    expect(session.recovery.canRetry, isTrue);
    expect(session.recovery.failure, isNull);
  });

  test('prepares the LiveKit endpoint before connecting', () async {
    final room = _RecordingRoom();
    final session = CallRoomSession(room: room);
    final connecting = session.connect('wss://media.example', 'token');
    await Future<void>.delayed(Duration.zero);
    expect(room.calls, ['prepare']);

    room.prepare.complete();
    await connecting;

    expect(room.calls, ['prepare', 'connect']);
    session.dispose();
  });

  test('disposal during prewarming prevents a late connection', () async {
    final room = _RecordingRoom();
    final session = CallRoomSession(room: room);
    final connecting = session.connect('wss://media.example', 'token');
    await Future<void>.delayed(Duration.zero);

    session.dispose();
    room.prepare.complete();
    await expectLater(connecting, throwsStateError);
    await Future<void>.delayed(Duration.zero);

    expect(room.calls, ['prepare', 'dispose']);
  });
}
