import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

import 'call_recovery.dart';

enum CallRoomPhase {
  idle,
  connecting,
  connected,
  reconnecting,
  connectionFailed,
  disconnected,
}

/// Owns the LiveKit room and transport recovery independently of call UI.
class CallRoomSession extends ChangeNotifier {
  CallRoomSession({Room? room})
    : room = room ?? Room(roomOptions: defaultRoomOptions) {
    this.room.addListener(_roomChanged);
    _events = this.room.createListener()
      ..on<RoomReconnectingEvent>((_) {
        if (_disposed || _ignoreDisconnectEvents) return;
        recovery.reconnecting();
        phase = CallRoomPhase.reconnecting;
        notifyListeners();
      })
      ..on<RoomReconnectedEvent>((_) {
        if (_disposed || _ignoreDisconnectEvents) return;
        recovery.reconnected();
        connected = true;
        phase = CallRoomPhase.connected;
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        if (_disposed || _ignoreDisconnectEvents) return;
        connected = false;
        recovery.disconnected(event.reason);
        phase = CallRoomPhase.disconnected;
        notifyListeners();
      });
  }

  static const defaultRoomOptions = RoomOptions(
    adaptiveStream: true,
    dynacast: true,
    defaultAudioCaptureOptions: AudioCaptureOptions(
      echoCancellation: true,
      noiseSuppression: true,
      autoGainControl: true,
      highPassFilter: true,
      voiceIsolation: true,
    ),
    defaultAudioPublishOptions: AudioPublishOptions(
      encoding: AudioEncoding(
        maxBitrate: 32000,
        bitratePriority: Priority.high,
        networkPriority: Priority.high,
      ),
      dtx: true,
      red: true,
    ),
    defaultCameraCaptureOptions: CameraCaptureOptions(
      params: VideoParametersPresets.h720_169,
      maxFrameRate: 24,
    ),
    defaultVideoPublishOptions: VideoPublishOptions(
      simulcast: true,
      degradationPreference: DegradationPreference.balanced,
    ),
  );

  final Room room;
  final CallRecovery recovery = CallRecovery();
  late final EventsListener<RoomEvent> _events;
  bool _ignoreDisconnectEvents = false;
  bool _disposed = false;
  Future<void>? _shutdown;
  Future<void>? _connectOperation;

  bool connected = false;
  CallRoomPhase phase = CallRoomPhase.idle;

  void resetForConnection() {
    recovery.reset();
    connected = false;
    phase = CallRoomPhase.connecting;
    notifyListeners();
  }

  Future<void> disconnectForRestart() async {
    if (room.connectionState == ConnectionState.disconnected) return;
    _ignoreDisconnectEvents = true;
    try {
      await room.disconnect();
    } finally {
      _ignoreDisconnectEvents = false;
    }
  }

  Future<void> connect(String url, String token) async {
    if (_disposed) throw StateError('Call room session is closed');
    // LiveKit uses this to warm DNS/TLS and, for LiveKit Cloud, select a close
    // edge before the WebRTC signaling connection starts.
    await room.prepareConnection(url, token);
    if (_disposed) throw StateError('Call room session is closed');
    final operation = room.connect(url, token);
    _connectOperation = operation;
    try {
      await operation;
    } finally {
      if (identical(_connectOperation, operation)) _connectOperation = null;
    }
  }

  void markConnected() {
    connected = true;
    phase = CallRoomPhase.connected;
    notifyListeners();
  }

  void markConnectionFailed() {
    connected = false;
    phase = CallRoomPhase.connectionFailed;
    notifyListeners();
  }

  void _roomChanged() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    room.removeListener(_roomChanged);
    _shutdown ??= _shutdownRoom();
    unawaited(_shutdown!.catchError((_) {}));
    super.dispose();
  }

  Future<void> _shutdownRoom() async {
    try {
      await _events.dispose();
      final connecting = _connectOperation;
      if (connecting != null) {
        try {
          await connecting;
        } catch (_) {
          // Continue with cleanup after an in-flight connection failure.
        }
      }
      if (room.connectionState != ConnectionState.disconnected) {
        await room.disconnect();
      }
    } catch (_) {
      // Disposal still has to release local tracks and the WebRTC engine when
      // graceful server notification is no longer possible.
    } finally {
      await room.dispose();
    }
  }
}
