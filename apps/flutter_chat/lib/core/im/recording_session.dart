/// Serializes native recorder operations and waits for them before disposal.
class RecordingSession {
  RecordingSession({
    required this.startRecorder,
    required this.stopRecorder,
    required this.cancelRecorder,
    required this.disposeRecorder,
    required this.discardFile,
  });
  final Future<void> Function() startRecorder;
  final Future<String?> Function() stopRecorder;
  final Future<void> Function() cancelRecorder;
  final Future<void> Function() disposeRecorder;
  final Future<void> Function(String) discardFile;
  bool recording = false;
  bool _closed = false;
  Future<void>? _pending;
  Future<void>? _closing;
  bool get busy => _pending != null;

  Future<T?> _run<T>(Future<T> Function() operation) async {
    if (_closed || busy) return null;
    final task = Future<T>.sync(operation);
    // Observe completion separately so close can wait even if the action fails.
    _pending = task.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    try {
      return await task;
    } finally {
      _pending = null;
    }
  }

  Future<bool> start() async =>
      await _run(() async {
        if (recording) return false;
        await startRecorder();
        recording = true;
        return !_closed;
      }) ??
      false;

  Future<String?> stop() => _run<String?>(() async {
    if (!recording) return null;
    final path = await stopRecorder();
    recording = false;
    if (_closed && path != null) {
      await discardFile(path);
      return null;
    }
    return path;
  });

  Future<bool> cancel() async =>
      await _run(() async {
        if (!recording) return false;
        await cancelRecorder();
        recording = false;
        return true;
      }) ??
      false;

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _closed = true;
    await _pending;
    try {
      if (recording) await cancelRecorder();
    } finally {
      recording = false;
      await disposeRecorder();
    }
  }
}
