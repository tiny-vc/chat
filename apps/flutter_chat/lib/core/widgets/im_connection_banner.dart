import 'package:flutter/material.dart';

import '../im/im_service.dart';

class ImConnectionBanner extends StatelessWidget {
  const ImConnectionBanner({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final ImConnectionState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final busy =
        state == ImConnectionState.connecting ||
        state == ImConnectionState.syncing;
    final colors = Theme.of(context).colorScheme;
    final message = switch (state) {
      ImConnectionState.connecting => '正在连接消息服务…',
      ImConnectionState.syncing => '正在同步新消息…',
      ImConnectionState.noNetwork => '消息服务离线，请检查网络或稍后重试',
      ImConnectionState.kicked => '当前设备的登录已失效，请重新登录',
      ImConnectionState.disconnected => '消息服务已断开',
      ImConnectionState.connected => '消息服务已连接',
    };
    return Material(
      color: busy ? colors.secondaryContainer : colors.errorContainer,
      child: InkWell(
        onTap: busy || state == ImConnectionState.connected ? null : onRetry,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(
            children: [
              if (busy)
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.cloud_off_outlined,
                  size: 18,
                  color: colors.onErrorContainer,
                ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (!busy &&
                  state != ImConnectionState.connected &&
                  state != ImConnectionState.kicked)
                Text(
                  '重试',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
