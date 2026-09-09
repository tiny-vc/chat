import 'package:flutter/material.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/notification_center_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedRepository implements HomeRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Files implements FileTransferService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NotificationController extends HomeController {
  _NotificationController() : super(_UnusedRepository());

  int friendRefreshes = 0;
  int groupRefreshes = 0;

  @override
  Future<void> refreshPendingFriends() async {
    friendRefreshes++;
    pendingFriendCount = 2;
    notifyListeners();
  }

  @override
  Future<void> refreshPendingJoins() async {
    groupRefreshes++;
    pendingJoinCount = 3;
    notifyListeners();
  }
}

void main() {
  testWidgets('disabled group capability excludes group refresh and count', (
    tester,
  ) async {
    final controller = _NotificationController()..pendingJoinCount = 99;
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationCenterPage(
          controller: controller,
          groupsEnabled: false,
          fileTransferService: _Files(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.friendRefreshes, 1);
    expect(controller.groupRefreshes, 0);
    expect(find.text('2 项待处理'), findsOneWidget);
    expect(find.text('群聊申请与邀请'), findsNothing);
  });

  testWidgets('notification summary combines enabled actionable sources', (
    tester,
  ) async {
    final controller = _NotificationController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationCenterPage(
          controller: controller,
          groupsEnabled: true,
          fileTransferService: _Files(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.friendRefreshes, 1);
    expect(controller.groupRefreshes, 1);
    expect(find.text('5 项待处理'), findsOneWidget);
    expect(find.text('群聊申请与邀请'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
