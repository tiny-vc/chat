import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class PendingReadStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecurePendingReadStore implements PendingReadStore {
  SecurePendingReadStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

typedef SendPendingRead =
    Future<void> Function(String channelId, int channelType, int messageSeq);

/// A durable, monotonic outbox for read cursors.
///
/// Recording happens before the HTTP request. A crash, timeout, token refresh,
/// or process restart therefore leaves enough information to retry. Only the
/// highest sequence per conversation is retained.
class ReadReceiptOutbox {
  ReadReceiptOutbox({
    required this.namespace,
    required this.send,
    PendingReadStore? store,
  }) : _store = store ?? SecurePendingReadStore();

  final String namespace;
  final SendPendingRead send;
  final PendingReadStore _store;
  Future<void> _tail = Future.value();

  String _storageKey(String uid) => 'chat.pending-reads.$namespace.$uid';
  String _conversationKey(String channelId, int channelType) =>
      '$channelType:$channelId';

  Future<void> record(
    String uid,
    String channelId,
    int channelType,
    int messageSeq,
  ) => _serialize(() async {
    if (uid.isEmpty || channelId.isEmpty || ![1, 2].contains(channelType)) {
      return;
    }
    final pending = await _load(uid);
    final key = _conversationKey(channelId, channelType);
    final current = pending[key];
    if (current == null || messageSeq > current.messageSeq) {
      pending[key] = _PendingRead(channelId, channelType, messageSeq);
      await _save(uid, pending);
    }
  });

  Future<void> flush(String uid) => _serialize(() => _flush(uid));

  Future<void> _serialize(Future<void> Function() operation) {
    final next = _tail.then((_) => operation());
    _tail = next.catchError((_) {});
    return next;
  }

  Future<void> _flush(String uid) async {
    final snapshot = await _load(uid);
    for (final entry in snapshot.entries) {
      final item = entry.value;
      try {
        await send(item.channelId, item.channelType, item.messageSeq);
      } catch (_) {
        // Keep this and subsequent entries durable for the next reconciliation.
        return;
      }
      final latest = await _load(uid);
      final current = latest[entry.key];
      if (current != null && current.messageSeq <= item.messageSeq) {
        latest.remove(entry.key);
        await _save(uid, latest);
      }
    }
  }

  Future<Map<String, _PendingRead>> _load(String uid) async {
    final encoded = await _store.read(_storageKey(uid));
    if (encoded == null || encoded.isEmpty) return {};
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) return {};
      final result = <String, _PendingRead>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is! Map) continue;
        final channelId = value['channelId']?.toString() ?? '';
        final channelType = value['channelType'];
        final messageSeq = value['messageSeq'];
        if (channelId.isEmpty || channelType is! int || messageSeq is! int) {
          continue;
        }
        result[entry.key.toString()] = _PendingRead(
          channelId,
          channelType,
          messageSeq,
        );
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> _save(String uid, Map<String, _PendingRead> pending) async {
    final key = _storageKey(uid);
    if (pending.isEmpty) {
      await _store.delete(key);
      return;
    }
    await _store.write(
      key,
      jsonEncode({
        for (final entry in pending.entries)
          entry.key: {
            'channelId': entry.value.channelId,
            'channelType': entry.value.channelType,
            'messageSeq': entry.value.messageSeq,
          },
      }),
    );
  }
}

class _PendingRead {
  const _PendingRead(this.channelId, this.channelType, this.messageSeq);
  final String channelId;
  final int channelType;
  final int messageSeq;
}
