import 'package:chat_api_client/chat_api_client.dart';

import '../../config/app_config.dart';

class CallInfo {
  const CallInfo({required this.id, required this.video});
  final String id;
  final bool video;
}

class CallToken {
  const CallToken({required this.url, required this.token});
  final String url;
  final String token;
}

class CallHistoryItem {
  const CallHistoryItem({
    required this.id,
    required this.video,
    required this.status,
    required this.outgoing,
    required this.startedAt,
    required this.answeredAt,
    required this.endedAt,
    required this.peerId,
    required this.peerName,
    required this.endReason,
  });

  final String id;
  final bool video;
  final String status;
  final bool outgoing;
  final DateTime startedAt;
  final DateTime? answeredAt;
  final DateTime? endedAt;
  final String peerId;
  final String peerName;
  final String? endReason;

  factory CallHistoryItem.fromJson(Map<String, dynamic> json) {
    final peer = json['peer'] is Map
        ? Map<String, dynamic>.from(json['peer'] as Map)
        : <String, dynamic>{};
    DateTime? date(Object? value) =>
        value == null ? null : DateTime.tryParse(value.toString())?.toLocal();
    return CallHistoryItem(
      id: json['id']?.toString() ?? '',
      video: json['type'] == 'VIDEO',
      status: json['status']?.toString() ?? '',
      outgoing: json['outgoing'] == true,
      startedAt: date(json['startedAt']) ?? DateTime.now(),
      answeredAt: date(json['answeredAt']),
      endedAt: date(json['endedAt']),
      peerId: peer['id']?.toString() ?? '',
      peerName: peer['nickname']?.toString() ?? '未知用户',
      endReason: json['endReason']?.toString(),
    );
  }
}

class CallService {
  const CallService(this._api);
  final ChatApiClient _api;

  Future<CallInfo> create(String targetUserId, {required bool video}) async {
    final response = await _api.dio.post<Object>(
      '/api/v1/calls',
      data: {'targetUserId': targetUserId, 'type': video ? 'VIDEO' : 'AUDIO'},
    );
    final data = _map(response.data);
    return CallInfo(id: data['id']?.toString() ?? '', video: video);
  }

  Future<CallToken> token(String callId) async {
    final response = await _api.dio.post<Object>('/api/v1/calls/$callId/token');
    final data = _map(response.data);
    return CallToken(
      url: AppConfig.resolveDeviceHost(data['url']?.toString() ?? ''),
      token: data['token']?.toString() ?? '',
    );
  }

  Future<void> accept(String callId) => _action(callId, 'accept');
  Future<void> reject(String callId) => _action(callId, 'reject');
  Future<void> busy(String callId) => _action(callId, 'busy');
  Future<void> cancel(String callId) => _action(callId, 'cancel');
  Future<void> miss(String callId) => _action(callId, 'miss');
  Future<void> end(String callId) => _action(callId, 'end');

  Future<List<CallHistoryItem>> history() async {
    final response = await _api.dio.get<Object>('/api/v1/calls');
    if (response.data is! List) return const [];
    return (response.data! as List)
        .map((value) => CallHistoryItem.fromJson(_map(value)))
        .toList();
  }

  Future<void> _action(String callId, String action) async {
    await _api.dio.post<Object>('/api/v1/calls/$callId/$action');
  }

  Map<String, dynamic> _map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}
