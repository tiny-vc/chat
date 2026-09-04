import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _Services
    implements HomeController, ImService, FileTransferService, CallService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final user = UserResponse(
    (b) => b
      ..id = 'alice'
      ..username = 'Alice123'
      ..nickname = '小明',
  );
  final friend = FriendResponse(
    (b) => b
      ..friendshipId = 'friend'
      ..user.replace(user)
      ..createdAt = DateTime(2026),
  );
  final services = _Services();
  Future<void> mount(
    WidgetTester tester, {
    bool empty = false,
    bool groupWithoutMembers = false,
    double scale = 1,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: ContactsView(
              controller: services,
              imService: services,
              fileTransferService: services,
              callService: services,
              snapshot: HomeSnapshot(
                me: user,
                friends: empty ? [] : [friend],
                groups: groupWithoutMembers
                    ? [
                        GroupResponse(
                          (b) => b
                            ..id = 'group'
                            ..name = '讨论组'
                            ..ownerId = 'alice'
                            ..memberLimit = 100
                            ..muteAll = false
                            ..status = GroupResponseStatusEnum.ACTIVE,
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'no-match search keeps its field and can be edited without clearing',
    (tester) async {
      await mount(tester);
      await tester.enterText(find.byType(TextField), 'nobody');
      await tester.pumpAndSettle();
      expect(find.text('没有找到联系人'), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'ALICE');
      await tester.pumpAndSettle();
      expect(find.text('小明'), findsOneWidget);
      expect(find.text('没有找到联系人'), findsNothing);
      await tester.tap(find.byTooltip('清除搜索'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );

  testWidgets('missing member list is not presented as zero members', (
    tester,
  ) async {
    await mount(tester, groupWithoutMembers: true);
    expect(find.text('0 位成员'), findsNothing);
    expect(find.text('群聊'), findsOneWidget);
    expect(find.text('1 位好友 · 1 个群聊'), findsOneWidget);
  });

  testWidgets(
    'empty contacts retain search and recover from an unmatched query',
    (tester) async {
      await mount(tester, empty: true);
      expect(find.text('通讯录还是空的'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle();
      expect(find.text('没有找到联系人'), findsOneWidget);
      await tester.tap(find.byTooltip('清除搜索'));
      await tester.pumpAndSettle();
      expect(find.text('通讯录还是空的'), findsOneWidget);
    },
  );

  testWidgets('320px screen with double font scale does not overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(tester, scale: 2);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField), 'missing');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
