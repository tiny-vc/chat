import 'dart:async';
import 'dart:io';

// Reproduce the SDK's add + unawaited flush pattern on a real loopback socket.
Future<void> main() async {
  final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final accepted = Completer<Socket>();
  final listener = server.listen((socket) => accepted.complete(socket));
  final client = await Socket.connect(server.address, server.port);
  final peer = await accepted.future;
  var received = 0;
  final reads = peer.listen((bytes) => received += bytes.length);
  var errors = 0;
  final flushes = <Future<void>>[];
  for (var i = 0; i < 100; i++) {
    try {
      client.add([i]);
      flushes.add(client.flush().then<void>((_) {}, onError: (Object error) {
        errors++;
      }));
    } catch (error) {
      errors++;
    }
  }
  await Future.wait(flushes);
  await Future<void>.delayed(const Duration(milliseconds: 100));
  stdout.writeln('attempted=100 received=$received writeErrors=$errors');
  client.destroy();
  peer.destroy();
  await reads.cancel();
  await listener.cancel();
  await server.close();
  if (errors == 0) exitCode = 1;
}
