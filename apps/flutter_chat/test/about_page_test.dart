import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/app.dart';
import 'package:flutter_chat/core/widgets/about_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart' show MemoryTokenStore;

void main() {
  testWidgets('about is accessible before login and returns to the form', (
    tester,
  ) async {
    await tester.pumpWidget(ChatApp(tokenStore: MemoryTokenStore()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('关于与使用说明'));
    await tester.tap(find.text('关于与使用说明'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('欢迎回来'), findsOneWidget);
  });

  for (final brightness in Brightness.values) {
    testWidgets('about scrolls at 320px and 2x text, $brightness', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const AboutPage(),
        ),
      );
      await tester.scrollUntilVisible(find.text('复制反馈模板'), 300);
      await tester.tap(find.text('复制反馈模板'));
      await tester.pumpAndSettle();
      expect(copied, AboutPage.feedbackTemplate);
      expect(copied, isNot(contains('localhost')));
      expect(find.text('反馈模板已复制，请填写后交给项目负责人'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('开源许可'), 150);
      await tester.tap(find.text('开源许可'));
      await tester.pumpAndSettle();
      expect(find.byType(LicensePage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('发布前须知'), 150);
      expect(tester.takeException(), isNull);
    });
  }
}
