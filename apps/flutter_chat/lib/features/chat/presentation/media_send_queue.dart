import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum MediaSendPhase { preparing, uploading, failed }

@immutable
class MediaSendTask {
  const MediaSendTask({
    required this.id,
    required this.label,
    required this.phase,
    required this.progress,
    required this.cancelToken,
    this.error,
    this.retry,
    this.retryLabel,
  });

  final String id;
  final String label;
  final MediaSendPhase phase;
  final double progress;
  final CancelToken cancelToken;
  final String? error;
  final AsyncCallback? retry;
  final String? retryLabel;

  bool get active => phase != MediaSendPhase.failed;

  MediaSendTask copyWith({
    String? label,
    MediaSendPhase? phase,
    double? progress,
    String? error,
    AsyncCallback? retry,
    String? retryLabel,
  }) => MediaSendTask(
    id: id,
    label: label ?? this.label,
    phase: phase ?? this.phase,
    progress: progress ?? this.progress,
    cancelToken: cancelToken,
    error: error,
    retry: retry,
    retryLabel: retryLabel ?? this.retryLabel,
  );
}

class MediaSendQueue extends ChangeNotifier {
  final Map<String, MediaSendTask> _tasks = {};

  List<MediaSendTask> get tasks => List.unmodifiable(_tasks.values);
  bool get hasActive => _tasks.values.any((task) => task.active);

  MediaSendTask start(String label, {CancelToken? cancelToken}) {
    final task = MediaSendTask(
      id: const Uuid().v4(),
      label: label,
      phase: MediaSendPhase.preparing,
      progress: 0,
      cancelToken: cancelToken ?? CancelToken(),
    );
    _tasks[task.id] = task;
    notifyListeners();
    return task;
  }

  void prepare(String id, {required String label}) {
    _replace(
      id,
      (task) => task.copyWith(
        label: label,
        phase: MediaSendPhase.preparing,
        progress: 0,
      ),
    );
  }

  void upload(String id, {String? label, double progress = 0}) {
    _replace(
      id,
      (task) => task.copyWith(
        label: label,
        phase: MediaSendPhase.uploading,
        progress: progress.clamp(0, 1),
      ),
    );
  }

  void progress(String id, int sent, int total) {
    if (total <= 0) return;
    _replace(
      id,
      (task) => task.copyWith(
        phase: MediaSendPhase.uploading,
        progress: (sent / total).clamp(0, 1),
      ),
    );
  }

  void fail(
    String id,
    String error, {
    AsyncCallback? retry,
    String? retryLabel,
  }) {
    _replace(
      id,
      (task) => task.copyWith(
        phase: MediaSendPhase.failed,
        error: error,
        retry: retry,
        retryLabel: retryLabel,
      ),
    );
  }

  void complete(String id) {
    if (_tasks.remove(id) != null) notifyListeners();
  }

  void cancel(String id) {
    final task = _tasks.remove(id);
    if (task == null) return;
    if (!task.cancelToken.isCancelled) task.cancelToken.cancel('用户取消上传');
    notifyListeners();
  }

  Future<void> retry(String id) async {
    final retry = _tasks[id]?.retry;
    if (retry == null) return;
    _tasks.remove(id);
    notifyListeners();
    await retry();
  }

  void cancelAll() {
    for (final task in _tasks.values) {
      if (!task.cancelToken.isCancelled) task.cancelToken.cancel('聊天页面已关闭');
    }
    _tasks.clear();
    notifyListeners();
  }

  void _replace(String id, MediaSendTask Function(MediaSendTask) update) {
    final task = _tasks[id];
    if (task == null) return;
    _tasks[id] = update(task);
    notifyListeners();
  }
}
