import 'dart:async';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/group_join_page.dart';
import 'package:flutter_test/flutter_test.dart';

class Repo implements HomeRepository {
  int calls = 0;
  int count = 5;
  bool fail = false;
  Completer<int>? pending;
  @override
  Future<int> pendingGroupJoinCount() async {
    calls++;
    if (fail) throw StateError('private-server-details');
    return pending == null ? count : pending!.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'uses typed count endpoint and rejects missing/negative count',
    () async {
      final api = ChatApiClient();
      addTearDown(() => api.dio.close(force: true));
      var count = 120;
      api.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (r, h) {
            expect(r.method, 'GET');
            expect(r.path, '/api/v1/groups/join-requests/pending-count');
            h.resolve(
              Response<Object>(
                requestOptions: r,
                statusCode: 200,
                data: {'count': count},
              ),
            );
          },
        ),
      );
      final repo = HomeRepository(api);
      expect(await repo.pendingGroupJoinCount(), 120);
      count = -1;
      await expectLater(repo.pendingGroupJoinCount(), throwsFormatException);
    },
  );

  test(
    'refresh deduplicates, preserves last count on failure and retries',
    () async {
      final repo = Repo()..pending = Completer<int>();
      final controller = HomeController(repo);
      addTearDown(controller.dispose);
      final first = controller.refreshPendingJoins();
      await controller.refreshPendingJoins();
      expect(repo.calls, 1);
      expect(controller.pendingJoinLoading, isTrue);
      repo.pending!.complete(7);
      await first;
      expect(controller.pendingJoinCount, 7);
      repo.fail = true;
      await controller.refreshPendingJoins();
      expect(controller.pendingJoinCount, 7);
      expect(controller.pendingJoinError, isNotNull);
      repo.fail = false;
      repo.pending = null;
      repo.count = 0;
      await controller.refreshPendingJoins();
      expect(controller.pendingJoinCount, 0);
      expect(controller.pendingJoinError, isNull);
    },
  );

  test(
    'completion after disposal does not notify or publish stale count',
    () async {
      final repo = Repo()..pending = Completer<int>();
      final controller = HomeController(repo);
      final future = controller.refreshPendingJoins();
      controller.dispose();
      repo.pending!.complete(9);
      await future;
      expect(controller.pendingJoinCount, isNull);
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      'reminder distinguishes unknown, error and zero at 320px/2x dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = Repo()..fail = true;
        final controller = HomeController(repo);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: dark ? Brightness.dark : Brightness.light,
            ),
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) =>
                      GroupJoinReminder(controller: controller),
                ),
              ),
            ),
          ),
        );
        expect(find.text('待处理数量尚未获取'), findsOneWidget);
        await tester.tap(find.byTooltip('刷新待处理提醒'));
        await tester.pumpAndSettle();
        expect(find.text('待处理提醒更新失败'), findsOneWidget);
        expect(find.textContaining('private-server-details'), findsNothing);
        repo.fail = false;
        repo.count = 0;
        await tester.tap(find.byTooltip('刷新待处理提醒'));
        await tester.pumpAndSettle();
        expect(find.text('需要你处理：0 条'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
