import 'package:flutter/material.dart';

import '../../../config/server_settings.dart';
import '../../../core/calls/call_coordinator.dart';
import '../../../core/calls/call_service.dart';
import '../../../core/im/im_service.dart';
import '../../../core/permissions/permission_ui.dart';
import '../../../core/widgets/app_feedback.dart';
import 'call_page.dart';
import 'call_overlay.dart';

/// The single product flow for outgoing calls, shared by every call entry.
Future<void> launchOutgoingCall({
  required BuildContext context,
  required String targetUserId,
  required String title,
  required bool video,
  required CallService callService,
  required ImService imService,
  required ServerCapabilities capabilities,
}) async {
  if (targetUserId.isEmpty) {
    AppFeedback.show(context, '无法识别通话对象');
    return;
  }
  final supported = video
      ? capabilities.canVideoCall
      : capabilities.canAudioCall;
  if (!supported) {
    AppFeedback.show(context, '当前服务器暂停了此通话功能');
    return;
  }
  final effectiveVideo = await prepareCallPermissions(context, video: video);
  if (effectiveVideo == null || !context.mounted) return;

  final coordinator = CallCoordinator.instance;
  final lease = coordinator.reserveOutgoing(video: effectiveVideo);
  if (lease == null) {
    AppFeedback.show(context, '已有通话正在进行');
    return;
  }
  try {
    final call = await callService.create(targetUserId, video: effectiveVideo);
    coordinator.bind(lease, call.id);
    final earlyTerminal = coordinator.terminalAction(lease);
    if (earlyTerminal != null) {
      if (context.mounted) {
        AppFeedback.show(context, callTerminalMessage(earlyTerminal));
      }
      return;
    }
    if (!context.mounted) {
      await callService.reportTerminal(call.id, 'end').catchError((_) {});
      return;
    }
    await presentCallOverlay(
      context: context,
      title: title,
      video: effectiveVideo,
      builder: (minimize, close) => CallPage(
        callId: call.id,
        title: title,
        video: effectiveVideo,
        incoming: false,
        callService: callService,
        imService: imService,
        callLease: lease,
        onMinimize: minimize,
        onClosed: close,
      ),
    );
    final endedAction = coordinator.terminalAction(lease);
    if (context.mounted && endedAction != null) {
      AppFeedback.show(context, callTerminalMessage(endedAction));
    }
  } catch (error) {
    if (context.mounted) {
      AppFeedback.error(context, error, fallback: '无法发起通话，请稍后重试');
    }
  } finally {
    coordinator.release(lease);
  }
}
