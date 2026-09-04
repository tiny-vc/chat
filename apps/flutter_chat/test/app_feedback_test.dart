import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/widgets/app_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('error feedback hides internal exception details', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  AppFeedback.error(context, StateError('secret-internal-url')),
              child: const Text('触发'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('触发'));
    await tester.pumpAndSettle();
    expect(find.text('操作失败，请稍后重试'), findsOneWidget);
    expect(find.textContaining('secret-internal-url'), findsNothing);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('network timeout has actionable feedback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AppFeedback.error(
                context,
                DioException(
                  requestOptions: RequestOptions(path: '/private'),
                  type: DioExceptionType.connectionTimeout,
                ),
              ),
              child: const Text('触发'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('触发'));
    await tester.pumpAndSettle();
    expect(find.text('请求超时，请检查网络后重试'), findsOneWidget);
  });

  testWidgets('destructive confirmation requires explicit approval', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await AppFeedback.confirm(
                  context,
                  title: '移除成员',
                  message: '成员将退出群聊',
                  confirmLabel: '确认移除',
                  destructive: true,
                );
              },
              child: const Text('打开'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认移除'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('status supports retry on narrow screen with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: AppStatus(
              title: '数据加载失败',
              message: '请检查网络后重试',
              onRetry: () => retries++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('重试'));
    expect(retries, 1);
    expect(tester.takeException(), isNull);
  });
}
