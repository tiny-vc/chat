import 'dart:async';

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter/services.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/calls/call_tone_player.dart';
import '../../../core/calls/call_acceptance.dart';
import '../../../core/calls/call_coordinator.dart';
import '../../../core/calls/call_controls.dart';
import '../../../core/calls/call_media_controller.dart';
import '../../../core/calls/call_media_policy.dart';
import '../../../core/calls/call_recovery.dart';
import '../../../core/calls/call_room_session.dart';
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
    this.callLease,
    this.alreadyAccepted = false,
    this.onMinimize,
    this.onClosed,
  });

  final String callId;
  final String title;
  final bool video;
  final bool incoming;
  final CallService callService;
  final ImService imService;
  final CallLease? callLease;
  final bool alreadyAccepted;
  final VoidCallback? onMinimize;
  final VoidCallback? onClosed;

  @override
  State<CallPage> createState() => CallPageState();
}

class CallPageState extends State<CallPage> with WidgetsBindingObserver {
  final _coordinator = CallCoordinator.instance;
  CallLease? _callLease;
  late final CallRoomSession _mediaSession;
  Room get _room => _mediaSession.room;
  CallRecovery get _recovery => _mediaSession.recovery;
  final _mediaPolicy = CallMediaPolicy();
  late final CallMediaController _mediaController;

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
        .where(
          (participant) =>
              participant.identity == identity ||
              participant.identity.startsWith('$identity:'),
        )
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
  bool get _connected => _mediaSession.connected;
  late bool _accepted;
  CallControls get _controls => _mediaController.controls;
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
  CallTonePlayer? _ringback;
  Timer? _durationTimer;
  Timer? _qualityTimer;
  Timer? _businessStateTimer;
  bool _qualityActionBusy = false;
  bool _reconcilingBusinessState = false;
  int _businessStatePollCount = 0;
  static const _businessStatePollLimit = 30;
  final ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
  bool _localVideoPrimary = false;

