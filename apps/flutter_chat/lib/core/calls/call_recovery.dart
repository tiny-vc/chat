import 'dart:async';

import 'package:livekit_client/livekit_client.dart';

/// UI state only. LiveKit remains responsible for reconnecting media transports.
class CallRecovery {
  bool recovering = false;
  String? failure;
  bool canRetry = true;

  void reset() {
    recovering = false;
    failure = null;
    canRetry = true;
  }

  void reconnecting() {
    if (!canRetry) return;
    recovering = true;
    failure = null;
  }

  void reconnected() => reset();

  void disconnected(DisconnectReason? reason) {
    recovering = false;
    canRetry = !{
      DisconnectReason.roomDeleted,
      DisconnectReason.participantRemoved,
      DisconnectReason.duplicateIdentity,
    }.contains(reason);
    failure = switch (reason) {
      DisconnectReason.roomDeleted => '通话房间已关闭，请挂断后重新发起通话。',
      DisconnectReason.participantRemoved => '你已离开通话，请挂断后重新发起。',
      DisconnectReason.duplicateIdentity => '通话已在另一台设备连接，请关闭当前通话。',
      _ => '通话连接已中断，自动恢复未成功。请检查网络后重试或挂断。',
    };
  }
}

/// Persist the terminal action before leaving, then deliver it in the
/// background. Persistence failure must never trap the user on the call page.
Future<void> reportCallEnd(
  Future<void> Function() persist,
  Future<void> Function() deliver,
  void Function() leave, {
  int attempts = 3,
  Duration attemptTimeout = const Duration(seconds: 2),
  Duration retryDelay = const Duration(milliseconds: 300),
}) async {
  try {
    await Future<void>.sync(persist);
  } catch (_) {
    // Server media reconciliation remains the final fallback.
  } finally {
    leave();
  }
  unawaited(
    _retryCallEndReport(
      deliver,
      attempts: attempts,
      attemptTimeout: attemptTimeout,
      retryDelay: retryDelay,
    ),
  );
}

Future<void> _retryCallEndReport(
  Future<void> Function() report, {
  required int attempts,
  required Duration attemptTimeout,
  required Duration retryDelay,
}) async {
  for (var attempt = 0; attempt < attempts; attempt++) {
    try {
      await Future<void>.sync(report).timeout(attemptTimeout);
      return;
    } catch (_) {
      if (attempt + 1 < attempts) await Future<void>.delayed(retryDelay);
    }
  }
}
