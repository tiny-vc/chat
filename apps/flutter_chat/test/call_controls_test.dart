import 'dart:async';
import 'package:flutter_chat/core/calls/call_controls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'microphone state changes only after hardware succeeds; rapid taps are ignored',
    () async {
      final pending = Completer<void>();
      var calls = 0;
      final controls = CallControls(
        setMicrophone: (_) async {
          calls++;
          await pending.future;
        },
        setCamera: (_) async {},
        setSpeaker: (_) async {},
      );
      addTearDown(controls.dispose);
      final operation = controls.toggleMicrophone();
      expect(controls.busy, isTrue);
      expect(controls.microphone, isTrue);
      await controls.toggleMicrophone();
      expect(calls, 1);
      pending.complete();
      await operation;
      expect(controls.microphone, isFalse);
      expect(controls.busy, isFalse);
    },
  );

  test('camera failure keeps previous state and permits retry', () async {
    var fail = true;
    final controls = CallControls(
      setMicrophone: (_) async {},
      setCamera: (_) async {
        if (fail) throw StateError('permission denied');
      },
      setSpeaker: (_) async {},
    );
    addTearDown(controls.dispose);
    await expectLater(controls.toggleCamera(), throwsStateError);
    expect(controls.camera, isTrue);
    expect(controls.busy, isFalse);
    fail = false;
    await controls.toggleCamera();
    expect(controls.camera, isFalse);
  });

  test('speaker failure preserves routing UI state', () async {
    final controls = CallControls(
      speaker: true,
      setMicrophone: (_) async {},
      setCamera: (_) async {},
      setSpeaker: (_) async => throw StateError('route unavailable'),
    );
    addTearDown(controls.dispose);
    await expectLater(controls.toggleSpeaker(), throwsStateError);
    expect(controls.speaker, isTrue);
    expect(controls.busy, isFalse);
  });

  test(
    'disposal during device change does not notify or accept new operations',
    () async {
      final pending = Completer<void>();
      var notifications = 0;
      var calls = 0;
      final controls = CallControls(
        setMicrophone: (_) async {
          calls++;
          await pending.future;
        },
        setCamera: (_) async {},
        setSpeaker: (_) async {},
      );
      controls.addListener(() => notifications++);
      final operation = controls.toggleMicrophone();
      controls.dispose();
      pending.complete();
      await operation;
      await controls.toggleMicrophone();
      expect(notifications, 1);
      expect(calls, 1);
    },
  );
}
