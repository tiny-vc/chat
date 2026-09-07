import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const callId = '10000000-0000-4000-8000-000000000001';
  Map<String, Object?> session({
    String type = 'AUDIO',
    String status = 'RINGING',
  }) => {
    'id': callId,
    'initiatorUserId': 'me',
    'targetUserId': 'peer-1',
    'livekitRoomName': 'call-room',
    'type': type,
    'status': status,
    'startedAt': '2026-09-07T08:00:00.000Z',
  };

  test('创建、凭证、状态和全部转移接口使用强类型 SDK', () async {
    final api = ChatApiClient(basePathOverride: 'http://chat.example');
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final Object data = request.path.endsWith('/token')
              ? {'url': 'ws://media.example', 'token': 'join-token'}
              : session(
                  type: request.path == '/api/v1/calls' ? 'VIDEO' : 'AUDIO',
                  status: request.method == 'GET' ? 'CONNECTED' : 'RINGING',
                );
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: request.method == 'GET' ? 200 : 201,
              data: data,
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final service = CallService(api);

    final created = await service.create('peer-1', video: true);
    final token = await service.token(callId);
    final state = await service.state(callId);
    await service.accept(callId);
    await service.reject(callId);
    await service.busy(callId);
    await service.cancel(callId);
    await service.miss(callId);
    await service.end(callId);

    expect(created.id, callId);
    expect(created.video, isTrue);
    expect(token.url, 'ws://media.example');
    expect(token.token, 'join-token');
    expect(state.status, 'CONNECTED');
    expect(requests.first.data, {'targetUserId': 'peer-1', 'type': 'VIDEO'});
    expect(requests.map((request) => request.path), [
      '/api/v1/calls',
      '/api/v1/calls/$callId/token',
      '/api/v1/calls/$callId',
      '/api/v1/calls/$callId/accept',
      '/api/v1/calls/$callId/reject',
      '/api/v1/calls/$callId/busy',
      '/api/v1/calls/$callId/cancel',
      '/api/v1/calls/$callId/miss',
      '/api/v1/calls/$callId/end',
    ]);
  });

  test('通话记录使用强类型 SDK 解析并传递稳定分页游标', () async {
    final api = ChatApiClient();
    RequestOptions? captured;
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          captured = request;
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: 200,
              data: [
                {
                  'id': callId,
                  'initiatorUserId': 'me',
                  'targetUserId': 'peer-1',
                  'livekitRoomName': 'call-room',
                  'type': 'VIDEO',
                  'status': 'ENDED',
                  'startedAt': '2026-09-07T08:00:00.000Z',
                  'answeredAt': '2026-09-07T08:00:03.000Z',
                  'endedAt': '2026-09-07T08:01:00.000Z',
                  'endReason': 'hangup',
                  'outgoing': true,
                  'peer': {
                    'id': 'peer-1',
                    'username': 'alice',
                    'nickname': '爱丽丝',
                  },
                },
              ],
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final service = CallService(api);
    final cursor = CallHistoryItem(
      id: '20000000-0000-4000-8000-000000000002',
      video: false,
      status: 'ENDED',
      outgoing: false,
      startedAt: DateTime.parse('2026-09-06T12:00:00+08:00'),
      answeredAt: null,
      endedAt: null,
      peerId: 'peer-2',
      peerName: '测试',
      endReason: null,
    );

    final result = await service.history(before: cursor);

    expect(captured?.path, '/api/v1/calls');
    expect(captured?.queryParameters, {
      'before': '2026-09-06T04:00:00.000Z',
      'beforeId': cursor.id,
    });
    expect(result, hasLength(1));
    expect(result.single.id, callId);
    expect(result.single.video, isTrue);
    expect(result.single.status, 'ENDED');
    expect(result.single.outgoing, isTrue);
    expect(result.single.peerId, 'peer-1');
    expect(result.single.peerName, '爱丽丝');
    expect(result.single.endReason, 'hangup');
  });

  test('通话记录缺失响应体时显式失败', () async {
    final api = ChatApiClient();
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) => handler.resolve(
          Response<Object>(requestOptions: request, statusCode: 204),
        ),
      ),
    );
    addTearDown(() => api.dio.close(force: true));

    await expectLater(
      CallService(api).history(),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          '服务器没有返回通话记录。',
        ),
      ),
    );
  });
}
