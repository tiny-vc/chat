import 'dart:async';
import 'package:flutter_chat/core/calls/call_recovery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart';

void main() {
  test('temporary loss recovers without a terminal error', () {
    final state = CallRecovery();
    state.reconnecting();
    expect(state.recovering, isTrue);
    expect(state.failure, isNull);
    state.reconnected();
    expect(state.recovering, isFalse);
    expect(state.failure, isNull);
  });
  test(
    'exhausted retries show an actionable failure; manual retry resets it',
    () {
      final state = CallRecovery();
      state.reconnecting();
      state.disconnected(DisconnectReason.reconnectAttemptsExceeded);
      expect(state.recovering, isFalse);
      expect(state.failure, contains('自动恢复未成功'));
      expect(state.canRetry, isTrue);
      state.reset();
      expect(state.failure, isNull);
    },
  );
  test(
    'closed room and duplicate device do not offer misleading reconnect',
    () {
      for (final reason in [
        DisconnectReason.roomDeleted,
        DisconnectReason.participantRemoved,
        DisconnectReason.duplicateIdentity,
      ]) {
        final state = CallRecovery()..disconnected(reason);
        expect(state.canRetry, isFalse);
        state.reconnecting();
        expect(state.recovering, isFalse);
        expect(state.failure, isNotNull);
      }
    },
  );
  test('hangup persists before leaving without waiting for delivery', () async {
    final order = <String>[];
    await reportCallEnd(
      () async => order.add('persist'),
      () async => order.add('deliver'),
      () => order.add('leave'),
    );
    expect(order.take(2), ['persist', 'leave']);
    await Future<void>.delayed(Duration.zero);
    expect(order, ['persist', 'leave', 'deliver']);
  });
  test('synchronous report failure cannot prevent local hangup', () async {
    var left = false;
    await reportCallEnd(
      () => throw StateError('storage unavailable'),
      () async {},
      () => left = true,
    );
    await Future<void>.delayed(Duration.zero);
    expect(left, isTrue);
  });
  test(
    'terminal report retries briefly without delaying local hangup',
    () async {
      var calls = 0;
      var left = false;
      final succeeded = Completer<void>();
      await reportCallEnd(
        () async {},
        () async {
          calls++;
          if (calls < 3) throw StateError('network switching');
          succeeded.complete();
        },
        () => left = true,
        attemptTimeout: const Duration(milliseconds: 50),
        retryDelay: Duration.zero,
      );

      expect(left, isTrue);
      await succeeded.future;
      expect(calls, 3);
    },
  );
}
