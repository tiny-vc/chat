import 'dart:convert';

import 'package:flutter_chat/core/im/read_receipt_outbox.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryPendingReadStore implements PendingReadStore {
  final values = <String, String>{};
  @override
  Future<void> delete(String key) async => values.remove(key);
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  test('keeps only the highest cursor and removes it after success', () async {
    final store = MemoryPendingReadStore();
    final sent = <int>[];
    final outbox = ReadReceiptOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _, sequence) async => sent.add(sequence),
    );
    await outbox.record('user', 'channel', 1, 4);
    await outbox.record('user', 'channel', 1, 3);
    await outbox.record('user', 'channel', 1, 9);
    await outbox.flush('user');

    expect(sent, [9]);
    expect(store.values, isEmpty);
  });

  test('survives failure and retries after a new instance starts', () async {
    final store = MemoryPendingReadStore();
    final failing = ReadReceiptOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _, _) async => throw StateError('offline'),
    );
    await failing.record('user', 'channel', 2, 7);
    await failing.flush('user');
    expect(store.values, isNotEmpty);

    final sent = <int>[];
    final restarted = ReadReceiptOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _, sequence) async => sent.add(sequence),
    );
    await restarted.flush('user');
    expect(sent, [7]);
    expect(store.values, isEmpty);
  });

  test('isolates pending state by server and user', () async {
    final store = MemoryPendingReadStore();
    final outbox = ReadReceiptOutbox(
      namespace: 'server-a',
      store: store,
      send: (_, _, _) async {},
    );
    await outbox.record('user-a', 'channel', 1, 1);
    final key = store.values.keys.single;
    expect(key, contains('server-a.user-a'));
    expect(jsonDecode(store.values[key]!), isA<Map>());
  });
}
