import 'package:flutter/material.dart';

import '../../../core/files/file_size.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/widgets/app_feedback.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key, required this.files});

  final FileTransferService files;

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  DownloadCacheStats? _stats;
  ServerFileUsage? _serverUsage;
  Object? _error;
  Object? _serverError;
  var _busy = false;
  var _refreshing = false;
  Future<void>? _refresh;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() {
    final current = _refresh;
    if (current != null) return current;
    if (mounted) setState(() => _refreshing = true);
    final Future<void> next = Future.wait([
      _loadLocal(),
      _loadServer(),
    ]).then((_) {});
    _refresh = next;
    return next.whenComplete(() {
      if (identical(_refresh, next)) _refresh = null;
      if (mounted) setState(() => _refreshing = false);
    });
  }

  Future<void> _loadLocal() async {
    try {
      final stats = await widget.files.downloadCacheStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  Future<void> _loadServer() async {
    try {
      final usage = await widget.files.serverFileUsage();
      if (mounted) {
        setState(() {
          _serverUsage = usage;
          _serverError = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _serverError = error);
    }
  }

  Future<void> _clear() async {
    final stats = _stats;
    if (_busy || stats == null || stats.fileCount == 0) return;
    if (!await AppFeedback.confirm(
      context,
      title: '清理下载缓存',
      message:
          '将删除 ${formatFileSize(stats.totalBytes)} 的已下载文件。聊天记录和消息中的文件不会删除，需要时可重新下载。',
      confirmLabel: '清理',
      destructive: true,
    )) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.files.clearDownloadCache();
      await _loadLocal();
      if (mounted) AppFeedback.show(context, '下载缓存已清理');
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '暂时无法清理，请稍后重试');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('存储空间'),
      actions: [
        IconButton(
          key: const ValueKey('refresh-storage'),
          tooltip: '刷新存储用量',
          onPressed: _refreshing ? null : _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.cloud_outlined),
                    title: Text('服务器文件'),
                  ),
                  if (_serverUsage != null) ...[
                    LinearProgressIndicator(
                      value: _serverUsage!.usedRatio,
                      color: _serverUsage!.isFull
                          ? Theme.of(context).colorScheme.error
                          : _serverUsage!.isNearlyFull
                          ? Theme.of(context).colorScheme.tertiary
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '已使用 ${formatFileSize(_serverUsage!.usedBytes)} / ${formatFileSize(_serverUsage!.quotaBytes)} · ${_serverUsage!.fileCount} 个文件',
                    ),
                    Text(
                      '剩余 ${formatFileSize(_serverUsage!.remainingBytes)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_serverUsage!.isFull || _serverUsage!.isNearlyFull) ...[
                      const SizedBox(height: 10),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _serverUsage!.isFull
                              ? '服务器空间已满，新文件可能无法发送，请联系管理员扩容。'
                              : '服务器空间即将用完，新文件可能无法发送，请联系管理员。',
                          style: TextStyle(
                            color: _serverUsage!.isFull
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ] else if (_serverError != null)
                    Row(
                      children: [
                        const Expanded(child: Text('暂时无法读取服务器用量')),
                        TextButton(
                          onPressed: _loadServer,
                          child: const Text('重试'),
                        ),
                      ],
                    )
                  else
                    const LinearProgressIndicator(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('下载缓存'),
              subtitle: Text(
                _error != null
                    ? '读取失败，请重试'
                    : _stats == null
                    ? '正在计算…'
                    : '${formatFileSize(_stats!.totalBytes)} · ${_stats!.fileCount} 个文件',
              ),
              trailing: _stats == null
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _busy || (_stats?.fileCount ?? 0) == 0 ? null : _clear,
            icon: const Icon(Icons.cleaning_services_outlined),
            label: Text(_busy ? '正在清理…' : '清理下载缓存'),
          ),
          if (_error != null)
            TextButton(onPressed: _load, child: const Text('重新读取')),
          const SizedBox(height: 12),
          Text(
            '这里只清理当前服务器已下载到本机的文件，不会删除聊天记录、服务器文件或其他账号数据。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}
