import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const groupId = '10000000-0000-4000-8000-000000000001';
  const memberId = '20000000-0000-4000-8000-000000000002';
  final group = {
    'id': groupId,
    'name': '新群',
    'ownerId': 'me',
    'memberLimit': 100,
    'muteAll': false,
    'status': 'ACTIVE',
  };

  test('建群、改名和成员管理使用强类型 SDK', () async {
    final api = ChatApiClient();
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final destructive =
              request.path.endsWith('/leave') || request.method == 'DELETE';
          final nickname = request.path.endsWith('/members/me/nickname');
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: request.method == 'POST' ? 201 : 200,
              data: destructive
                  ? {'success': true}
                  : nickname
                  ? {
                      'groupId': groupId,
                      'userId': 'me',
                      'role': 'OWNER',
                      'status': 'ACTIVE',
                      'nickname': '蜘蛛侠',
                      'joinedAt': '2026-09-08T00:00:00.000Z',
                    }
                  : group,
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final repository = HomeRepository(api);

    await repository.createGroup(' 新群 ', [memberId]);
    await repository.renameGroup(groupId, ' 新名称 ');
    await repository.updateGroupAnnouncement(groupId, ' 重要公告 ');
    await repository.updateMyGroupNickname(groupId, ' 蜘蛛侠 ');
    await repository.addGroupMembers(groupId, [memberId]);
    await repository.removeGroupMember(groupId, memberId);
    await repository.leaveGroup(groupId);
    await repository.disbandGroup(groupId);

    expect(requests[0].data, {
      'name': '新群',
      'memberIds': [memberId],
    });
    expect(requests[1].data, {'name': '新名称'});
    expect(requests[2].data, {'announcement': '重要公告'});
    expect(requests[3].data, {'nickname': '蜘蛛侠'});
    expect(requests[4].data, {
      'userIds': [memberId],
    });
    expect(requests.map((request) => '${request.method} ${request.path}'), [
      'POST /api/v1/groups',
      'PATCH /api/v1/groups/$groupId',
      'PATCH /api/v1/groups/$groupId',
      'PATCH /api/v1/groups/$groupId/members/me/nickname',
      'POST /api/v1/groups/$groupId/members',
      'DELETE /api/v1/groups/$groupId/members/$memberId',
      'POST /api/v1/groups/$groupId/leave',
      'DELETE /api/v1/groups/$groupId',
    ]);
  });

  test('允许先创建只有群主的群聊', () async {
    final api = ChatApiClient();
    RequestOptions? request;
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response<Object>(
              requestOptions: options,
              statusCode: 201,
              data: group,
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));

    await HomeRepository(api).createGroup(' 个人群 ', const []);

    expect(request?.path, '/api/v1/groups');
    expect(request?.data, {'name': '个人群', 'memberIds': <String>[]});
  });

  test('解散群未获服务器确认时不报成功', () async {
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
      HomeRepository(api).disbandGroup(groupId),
      throwsA(isA<FormatException>()),
    );
  });
}
