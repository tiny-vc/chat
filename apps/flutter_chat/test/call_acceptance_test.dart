import 'package:flutter_chat/core/calls/call_acceptance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('connected peer recovers an accept signal missed by the caller UI', () {
    expect(
      shouldConfirmCallAcceptedFromPeer(
        incoming: false,
        accepted: false,
        mediaConnected: true,
        remoteParticipantCount: 1,
      ),
      isTrue,
    );
  });

  test('never infers acceptance without an established remote peer', () {
    for (final state in [
      (incoming: true, accepted: false, connected: true, peers: 1),
      (incoming: false, accepted: true, connected: true, peers: 1),
      (incoming: false, accepted: false, connected: false, peers: 1),
      (incoming: false, accepted: false, connected: true, peers: 0),
    ]) {
      expect(
        shouldConfirmCallAcceptedFromPeer(
          incoming: state.incoming,
          accepted: state.accepted,
          mediaConnected: state.connected,
          remoteParticipantCount: state.peers,
        ),
        isFalse,
      );
    }
  });
}
