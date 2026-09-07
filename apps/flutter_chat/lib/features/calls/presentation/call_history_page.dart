import 'package:flutter/material.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/widgets/app_feedback.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key, required this.callService, this.onRedial});

  final CallService callService;
  final Future<void> Function(CallHistoryItem item)? onRedial;

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<CallHistoryItem> _items = const [];
  bool _loading = true;
  Object? _error;
  String? _redialingId;
  bool _moreLoading = false;
  bool _hasMore = false;
  Object? _moreError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.callService.history();
      if (mounted) {
        setState(() {
          _items = items;
          _hasMore = items.length == 100;
          _moreError = null;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error);
        if (_items.isNotEmpty) {
          AppFeedback.error(context, error, fallback: '刷新失败，当前显示上次加载的通话记录');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _moreLoading || !_hasMore || _items.isEmpty) return;
    setState(() {
      _moreLoading = true;
      _moreError = null;
    });
    try {
      final rows = await widget.callService.history(before: _items.last);
      if (!mounted) return;
      setState(() {
        final ids = _items.map((item) => item.id).toSet();
        _items = [..._items, ...rows.where((item) => ids.add(item.id))];
        _hasMore = rows.length == 100;
      });
    } catch (error) {
      if (mounted) setState(() => _moreError = error);
    } finally {
      if (mounted) setState(() => _moreLoading = false);
    }
  }

  Future<void> _redial(CallHistoryItem item) async {
    final action = widget.onRedial;
    if (action == null || item.peerId.isEmpty || _redialingId != null) return;
    setState(() => _redialingId = item.id);
    try {
      await action(item);
      if (mounted) await _load();
    } finally {
      if (mounted) setState(() => _redialingId = null);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('通话记录'),
      actions: [
        IconButton(
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: _loading && _items.isEmpty
        ? const AppLoading(message: '正在加载通话记录…')
        : _error != null && _items.isEmpty
        ? AppStatus(
            title: '通话记录加载失败',
            message: '请检查网络后重试',
            icon: Icons.cloud_off_outlined,
            onRetry: _load,
          )
        : _items.isEmpty
        ? const AppStatus(
            title: '暂无通话记录',
            message: '与好友通话后，记录会显示在这里',
            icon: Icons.call_outlined,
          )
        : RefreshIndicator(
            onRefresh: _load,
            child: ListView.separated(
              itemCount:
                  _items.length + (_hasMore || _moreError != null ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: _moreError != null
                          ? OutlinedButton.icon(
                              onPressed: _loadMore,
                              icon: const Icon(Icons.refresh),
                              label: const Text('加载失败，点击重试'),
                            )
                          : TextButton(
                              onPressed: _moreLoading ? null : _loadMore,
                              child: Text(_moreLoading ? '正在加载…' : '加载更多'),
                            ),
                    ),
                  );
                }
                final item = _items[index];
                final missed = item.status == 'MISSED';
                return ListTile(
                  onTap:
                      item.peerId.isEmpty ||
                          widget.onRedial == null ||
                          _redialingId != null
                      ? null
                      : () => _redial(item),
                  leading: CircleAvatar(
                    child: Icon(item.video ? Icons.videocam : Icons.call),
                  ),
                  title: Text(
                    item.peerName,
                    style: missed
                        ? TextStyle(color: Theme.of(context).colorScheme.error)
                        : null,
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        item.outgoing ? Icons.call_made : Icons.call_received,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          callHistoryStatus(item),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_time(item.startedAt)),
                      if (_redialingId == item.id)
                        const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (item.peerId.isNotEmpty &&
                          widget.onRedial != null)
                        const Icon(Icons.call_outlined, size: 18),
                    ],
                  ),
                );
              },
            ),
          ),
  );

  String _time(DateTime value) {
    final now = DateTime.now();
    String two(int number) => number.toString().padLeft(2, '0');
    if (value.year == now.year &&
        value.month == now.month &&
        value.day == now.day) {
      return '${two(value.hour)}:${two(value.minute)}';
    }
    return '${value.month}/${value.day}';
  }
}

String callHistoryStatus(CallHistoryItem item) {
  final duration = item.answeredAt != null && item.endedAt != null
      ? item.endedAt!.difference(item.answeredAt!)
      : null;
  if (duration != null && !duration.isNegative) {
    final suffix = item.endReason == 'MEDIA_DISCONNECTED' ? ' · 连接中断' : '';
    return '${item.video ? '视频' : '语音'}通话 ${formatCallDuration(duration)}$suffix';
  }
  return switch (item.endReason) {
    'BUSY' => item.outgoing ? '对方忙线中' : '已回复忙线',
    'MEDIA_DISCONNECTED' => '连接中断，通话已结束',
    'SIGNAL_FAILED' => '呼叫发送失败',
    'NO_ANSWER' => item.outgoing ? '对方未接听' : '未接来电',
    'REJECTED' => item.outgoing ? '对方已拒绝' : '已拒绝',
    'CANCELLED' => item.outgoing ? '已取消' : '对方已取消',
    _ => switch (item.status) {
      'MISSED' => item.outgoing ? '对方未接听' : '未接来电',
      'REJECTED' => item.outgoing ? '对方已拒绝' : '已拒绝',
      'CANCELLED' => item.outgoing ? '已取消' : '对方已取消',
      'FAILED' => '呼叫失败',
      'ENDED' => '通话已结束',
      _ => item.video ? '视频通话' : '语音通话',
    },
  };
}

String formatCallDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60);
  final seconds = value.inSeconds.remainder(60);
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${value.inMinutes}:${seconds.toString().padLeft(2, '0')}';
}
