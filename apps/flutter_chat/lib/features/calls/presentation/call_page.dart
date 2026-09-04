import 'dart:async';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/calls/call_controls.dart';
import '../../../core/calls/call_media_policy.dart';
import '../../../core/calls/call_recovery.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/im/chat_message_content.dart';
import '../../../core/im/im_service.dart';

class CallPage extends StatefulWidget {
  const CallPage({
    super.key,
    required this.callId,
    required this.title,
    required this.video,
    required this.incoming,
    required this.callService,
    required this.imService,
  });

  final String callId;
  final String title;
  final bool video;
  final bool incoming;
  final CallService callService;
  final ImService imService;

  @override
  State<CallPage> createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  final _room = Room(
    roomOptions: const RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultCameraCaptureOptions: CameraCaptureOptions(
        params: VideoParametersPresets.h720_169,
        maxFrameRate: 24,
      ),
      defaultVideoPublishOptions: VideoPublishOptions(
        simulcast: true,
        degradationPreference: DegradationPreference.balanced,
      ),
    ),
  );
  final _recovery = CallRecovery();
  final _mediaPolicy = CallMediaPolicy();
  late final EventsListener<RoomEvent> _roomEvents;

  @visibleForTesting
  Future<({num? packets, num? bytes})?> readLocalAudioStats() async {
    final track =
        _room.localParticipant?.audioTrackPublications.firstOrNull?.track;
    if (track is! LocalAudioTrack) return null;
    final stats = await track.getSenderStats();
    return (packets: stats?.packetsSent, bytes: stats?.bytesSent);
  }

  /// Read-only native receiver statistics used by device integration tests.
  @visibleForTesting
  Future<({bool subscribed, bool muted, num? packets, num? bytes})?>
  readRemoteAudioStats(String identity) async {
    final peer = _room.remoteParticipants.values
        .where((participant) => participant.identity == identity)
        .firstOrNull;
    final publication = peer?.audioTrackPublications.firstOrNull;
    if (publication == null) return null;
    final track = publication.track;
    final stats = track is RemoteAudioTrack
        ? await track.getReceiverStats()
        : null;
    return (
      subscribed: publication.subscribed,
      muted: publication.muted,
      packets: stats?.packetsReceived,
      bytes: stats?.bytesReceived,
    );
  }

  StreamSubscription<ChatCallSignalContent>? _signals;
  bool _connected = false;
  bool _accepted = false;
  late final CallControls _controls;
  bool get _microphone => _controls.microphone;
  bool get _camera => _controls.camera;
  bool get _speaker => _controls.speaker;
  bool _starting = false;
  bool get _canControl =>
      _connected &&
      !_ending &&
      !_starting &&
      !_controls.busy &&
      _room.connectionState == ConnectionState.connected;
  bool _ending = false;
  Object? _error;
  Timer? _timeout;
  Timer? _ringback;
  Timer? _durationTimer;
  Timer? _qualityTimer;
  bool _qualityActionBusy = false;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controls = CallControls(
      speaker: widget.video,
      setMicrophone: (enabled) async {
        final participant = _room.localParticipant;
        if (participant == null) throw StateError('No local participant');
        await participant.setMicrophoneEnabled(enabled);
      },
      setCamera: (enabled) async {
        final participant = _room.localParticipant;
        if (participant == null) throw StateError('No local participant');
        await participant.setCameraEnabled(enabled);
      },
      setSpeaker: Hardware.instance.setSpeakerphoneOn,
    )..addListener(_refresh);
    _room.addListener(_refresh);
    _roomEvents = _room.createListener()
      ..on<RoomReconnectingEvent>((_) {
        if (!mounted || _ending || _starting) return;
        setState(_recovery.reconnecting);
      })
      ..on<RoomReconnectedEvent>((_) {
        if (!mounted || _ending || _starting) return;
        setState(_recovery.reconnected);
      })
      ..on<RoomDisconnectedEvent>((event) {
        if (!mounted || _ending || _starting) return;
        setState(() {
          _connected = false;
          _recovery.disconnected(event.reason);
        });
      });
    _signals = widget.imService.callSignals.listen(_onSignal);
    if (!widget.incoming) {
      _timeout = Timer(const Duration(seconds: 45), _markMissed);
      _ringback = Timer.periodic(
        const Duration(seconds: 2),
        (_) => SystemSound.play(SystemSoundType.alert),
      );
    }
    _start();
  }

  Future<void> _markMissed() async {
    if (_accepted || _ending) return;
    setState(() => _ending = true);
    reportCallEnd(() => widget.callService.miss(widget.callId), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _start() async {
    if (!mounted || _ending || _starting) return;
    _starting = true;
    _recovery.reset();
    _mediaPolicy.reset();
    _durationTimer?.cancel();
    _qualityTimer?.cancel();
    if (mounted) {
      setState(() {
        _error = null;
        _connected = false;
      });
    }
    var stage = 'accept';
    try {
      if (widget.incoming && !_accepted) {
        await widget.callService.accept(widget.callId);
        _accepted = true;
      }
      if (!mounted || _ending) return;
      stage = 'disconnect';
      // A fresh Room has no connection to tear down. In SDK 2.3.1 calling
      // disconnect here waits for an EngineDisconnectedEvent that never fires.
      if (_room.connectionState != ConnectionState.disconnected) {
        await _room.disconnect();
      }
      if (!mounted || _ending) return;
      stage = 'token';
      final credentials = await widget.callService.token(widget.callId);
      if (!mounted || _ending) return;
      stage = 'connect';
      await _room.connect(credentials.url, credentials.token);
      if (!mounted || _ending) return;
      stage = 'microphone';
      await _room.localParticipant?.setMicrophoneEnabled(_microphone);
      if (!mounted || _ending) return;
      if (widget.video) {
        await _room.localParticipant?.setCameraEnabled(_camera);
      }
      if (!mounted || _ending) return;
      try {
        await Hardware.instance.setSpeakerphoneOn(_speaker);
      } catch (error) {
        if (mounted && !_ending) {
          AppFeedback.error(context, error, fallback: '音频输出设置失败，请使用系统音频输出');
        }
      }
      if (!mounted || _ending) return;
      if (mounted) setState(() => _connected = true);
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted &&
            !_ending &&
            _accepted &&
            _connected &&
            _room.connectionState == ConnectionState.connected) {
          setState(() => _duration += const Duration(seconds: 1));
        }
      });
      _qualityTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _sampleMediaQuality(),
      );
    } catch (error) {
      assert(() {
        debugPrint('CALL_START_FAILED stage=$stage type=${error.runtimeType}');
        return true;
      }());
      if (mounted && !_ending) setState(() => _error = error);
    } finally {
      _starting = false;
      if (mounted && !_ending) setState(() {});
    }
  }

  void _onSignal(ChatCallSignalContent signal) {
    // A local hangup request can race with its terminal IM signal. Only one
    // path may close the route; otherwise the underlying chat can be popped.
    if (signal.callId != widget.callId || !mounted || _ending) return;
    if (signal.action == 'accept') {
      _timeout?.cancel();
      _ringback?.cancel();
      setState(() => _accepted = true);
    }
    if (['reject', 'busy', 'cancel', 'miss', 'end'].contains(signal.action)) {
      setState(() => _ending = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _hangup() async {
    if (_ending) return;
    setState(() => _ending = true);
    reportCallEnd(() => widget.callService.end(widget.callId), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _toggleMicrophone() async {
    await _deviceAction(_controls.toggleMicrophone);
  }

  Future<void> _toggleCamera() async {
    await _deviceAction(_controls.toggleCamera);
    if (!_controls.busy) _mediaPolicy.userChangedCamera();
  }

  Future<void> _sampleMediaQuality() async {
    if (!mounted || !_connected || _ending || _qualityActionBusy) return;
    final decision = _mediaPolicy.sample(
      poor: _hasPoorNetwork,
      videoCall: widget.video,
      cameraEnabled: _camera,
    );
    if (decision == CallMediaDecision.pauseVideo) {
      _qualityActionBusy = true;
      try {
        await _controls.setCameraEnabled(false);
      } catch (error) {
        _mediaPolicy.reset();
        if (mounted && !_ending) {
          AppFeedback.error(context, error, fallback: '弱网视频降级失败，建议手动关闭摄像头');
        }
      } finally {
        _qualityActionBusy = false;
        if (mounted && !_ending) setState(() {});
      }
    } else if (decision == CallMediaDecision.videoCanResume && mounted) {
      setState(() {});
    }
  }

  bool get _hasPoorNetwork =>
      _room.localParticipant?.connectionQuality == ConnectionQuality.poor ||
      _room.localParticipant?.connectionQuality == ConnectionQuality.lost ||
      _room.remoteParticipants.values.any(
        (peer) =>
            peer.connectionQuality == ConnectionQuality.poor ||
            peer.connectionQuality == ConnectionQuality.lost,
      );

  Future<void> _toggleSpeaker() async {
    await _deviceAction(_controls.toggleSpeaker);
  }

  Future<void> _switchCamera() async {
    await _deviceAction(
      () => _controls.run(() async {
        final publication =
            _room.localParticipant?.videoTrackPublications.firstOrNull;
        final track = publication?.track;
        if (track is LocalVideoTrack) {
          final options = track.currentOptions;
          if (options is CameraCaptureOptions) {
            await track.setCameraPosition(options.cameraPosition.switched());
          }
        }
      }),
    );
  }

  Future<void> _deviceAction(Future<void> Function() operation) async {
    if (!_canControl) return;
    try {
      await operation();
    } catch (error) {
      if (mounted && !_ending) {
        AppFeedback.error(context, error, fallback: '设备切换失败，请检查权限或音频设备后重试');
      }
    }
  }

  VideoTrack? get _remoteVideo {
    for (final participant in _room.remoteParticipants.values) {
      for (final publication in participant.videoTrackPublications) {
        if (publication.subscribed &&
            !publication.muted &&
            publication.track != null) {
          return publication.track;
        }
      }
    }
    return null;
  }

  VideoTrack? get _localVideo {
    for (final publication
        in _room.localParticipant?.videoTrackPublications ?? const []) {
      if (!publication.muted && publication.track != null) {
        return publication.track;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controls.removeListener(_refresh);
    _controls.dispose();
    _signals?.cancel();
    _timeout?.cancel();
    _ringback?.cancel();
    _durationTimer?.cancel();
    _qualityTimer?.cancel();
    _room.removeListener(_refresh);
    _roomEvents.dispose();
    _room.disconnect();
    _room.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remoteVideo = _remoteVideo;
    final localVideo = _localVideo;
    final reconnecting =
        _recovery.recovering ||
        _room.connectionState == ConnectionState.reconnecting ||
        _room.connectionState == ConnectionState.connecting;
    final poorNetwork = _hasPoorNetwork;
    final peerMissing =
        _connected && _accepted && _room.remoteParticipants.isEmpty;
    return PopScope(
      canPop: _ending,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _hangup();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: widget.video && remoteVideo != null
                    ? VideoTrackRenderer(remoteVideo)
                    : _CallPlaceholder(
                        title: widget.title,
                        status: _recovery.failure != null
                            ? '通话已中断'
                            : reconnecting && _connected
                            ? '正在恢复连接…'
                            : peerMissing
                            ? '等待对方恢复连接…'
                            : _error != null
                            ? '连接失败，请查看下方提示'
                            : !_connected
                            ? '正在连接…'
                            : !_accepted && !widget.incoming
                            ? '等待对方接听…'
                            : '通话中',
                      ),
              ),
              Positioned(
                top: 18,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Text(
                      widget.video ? '视频通话' : '语音通话',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_connected) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(_duration),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.video && localVideo != null && _camera)
                Positioned(
                  top: 72,
                  right: 16,
                  child: Container(
                    width: 112,
                    height: 158,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: VideoTrackRenderer(localVideo),
                  ),
                ),
              if ((reconnecting && _connected) ||
                  (_connected &&
                      (poorNetwork ||
                          peerMissing ||
                          _mediaPolicy.pausedForNetwork)))
                Positioned(
                  top: 70,
                  left: 20,
                  right: 20,
                  child: _CallNotice(
                    icon: Icons.wifi_off_outlined,
                    text: reconnecting
                        ? '网络波动，正在恢复通话…'
                        : peerMissing
                        ? '对方尚未连接或暂时掉线，正在等待…'
                        : _mediaPolicy.canResumeVideo
                        ? '网络已恢复，可手动打开摄像头'
                        : _mediaPolicy.pausedForNetwork
                        ? '网络持续较差，已暂停视频以保障语音'
                        : '网络质量较差，声音或画面可能卡顿',
                  ),
                ),
              if (_error != null || _recovery.failure != null)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 138,
                  child: _recovery.canRetry
                      ? _CallError(
                          message: _recovery.failure ?? _friendlyError(_error!),
                          onRetry: _start,
                        )
                      : _CallNotice(
                          icon: Icons.call_end,
                          text: _recovery.failure!,
                        ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 12,
                    children: [
                      _CallButton(
                        icon: _microphone ? Icons.mic : Icons.mic_off,
                        label: _microphone ? '静音' : '取消静音',
                        onPressed: _canControl ? _toggleMicrophone : null,
                      ),
                      _CallButton(
                        icon: _speaker
                            ? Icons.volume_up
                            : Icons.hearing_outlined,
                        label: _speaker ? '扬声器' : '听筒',
                        active: _speaker,
                        onPressed: _canControl ? _toggleSpeaker : null,
                      ),
                      if (widget.video)
                        _CallButton(
                          icon: _camera ? Icons.videocam : Icons.videocam_off,
                          label: _camera ? '关闭摄像头' : '打开摄像头',
                          onPressed: _canControl ? _toggleCamera : null,
                        ),
                      if (widget.video)
                        _CallButton(
                          icon: Icons.cameraswitch,
                          label: '切换',
                          onPressed: _canControl ? _switchCamera : null,
                        ),
                      _CallButton(
                        icon: Icons.call_end,
                        label: '挂断',
                        color: Colors.red,
                        onPressed: _ending ? null : _hangup,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _friendlyError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('permission') || text.contains('denied')) {
      return '无法使用麦克风或摄像头，请在系统设置中允许权限。';
    }
    if (text.contains('network') || text.contains('connect')) {
      return '无法连接通话服务，请检查网络后重试。';
    }
    return '通话连接失败，请稍后重试。';
  }
}

class _CallNotice extends StatelessWidget {
  const _CallNotice({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

class _CallError extends StatelessWidget {
  const _CallError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
    decoration: BoxDecoration(
      color: const Color(0xDD7A1E2A),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: onRetry,
          child: const Text('重试', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

class _CallPlaceholder extends StatelessWidget {
  const _CallPlaceholder({required this.title, required this.status});
  final String title;
  final String status;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF25316D), Color(0xFF121528), Colors.black],
      ),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 54,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            child: Text(
              title.isEmpty ? '?' : title.characters.first.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(status, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    ),
  );
}

class _CallButton extends StatelessWidget {
  const _CallButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.active = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton.filled(
        tooltip: label,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: color ?? (active ? Colors.white : Colors.white24),
          foregroundColor: active ? Colors.black : Colors.white,
          disabledBackgroundColor: Colors.white12,
          minimumSize: const Size.square(52),
        ),
        icon: Icon(icon),
      ),
      const SizedBox(height: 7),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ],
  );
}
