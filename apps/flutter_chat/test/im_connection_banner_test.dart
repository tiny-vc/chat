import 'package:flutter/material.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/core/widgets/im_connection_banner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('syncing is distinct from a disconnected failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImConnectionBanner(
            state: ImConnectionState.syncing,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('正在同步新消息…'), findsOneWidget);
    expect(find.text('消息服务已断开'), findsNothing);
    expect(find.text('重试'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('disconnected banner retries on narrow large-text screens', (
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
            body: ImConnectionBanner(
              state: ImConnectionState.disconnected,
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

  testWidgets('kicked state directs login instead of offering reconnect', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImConnectionBanner(
            state: ImConnectionState.kicked,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('当前设备的登录已失效，请重新登录'), findsOneWidget);
    expect(find.text('重试'), findsNothing);
  });
}
