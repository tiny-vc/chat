import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/auth/token_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IM address validation', () {
    test('accepts host names, IPv4 and bracketed IPv6 with a valid port', () {
      expect(validateImAddress('im.example.com:5100'), 'im.example.com:5100');
      expect(validateImAddress('192.168.1.8:5100'), '192.168.1.8:5100');
      expect(validateImAddress('[::1]:5100'), '[::1]:5100');
    });

    test('rejects URLs, paths, credentials and invalid ports', () {
      for (final value in [
        'ws://im.example.com:5200',
        'im.example.com:5100/path',
        'user@im.example.com:5100',
        'im.example.com:0',
        'im.example.com:65536',
        'im.example.com',
        ' im.example.com:5100',
      ]) {
        expect(() => validateImAddress(value), throwsFormatException);
      }
    });

    test('Android host replacement never changes a hostname substring', () {
      expect(
        AppConfig.resolveDeviceHost('notlocalhost.example.com:5100'),
        'notlocalhost.example.com:5100',
      );
    });
  });
}
