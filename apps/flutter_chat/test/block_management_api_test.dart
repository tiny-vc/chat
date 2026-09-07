import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const userId = '10000000-0000-4000-8000-000000000001';
  final blocked = {
    'user': {'id': userId, 'username': 'alice', 'nickname': '爱丽丝'},
    'createdAt': '2026-09-07T08:00:00.000Z',
  };

  test('黑名单读写全部使用强类型 SDK', () async {
    final api = ChatApiClient();
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: request.method == 'POST' ? 201 : 200,
              data: request.method == 'GET'
                  ? [blocked]
                  : request.method == 'POST'
                  ? blocked
                  : {'success': true},
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final repository = HomeRepository(api);

    final items = await repository.blockedUsers();
    await repository.blockUser(userId);
    await repository.unblockUser(userId);

    expect(items.single.user.id, userId);
    expect(items.single.user.username, 'alice');
    expect(items.single.user.nickname, '爱丽丝');
    expect(items.single.createdAt, isNotNull);
    expect(requests.map((request) => '${request.method} ${request.path}'), [
      'GET /api/v1/blocks',
      'POST /api/v1/blocks/$userId',
      'DELETE /api/v1/blocks/$userId',
    ]);
  });

  test('移出黑名单未获服务器确认时不报成功', () async {
    final api = ChatApiClient();
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) => handler.resolve(
          Response<Object>(
            requestOptions: request,
            statusCode: 200,
            data: {'success': false},
          ),
        ),
      ),
    );
    addTearDown(() => api.dio.close(force: true));

    await expectLater(
      HomeRepository(api).unblockUser(userId),
      throwsA(isA<FormatException>()),
    );
  });
}
