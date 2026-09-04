import 'package:flutter/material.dart';

class MessageMeta extends StatelessWidget {
  const MessageMeta({
    super.key,
    required this.time,
    this.status,
    this.receipt,
    this.read = false,
  });
  final String time;
  final Widget? status;
  final String? receipt;
  final bool read;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Wrap(
        spacing: 6,
        runSpacing: 3,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),
          ?status,
          if (receipt != null)
            Text(
              receipt!,
              style: TextStyle(
                fontSize: 11,
                color: read ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class FileMessageTile extends StatelessWidget {
  const FileMessageTile({
    super.key,
    required this.name,
    required this.sizeLabel,
    required this.downloading,
    required this.progress,
    required this.onOpen,
  });
  final String name;
  final String sizeLabel;
  final bool downloading;
  final double progress;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      enabled: !downloading,
      child: InkWell(
        onTap: downloading ? null : onOpen,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 230, minHeight: 56),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: downloading
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          value: progress > 0 ? progress.clamp(0, 1) : null,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.insert_drive_file_outlined,
                        color: colors.primary,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      downloading
                          ? (progress > 0
                                ? '下载中 ${(progress.clamp(0, 1) * 100).round()}%'
                                : '正在准备…')
                          : sizeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (!downloading)
                      Text(
                        '点击打开',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMediaFrame extends StatelessWidget {
  const ChatMediaFrame({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });
  final int width;
  final int height;
  final Widget child;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: AspectRatio(
      aspectRatio: width > 0 && height > 0
          ? (width / height).clamp(.65, 1.8)
          : 220 / 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: child,
        ),
      ),
    ),
  );
}
