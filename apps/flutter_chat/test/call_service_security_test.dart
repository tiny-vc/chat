import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('call ID validation', () {
    test('accepts and normalizes a canonical UUID', () {
      expect(
        validateCallId('AAAAAAAA-AAAA-4AAA-8AAA-AAAAAAAAAAAA'),
        'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      );
    });

    test('rejects empty, non-UUID and path-bearing values', () {
      for (final value in [
        '',
        'call',
        '../users/me',
        '11111111-1111-4111-8111-111111111111/token?admin=true',
        ' 11111111-1111-4111-8111-111111111111',
      ]) {
        expect(() => validateCallId(value), throwsFormatException);
      }
    });
  });

  group('LiveKit URL validation', () {
    test('accepts WSS for an HTTPS business server', () {
      expect(
        validateLiveKitUrl(
          'wss://livekit.example.com',
          apiBaseUrl: 'https://chat.example.com',
        ),
        'wss://livekit.example.com',
      );
    });

    test('rejects plaintext signaling for an HTTPS business server', () {
      expect(
        () => validateLiveKitUrl(
          'ws://livekit.example.com',
          apiBaseUrl: 'https://chat.example.com',
        ),
        throwsFormatException,
      );
    });

    test('allows WS for local development over HTTP', () {
      expect(
        validateLiveKitUrl(
          'ws://localhost:7880',
          apiBaseUrl: 'http://localhost:3000',
        ),
        contains(':7880'),
      );
    });

    test('rejects credentials and non-WebSocket schemes', () {
      expect(
        () => validateLiveKitUrl(
          'https://livekit.example.com',
          apiBaseUrl: 'https://chat.example.com',
        ),
        throwsFormatException,
      );
      expect(
        () => validateLiveKitUrl(
          'wss://user:password@livekit.example.com',
          apiBaseUrl: 'https://chat.example.com',
        ),
        throwsFormatException,
      );
    });
  });

  test('only final business call states are terminal', () {
    for (final status in ['INVITING', 'RINGING', 'ACCEPTED', 'CONNECTED']) {
      expect(CallState(status: status).terminal, isFalse);
    }
    for (final status in [
      'REJECTED',
      'CANCELLED',
      'MISSED',
      'ENDED',
      'FAILED',
    ]) {
      expect(CallState(status: status).terminal, isTrue);
    }
  });
}
