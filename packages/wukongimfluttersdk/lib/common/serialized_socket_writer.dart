// Local modification, 2026-09-03. See PATCHES.md.
import 'dart:io';

/// Serializes add AND flush; writing while a previous flush is pending can
/// otherwise throw "StreamSink is bound to a stream" and lose a packet.
class SerializedSocketWriter {
  SerializedSocketWriter(this._sink);

  final IOSink _sink;
  Future<void> _tail = Future<void>.value();
  bool _closed = false;
  bool _failed = false;

  Future<void> send(List<int> bytes) {
    // The caller may reuse/mutate its encode buffer before this write runs.
    final packet = List<int>.of(bytes);
    final operation = _tail.then((_) async {
      if (_closed || _failed) throw StateError('Socket writer is closed');
      _sink.add(packet);
      await _sink.flush();
    });
    // Observe internal errors without hiding failure from the caller. A failed
    // transport must be replaced, not reused for subsequent queued packets.
    _tail = operation.catchError((Object error) {
      _failed = true;
    });
    return operation;
  }

  /// The owner destroys the old socket; queued packets must never cross over
  /// to its replacement connection (they may use the old encryption key).
  void close() => _closed = true;
}
