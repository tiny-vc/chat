import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const userId = '10000000-0000-4000-8000-000000000001';
  final user = {'id': 'me', 'username': 'owner', 'nickname': '新昵称'};

  test('个人资料、密码、好友和举报使用强类型 SDK', () async {
    final api = ChatApiClient();
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final profile = request.path.startsWith('/api/v1/users/me');
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: request.method == 'POST' ? 201 : 200,
              data: profile ? user : {'success': true},
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final repository = HomeRepository(api);

    await repository.updateNickname(' 新昵称 ');
    await repository.setAvatar('file-1');
    await repository.removeAvatar();
    await repository.changePassword('old-password', 'new-password');
    await repository.removeFriend(userId);
    await repository.reportUser(userId, 'SPAM', '  反复发送  ');

    expect(requests[0].data, {'nickname': '新昵称'});
    expect(requests[1].data, {'fileId': 'file-1'});
    expect(requests[3].data, {
      'currentPassword': 'old-password',
      'newPassword': 'new-password',
    });
    expect(requests[5].data, {'reason': 'SPAM', 'details': '反复发送'});
    expect(requests.map((request) => '${request.method} ${request.path}'), [
      'PATCH /api/v1/users/me',
      'PUT /api/v1/users/me/avatar',
      'DELETE /api/v1/users/me/avatar',
      'POST /api/v1/auth/change-password',
      'DELETE /api/v1/friends/$userId',
      'POST /api/v1/users/$userId/report',
    ]);
  });

  test('不支持的举报原因不会发送请求', () async {
    final api = ChatApiClient();
    var requests = 0;
    api.dio.interceptors.add(
      InterceptorsWrapper(onRequest: (request, handler) => requests++),
    );
    addTearDown(() => api.dio.close(force: true));

    await expectLater(
      HomeRepository(api).reportUser(userId, 'UNKNOWN', null),
      throwsArgumentError,
    );
    expect(requests, 0);
  });
}
