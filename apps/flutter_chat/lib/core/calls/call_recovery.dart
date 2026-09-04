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

/// Never wait for the API before leaving a call. The page's disposal stops media;
/// server reconciliation handles reports that cannot reach the API while offline.
void reportCallEnd(Future<void> Function() report, void Function() leave) {
  leave();
  Future<void>.sync(
    report,
  ).timeout(const Duration(seconds: 8)).catchError((_) {});
}
