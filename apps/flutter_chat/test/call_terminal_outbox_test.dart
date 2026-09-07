import 'dart:convert';

import 'package:flutter_chat/core/calls/call_terminal_outbox.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryPendingCallTerminalStore implements PendingCallTerminalStore {
  final values = <String, String>{};

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  test('records before sending and removes the entry after success', () async {
    final store = MemoryPendingCallTerminalStore();
    var wasDurableDuringSend = false;
    final outbox = CallTerminalOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _) async {
        wasDurableDuringSend = store.values.isNotEmpty;
      },
    );

    await outbox.recordAndFlush('call-1', 'end');

    expect(wasDurableDuringSend, isTrue);
    expect(store.values, isEmpty);
  });

  test('survives process restart and retries the original action', () async {
    final store = MemoryPendingCallTerminalStore();
    final failing = CallTerminalOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _) async => throw StateError('offline'),
    );
    await failing.recordAndFlush('call-1', 'miss');
    expect(store.values, isNotEmpty);

    final sent = <String>[];
    final restarted = CallTerminalOutbox(
      namespace: 'server-a',
      store: store,
      send: (callId, action) async => sent.add('$callId:$action'),
    );
    await restarted.flush();

    expect(sent, ['call-1:miss']);
    expect(store.values, isEmpty);
  });

  test('first terminal action wins when delivery is pending', () async {
    final store = MemoryPendingCallTerminalStore();
    final outbox = CallTerminalOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _) async => throw StateError('offline'),
    );

    await outbox.recordAndFlush('call-1', 'cancel');
    await outbox.recordAndFlush('call-1', 'end');

    final encoded = store.values.values.single;
    final pending = jsonDecode(encoded) as List<dynamic>;
    expect(pending, hasLength(1));
    expect((pending.single as Map<String, dynamic>)['action'], 'cancel');
  });

  test('isolates pending actions by server namespace', () async {
    final store = MemoryPendingCallTerminalStore();
    final outbox = CallTerminalOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _) async => throw StateError('offline'),
    );

    await outbox.recordAndFlush('call-1', 'reject');

    expect(store.values.keys.single, contains('server-a'));
  });
}
