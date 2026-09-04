import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'join requests parse real-shaped group summaries and use typed contracts',
    () async {
      final api = ChatApiClient();
      final requests = <RequestOptions>[];
      final row = <String, Object>{
        'id': 'r',
        'groupId': 'g',
        'userId': 'u',
        'requestedById': 'u',
        'type': 'APPLY',
        'status': 'PENDING',
        'expiresAt': '2030-01-01T00:00:00Z',
        'createdAt': '2026-01-01T00:00:00Z',
        'group': {
          'id': 'g',
          'name': '测试群',
          'ownerId': 'owner',
          'memberLimit': 100,
          'muteAll': false,
          'status': 'ACTIVE',
        },
      };
      api.dio.interceptors.insert(
        0,
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response<Object>(
                requestOptions: request,
                statusCode: 200,
                data: request.method == 'GET' ? [row] : row,
              ),
            );
          },
        ),
      );
      addTearDown(() => api.dio.close(force: true));
      final repo = HomeRepository(api);
      expect(
        (await repo.groupJoinPage(actionable: false)).single.group!.name,
        '测试群',
      );
      await repo.groupJoinRequests(groupId: 'g');
      await repo.applyToGroup('g', ' 申请说明 ');
      await repo.inviteToGroup('g', 'u');
      await repo.decideGroupJoin('r', 'approve');
      await repo.decideGroupJoin('r', 'reject', message: ' 拒绝说明 ');
      await repo.decideGroupJoin('r', 'cancel');
      expect(requests.map((r) => r.path).toList(), [
        '/api/v1/groups/join-requests/me',
        '/api/v1/groups/g/join-requests',
        '/api/v1/groups/g/join-requests',
        '/api/v1/groups/g/invitations',
        '/api/v1/groups/join-requests/r/approve',
        '/api/v1/groups/join-requests/r/reject',
        '/api/v1/groups/join-requests/r/cancel',
      ]);
      expect(requests.map((r) => r.method).toList(), [
        'GET',
        'GET',
        'POST',
        'POST',
        'POST',
        'POST',
        'POST',
      ]);
      expect(requests[2].data, {'message': '申请说明'});
      expect(requests[3].data, {'userId': 'u'});
      expect(requests[5].data, {'message': '拒绝说明'});
      await expectLater(
        repo.decideGroupJoin('r', 'unsupported'),
        throwsArgumentError,
      );
      expect(requests.length, 7);
    },
  );
}
