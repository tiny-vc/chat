import 'package:flutter_chat/core/calls/call_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes outgoing and incoming call flows', () {
    final coordinator = CallCoordinator();
    final outgoing = coordinator.reserveOutgoing(video: true)!;
    expect(coordinator.phase, CoordinatedCallPhase.preparing);
    expect(coordinator.beginIncoming(callId: 'incoming', video: false), isNull);

    coordinator.bind(outgoing, 'outgoing');
    expect(coordinator.activeCallId, 'outgoing');
    expect(coordinator.ownsCall('outgoing'), isTrue);
    coordinator.update(outgoing, CoordinatedCallPhase.connected);
    expect(coordinator.phase, CoordinatedCallPhase.connected);

    coordinator.release(outgoing);
    expect(coordinator.hasActiveCall, isFalse);
  });

  test('stale owners cannot mutate or release the active call', () {
    final coordinator = CallCoordinator();
    final first = coordinator.reserveOutgoing(video: false)!;
    coordinator.release(first);
    final second = coordinator.beginIncoming(callId: 'second', video: true)!;

    coordinator.bind(first, 'stale');
    coordinator.update(first, CoordinatedCallPhase.ended);
    coordinator.release(first);
    expect(coordinator.active, same(second));
    expect(coordinator.activeCallId, 'second');
    expect(coordinator.phase, CoordinatedCallPhase.ringing);
  });

  test('failed media keeps call ownership until the user leaves', () {
    final coordinator = CallCoordinator();
    final call = coordinator.reserveOutgoing(video: false)!;
    coordinator.bind(call, 'retryable');

    coordinator.update(call, CoordinatedCallPhase.failed);

    expect(coordinator.phase, CoordinatedCallPhase.failed);
    expect(coordinator.hasActiveCall, isTrue);
    coordinator.release(call);
    expect(coordinator.phase, CoordinatedCallPhase.ended);
    expect(coordinator.hasActiveCall, isFalse);
  });

  test(
    'buffers a terminal signal that arrives before the call ID is bound',
    () {
      final coordinator = CallCoordinator();
      final call = coordinator.reserveOutgoing(video: false)!;

      coordinator.recordTerminalSignal('fast-reject', 'reject');
      coordinator.bind(call, 'fast-reject');

      expect(coordinator.terminalAction(call), 'reject');
      expect(coordinator.phase, CoordinatedCallPhase.ended);
    },
  );

  test('expired and unknown buffered signals cannot terminate a new call', () {
    var now = DateTime(2026);
    final coordinator = CallCoordinator(now: () => now);
    final call = coordinator.reserveOutgoing(video: false)!;
    coordinator.recordTerminalSignal('call', 'unknown');
    coordinator.recordTerminalSignal('call', 'busy');
    now = now.add(const Duration(minutes: 2));

    coordinator.bind(call, 'call');

    expect(coordinator.terminalAction(call), isNull);
    expect(coordinator.phase, CoordinatedCallPhase.ringing);
  });
}
