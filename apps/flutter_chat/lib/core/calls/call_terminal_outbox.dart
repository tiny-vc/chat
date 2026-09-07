import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class PendingCallTerminalStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecurePendingCallTerminalStore implements PendingCallTerminalStore {
  SecurePendingCallTerminalStore([FlutterSecureStorage? storage])
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

typedef SendPendingCallTerminal =
    Future<void> Function(String callId, String action);

/// Durable delivery for idempotent terminal call actions.
///
/// The entry is stored before it is sent, so a process kill or a long offline
/// period can be repaired after the next login/resume. The first terminal
/// action wins for a call, matching the server's terminal state transition.
class CallTerminalOutbox {
  CallTerminalOutbox({
    required this.namespace,
    required this.send,
    PendingCallTerminalStore? store,
  }) : _store = store ?? SecurePendingCallTerminalStore();

  static const _validActions = {'reject', 'busy', 'cancel', 'miss', 'end'};
  static const _maxPending = 100;

  final String namespace;
  final SendPendingCallTerminal send;
  final PendingCallTerminalStore _store;
  Future<void> _tail = Future.value();

  String get _storageKey => 'chat.pending-call-terminals.$namespace';

  Future<void> recordAndFlush(String callId, String action) =>
      _serialize(() async {
        await _record(callId, action);
        await _flush();
      });

  /// Durably queues an action without waiting for the network.
  Future<void> record(String callId, String action) =>
      _serialize(() => _record(callId, action));

  Future<void> flush() => _serialize(_flush);

  Future<void> _record(String callId, String action) async {
    if (callId.isEmpty || !_validActions.contains(action)) return;
    final pending = await _load();
    pending.putIfAbsent(
      callId,
      () => _PendingCallTerminal(callId, action, DateTime.now().toUtc()),
    );
    if (pending.length > _maxPending) pending.remove(pending.keys.first);
    await _save(pending);
  }

  Future<void> _serialize(Future<void> Function() operation) {
    final next = _tail.then((_) => operation());
    _tail = next.catchError((_) {});
    return next;
  }

  Future<void> _flush() async {
    final snapshot = await _load();
    for (final entry in snapshot.entries) {
      try {
        await send(entry.value.callId, entry.value.action);
      } catch (_) {
        return;
      }
      final latest = await _load();
      final current = latest[entry.key];
      if (current != null && current.action == entry.value.action) {
        latest.remove(entry.key);
        await _save(latest);
      }
    }
  }

  Future<Map<String, _PendingCallTerminal>> _load() async {
    final encoded = await _store.read(_storageKey);
    if (encoded == null || encoded.isEmpty) return {};
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! List) return {};
      final result = <String, _PendingCallTerminal>{};
      for (final value in decoded) {
        if (value is! Map) continue;
        final callId = value['callId']?.toString() ?? '';
        final action = value['action']?.toString() ?? '';
        final createdAt = DateTime.tryParse(
          value['createdAt']?.toString() ?? '',
        );
        if (callId.isEmpty ||
            !_validActions.contains(action) ||
            createdAt == null) {
          continue;
        }
        result.putIfAbsent(
          callId,
          () => _PendingCallTerminal(callId, action, createdAt),
        );
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> _save(Map<String, _PendingCallTerminal> pending) async {
    if (pending.isEmpty) {
      await _store.delete(_storageKey);
      return;
    }
    await _store.write(
      _storageKey,
      jsonEncode([
        for (final item in pending.values)
          {
            'callId': item.callId,
            'action': item.action,
            'createdAt': item.createdAt.toIso8601String(),
          },
      ]),
    );
  }
}

class _PendingCallTerminal {
  const _PendingCallTerminal(this.callId, this.action, this.createdAt);
  final String callId;
  final String action;
  final DateTime createdAt;
}
