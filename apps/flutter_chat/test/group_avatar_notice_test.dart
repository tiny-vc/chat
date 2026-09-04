import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'group_avatar_test.dart' as avatar;
import 'group_management_test.dart' as fixtures;

class DelayedGroups extends fixtures.GroupsFake {
  Completer<HomeSnapshot>? first;
  int loads = 0;
  @override
  Future<HomeSnapshot> load() async {
    loads++;
    if (loads == 1) return first!.future;
    return super.load();
  }
}

void main() {
  test('only recognized group notices request authoritative refresh', () async {
    final dio = Dio();
    final im = ImService(dio);
    final events = <String>[];
    final subscription = im.groupChanges.listen(events.add);
    final content = ChatSystemContent()
      ..decodeJson({'event': 'group.avatar_changed'});
    expect(content.displayText(), '群头像已更新');
    im.handleGroupNotice(
      WKMsg()
        ..channelID = 'g'
        ..channelType = 1
        ..messageContent = content,
    );
    im.handleGroupNotice(
      WKMsg()
        ..channelID = 'g'
        ..channelType = 2
        ..messageContent = (ChatSystemContent()..event = 'unknown'),
    );
    im.handleGroupNotice(
      WKMsg()
        ..channelID = 'g'
        ..channelType = 2
        ..messageContent = content,
    );
    await Future<void>.delayed(Duration.zero);
    expect(events, ['g']);
    await subscription.cancel();
    im.dispose();
    im.handleGroupNotice(WKMsg()..channelType = 2);
    dio.close();
  });

  test('notices arriving during a load trigger a trailing reload', () async {
    final repo = DelayedGroups()..first = Completer<HomeSnapshot>();
    final controller = HomeController(repo);
    final pending = controller.load();
    await controller.refreshRemoteGroup('g');
    await controller.refreshRemoteGroup('g');
    repo.first!.complete(
      HomeSnapshot(me: fixtures.user('owner'), friends: [], groups: []),
    );
    await pending;
    expect(repo.loads, 2);
    expect(controller.snapshot!.groups.single.id, 'g');
    expect(controller.groupRevisions['g'], 2);
    controller.dispose();
    await controller.refreshRemoteGroup('g');
    expect(repo.loads, 2);
  });

  testWidgets('open group page refreshes avatar on notice and removal', (
    tester,
  ) async {
    final repo = avatar.AvatarRepo()..me = 'member';
    final controller = HomeController(repo);
    await controller.load();
    await tester.pumpWidget(
      MaterialApp(
        home: GroupSettingsPage(
          groupId: 'g',
          controller: controller,
          fileTransferService: avatar.AvatarFiles(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    repo.group = repo.group.rebuild((b) => b.avatarFileId = 'remote-file');
    await controller.refreshRemoteGroup('g');
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId,
      'remote-file',
    );
    repo.group = repo.group.rebuild((b) => b.avatarFileId = null);
    await controller.refreshRemoteGroup('g');
    await tester.pumpAndSettle();
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await controller.refreshRemoteGroup('g');
    controller.dispose();
  });
}
