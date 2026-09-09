import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/features/chat/presentation/message_details.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('upload progress identifies task and fits narrow large text', (
    tester,
  ) async {
    var cancels = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: TransferProgressPanel(
                label: '视频 · 一个名称非常长的产品演示视频最终版本.mp4',
                progress: .42,
                onCancel: () => cancels++,
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('已上传 42%'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const ValueKey('cancel-upload')));
    expect(cancels, 1);
  });

  testWidgets('failed transfer presents the task-specific recovery action', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransferProgressPanel(
            label: '语音消息',
            progress: 0,
            error: '语音发送失败',
            retryLabel: '重新录制',
            onRetry: () => retries++,
            onCancel: () {},
          ),
        ),
      ),
    );

    expect(find.text('语音发送失败'), findsOneWidget);
    await tester.tap(find.text('重新录制'));
    expect(retries, 1);
  });

  testWidgets('attachment confirmation requires an explicit choice', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () async {
                result = await showModalBottomSheet<bool>(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => const AttachmentSendConfirmation(
                    name: '产品方案最终版.pdf',
                    sizeLabel: '12.5 MB',
                    kindLabel: '文件',
                    icon: Icons.description_outlined,
                  ),
                );
              },
              child: const Text('选择文件'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();
    expect(find.text('发送文件'), findsOneWidget);
    expect(find.text('产品方案最终版.pdf'), findsOneWidget);
    expect(find.text('12.5 MB'), findsOneWidget);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(result, isFalse);

    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确认发送'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

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
      var cancels = 0;
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
                onCancel: () => cancels++,
              ),
            ),
          ),
        ),
      );
      expect(find.text('正在准备…'), findsOneWidget);
      expect(find.text('点击打开'), findsNothing);
      await tester.tap(find.byType(FileMessageTile));
      expect(opens, 0);
      await tester.tap(find.byKey(const ValueKey('cancel-file-download')));
      expect(cancels, 1);
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
