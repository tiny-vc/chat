import 'dart:async';

enum DownloadPriority { avatar, interactive, background }

/// Bounds simultaneous transfers and gives user-visible assets priority over
/// thumbnails discovered while scrolling.
class DownloadScheduler {
  DownloadScheduler({this.maxConcurrent = 4}) : assert(maxConcurrent > 0);

  final int maxConcurrent;
  final List<_DownloadTask<dynamic>> _waiting = [];
  int _active = 0;
  bool _closed = false;

  bool get hasWork => _active > 0 || _waiting.isNotEmpty;

  Future<T> schedule<T>(
    Future<T> Function() operation, {
    DownloadPriority priority = DownloadPriority.interactive,
  }) {
    if (_closed) return Future.error(StateError('Download scheduler closed'));
    final task = _DownloadTask<T>(priority, operation);
    final insertion = _waiting.indexWhere(
      (queued) => queued.priority.index > priority.index,
    );
    if (insertion < 0) {
      _waiting.add(task);
    } else {
      _waiting.insert(insertion, task);
    }
    _drain();
    return task.future;
  }

  void _drain() {
    while (!_closed && _active < maxConcurrent && _waiting.isNotEmpty) {
      final task = _waiting.removeAt(0);
      _active++;
      unawaited(
        task.run().whenComplete(() {
          _active--;
          _drain();
        }),
      );
    }
  }

  void close() {
    if (_closed) return;
    _closed = true;
    final error = StateError('Download scheduler closed');
    for (final task in _waiting) {
      task.fail(error);
    }
    _waiting.clear();
  }
}

class _DownloadTask<T> {
  _DownloadTask(this.priority, this._operation);

  final DownloadPriority priority;
  final Future<T> Function() _operation;
  final Completer<T> _completer = Completer<T>();

  Future<T> get future => _completer.future;

  Future<void> run() async {
    try {
      _completer.complete(await _operation());
    } catch (error, stackTrace) {
      _completer.completeError(error, stackTrace);
    }
  }

  void fail(Object error) {
    if (!_completer.isCompleted) _completer.completeError(error);
  }
}
