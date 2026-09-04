import 'dart:async';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';

UserResponse user(String id) => UserResponse(
  (b) => b
    ..id = id
    ..username = id
    ..nickname = id,
);
GroupMemberResponse member(String id, GroupMemberResponseRoleEnum role) =>
    GroupMemberResponse(
      (b) => b
        ..groupId = 'g'
        ..userId = id
        ..role = role
        ..status = GroupMemberResponseStatusEnum.ACTIVE
        ..joinedAt = DateTime.utc(2026)
        ..user.replace(user(id)),
    );

class GroupsFake implements HomeRepository {
  String me = 'owner';
  int calls = 0;
  int? minutes;
  bool failReload = false;
  Completer<void>? pending;
  GroupResponse group = GroupResponse(
    (b) => b
      ..id = 'g'
      ..name = '测试群'
      ..ownerId = 'owner'
      ..memberLimit = 100
      ..muteAll = false
      ..status = GroupResponseStatusEnum.ACTIVE
      ..members.addAll([
        member('owner', GroupMemberResponseRoleEnum.OWNER),
        member('admin', GroupMemberResponseRoleEnum.ADMIN),
        member('member', GroupMemberResponseRoleEnum.MEMBER),
      ]),
  );
  @override
  Future<HomeSnapshot> load() async =>
      HomeSnapshot(me: user(me), friends: [], groups: [group]);
  @override
  Future<GroupResponse> getGroup(String id) async {
    if (failReload) throw StateError('private-server-details');
    return group;
  }

  @override
  Future<void> setGroupAdmin(String id, String uid, bool admin) async {
    calls++;
    await pending?.future;
    group = group.rebuild(
      (b) => b.members.map(
        (m) => m.userId == uid
            ? m.rebuild(
                (b) => b.role = admin
                    ? GroupMemberResponseRoleEnum.ADMIN
                    : GroupMemberResponseRoleEnum.MEMBER,
              )
            : m,
      ),
    );
  }

  @override
  Future<void> transferGroupOwner(String id, String uid) async {
    calls++;
    group = group.rebuild(
      (b) => b
        ..ownerId = uid
        ..members.map(
          (m) => m.rebuild(
            (b) => b.role = m.userId == uid
                ? GroupMemberResponseRoleEnum.OWNER
                : GroupMemberResponseRoleEnum.ADMIN,
          ),
        ),
    );
  }

  @override
  Future<void> muteGroupMember(
    String id,
    String uid,
    bool muted, {
    int? minutes,
  }) async {
    calls++;
    this.minutes = minutes;
    group = group.rebuild(
      (b) => b.members.map(
        (m) => m.userId == uid
            ? m.rebuild(
                (b) => b.mutedUntil = muted
                    ? DateTime.now().add(Duration(minutes: minutes!))
                    : null,
              )
            : m,
      ),
    );
  }

  @override
  Future<void> setGroupMuteAll(String id, bool muted) async {
    calls++;
    group = group.rebuild((b) => b.muteAll = muted);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> open(WidgetTester tester, GroupsFake repo) async {
  final controller = HomeController(repo);
  await controller.load();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: GroupSettingsPage(
        groupId: 'g',
        controller: controller,
        fileTransferService: FileTransferService(ChatApiClient()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> action(WidgetTester tester, String title) async {
  await tester.scrollUntilVisible(memberMenu, 200);
  await tester.pumpAndSettle();
  await tester.tap(memberMenu);
  await tester.pumpAndSettle();
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

Finder get memberMenu => find.byWidgetPredicate(
  (widget) => widget is PopupMenuButton<String> && widget.tooltip == '管理member',
);

Future<void> confirm(WidgetTester tester, String title) async {
  await tester.tap(find.widgetWithText(FilledButton, title));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'ordinary members cannot manage, admins cannot manage peers or owner',
    (tester) async {
      final repo = GroupsFake()..me = 'member';
      await open(tester, repo);
      expect(find.byType(SwitchListTile), findsNothing);
      expect(find.byType(PopupMenuButton<String>), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      repo.me = 'admin';
      await open(tester, repo);
      expect(find.byTooltip('管理owner'), findsNothing);
      expect(find.byTooltip('管理admin'), findsNothing);
      await tester.scrollUntilVisible(memberMenu, 200);
      await tester.pumpAndSettle();
      await tester.tap(memberMenu);
      await tester.pumpAndSettle();
      expect(find.text('设置管理员'), findsNothing);
      expect(find.text('转让群主'), findsNothing);
      expect(find.text('禁言成员'), findsOneWidget);
    },
  );
  testWidgets(
    'role change requires confirmation and blocks repeated submission',
    (tester) async {
      final repo = GroupsFake();
      await open(tester, repo);
      await action(tester, '设置管理员');
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(repo.calls, 0);
      await action(tester, '设置管理员');
      repo.pending = Completer<void>();
      await tester.tap(find.widgetWithText(FilledButton, '设置管理员'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(repo.calls, 1);
      expect(
        tester.widget<PopupMenuButton<String>>(memberMenu).enabled,
        isFalse,
      );
      repo.pending!.complete();
      await tester.pumpAndSettle();
      await action(tester, '取消管理员');
      await confirm(tester, '取消管理员');
      expect(repo.calls, 2);
    },
  );
  testWidgets('transfer refreshes ownership and removes owner-only actions', (
    tester,
  ) async {
    final repo = GroupsFake();
    await open(tester, repo);
    await action(tester, '转让群主');
    await confirm(tester, '转让群主');
    expect(repo.calls, 1);
    expect(repo.group.ownerId, 'member');
    expect(find.text('退出群聊'), findsOneWidget);
    expect(find.text('解散群聊'), findsNothing);
    expect(find.byTooltip('管理member'), findsNothing);
  });
  testWidgets('timed mute, unmute and whole-group mute use explicit values', (
    tester,
  ) async {
    final repo = GroupsFake();
    await open(tester, repo);
    await action(tester, '禁言成员');
    await tester.tap(find.text('15 分钟'));
    await tester.pumpAndSettle();
    await confirm(tester, '确认禁言');
    expect(repo.minutes, 15);
    await action(tester, '解除禁言');
    await confirm(tester, '解除禁言');
    expect(repo.group.members!.last.mutedUntil, isNull);
    await tester.scrollUntilVisible(find.text('全员禁言'), -200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('全员禁言'));
    await tester.pumpAndSettle();
    await confirm(tester, '开启全员禁言');
    expect(repo.group.muteAll, isTrue);
  });
  testWidgets(
    'failed refresh disables stale mutation controls and offers retry',
    (tester) async {
      final repo = GroupsFake();
      await open(tester, repo);
      repo.failReload = true;
      await tester.tap(find.byTooltip('刷新'));
      await tester.pumpAndSettle();
      expect(find.text('群资料更新失败，暂时无法操作。请刷新后重试。'), findsOneWidget);
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
        isNull,
      );
      repo.failReload = false;
      await tester.tap(find.byTooltip('刷新'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).onChanged,
        isNotNull,
      );
    },
  );
}
