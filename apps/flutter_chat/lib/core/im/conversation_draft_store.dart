import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConversationDraftStore {
  ConversationDraftStore({
    FlutterSecureStorage? storage,
    this.namespace = 'default',
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final String namespace;

  String _key(String uid, String channelId, int channelType) =>
      'chat.draft.$namespace.$uid.$channelType.$channelId';

  Future<String> read(String uid, String channelId, int channelType) async =>
      await _storage.read(key: _key(uid, channelId, channelType)) ?? '';

  Future<void> write(
    String uid,
    String channelId,
    int channelType,
    String value,
  ) async {
    final key = _key(uid, channelId, channelType);
    if (value.trim().isEmpty) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }
}