  @override
  void initState() {
    super.initState();
    _accepted = widget.alreadyAccepted;
    _callLease = widget.callLease;
    _mediaSession = CallRoomSession()..addListener(_handleMediaSessionChange);
    _mediaController = CallMediaController(
      session: _mediaSession,
      video: widget.video,
    )..addListener(_refresh);
    WidgetsBinding.instance.addObserver(this);
    _coordinator.attachHangupHandler(_hangup);
    _signals = widget.imService.callSignals.listen(_onSignal);
    final earlyTerminal = _callLease == null
        ? null
        : _coordinator.terminalAction(_callLease!);
    if (earlyTerminal != null) {
      _ending = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _closePresentation();
      });
      return;
    }
    unawaited(_mediaController.initialize());
    if (!widget.incoming) {
      _timeout = Timer(const Duration(seconds: 45), _markMissed);
      _ringback = CallTonePlayer();
      unawaited(
        _ringback!.start(CallTone.ringback).catchError((Object _) {
          SystemSound.play(SystemSoundType.alert);
        }),
      );
    }
    _start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_ending) return;
    _mediaController.handleLifecycle(state);
    if (state == AppLifecycleState.resumed) {
      unawaited(_reconcileBusinessState());
      if (_mediaSession.phase == CallRoomPhase.disconnected) {
        _startBusinessStatePolling();
      }
    }
  }

  Future<void> _markMissed() async {
    if (_accepted || _ending) return;
    setState(() => _ending = true);
    await reportCallEnd(
      () => widget.callService.queueTerminal(widget.callId, 'miss'),
      widget.callService.flushTerminalReports,
      () {
        if (mounted) _closePresentation();
      },
    );
  }

  Future<void> _start() async {
    if (!mounted || _ending || _starting) return;
    _starting = true;
    _updateCoordinatedPhase(CoordinatedCallPhase.connecting);
    _mediaSession.resetForConnection();
    _mediaPolicy.reset();
    _durationTimer?.cancel();
    _qualityTimer?.cancel();
    _businessStateTimer?.cancel();
    if (mounted) {
      setState(() {
        _error = null;
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
      // Avoid disconnecting a fresh Room while still allowing a manual retry
      // to tear down the previous transport cleanly.
      await _mediaSession.disconnectForRestart();
      if (!mounted || _ending) return;
      stage = 'token';
      final credentials = await widget.callService.token(widget.callId);
      if (!mounted || _ending) return;
      stage = 'connect';
      await _mediaSession.connect(credentials.url, credentials.token);
      if (!mounted || _ending) return;
      stage = 'microphone';
      await _room.localParticipant?.setMicrophoneEnabled(_microphone);
      if (!mounted || _ending) return;
      if (widget.video) {
        await _room.localParticipant?.setCameraEnabled(_camera);
      }
      if (!mounted || _ending) return;
      try {
        await AudioManager.instance.setSpeakerOutputPreferred(_speaker);
      } catch (error) {
        if (mounted && !_ending) {
          AppFeedback.error(context, error, fallback: '音频输出设置失败，请使用系统音频输出');
        }
      }
      if (!mounted || _ending) return;
      _mediaSession.markConnected();
      _updateCoordinatedPhase(CoordinatedCallPhase.connected);
      await _mediaController.callConnected();
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted &&
            !_ending &&
            _accepted &&
            _connected &&
            _room.connectionState == ConnectionState.connected) {
          _duration.value += const Duration(seconds: 1);
        }
      });
      _qualityTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _sampleMediaQuality(),
      );
    } catch (error) {
      _mediaSession.markConnectionFailed();
      assert(() {
        debugPrint('CALL_START_FAILED stage=$stage type=${error.runtimeType}');
        return true;
      }());
      if (await _reconcileBusinessState()) return;
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
      unawaited(_ringback?.stop() ?? Future<void>.value());
      setState(() => _accepted = true);
    }
    if (['reject', 'busy', 'cancel', 'miss', 'end'].contains(signal.action)) {
      _coordinator.recordTerminalSignal(widget.callId, signal.action);
      setState(() => _ending = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _closePresentation();
      });
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _hangup() async {
    if (_ending) return;
    setState(() => _ending = true);
    await reportCallEnd(
      () => widget.callService.queueTerminal(widget.callId, 'end'),
      widget.callService.flushTerminalReports,
      () {
        if (mounted) _closePresentation();
      },
    );
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

  ConnectionQuality get _connectionQuality {
    final qualities = <ConnectionQuality>[
      if (_room.localParticipant case final participant?)
        participant.connectionQuality,
      ..._room.remoteParticipants.values.map(
        (participant) => participant.connectionQuality,
      ),
    ];
    if (qualities.contains(ConnectionQuality.lost)) {
      return ConnectionQuality.lost;
    }
    if (qualities.contains(ConnectionQuality.poor)) {
      return ConnectionQuality.poor;
    }
    if (qualities.contains(ConnectionQuality.good)) {
      return ConnectionQuality.good;
    }
    if (qualities.contains(ConnectionQuality.excellent)) {
      return ConnectionQuality.excellent;
    }
    return ConnectionQuality.unknown;
  }

  Future<void> _toggleSpeaker() async {
    await _deviceAction(_controls.toggleSpeaker);
  }

  Future<void> _switchCamera() async {
    await _deviceAction(_mediaController.switchCamera);
  }

  void _dismissAudioNotice() {
    if (_mediaController.routeChanged) {
      _mediaController.dismissRouteNotice();
    }
    if (_mediaController.audioRecoveryError != null) {
      _mediaController.dismissAudioRecoveryError();
    }
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
    WidgetsBinding.instance.removeObserver(this);
    _mediaController.removeListener(_refresh);
    _mediaController.dispose();
    _signals?.cancel();
    _timeout?.cancel();
    unawaited(_ringback?.dispose() ?? Future<void>.value());
    _durationTimer?.cancel();
    _duration.dispose();
    _qualityTimer?.cancel();
    _businessStateTimer?.cancel();
    _mediaSession.removeListener(_handleMediaSessionChange);
    _mediaSession.dispose();
    _coordinator.detachHangupHandler(_hangup);
    final lease = _callLease;
    if (lease != null) _coordinator.release(lease);
    super.dispose();
  }

  void _updateCoordinatedPhase(CoordinatedCallPhase phase) {
    final lease = _callLease;
    if (lease != null) _coordinator.update(lease, phase);
  }

  void _handleMediaSessionChange() {
    if (!mounted || _ending) return;
    if (shouldConfirmCallAcceptedFromPeer(
      incoming: widget.incoming,
      accepted: _accepted,
      mediaConnected: _mediaSession.connected,
      remoteParticipantCount: _room.remoteParticipants.length,
    )) {
      _accepted = true;
      _timeout?.cancel();
      unawaited(_ringback?.stop() ?? Future<void>.value());
    }
    final phase = switch (_mediaSession.phase) {
      CallRoomPhase.connecting => CoordinatedCallPhase.connecting,
      CallRoomPhase.connected => CoordinatedCallPhase.connected,
      CallRoomPhase.reconnecting => CoordinatedCallPhase.reconnecting,
      CallRoomPhase.connectionFailed ||
      CallRoomPhase.disconnected => CoordinatedCallPhase.failed,
      CallRoomPhase.idle => null,
    };
    if (phase != null) _updateCoordinatedPhase(phase);
    if (_mediaSession.phase == CallRoomPhase.connected) {
      _businessStateTimer?.cancel();
      _businessStateTimer = null;
      _businessStatePollCount = 0;
    } else if (_mediaSession.phase == CallRoomPhase.disconnected) {
      _startBusinessStatePolling();
    }
    setState(() {});
  }

  Future<bool> _reconcileBusinessState() async {
    if (!mounted || _ending || _reconcilingBusinessState) return _ending;
    _reconcilingBusinessState = true;
    try {
      final state = await widget.callService.state(widget.callId);
      if (!mounted || _ending || !state.terminal) return _ending;
      _coordinator.recordTerminalSignal(widget.callId, switch (state.status) {
        'REJECTED' when state.endReason == 'BUSY' => 'busy',
        'REJECTED' => 'reject',
        'CANCELLED' => 'cancel',
        'MISSED' => 'miss',
        _ => 'end',
      });
      _businessStateTimer?.cancel();
      _businessStateTimer = null;
      setState(() => _ending = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _closePresentation();
      });
      return true;
    } catch (_) {
      // IM and LiveKit recovery remain active when the business API is
      // temporarily unreachable. A later resume/reconnect will retry.
      return false;
    } finally {
      _reconcilingBusinessState = false;
    }
  }

  void _startBusinessStatePolling() {
    if (_ending || _businessStateTimer?.isActive == true) return;
    _businessStatePollCount = 0;
    _pollBusinessState();
    _businessStateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted ||
          _ending ||
          _mediaSession.phase != CallRoomPhase.disconnected ||
          _businessStatePollCount >= _businessStatePollLimit) {
        _businessStateTimer?.cancel();
        _businessStateTimer = null;
        return;
      }
      _pollBusinessState();
    });
  }

  void _pollBusinessState() {
    if (_businessStatePollCount >= _businessStatePollLimit) return;
    _businessStatePollCount++;
    unawaited(_reconcileBusinessState());
  }

  @override
  Widget build(BuildContext context) {
    final remoteVideo = _remoteVideo;
    final localVideo = _localVideo;
    final primaryVideo = _localVideoPrimary
        ? localVideo ?? remoteVideo
        : remoteVideo ?? localVideo;
    final previewVideo = remoteVideo != null && localVideo != null
        ? (_localVideoPrimary ? remoteVideo : localVideo)
        : null;
    final reconnecting =
        _recovery.recovering ||
        _room.connectionState == ConnectionState.reconnecting ||
        _room.connectionState == ConnectionState.connecting;
    final poorNetwork = _hasPoorNetwork;
    final peerMissing =
        _connected && _accepted && _room.remoteParticipants.isEmpty;
    final audioNoticeDismissible =
        _mediaController.routeChanged ||
        _mediaController.audioRecoveryError != null;
    return PopScope(
      canPop: _ending,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          final minimize = widget.onMinimize;
          if (minimize != null) {
            minimize();
          } else {
            _hangup();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: widget.video && primaryVideo != null
                    ? VideoTrackRenderer(primaryVideo)
                    : ValueListenableBuilder<Duration>(
                        valueListenable: _duration,
                        builder: (_, duration, _) => _CallPlaceholder(
                          title: widget.title,
                          status: _callStatus(
                            duration,
                            reconnecting: reconnecting,
                            peerMissing: peerMissing,
                          ),
                        ),
                      ),
              ),
              const Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x99000000),
                          Colors.transparent,
                          Color(0xC7000000),
                        ],
                        stops: [0, .42, 1],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: ValueListenableBuilder<Duration>(
                  valueListenable: _duration,
                  builder: (_, duration, _) => _CallTopBar(
                    title: widget.title,
                    video: widget.video,
                    status: _callStatus(
                      duration,
                      reconnecting: reconnecting,
                      peerMissing: peerMissing,
                    ),
                    quality: _connectionQuality,
                    reconnecting: reconnecting,
                    onMinimize: widget.onMinimize,
                  ),
                ),
              ),
              if (widget.video && previewVideo != null && _camera)
                Positioned.fill(
                  child: _DraggableVideoPreview(
                    track: previewVideo,
                    label: _localVideoPrimary ? '对方画面' : '我的画面',
                    onSwap: () => setState(
                      () => _localVideoPrimary = !_localVideoPrimary,
                    ),
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
              if (_mediaController.audioInterrupted ||
                  _mediaController.routeChanged ||
                  _mediaController.backgrounded ||
                  _mediaController.audioRecoveryError != null)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 218,
                  child: Semantics(
                    button: audioNoticeDismissible,
                    label: audioNoticeDismissible ? '通话音频提示，点按关闭' : null,
                    onTap: audioNoticeDismissible ? _dismissAudioNotice : null,
                    child: GestureDetector(
                      onTap: audioNoticeDismissible
                          ? _dismissAudioNotice
                          : null,
                      child: _CallNotice(
                        icon: _mediaController.audioRecoveryError != null
                            ? Icons.error_outline
                            : _mediaController.audioInterrupted
                            ? Icons.phone_paused_outlined
                            : _mediaController.backgrounded
                            ? Icons.picture_in_picture_alt_outlined
                            : Icons.headphones_outlined,
                        text: _mediaController.audioRecoveryError != null
                            ? '系统音频恢复失败，请手动切换麦克风后重试'
                            : _mediaController.audioInterrupted
                            ? '系统音频被占用，通话将在中断结束后恢复'
                            : _mediaController.backgrounded
                            ? '通话正在后台保持'
                            : '音频设备已变化，请确认当前声音输出（点按关闭）',
                      ),
                    ),
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                    decoration: BoxDecoration(
                      color: const Color(0xB31B1B24),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          runAlignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 10,
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
                                icon: _camera
                                    ? Icons.videocam
                                    : Icons.videocam_off,
                                label: _camera ? '关闭摄像头' : '打开摄像头',
                                onPressed: _canControl ? _toggleCamera : null,
                              ),
                            if (widget.video)
                              _CallButton(
                                icon: Icons.cameraswitch,
                                label: '前后镜头',
                                onPressed: _canControl ? _switchCamera : null,
                              ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Divider(height: 1, color: Colors.white12),
                        ),
                        Semantics(
                          label: '结束当前通话',
                          child: _CallButton(
                            icon: Icons.call_end,
                            label: '挂断',
                            color: const Color(0xFFE53935),
                            onPressed: _ending ? null : _hangup,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _closePresentation() {
    final close = widget.onClosed;
    if (close != null) {
      close();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _callStatus(
    Duration duration, {
    required bool reconnecting,
    required bool peerMissing,
  }) => _recovery.failure != null
      ? '通话已中断'
      : reconnecting && _connected
      ? '正在恢复连接…'
      : peerMissing
      ? '等待对方恢复连接…'
      : _error != null
      ? '连接失败'
      : !_connected
      ? '正在连接…'
      : !_accepted && !widget.incoming
      ? '等待对方接听…'
      : _formatDuration(duration);

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

class _CallTopBar extends StatelessWidget {
  const _CallTopBar({
    required this.title,
    required this.video,
    required this.status,
    required this.quality,
    required this.reconnecting,
    this.onMinimize,
  });

  final String title;
  final bool video;
  final String status;
  final ConnectionQuality quality;
  final bool reconnecting;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white.withValues(alpha: .16),
        child: Text(
          title.isEmpty ? '?' : title.characters.first.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${video ? '视频通话' : '语音通话'} · $status',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      if (onMinimize != null)
        IconButton(
          tooltip: '最小化通话',
          onPressed: onMinimize,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ),
      const SizedBox(width: 8),
      _CallQualityChip(quality: quality, reconnecting: reconnecting),
    ],
  );
}

class _CallQualityChip extends StatelessWidget {
  const _CallQualityChip({required this.quality, required this.reconnecting});

  final ConnectionQuality quality;
  final bool reconnecting;

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = reconnecting
        ? (Icons.sync_rounded, '恢复中', const Color(0xFFFFC857))
        : switch (quality) {
            ConnectionQuality.lost => (
              Icons.signal_wifi_connected_no_internet_4_outlined,
              '已断开',
              const Color(0xFFFF6B6B),
            ),
            ConnectionQuality.poor => (
              Icons.network_wifi_1_bar,
              '网络较差',
              const Color(0xFFFFC857),
            ),
            ConnectionQuality.good => (
              Icons.network_wifi_2_bar,
              '网络良好',
              const Color(0xFF8DE1B7),
            ),
            ConnectionQuality.excellent => (
              Icons.network_wifi_3_bar,
              '网络优秀',
              const Color(0xFF8DE1B7),
            ),
            ConnectionQuality.unknown => (
              Icons.network_check,
              '检测中',
              Colors.white70,
            ),
          };
    return Semantics(
      label: '通话网络状态：$label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: color.withValues(alpha: .45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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

class _DraggableVideoPreview extends StatefulWidget {
  const _DraggableVideoPreview({
    required this.track,
    required this.label,
    required this.onSwap,
  });

  final VideoTrack track;
  final String label;
  final VoidCallback onSwap;

  @override
  State<_DraggableVideoPreview> createState() => _DraggableVideoPreviewState();
}

class _DraggableVideoPreviewState extends State<_DraggableVideoPreview> {
  Offset? _position;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const width = 112.0;
      const height = 158.0;
      final maxX = (constraints.maxWidth - width - 16).clamp(
        16.0,
        double.infinity,
      );
      final maxY = (constraints.maxHeight - height - 210).clamp(
        88.0,
        double.infinity,
      );
      final position = _position ?? Offset(maxX, 88);
      return Stack(
        children: [
          Positioned(
            left: position.dx.clamp(16.0, maxX),
            top: position.dy.clamp(88.0, maxY),
            child: GestureDetector(
              onTap: widget.onSwap,
              onPanUpdate: (details) => setState(() {
                _position = Offset(
                  (position.dx + details.delta.dx).clamp(16.0, maxX),
                  (position.dy + details.delta.dy).clamp(88.0, maxY),
                );
              }),
              child: Semantics(
                button: true,
                label: '${widget.label}，点按交换大小画面，可拖动',
                child: Container(
                  width: width,
                  height: height,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white38),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      VideoTrackRenderer(widget.track),
                      Positioned(
                        left: 7,
                        right: 7,
                        bottom: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.swap_calls_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    widget.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
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
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final background = color ?? (active ? Colors.white : Colors.white24);
    final foreground = active ? Colors.black : Colors.white;
    return Semantics(
      button: true,
      enabled: enabled,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: enabled ? 1 : .45,
        child: InkWell(
          key: ValueKey('call-control-$label'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: enabled ? background : Colors.white12,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: foreground, size: 26),
                ),
                const SizedBox(height: 7),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
