import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/calls/call_tone_player.dart';
import '../../../core/im/chat_message_content.dart';

enum IncomingCallResult { accept, reject, answeredElsewhere, ended, timedOut }

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
      child: _IncomingCallCard(
        caller: caller,
        video: video,
        onReject: () => finish(IncomingCallResult.reject),
        onAccept: () => finish(IncomingCallResult.accept),
      ),
    ),
  );
  final subscription = signals.listen((signal) {
    if (signal.callId != callId) return;
    if (signal.action == 'answered_elsewhere') {
      finish(IncomingCallResult.answeredElsewhere);
    } else if ([
      'cancel',
      'miss',
      'end',
      'reject',
      'busy',
    ].contains(signal.action)) {
      finish(IncomingCallResult.ended);
    }
  });
  final timeout = Timer(
    const Duration(seconds: 45),
    () => finish(IncomingCallResult.timedOut),
  );
  final ringtone = CallTonePlayer();
  try {
    unawaited(
      ringtone.start(CallTone.incoming).catchError((Object _) {
        SystemSound.play(SystemSoundType.alert);
      }),
    );
    return await navigator.push(route);
  } finally {
    finished = true;
    timeout.cancel();
    unawaited(
      ringtone
          .stop()
          .catchError((Object _) {})
          .whenComplete(() => ringtone.dispose().catchError((Object _) {})),
    );
    await subscription.cancel();
  }
}

class _IncomingCallCard extends StatelessWidget {
  const _IncomingCallCard({
    required this.caller,
    required this.video,
    required this.onReject,
    required this.onAccept,
  });

  final String caller;
  final bool video;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayName = caller.trim().isEmpty ? '未知联系人' : caller.trim();
    final initial = displayName.characters.first.toUpperCase();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initial,
                  maxLines: 1,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    video ? Icons.videocam_rounded : Icons.call_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      video ? '视频来电' : '语音来电',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallDecisionButton(
                    label: '拒绝',
                    icon: Icons.call_end_rounded,
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    onPressed: onReject,
                  ),
                  _CallDecisionButton(
                    label: '接听',
                    icon: video ? Icons.videocam_rounded : Icons.call_rounded,
                    backgroundColor: const Color(0xFF27A844),
                    foregroundColor: Colors.white,
                    onPressed: onAccept,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallDecisionButton extends StatelessWidget {
  const _CallDecisionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('incoming-call-$label'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: foregroundColor, size: 30),
              ),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
