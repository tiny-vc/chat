import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

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
      imAddress: values[4]!,
    );
  }

  @override
  Future<void> write(StoredTokens tokens) async {
    // Refresh tokens rotate on every use. Persist the new refresh token first so
    // an interrupted write never leaves a new access token with an invalid old refresh token.
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
    await _storage.write(key: _imUidKey, value: tokens.imUid);
    await _storage.write(key: _imTokenKey, value: tokens.imToken);
    await _storage.write(key: _imAddressKey, value: tokens.imAddress);
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
