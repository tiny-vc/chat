import 'package:flutter/foundation.dart';

enum CoordinatedCallPhase {
  preparing,
  ringing,
  connecting,
  connected,
  reconnecting,
  failed,
  ended,
}

class CallLease {
  CallLease._({required this.incoming, required this.video, this.callId});

  final bool incoming;
  final bool video;
  String? callId;
  String? terminalAction;
}

/// App-wide ownership and observable state for the single active call flow.
class CallCoordinator extends ChangeNotifier {
  CallCoordinator({DateTime Function()? now}) : _now = now ?? DateTime.now;

  static final instance = CallCoordinator();

  CallLease? _active;
  CoordinatedCallPhase? _phase;
  final DateTime Function() _now;
  final Map<String, ({String action, DateTime receivedAt})> _pendingTerminal =
      {};
  static const _terminalTtl = Duration(minutes: 1);

  CallLease? get active => _active;
  String? get activeCallId => _active?.callId;
  CoordinatedCallPhase? get phase => _phase;
  bool get hasActiveCall => _active != null;

  CallLease? reserveOutgoing({required bool video}) {
    if (_active != null) return null;
    final lease = CallLease._(incoming: false, video: video);
    _active = lease;
    _phase = CoordinatedCallPhase.preparing;
    notifyListeners();
    return lease;
  }

  CallLease? beginIncoming({required String callId, required bool video}) {
    if (_active != null) return null;
    final lease = CallLease._(incoming: true, video: video, callId: callId);
    _active = lease;
    _phase = CoordinatedCallPhase.ringing;
    notifyListeners();
    return lease;
  }

  bool ownsCall(String callId) => _active?.callId == callId;

  void bind(CallLease lease, String callId) {
    if (!identical(_active, lease)) return;
    _prunePendingTerminal();
    lease.callId = callId;
    lease.terminalAction = _pendingTerminal.remove(callId)?.action;
    _phase = lease.terminalAction == null
        ? CoordinatedCallPhase.ringing
        : CoordinatedCallPhase.ended;
    notifyListeners();
  }

  void recordTerminalSignal(String callId, String action) {
    if (!{'reject', 'busy', 'cancel', 'miss', 'end'}.contains(action)) return;
    _prunePendingTerminal();
    if (_active?.callId == callId) {
      _active!.terminalAction = action;
      _phase = CoordinatedCallPhase.ended;
      notifyListeners();
      return;
    }
    _pendingTerminal[callId] = (action: action, receivedAt: _now());
  }

  String? terminalAction(CallLease lease) =>
      identical(_active, lease) ? lease.terminalAction : null;

  void update(CallLease lease, CoordinatedCallPhase phase) {
    if (!identical(_active, lease) || _phase == phase) return;
    _phase = phase;
    notifyListeners();
  }

  void release(CallLease lease) {
    if (!identical(_active, lease)) return;
    _phase = CoordinatedCallPhase.ended;
    _active = null;
    notifyListeners();
  }

  void _prunePendingTerminal() {
    final cutoff = _now().subtract(_terminalTtl);
    _pendingTerminal.removeWhere(
      (_, value) => value.receivedAt.isBefore(cutoff),
    );
  }
}

String callTerminalMessage(String action) => switch (action) {
  'reject' => '对方已拒绝通话',
  'busy' => '对方正在通话中',
  'cancel' => '通话已取消',
  'miss' => '无人接听',
  _ => '通话已结束',
};
