import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/home/presentation/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

class Conversation extends WKUIConversationMsg {
  Conversation(String id) {
    channelID = id;
    channelType = 1;
    unreadCount = 3;
  }
  @override
  Future<WKMsg?> getWkMsg() async => null;
}

class Services implements FileTransferService, CallService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Harness {
  final dio = Dio();
  late final im = ImService(dio);
  final requests = <RequestOptions>[];
  bool archived = false;
  bool fail = false;
  bool invalidList = false;
  Completer<void>? pending;
  Harness() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (r, h) async {
          requests.add(r);
          if (r.method == 'PATCH') {
            await pending?.future;
            if (fail) {
              h.reject(
                DioException(
                  requestOptions: r,
                  type: DioExceptionType.connectionError,
                ),
              );
              return;
            }
            archived = (r.data as Map)['archived'] as bool;
          }
          h.resolve(
            Response<Object>(
              requestOptions: r,
              statusCode: 200,
              data: invalidList && r.method == 'GET'
                  ? {}
                  : r.method == 'GET'
                  ? [
                      {
                        'channelId': 'alice',
                        'channelType': 1,
                        'archived': archived,
                        'pinned': true,
                        'muted': true,
                      },
                    ]
                  : {},
            ),
          );
        },
      ),
    );
    im.conversations = [Conversation('alice')];
    im.connectionState = ImConnectionState.connected;
    im.conversationSettings['1:alice'] = const ConversationSetting(
      pinned: true,
      muted: true,
    );
  }
  void close() {
    im.dispose();
    dio.close(force: true);
  }
}

Future<void> mount(
  WidgetTester tester,
  Harness h, {
  bool dark = false,
  double scale = 1,
}) async {
  final services = Services();
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Scaffold(
        body: ConversationsView(
          imService: h.im,
          fileTransferService: services,
          callService: services,
          snapshot: null,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test(
    'archive contract preserves messages, unread and other settings; restore reverses filter',
    () async {
      final h = Harness();
      addTearDown(h.close);
      final original = h.im.conversations.single;
      await h.im.updateConversationSetting(
        channelId: 'alice',
        channelType: 1,
        archived: true,
      );
      expect(h.requests.map((r) => r.method), ['PATCH', 'GET']);
      expect(h.requests.first.path, '/api/v1/conversations/settings');
      expect(h.requests.first.data, {
        'channelId': 'alice',
        'channelType': 1,
        'archived': true,
      });
      expect(h.im.conversationsFor(archived: false), isEmpty);
      expect(h.im.conversationsFor(archived: true).single, same(original));
      expect(original.unreadCount, 3);
      expect(h.im.settingFor('alice', 1).pinned, isTrue);
      expect(h.im.settingFor('alice', 1).muted, isTrue);
      original.unreadCount++;
      h.im.notifyListeners();
      expect(h.im.conversationsFor(archived: false), isEmpty);
      await h.im.updateConversationSetting(
        channelId: 'alice',
        channelType: 1,
        archived: false,
      );
      expect(h.requests[2].data['archived'], isFalse);
      expect(h.im.conversationsFor(archived: false).single, same(original));
    },
  );

  test(
    'pending operation deduplicates and failure retains list for retry',
    () async {
      final h = Harness()
        ..pending = Completer<void>()
        ..fail = true;
      addTearDown(h.close);
      final first = h.im.updateConversationSetting(
        channelId: 'alice',
        channelType: 1,
        archived: true,
      );
      final assertion = expectLater(first, throwsA(isA<DioException>()));
      await h.im.updateConversationSetting(
        channelId: 'alice',
        channelType: 1,
        archived: true,
      );
      expect(h.im.isUpdatingSetting('alice', 1), isTrue);
      h.pending!.complete();
      await assertion;
      expect(h.requests, hasLength(1));
      expect(h.im.isUpdatingSetting('alice', 1), isFalse);
      expect(h.im.conversationsFor(archived: false), hasLength(1));
      h.fail = false;
      await h.im.updateConversationSetting(
        channelId: 'alice',
        channelType: 1,
        archived: true,
      );
      expect(h.im.conversationsFor(archived: true), hasLength(1));
    },
  );

  test('invalid refresh preserves prior settings and can be retried', () async {
    final h = Harness();
    addTearDown(h.close);
    await h.im.updateConversationSetting(
      channelId: 'alice',
      channelType: 1,
      archived: true,
    );
    h.invalidList = true;
    await expectLater(
      h.im.refreshConversationSettings(),
      throwsFormatException,
    );
    expect(h.im.conversationsFor(archived: true), hasLength(1));
    h.invalidList = false;
    h.archived = false;
    await h.im.refreshConversationSettings();
    expect(h.im.conversationsFor(archived: false), hasLength(1));
  });

  testWidgets('failed archive stays visible and can be retried', (
    tester,
  ) async {
    final h = Harness()..fail = true;
    addTearDown(h.close);
    await mount(tester, h);
    await tester.longPress(find.text('alice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('归档会话'));
    await tester.pumpAndSettle();
    expect(find.text('alice'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    h.fail = false;
    await tester.longPress(find.text('alice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('归档会话'));
    await tester.pumpAndSettle();
    expect(find.text('已归档会话'), findsOneWidget);
    expect(find.text('alice'), findsNothing);
  });

  for (final dark in [false, true]) {
    testWidgets('archive entry and restore work at 320px / 2x, dark=$dark', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final h = Harness();
      addTearDown(h.close);
      await mount(tester, h, dark: dark, scale: 2);
      await tester.longPress(find.text('alice'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('归档会话'));
      await tester.pumpAndSettle();
      expect(find.text('alice'), findsNothing);
      await tester.tap(find.text('已归档会话'));
      await tester.pumpAndSettle();
      expect(find.text('alice'), findsOneWidget);
      await tester.longPress(find.text('alice'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('恢复到会话列表'));
      await tester.pumpAndSettle();
      expect(find.text('暂无归档会话'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('alice'), findsOneWidget);
      expect(find.text('已归档会话'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
