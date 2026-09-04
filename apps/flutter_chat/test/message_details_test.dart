import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/features/chat/presentation/message_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'long file and metadata fit narrow large-text bubble dark=$dark',
      (tester) async {
        var opens = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FileMessageTile(
                          name: '产品设计方案最终评审版本2026.pdf',
                          sizeLabel: '12.5 MB',
                          downloading: false,
                          progress: 0,
                          onOpen: () => opens++,
                        ),
                        const MessageMeta(
                          time: '14:30',
                          status: Icon(Icons.check, size: 14),
                          receipt: '123人已读',
                          read: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('点击打开'));
        expect(opens, 1);
        expect(find.text('123人已读'), findsOneWidget);
      },
    );
  }
  testWidgets(
    'busy file cannot open again and unknown progress is not 0 percent',
    (tester) async {
      var opens = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FileMessageTile(
                name: '方案.pdf',
                sizeLabel: '1 MB',
                downloading: true,
                progress: 0,
                onOpen: () => opens++,
              ),
            ),
          ),
        ),
      );
      expect(find.text('正在准备…'), findsOneWidget);
      expect(find.text('点击打开'), findsNothing);
      await tester.tap(find.byType(FileMessageTile));
      expect(opens, 0);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'image frame preserves dimensions across loading and content and clamps tall images',
    (tester) async {
      Future<void> mount(Widget child) => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 180,
                child: ChatMediaFrame(width: 100, height: 2000, child: child),
              ),
            ),
          ),
        ),
      );
      await mount(const Center(child: CircularProgressIndicator()));
      final before = tester.getSize(find.byType(ChatMediaFrame));
      await mount(const ColoredBox(color: Colors.blue));
      expect(tester.getSize(find.byType(ChatMediaFrame)), before);
      expect(before.width, 180);
      expect(before.height, closeTo(180 / .65, .01));
    },
  );
}
