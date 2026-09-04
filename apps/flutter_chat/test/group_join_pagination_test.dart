import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/group_join_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'group_join_test.dart' as fixture;

class Repo implements HomeRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Controller extends HomeController {
  Controller() : super(Repo()) {
    snapshot = HomeSnapshot(
      me: UserResponse(
        (b) => b
          ..id = 'me'
          ..username = 'me'
          ..nickname = '我',
      ),
      friends: [],
      groups: [],
    );
  }
  bool failMore = true;
  final cursors = <String?>[];
  String? decision;
  @override
  Future<void> refreshPendingJoins() async {}
  @override
  Future<List<GroupJoinRequestResponse>> groupJoinPage({
    required bool actionable,
    GroupJoinRequestResponse? before,
  }) async {
    cursors.add(before?.id);
    if (actionable) {
      return [
        fixture
            .item(requestedBy: 'other')
            .rebuild(
              (b) => b
                ..userId = 'applicant'
                ..id = 'apply',
            ),
      ];
    }
    if (before == null) {
      return List.generate(
        100,
        (i) => fixture.item().rebuild(
          (b) => b
            ..id = 'r$i'
            ..status = GroupJoinRequestResponseStatusEnum.CANCELLED,
        ),
      );
    }
    if (failMore) throw StateError('network');
    return [
      fixture.item().rebuild(
        (b) => b
          ..id = 'last'
          ..status = GroupJoinRequestResponseStatusEnum.CANCELLED,
      ),
    ];
  }

  @override
  Future<void> decideGroupJoin(
    String requestId,
    String action, {
    String message = '',
  }) async {
    decision = '$requestId:$action';
  }
}

void main() {
  test('typed endpoints carry both cursor components', () async {
    final api = ChatApiClient();
    addTearDown(() => api.dio.close(force: true));
    final requests = <RequestOptions>[];
    api.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (r, h) {
          requests.add(r);
          h.resolve(
            Response<Object>(requestOptions: r, statusCode: 200, data: []),
          );
        },
      ),
    );
    final repo = HomeRepository(api);
    final cursor = fixture.item();
    await repo.groupJoinPage(actionable: true);
    await repo.groupJoinPage(actionable: false, before: cursor);
    expect(requests[0].path, '/api/v1/groups/join-requests/actionable');
    expect(requests[0].queryParameters, isEmpty);
    expect(requests[1].path, '/api/v1/groups/join-requests/me');
    expect(requests[1].queryParameters, {
      'before': cursor.createdAt.toUtc().toIso8601String(),
      'beforeId': cursor.id,
    });
  });

  testWidgets('cross-group actionable application can be approved', (
    tester,
  ) async {
    final controller = Controller();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: GroupJoinPage(controller: controller, actionable: true),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('同意申请'));
    await tester.tap(find.text('同意申请'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '同意申请'));
    await tester.pumpAndSettle();
    expect(controller.decision, 'apply:approve');
  });

  testWidgets('personal history retries same cursor and reaches end', (
    tester,
  ) async {
    final controller = Controller();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(home: GroupJoinPage(controller: controller)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('加载更多'), 2000, maxScrolls: 100);
    await tester.tap(find.text('加载更多'));
    await tester.pumpAndSettle();
    expect(find.text('加载更多失败，已有记录已保留。'), findsOneWidget);
    controller.failMore = false;
    await tester.ensureVisible(find.text('重试加载更多'));
    await tester.tap(find.text('重试加载更多'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('已显示全部记录'), 500);
    expect(controller.cursors, [null, 'r99', 'r99']);
    expect(find.text('已显示全部记录'), findsOneWidget);
  });
}
