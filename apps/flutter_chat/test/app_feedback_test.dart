import 'package:flutter/material.dart';
import 'package:flutter_chat/core/widgets/app_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('error feedback can offer a safe recovery action', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => AppFeedback.error(
                context,
                StateError('internal detail'),
                fallback: '发送失败，请稍后重试',
                actionLabel: '重新选择',
                onAction: () => retries++,
              ),
              child: const Text('触发失败'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('触发失败'));
    await tester.pumpAndSettle();
    expect(find.text('发送失败，请稍后重试'), findsOneWidget);
    expect(find.textContaining('internal detail'), findsNothing);
    await tester.tap(find.text('重新选择'));
    expect(retries, 1);
  });
}
