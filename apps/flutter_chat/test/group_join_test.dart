import 'dart:async';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/group_join_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo implements HomeRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GroupJoinRequestResponse item({
  bool invite = false,
  bool expired = false,
  String requestedBy = 'me',
}) => GroupJoinRequestResponse(
  (b) => b
    ..id = 'r'
    ..groupId = 'g'
    ..userId = 'me'
    ..requestedById = requestedBy
    ..type = invite
        ? GroupJoinRequestResponseTypeEnum.INVITE
        : GroupJoinRequestResponseTypeEnum.APPLY
    ..status = GroupJoinRequestResponseStatusEnum.PENDING
    ..expiresAt = DateTime.now().add(Duration(days: expired ? -1 : 1))
    ..createdAt = DateTime.now(),
);

class _Controller extends HomeController {
  _Controller() : super(_Repo()) {
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
  List<GroupJoinRequestResponse> rows = [];
  @override
  Future<List<GroupJoinRequestResponse>> groupJoinPage({
    required bool actionable,
    GroupJoinRequestResponse? before,
  }) => groupJoinRequests(groupId: 'g');
  bool fail = false;
  int calls = 0;
  String? lastAction;
  Completer<void>? pending;
  @override
  Future<List<GroupJoinRequestResponse>> groupJoinRequests({
    required String groupId,
  }) async {
    if (fail) throw StateError('internal-server-error');
    return rows;
  }

  @override
  Future<void> decideGroupJoin(
    String requestId,
    String action, {
    String message = '',
  }) async {
    calls++;
    lastAction = action;
    await pending?.future;
    rows = [
      for (final row in rows)
        row.rebuild(
          (b) => b.status = GroupJoinRequestResponseStatusEnum.APPROVED,
        ),
    ];
  }

  @override
  Future<void> applyToGroup(String id, String message) async {
    calls++;
  }
}

Future<void> _mount(
  WidgetTester tester,
  _Controller controller, {
  String? groupId,
}) async {
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: GroupJoinPage(controller: controller, groupId: groupId),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test(
    'approval authority distinguishes invitations, applications and expiry',
    () {
      expect(groupJoinActions(item(), 'me', null), ['cancel']);
      expect(groupJoinActions(item(), 'admin', 'g'), ['approve', 'reject']);
      expect(
        groupJoinActions(
          item(invite: true, requestedBy: 'admin'),
          'admin',
          'g',
        ),
        ['cancel'],
      );
      expect(
        groupJoinActions(
          item(invite: true, requestedBy: 'admin'),
          'other-admin',
          'g',
        ),
        isEmpty,
      );
      expect(
        groupJoinActions(item(invite: true, requestedBy: 'admin'), 'me', null),
        ['approve', 'reject'],
      );
      expect(groupJoinActions(item(expired: true), 'me', 'g'), isEmpty);
      expect(groupJoinActions(item(), null, 'g'), isEmpty);
    },
  );
  testWidgets(
    'accept requires confirmation, blocks duplicates and reloads state',
    (tester) async {
      final c = _Controller()
        ..rows = [item(invite: true, requestedBy: 'admin')];
      await _mount(tester, c);
      await tester.tap(find.text('接受邀请'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(c.calls, 0);
      await tester.tap(find.text('接受邀请'));
      await tester.pumpAndSettle();
      c.pending = Completer<void>();
      await tester.tap(find.widgetWithText(FilledButton, '接受邀请'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(c.calls, 1);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, '接受邀请'))
            .onPressed,
        isNull,
      );
      c.pending!.complete();
      await tester.pumpAndSettle();
      expect(find.text('接受邀请'), findsNothing);
      expect(find.text('入群邀请 · 已通过'), findsOneWidget);
    },
  );
  testWidgets(
    'application validates group ID and does not submit invalid data',
    (tester) async {
      final c = _Controller();
      await _mount(tester, c);
      await tester.tap(find.text('申请加入群聊'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, '群 ID'),
        'not-a-group-id',
      );
      await tester.tap(find.text('提交申请'));
      await tester.pumpAndSettle();
      expect(find.text('请输入有效的群 ID'), findsOneWidget);
      expect(c.calls, 0);
      await tester.enterText(
        find.widgetWithText(TextFormField, '群 ID'),
        '00000000-0000-4000-8000-000000000001',
      );
      await tester.tap(find.text('提交申请'));
      await tester.pumpAndSettle();
      expect(c.calls, 1);
    },
  );
  testWidgets('failed loads are retryable and expired rows have no actions', (
    tester,
  ) async {
    final c = _Controller()
      ..fail = true
      ..rows = [item(expired: true)];
    await _mount(tester, c);
    expect(find.text('入群记录加载失败'), findsOneWidget);
    c.fail = false;
    await tester.tap(find.text('重试'));
    await tester.pumpAndSettle();
    expect(find.text('入群申请 · 已过期'), findsOneWidget);
    expect(find.text('撤回'), findsNothing);
  });
  for (final brightness in Brightness.values) {
    testWidgets('long records fit narrow large-text $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = _Controller()
        ..rows = [item().rebuild((b) => b.message = '很长的申请说明' * 60)];
      addTearDown(c.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: GroupJoinPage(controller: c),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('撤回'), 300);
      expect(tester.takeException(), isNull);
    });
  }
}
