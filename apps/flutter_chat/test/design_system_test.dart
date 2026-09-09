import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/core/theme/app_motion.dart';
import 'package:flutter_chat/core/widgets/app_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('page transitions retain native platform behavior', () {
    final transitions = AppTheme.light().pageTransitionsTheme.builders;
    expect(
      transitions[TargetPlatform.android],
      isA<PredictiveBackPageTransitionsBuilder>(),
    );
    expect(
      transitions[TargetPlatform.iOS],
      isA<CupertinoPageTransitionsBuilder>(),
    );
    expect(
      transitions[TargetPlatform.macOS],
      isA<CupertinoPageTransitionsBuilder>(),
    );
  });

  testWidgets('reduced-motion preference removes custom transition duration', (
    tester,
  ) async {
    Duration? resolved;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resolved = appMotionDuration(
                context,
                const Duration(milliseconds: 220),
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(resolved, Duration.zero);
  });

  testWidgets('status illustration fits narrow dark large-text layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: AppStatus(
              title: '暂时没有内容',
              message: '新的消息和通知会显示在这里',
              onRetry: () => retried = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('暂时没有内容'), findsOneWidget);
    await tester.tap(find.text('重试'));
    expect(retried, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state exposes one live semantic label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: AppLoading(message: '正在同步消息…')),
      ),
    );

    expect(find.bySemanticsLabel('正在同步消息…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('bottom navigation uses restrained selected and unselected colors', () {
    final theme = AppTheme.light().navigationBarTheme;
    final selected = theme.iconTheme?.resolve({WidgetState.selected});
    final unselected = theme.iconTheme?.resolve({});

    expect(selected?.color, AppTheme.light().colorScheme.primary);
    expect(unselected?.color, AppTheme.light().colorScheme.onSurfaceVariant);
    expect(selected?.size, greaterThan(unselected?.size ?? 0));
  });
}
