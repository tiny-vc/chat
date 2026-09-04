import 'package:flutter/foundation.dart';

/// Commits UI state only after the underlying device operation succeeds.
class CallControls extends ChangeNotifier {
  CallControls({
    required this.setMicrophone,
    required this.setCamera,
    required this.setSpeaker,
    bool speaker = false,
  }) : _speaker = speaker;

  final Future<void> Function(bool) setMicrophone;
  final Future<void> Function(bool) setCamera;
  final Future<void> Function(bool) setSpeaker;
  bool _microphone = true;
  bool _camera = true;
  bool _speaker;
  bool _busy = false;
  bool _disposed = false;
  bool get microphone => _microphone;
  bool get camera => _camera;
  bool get speaker => _speaker;
  bool get busy => _busy;

  Future<void> toggleMicrophone() => run(() async {
    final next = !_microphone;
    await setMicrophone(next);
    if (!_disposed) _microphone = next;
  });

  Future<void> toggleCamera() => setCameraEnabled(!_camera);

  Future<void> setCameraEnabled(bool enabled) => run(() async {
    if (_camera == enabled) return;
    await setCamera(enabled);
    if (!_disposed) _camera = enabled;
  });

  Future<void> toggleSpeaker() => run(() async {
    final next = !_speaker;
    await setSpeaker(next);
    if (!_disposed) _speaker = next;
  });

  Future<void> run(Future<void> Function() operation) async {
    if (_busy || _disposed) return;
    _busy = true;
    notifyListeners();
    try {
      await operation();
    } finally {
      _busy = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
