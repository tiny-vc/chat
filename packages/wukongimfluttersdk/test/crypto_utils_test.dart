import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/common/crypto_utils.dart';

void main() {
  test('AES-CBC payload remains deterministic and round-trips UTF-8', () {
    CryptoUtils.aesKey = '0123456789abcdef';
    CryptoUtils.salt = 'abcdef0123456789';

    final encrypted = CryptoUtils.aesEncrypt('消息 payload');

    // OpenSSL AES-128-CBC/PKCS7 interoperability vector.
    expect(encrypted, '5ZjF2NL67euJNIpzJt/ojA==');
    expect(CryptoUtils.aesDecrypt(encrypted), '消息 payload');
  });
}
