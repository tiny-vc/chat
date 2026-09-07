import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';

import '../../config/server_settings.dart';
import 'call_terminal_outbox.dart';

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

class CallState {
  const CallState({required this.status, this.endReason});

  final String status;
  final String? endReason;

  bool get terminal => const {
    'REJECTED',
    'CANCELLED',
    'MISSED',
    'ENDED',
    'FAILED',
  }.contains(status);
}

final _callIdPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

String validateCallId(String value) {
  if (!_callIdPattern.hasMatch(value)) {
    throw const FormatException('通话标识无效，请刷新后重试。');
  }
  return value.toLowerCase();
}

String validateLiveKitUrl(String value, {required String apiBaseUrl}) {
  final resolved = AppConfig.resolveDeviceHost(value);
  final uri = Uri.tryParse(resolved);
  if (uri == null ||
      !['ws', 'wss'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty) {
    throw const FormatException('服务器返回了无效的音视频服务地址。');
  }
  final apiUri = Uri.tryParse(apiBaseUrl);
  if (apiUri?.scheme == 'https' && uri.scheme != 'wss') {
    throw const FormatException('安全服务器不能使用未加密的音视频信令连接。');
  }
  return uri.toString();
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

  factory CallHistoryItem.fromApi(CallHistoryResponse value) {
    return CallHistoryItem(
      id: value.id,
      video: value.type == CallSessionResponseTypeEnum.VIDEO,
      status: value.status.name,
      outgoing: value.outgoing,
      startedAt: value.startedAt.toLocal(),
      answeredAt: value.answeredAt?.toLocal(),
      endedAt: value.endedAt?.toLocal(),
      peerId: value.peer?.id ?? '',
      peerName: value.peer?.nickname ?? '未知用户',
      endReason: value.endReason,
    );
  }
}

class CallService {
  CallService(this._api, {CallTerminalOutbox? terminalOutbox})
    : _terminalOutbox =
          terminalOutbox ??
          CallTerminalOutbox(
            namespace: serverNamespace(_api.dio.options.baseUrl),
            send: (callId, action) => _sendTerminal(_api, callId, action),
          );
  final ChatApiClient _api;
  final CallTerminalOutbox _terminalOutbox;

  Future<CallInfo> create(String targetUserId, {required bool video}) async {
    final response = await _api.getCallsApi().callsCreate(
      createCallDto: CreateCallDto(
        (builder) => builder
          ..targetUserId = targetUserId
          ..type = video
              ? CreateCallDtoTypeEnum.VIDEO
              : CreateCallDtoTypeEnum.AUDIO,
      ),
    );
    final data = _requireSession(response.data);
    return CallInfo(
      id: validateCallId(data.id),
      video: data.type == CallSessionResponseTypeEnum.VIDEO,
    );
  }

  Future<CallToken> token(String callId) async {
    final safeCallId = validateCallId(callId);
    final response = await _api.getCallsApi().callsCreateToken(
      callId: safeCallId,
    );
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回音视频访问凭证。');
    final token = data.token;
    if (token.isEmpty) throw const FormatException('服务器没有返回音视频访问凭证。');
    return CallToken(
      url: validateLiveKitUrl(data.url, apiBaseUrl: _api.dio.options.baseUrl),
      token: token,
    );
  }

  Future<void> accept(String callId) => _action(callId, 'accept');
  Future<void> reject(String callId) => _action(callId, 'reject');
  Future<void> busy(String callId) => _action(callId, 'busy');
  Future<void> cancel(String callId) => _action(callId, 'cancel');
  Future<void> miss(String callId) => _action(callId, 'miss');
  Future<void> end(String callId) => _action(callId, 'end');

  /// Persists a terminal action before delivery. Safe to call without awaiting
  /// from UI hangup paths; [flushTerminalReports] retries it after resume.
  Future<void> reportTerminal(String callId, String action) =>
      _terminalOutbox.recordAndFlush(validateCallId(callId), action);

  Future<void> queueTerminal(String callId, String action) =>
      _terminalOutbox.record(validateCallId(callId), action);

  Future<void> flushTerminalReports() => _terminalOutbox.flush();

  Future<CallState> state(String callId) async {
    final safeCallId = validateCallId(callId);
    final response = await _api.getCallsApi().callsGet(callId: safeCallId);
    final data = _requireSession(response.data);
    return CallState(status: data.status.name, endReason: data.endReason);
  }

  Future<List<CallHistoryItem>> history({CallHistoryItem? before}) async {
    final response = await _api.getCallsApi().callsList(
      before: before?.startedAt.toUtc().toIso8601String(),
      beforeId: before?.id,
    );
    final data = response.data;
    if (data == null) throw const FormatException('服务器没有返回通话记录。');
    return data.map(CallHistoryItem.fromApi).toList(growable: false);
  }

  Future<void> _action(String callId, String action) async {
    final safeCallId = validateCallId(callId);
    final calls = _api.getCallsApi();
    final response = switch (action) {
      'accept' => await calls.callsAccept(callId: safeCallId),
      'reject' => await calls.callsReject(callId: safeCallId),
      'busy' => await calls.callsBusy(callId: safeCallId),
      'cancel' => await calls.callsCancel(callId: safeCallId),
      'miss' => await calls.callsMiss(callId: safeCallId),
      'end' => await calls.callsEnd(callId: safeCallId),
      _ => throw ArgumentError.value(action, 'action', '不支持的通话操作'),
    };
    _requireSession(response.data);
  }

  CallSessionResponse _requireSession(CallSessionResponse? value) =>
      value ?? (throw const FormatException('服务器没有返回通话状态。'));
}

Future<void> _sendTerminal(
  ChatApiClient api,
  String callId,
  String action,
) async {
  try {
    final calls = api.getCallsApi();
    switch (action) {
      case 'reject':
        await calls.callsReject(callId: callId);
        return;
      case 'busy':
        await calls.callsBusy(callId: callId);
        return;
      case 'cancel':
        await calls.callsCancel(callId: callId);
        return;
      case 'miss':
        await calls.callsMiss(callId: callId);
        return;
      case 'end':
        await calls.callsEnd(callId: callId);
        return;
      default:
        throw ArgumentError.value(action, 'action', '不支持的通话操作');
    }
  } on DioException catch (error) {
    // A terminal state already won, the call expired, or this installation now
    // belongs to another account. None can become deliverable on a later retry.
    if ({403, 404, 409}.contains(error.response?.statusCode)) return;
    rethrow;
  }
}
