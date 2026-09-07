import 'package:flutter/material.dart';

class TransferProgressPanel extends StatelessWidget {
  const TransferProgressPanel({
    super.key,
    required this.label,
    required this.progress,
    required this.onCancel,
  });

  final String label;
  final double progress;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final normalized = progress.clamp(0.0, 1.0);
    final status = progress > 0
        ? '已上传 ${(normalized * 100).round()}%'
        : '正在准备上传';
    return Semantics(
      liveRegion: true,
      label: '$label，$status',
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 4, 9),
          child: Row(
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: progress > 0 ? normalized : null,
                    ),
                    const SizedBox(height: 3),
                    Text(status, style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              IconButton(
                key: const ValueKey('cancel-upload'),
                tooltip: '取消上传',
                onPressed: onCancel,
                icon: const Icon(Icons.close, size: 19),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttachmentSendConfirmation extends StatelessWidget {
  const AttachmentSendConfirmation({
    super.key,
    required this.name,
    required this.sizeLabel,
    required this.kindLabel,
    required this.icon,
    this.preview,
  });

  final String name;
  final String sizeLabel;
  final String kindLabel;
  final IconData icon;
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('发送$kindLabel', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            if (preview != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ColoredBox(
                    color: colors.surfaceContainerHighest,
                    child: preview,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colors.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        sizeLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('确认发送'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    this.onCancel,
  });
  final String name;
  final String sizeLabel;
  final bool downloading;
  final double progress;
  final VoidCallback onOpen;
  final VoidCallback? onCancel;

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
              if (downloading && onCancel != null)
                IconButton(
                  key: const ValueKey('cancel-file-download'),
                  tooltip: '取消下载',
                  visualDensity: VisualDensity.compact,
                  onPressed: onCancel,
                  icon: const Icon(Icons.close, size: 18),
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
