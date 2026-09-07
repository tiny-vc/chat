import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

String validateImAddress(String value) {
  final address = value.trim();
  if (address.isEmpty ||
      address.length > 512 ||
      address != value ||
      address.contains(RegExp(r'[\s/@?#]')) ||
      address.contains('://')) {
    throw const FormatException('服务器返回了无效的即时消息服务地址。');
  }
  final uri = Uri.tryParse('tcp://$address');
  if (uri == null ||
      uri.host.isEmpty ||
      !uri.hasPort ||
      uri.port < 1 ||
      uri.port > 65535 ||
      (uri.path.isNotEmpty && uri.path != '/')) {
    throw const FormatException('服务器返回了无效的即时消息服务地址。');
  }
  return address;
}

class StoredTokens {
  const StoredTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.imUid,
    required this.imToken,
    required this.imAddress,
  });

  final String accessToken;
  final String refreshToken;
  final String imUid;
  final String imToken;
  final String imAddress;
}

abstract interface class TokenStore {
  Future<StoredTokens?> read();
  Future<void> write(StoredTokens tokens);
  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  SecureTokenStore({
    FlutterSecureStorage? storage,
    String namespace = 'default',
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _namespace = namespace;

  final String _namespace;
  String get _accessKey => 'chat.$_namespace.access_token';
  String get _refreshKey => 'chat.$_namespace.refresh_token';
  String get _imUidKey => 'chat.$_namespace.im_uid';
  String get _imTokenKey => 'chat.$_namespace.im_token';
  String get _imAddressKey => 'chat.$_namespace.im_address';
  final FlutterSecureStorage _storage;

  @override
  Future<StoredTokens?> read() async {
    final values = await Future.wait([
      _storage.read(key: _accessKey),
      _storage.read(key: _refreshKey),
      _storage.read(key: _imUidKey),
      _storage.read(key: _imTokenKey),
      _storage.read(key: _imAddressKey),
    ]);
    if (values.any((value) => value == null)) return null;
    return StoredTokens(
      accessToken: values[0]!,
      refreshToken: values[1]!,
      imUid: values[2]!,
      imToken: values[3]!,
      imAddress: validateImAddress(values[4]!),
    );
  }

  @override
  Future<void> write(StoredTokens tokens) async {
    final imAddress = validateImAddress(tokens.imAddress);
    // Refresh tokens rotate on every use. Persist the new refresh token first so
    // an interrupted write never leaves a new access token with an invalid old refresh token.
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
    await _storage.write(key: _imUidKey, value: tokens.imUid);
    await _storage.write(key: _imTokenKey, value: tokens.imToken);
    await _storage.write(key: _imAddressKey, value: imAddress);
    await _storage.write(key: _accessKey, value: tokens.accessToken);
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
      _storage.delete(key: _imUidKey),
      _storage.delete(key: _imTokenKey),
      _storage.delete(key: _imAddressKey),
    ]);
  }
}

class InstallationIdStore {
  InstallationIdStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'chat.installation_id';
  final FlutterSecureStorage _storage;

  Future<String> getOrCreate() async {
    final existing = await _storage.read(key: _key);
    if (existing != null) return existing;
    final created = const Uuid().v4();
    await _storage.write(key: _key, value: created);
    return created;
  }
}
