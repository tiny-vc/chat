import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/calls/call_coordinator.dart';

/// Presents one call above the root navigator while allowing it to collapse
/// into a small, non-modal bar. The call widget remains mounted while
/// minimized, so its LiveKit room and device state are preserved.
Future<void> presentCallOverlay({
  required BuildContext context,
  required String title,
  required bool video,
  required Widget Function(VoidCallback minimize, VoidCallback close) builder,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final completion = Completer<void>();
  final minimized = ValueNotifier(false);
  late final OverlayEntry entry;

  void close() {
    if (completion.isCompleted) return;
    entry.remove();
    minimized.dispose();
    completion.complete();
  }

  entry = OverlayEntry(
    builder: (context) => ValueListenableBuilder<bool>(
      valueListenable: minimized,
      builder: (context, isMinimized, child) => Stack(
        children: [
          Offstage(offstage: isMinimized, child: child!),
          if (isMinimized)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 12,
              right: 12,
              child: _MinimizedCallBar(
                title: title,
                video: video,
                onRestore: () => minimized.value = false,
                onEnd: () => CallCoordinator.instance.requestHangup(),
              ),
            ),
        ],
      ),
      child: SizedBox.expand(
        child: builder(() => minimized.value = true, close),
      ),
    ),
  );
  overlay.insert(entry);
  return completion.future;
}

class _MinimizedCallBar extends StatelessWidget {
  const _MinimizedCallBar({
    required this.title,
    required this.video,
    required this.onRestore,
    required this.onEnd,
  });

  final String title;
  final bool video;
  final VoidCallback onRestore;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: CallCoordinator.instance,
    builder: (context, _) {
      final phase = CallCoordinator.instance.phase;
      final status = switch (phase) {
        CoordinatedCallPhase.ringing => '等待接听',
        CoordinatedCallPhase.connecting => '正在连接',
        CoordinatedCallPhase.reconnecting => '正在恢复连接',
        CoordinatedCallPhase.failed => '连接异常',
        _ => '通话中',
      };
      return Material(
        elevation: 10,
        color: const Color(0xFF20212A),
        shadowColor: Colors.black45,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onRestore,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
            child: Row(
              children: [
                const Icon(Icons.call, color: Color(0xFF55D187), size: 21),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${video ? '视频' : '语音'}通话 · $status',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: '恢复通话',
                  onPressed: onRestore,
                  icon: const Icon(
                    Icons.open_in_full,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
                IconButton.filled(
                  tooltip: '结束通话',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                  ),
                  onPressed: onEnd,
                  icon: const Icon(Icons.call_end, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
