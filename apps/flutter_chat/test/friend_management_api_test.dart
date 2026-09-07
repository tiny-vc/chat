import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const userId = '10000000-0000-4000-8000-000000000001';
  const requestId = '20000000-0000-4000-8000-000000000002';
  final user = {'id': userId, 'username': 'alice', 'nickname': '爱丽丝'};
  final friendship = {
    'id': requestId,
    'requesterId': userId,
    'addresseeId': 'me',
    'status': 'PENDING',
  };

  test('搜索和好友申请全链路使用强类型 SDK 且列表无 N+1 请求', () async {
    final api = ChatApiClient();
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final Object data;
          if (request.path == '/api/v1/users/search') {
            data = [user];
          } else if (request.method == 'GET') {
            data = [
              {...friendship, 'requester': user},
            ];
          } else {
            data = friendship;
          }
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
    final repository = HomeRepository(api);

    final users = await repository.searchUsers(' alice ');
    await repository.requestFriend(userId);
    final pending = await repository.friendRequests();
    await repository.respondToFriendRequest(requestId, true);
    await repository.respondToFriendRequest(requestId, false);

    expect(users.single.nickname, '爱丽丝');
    expect(pending.single.requester.id, userId);
    expect(pending.single.status, 'PENDING');
    expect(requests, hasLength(5));
    expect(requests.first.queryParameters, {'q': 'alice'});
    expect(requests[1].data, {'userId': userId});
    expect(requests.map((request) => '${request.method} ${request.path}'), [
      'GET /api/v1/users/search',
      'POST /api/v1/friends/requests',
      'GET /api/v1/friends/requests',
      'POST /api/v1/friends/requests/$requestId/accept',
      'POST /api/v1/friends/requests/$requestId/reject',
    ]);
  });
}
