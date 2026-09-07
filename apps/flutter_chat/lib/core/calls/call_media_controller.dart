import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/widgets.dart';
import 'package:livekit_client/livekit_client.dart';

import 'call_controls.dart';
import 'call_platform_service.dart';
import 'call_room_session.dart';

/// Owns call media devices, system audio focus and background call lifetime.
///
/// This keeps native media state independent from the call screen so route and
/// interruption changes always update the controls shown to the user.
class CallMediaController extends ChangeNotifier {
  CallMediaController({
    required CallRoomSession session,
    required this.video,
    CallPlatformService? platformService,
  }) : _session = session,
       _platformService = platformService ?? CallPlatformService() {
    controls = CallControls(
      speaker: video,
      setMicrophone: (enabled) async {
        final participant = _session.room.localParticipant;
        if (participant == null) throw StateError('No local participant');
        await participant.setMicrophoneEnabled(enabled);
      },
      setCamera: (enabled) async {
        final participant = _session.room.localParticipant;
        if (participant == null) throw StateError('No local participant');
        await participant.setCameraEnabled(enabled);
      },
      setSpeaker: AudioManager.instance.setSpeakerOutputPreferred,
    )..addListener(_notify);
  }

  final CallRoomSession _session;
  final bool video;
  final CallPlatformService _platformService;
  late final CallControls controls;
  StreamSubscription<AudioInterruptionEvent>? _audioInterruptions;
  StreamSubscription<void>? _noisyAudioRoutes;
  StreamSubscription<AudioDevicesChangedEvent>? _audioDevices;
  bool _disposed = false;
  bool _audioInterrupted = false;
  bool _audioInterruptionMayResume = false;
  bool _microphoneMutedForInterruption = false;
  bool _routeChanged = false;
  bool _backgrounded = false;
  Object? _audioRecoveryError;

  bool get audioInterrupted => _audioInterrupted;
  bool get routeChanged => _routeChanged;
  bool get backgrounded => _backgrounded;
  Object? get audioRecoveryError => _audioRecoveryError;

  Future<void> initialize() async {
    try {
      final session = await AudioSession.instance;
      if (_disposed) return;
      // LiveKit 2.11 owns platform audio activation and routing. We only
      // observe OS interruptions here so the app can restore its mute state.
      _audioInterruptions = session.interruptionEventStream.listen(
        _handleAudioInterruption,
      );
      _noisyAudioRoutes = session.becomingNoisyEventStream.listen((_) {
        if (!_disposed) unawaited(_handleNoisyAudioRoute());
      });
      _audioDevices = session.devicesChangedEventStream.listen((_) {
        if (_disposed) return;
        _routeChanged = true;
        notifyListeners();
      });
    } catch (error) {
      assert(() {
        debugPrint('CALL_AUDIO_SESSION_FAILED $error');
        return true;
      }());
    }
  }

  Future<void> callConnected() async {
    try {
      await _platformService.start(video: video);
    } catch (error) {
      assert(() {
        debugPrint('CALL_BACKGROUND_SERVICE_FAILED $error');
        return true;
      }());
    }
  }

  void handleLifecycle(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _backgrounded = true;
      notifyListeners();
    } else if (state == AppLifecycleState.resumed) {
      _backgrounded = false;
      notifyListeners();
      if (_audioInterrupted && _audioInterruptionMayResume) {
        unawaited(_resumeAfterAudioInterruption());
      }
    }
  }

  void dismissRouteNotice() {
    if (!_routeChanged || _disposed) return;
    _routeChanged = false;
    notifyListeners();
  }

  void dismissAudioRecoveryError() {
    if (_audioRecoveryError == null || _disposed) return;
    _audioRecoveryError = null;
    notifyListeners();
  }

  Future<void> switchCamera() => controls.run(() async {
    final publication =
        _session.room.localParticipant?.videoTrackPublications.firstOrNull;
    final track = publication?.track;
    if (track is LocalVideoTrack) {
      final options = track.currentOptions;
      if (options is CameraCaptureOptions) {
        await track.setCameraPosition(options.cameraPosition.switched());
      }
    }
  });

  void _handleAudioInterruption(AudioInterruptionEvent event) {
    if (_disposed || event.type == AudioInterruptionType.duck) return;
    if (event.begin) {
      final shouldMute = controls.microphone && _session.connected;
      _audioInterrupted = true;
      _audioInterruptionMayResume = event.type == AudioInterruptionType.pause;
      _microphoneMutedForInterruption = shouldMute;
      notifyListeners();
      if (shouldMute) {
        unawaited(
          _session.room.localParticipant?.setMicrophoneEnabled(false) ??
              Future<void>.value(),
        );
      }
      return;
    }
    // Unknown interruptions are not safe to resume automatically.
    if (event.type != AudioInterruptionType.unknown) {
      unawaited(_resumeAfterAudioInterruption());
    }
  }

  Future<void> _resumeAfterAudioInterruption() async {
    try {
      if (_disposed) return;
      if (_microphoneMutedForInterruption && controls.microphone) {
        await _session.room.localParticipant?.setMicrophoneEnabled(true);
      }
      if (_disposed) return;
      _audioInterrupted = false;
      _audioInterruptionMayResume = false;
      _microphoneMutedForInterruption = false;
      _audioRecoveryError = null;
      notifyListeners();
    } catch (error) {
      if (_disposed) return;
      _audioRecoveryError = error;
      notifyListeners();
    }
  }

  Future<void> _handleNoisyAudioRoute() async {
    try {
      await controls.setSpeakerEnabled(false);
    } catch (_) {
      // The OS may already have moved the route. Keep the current UI state and
      // surface a route-change notice so the user can confirm it manually.
    } finally {
      if (!_disposed) {
        _routeChanged = true;
        notifyListeners();
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    controls.removeListener(_notify);
    controls.dispose();
    _ignoreFailure(_audioInterruptions?.cancel());
    _ignoreFailure(_noisyAudioRoutes?.cancel());
    _ignoreFailure(_audioDevices?.cancel());
    _ignoreFailure(_platformService.stop());
    super.dispose();
  }

  void _ignoreFailure(Future<Object?>? operation) {
    if (operation == null) return;
    unawaited(operation.then<void>((_) {}, onError: (_) {}));
  }
}
