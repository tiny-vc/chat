import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'group management uses generated API contracts without network',
    () async {
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
                statusCode: 200,
                data: request.path.contains('/members/')
                    ? {
                        'groupId': 'g',
                        'userId': 'u',
                        'role': 'MEMBER',
                        'status': 'ACTIVE',
                        'joinedAt': '2026-01-01T00:00:00.000Z',
                      }
                    : {
                        'id': 'g',
                        'name': '测试群',
                        'ownerId': 'u',
                        'memberLimit': 100,
                        'muteAll': true,
                        'status': 'ACTIVE',
                      },
              ),
            );
          },
        ),
      );
      addTearDown(() => api.dio.close(force: true));
      final repository = HomeRepository(api);
      await repository.setGroupAdmin('g', 'u', true);
      await repository.setGroupAdmin('g', 'u', false);
      await repository.transferGroupOwner('g', 'u');
      await repository.muteGroupMember('g', 'u', true, minutes: 15);
      await repository.muteGroupMember('g', 'u', false);
      await repository.setGroupMuteAll('g', true);
      await repository.setGroupAvatar('g', 'file-id');
      await repository.removeGroupAvatar('g');
      expect(requests.map((r) => r.method).toList(), [
        'PATCH',
        'PATCH',
        'POST',
        'PATCH',
        'PATCH',
        'PATCH',
        'PUT',
        'DELETE',
      ]);
      expect(requests.map((r) => r.path).toList(), [
        '/api/v1/groups/g/members/u/role',
        '/api/v1/groups/g/members/u/role',
        '/api/v1/groups/g/transfer-owner',
        '/api/v1/groups/g/members/u/mute',
        '/api/v1/groups/g/members/u/mute',
        '/api/v1/groups/g',
        '/api/v1/groups/g/avatar',
        '/api/v1/groups/g/avatar',
      ]);
      expect(requests.map((r) => r.data).toList(), [
        {'role': 'ADMIN'},
        {'role': 'MEMBER'},
        {'userId': 'u'},
        {'muted': true, 'durationMinutes': 15},
        {'muted': false},
        {'muteAll': true},
        {'fileId': 'file-id'},
        null,
      ]);
    },
  );
}
