import 'dart:async';
import 'package:flutter_chat/core/im/recording_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RecordingSession session;
  var starts = 0;
  var stops = 0;
  var cancels = 0;
  var disposals = 0;
  var deleted = <String>[];
  Completer<void>? startPending;
  Completer<String?>? stopPending;
  var failStop = false;
  setUp(() {
    starts = stops = cancels = disposals = 0;
    deleted = [];
    startPending = null;
    stopPending = null;
    failStop = false;
    session = RecordingSession(
      startRecorder: () async {
        starts++;
        await startPending?.future;
      },
      stopRecorder: () async {
        stops++;
        if (failStop) throw StateError('stop failed');
        return stopPending == null
            ? '/test/voice.m4a'
            : await stopPending!.future;
      },
      cancelRecorder: () async {
        cancels++;
      },
      disposeRecorder: () async {
        disposals++;
      },
      discardFile: (path) async {
        deleted.add(path);
      },
    );
  });

  test('rapid start and stop calls invoke the recorder only once', () async {
    startPending = Completer<void>();
    final start = session.start();
    expect(await session.start(), isFalse);
    expect(starts, 1);
    startPending!.complete();
    expect(await start, isTrue);
    stopPending = Completer<String?>();
    final stop = session.stop();
    expect(await session.stop(), isNull);
    expect(stops, 1);
    stopPending!.complete('/test/voice.m4a');
    expect(await stop, '/test/voice.m4a');
    expect(session.recording, isFalse);
    await session.close();
  });

  test('failed stop keeps recording recoverable and unlocks cancel', () async {
    await session.start();
    failStop = true;
    await expectLater(session.stop(), throwsStateError);
    expect(session.busy, isFalse);
    expect(session.recording, isTrue);
    expect(await session.cancel(), isTrue);
    expect(cancels, 1);
    expect(session.recording, isFalse);
    await session.close();
  });

  test(
    'closing waits for a pending start then cancels before disposal',
    () async {
      startPending = Completer<void>();
      final start = session.start();
      final close = session.close();
      expect(disposals, 0);
      startPending!.complete();
      expect(await start, isFalse);
      await close;
      expect(cancels, 1);
      expect(disposals, 1);
      await session.close();
      expect(disposals, 1);
      expect(await session.start(), isFalse);
    },
  );

  test(
    'closing during stop discards the result instead of sending it',
    () async {
      await session.start();
      stopPending = Completer<String?>();
      final stop = session.stop();
      final close = session.close();
      stopPending!.complete('/test/voice.m4a');
      expect(await stop, isNull);
      await close;
      expect(deleted, ['/test/voice.m4a']);
      expect(disposals, 1);
    },
  );

  test(
    'cancel never produces a sendable file and can be followed by a new recording',
    () async {
      await session.start();
      expect(await session.cancel(), isTrue);
      expect(await session.stop(), isNull);
      expect(stops, 0);
      expect(await session.start(), isTrue);
      await session.close();
    },
  );
}
