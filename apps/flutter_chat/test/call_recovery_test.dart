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
  test(
    'hangup leaves before the API responds and swallows offline failures',
    () async {
      final pending = Completer<void>();
      final order = <String>[];
      reportCallEnd(() {
        order.add('report');
        return pending.future;
      }, () => order.add('leave'));
      expect(order, ['leave', 'report']);
      pending.completeError(StateError('offline'));
      await Future<void>.delayed(Duration.zero);
    },
  );
  test('synchronous report failure cannot prevent local hangup', () async {
    var left = false;
    reportCallEnd(() => throw StateError('offline'), () => left = true);
    await Future<void>.delayed(Duration.zero);
    expect(left, isTrue);
  });
}
