import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/home/presentation/friend_profile_page.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _Services
    implements HomeController, ImService, FileTransferService, CallService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'friend profile actions remain clear on narrow large-text dark UI',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final services = _Services();
      final friend = FriendResponse(
        (b) => b
          ..friendshipId = 'friend'
          ..createdAt = DateTime(2026)
          ..user.update(
            (u) => u
              ..id = 'alice'
              ..username = 'alice_with_a_long_username'
              ..nickname = '一位名称非常长的测试好友',
          ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: FriendProfilePage(
              friend: friend,
              controller: services,
              imService: services,
              fileTransferService: services,
              callService: services,
              forwardTargets: const [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('发消息'), findsOneWidget);
      expect(find.text('语音通话'), findsOneWidget);
      expect(find.text('视频通话'), findsOneWidget);
      await tester.ensureVisible(find.text('加入黑名单'));
      await tester.pumpAndSettle();
      expect(find.text('加入黑名单'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
