import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Keeps an established Android call alive when the Flutter activity is
/// backgrounded. iOS uses the audio background mode declared in Info.plist.
class CallPlatformService {
  CallPlatformService({
    TargetPlatform? platform,
    Future<void> Function(String method, Map<String, Object?>? arguments)?
    invoke,
  }) : _platform = platform ?? defaultTargetPlatform,
       _invoke = invoke ?? _invokeChannel;

  static const _channel = MethodChannel('chat/call_lifecycle');
  final TargetPlatform _platform;
  final Future<void> Function(String, Map<String, Object?>?) _invoke;
  bool _started = false;

  static Future<void> _invokeChannel(
    String method,
    Map<String, Object?>? arguments,
  ) => _channel.invokeMethod<void>(method, arguments);

  Future<void> start({required bool video}) async {
    if (_platform != TargetPlatform.android || _started) return;
    await _invoke('start', {'video': video});
    _started = true;
  }

  Future<void> stop() async {
    if (_platform != TargetPlatform.android || !_started) return;
    // Mark stopped before crossing the platform boundary so repeated disposal
    // cannot issue duplicate stop requests if the engine is shutting down.
    _started = false;
    await _invoke('stop', null);
  }
}
