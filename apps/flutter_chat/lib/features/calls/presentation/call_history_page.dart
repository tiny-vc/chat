import 'package:flutter/material.dart';

import '../../../core/calls/call_service.dart';
import '../../../core/widgets/app_feedback.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key, required this.callService});

  final CallService callService;

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<CallHistoryItem> _items = const [];
  bool _loading = true;
  Object? _error;

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
      if (mounted) setState(() => _items = items);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
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
              itemCount: _items.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final item = _items[index];
                final missed = item.status == 'MISSED';
                return ListTile(
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
                      Text(_status(item)),
                    ],
                  ),
                  trailing: Text(_time(item.startedAt)),
                );
              },
            ),
          ),
  );

  String _status(CallHistoryItem item) {
    final duration = item.answeredAt != null && item.endedAt != null
        ? item.endedAt!.difference(item.answeredAt!)
        : null;
    if (duration != null) {
      return '${item.video ? '视频' : '语音'}通话 ${_duration(duration)}';
    }
    if (item.endReason == 'BUSY') return '对方忙线中';
    if (item.endReason == 'MEDIA_DISCONNECTED') return '连接中断，通话已结束';
    return switch (item.status) {
      'MISSED' => item.outgoing ? '对方未接听' : '未接来电',
      'REJECTED' => item.outgoing ? '对方已拒绝' : '已拒绝',
      'CANCELLED' => '已取消',
      'FAILED' => '呼叫失败',
      _ => item.video ? '视频通话' : '语音通话',
    };
  }

  String _duration(Duration value) {
    final minutes = value.inMinutes;
    final seconds = value.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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
