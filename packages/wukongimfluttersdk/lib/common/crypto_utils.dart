import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

import 'package:x25519/x25519.dart';

class CryptoUtils {
  static String aesKey = "";
  static String salt = "";
  static List<int>? dhPrivateKey;
  static List<int>? dhPublicKey;

  static init() {
    var keyPair = generateKeyPair();
    dhPrivateKey = keyPair.privateKey;
    dhPublicKey = keyPair.publicKey;
  }

  static generateMD5(String content) {
    return md5.convert(utf8.encode(content)).toString();
  }

  static setServerKeyAndSalt(String serverKey, String salt) {
    CryptoUtils.salt = salt;
    var sharedSecret = X25519(dhPrivateKey!, base64Decode(serverKey));
    var key = generateMD5(base64Encode(sharedSecret));
    if (key != "" && key.length > 16) {
      aesKey = key.substring(0, 16);
    } else {
      aesKey = key;
    }
  }

  // 加密
  static String aesEncrypt(String content) {
    final cipher = _aesCipher(true);
    return base64Encode(cipher.process(Uint8List.fromList(utf8.encode(content))));
  }

  // 解密
  static String aesDecrypt(String content) {
    final cipher = _aesCipher(false);
    return utf8.decode(cipher.process(base64Decode(content)));
  }

  static PaddedBlockCipher _aesCipher(bool encrypting) {
    final key = Uint8List.fromList(aesKey.codeUnits);
    final iv = Uint8List.fromList(salt.codeUnits);
    final cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    );
    cipher.init(
      encrypting,
      PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv),
        null,
      ),
    );
    return cipher;
  }
}
