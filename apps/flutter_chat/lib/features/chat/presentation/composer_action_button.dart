import 'package:flutter/material.dart';

/// One stable interactive control: rapid edits must not leave outgoing buttons
/// in an AnimatedSwitcher stack with stale actions or duplicate keys.
class ComposerActionButton extends StatelessWidget {
  const ComposerActionButton({
    super.key,
    required this.hasText,
    required this.recording,
    required this.voiceBusy,
    required this.onSend,
    required this.onVoice,
    this.voiceEnabled = true,
  });

  final bool hasText;
  final bool recording;
  final bool voiceBusy;
  final VoidCallback onSend;
  final VoidCallback onVoice;
  final bool voiceEnabled;

  @override
  Widget build(BuildContext context) {
    final send = hasText && !recording;
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: send
          ? '发送'
          : recording
          ? '结束并发送'
          : voiceEnabled
          ? '录制语音'
          : '服务器未提供文件功能',
      onPressed: send
          ? onSend
          : voiceBusy || !voiceEnabled
          ? null
          : onVoice,
      style: IconButton.styleFrom(
        backgroundColor: send ? colors.primary : Colors.transparent,
        foregroundColor: send
            ? colors.onPrimary
            : recording
            ? colors.error
            : colors.onSurfaceVariant,
      ),
      icon: Icon(
        send
            ? Icons.send_rounded
            : recording
            ? Icons.stop_circle
            : Icons.mic_none,
      ),
    );
  }
}
