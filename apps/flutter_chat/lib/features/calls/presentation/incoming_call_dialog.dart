import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/im/chat_message_content.dart';

enum IncomingCallResult { accept, reject, ended, timedOut }

Future<IncomingCallResult?> showIncomingCallDialog({
  required BuildContext context,
  required String callId,
  required String caller,
  required bool video,
  required Stream<ChatCallSignalContent> signals,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  late final DialogRoute<IncomingCallResult> route;
  var finished = false;
  void finish(IncomingCallResult result) {
    if (finished) return;
    finished = true;
    // Close this invitation only, even if another route is above it.
    if (route.isActive) navigator.removeRoute(route, result);
  }

  route = DialogRoute<IncomingCallResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(video ? '视频来电' : '语音来电'),
        content: Text('$caller 邀请你进行通话'),
        actions: [
          TextButton(
            onPressed: () => finish(IncomingCallResult.reject),
            child: const Text('拒绝'),
          ),
          FilledButton(
            onPressed: () => finish(IncomingCallResult.accept),
            child: const Text('接听'),
          ),
        ],
      ),
    ),
  );
  final subscription = signals.listen((signal) {
    if (signal.callId == callId &&
        ['cancel', 'miss', 'end', 'reject', 'busy'].contains(signal.action)) {
      finish(IncomingCallResult.ended);
    }
  });
  final timeout = Timer(
    const Duration(seconds: 45),
    () => finish(IncomingCallResult.timedOut),
  );
  final ringtone = Timer.periodic(const Duration(seconds: 2), (_) {
    if (!finished) SystemSound.play(SystemSoundType.alert);
  });
  try {
    SystemSound.play(SystemSoundType.alert);
    return await navigator.push(route);
  } finally {
    finished = true;
    timeout.cancel();
    ringtone.cancel();
    await subscription.cancel();
  }
}
