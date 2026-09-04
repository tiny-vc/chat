import 'package:flutter/material.dart';
import 'package:flutter_chat/features/chat/presentation/composer_action_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('rapid text toggles retain exactly one current action', (
    tester,
  ) async {
    var sends = 0;
    var voices = 0;
    for (var i = 0; i < 20; i++) {
      final hasText = i.isEven;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ComposerActionButton(
              hasText: hasText,
              recording: false,
              voiceBusy: false,
              onSend: () => sends++,
              onVoice: () => voices++,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.byType(IconButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip(hasText ? '发送' : '录制语音'));
    }
    expect(sends, 10);
    expect(voices, 10);
  });
  testWidgets('recording overrides text and busy state prevents activation', (
    tester,
  ) async {
    var actions = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ComposerActionButton(
            hasText: true,
            recording: true,
            voiceBusy: true,
            onSend: () => actions++,
            onVoice: () => actions++,
          ),
        ),
      ),
    );
    expect(find.byTooltip('发送'), findsNothing);
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('结束并发送'));
    expect(actions, 0);
  });
}
