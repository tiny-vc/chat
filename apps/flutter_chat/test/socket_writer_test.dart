import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/common/serialized_socket_writer.dart';

class _Sink implements IOSink {
  final packets = <List<int>>[];
  final flushes = <Completer<void>>[];
  bool bound = false;
  @override
  void add(List<int> bytes) {
    if (bound) throw StateError('StreamSink is bound to a stream');
    packets.add(List.of(bytes));
  }

  @override
  Future<void> flush() {
    bound = true;
    final pending = Completer<void>();
    flushes.add(pending);
    return pending.future.whenComplete(() => bound = false);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> tick() => Future<void>.delayed(Duration.zero);

void main() {
  test(
    'concurrent writes serialize add and flush and snapshot bytes',
    () async {
      final sink = _Sink();
      final writer = SerializedSocketWriter(sink);
      final bytes = [1];
      final first = writer.send(bytes);
      bytes[0] = 99;
      final second = writer.send([2]);
      await tick();
      expect(sink.packets, [
        [1],
      ]);
      sink.flushes[0].complete();
      await first;
      await tick();
      expect(sink.packets, [
        [1],
        [2],
      ]);
      sink.flushes[1].complete();
      await second;
    },
  );

  test(
    'flush failure rejects queued packets and does not reuse failed sink',
    () async {
      final sink = _Sink();
      final writer = SerializedSocketWriter(sink);
      final first = expectLater(writer.send([1]), throwsStateError);
      final queued = expectLater(writer.send([2]), throwsStateError);
      await tick();
      sink.flushes.single.completeError(StateError('connection reset'));
      await Future.wait([first, queued]);
      await expectLater(writer.send([3]), throwsStateError);
      expect(sink.packets, [
        [1],
      ]);
    },
  );

  test(
    'close invalidates queued packets; replacement connection is independent',
    () async {
      final oldSink = _Sink();
      final old = SerializedSocketWriter(oldSink);
      final sent = old.send([1]);
      final dropped = expectLater(old.send([2]), throwsStateError);
      await tick();
      old.close();
      final newSink = _Sink();
      final replacement = SerializedSocketWriter(newSink);
      final fresh = replacement.send([3]);
      oldSink.flushes.single.complete();
      await sent;
      await dropped;
      await tick();
      newSink.flushes.single.complete();
      await fresh;
      expect(oldSink.packets, [
        [1],
      ]);
      expect(newSink.packets, [
        [3],
      ]);
      await expectLater(old.send([4]), throwsStateError);
    },
  );

  test('close before first write sends nothing', () async {
    final sink = _Sink();
    final writer = SerializedSocketWriter(sink);
    final pending = expectLater(writer.send([1]), throwsStateError);
    writer.close();
    await pending;
    expect(sink.packets, isEmpty);
  });

  test(
    'real loopback receives 1000 concurrent packets in exact order',
    () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final accepted = Completer<Socket>();
      final listener = server.listen(accepted.complete);
      final client = await Socket.connect(server.address, server.port);
      final peer = await accepted.future;
      final expected = List.generate(
        1000,
        (i) => [i ~/ 256, i % 256],
      ).expand((b) => b).toList();
      final received = <int>[];
      final complete = Completer<void>();
      final reader = peer.listen((bytes) {
        received.addAll(bytes);
        if (received.length >= expected.length && !complete.isCompleted) {
          complete.complete();
        }
      });
      try {
        final writer = SerializedSocketWriter(client);
        await Future.wait(
          List.generate(1000, (i) => writer.send([i ~/ 256, i % 256])),
        );
        await complete.future.timeout(const Duration(seconds: 10));
        expect(received, orderedEquals(expected));
        writer.close();
      } finally {
        client.destroy();
        peer.destroy();
        await reader.cancel();
        await listener.cancel();
        await server.close();
      }
    },
  );
}
