import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/features/chat/presentation/message_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Real presentation components, fixture data; does not send or download files.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('media and metadata visual layout', (tester) async {
    final theme = AppTheme.light();
    var opens = 0;
    Widget bubble(bool mine, List<Widget> children) => Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mine
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          appBar: AppBar(title: const Text('消息样式预览')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              bubble(false, [
                const Text('这份方案请你看看，图片和附件在下面。'),
                const MessageMeta(time: '14:30'),
              ]),
              bubble(true, [
                FileMessageTile(
                  name: '产品设计方案_评审版.pdf',
                  sizeLabel: '2.4 MB',
                  downloading: false,
                  progress: 0,
                  onOpen: () => opens++,
                ),
                const MessageMeta(
                  time: '14:31',
                  status: Icon(Icons.check, size: 14),
                  receipt: '已读',
                  read: true,
                ),
              ]),
              bubble(false, [
                ChatMediaFrame(
                  width: 640,
                  height: 480,
                  child: ColoredBox(
                    color: theme.colorScheme.secondaryContainer,
                    child: const Center(
                      child: Icon(Icons.landscape_outlined, size: 72),
                    ),
                  ),
                ),
                const MessageMeta(time: '14:32'),
              ]),
              bubble(true, [
                FileMessageTile(
                  name: '会议记录.zip',
                  sizeLabel: '12.8 MB',
                  downloading: true,
                  progress: .45,
                  onOpen: () => opens++,
                ),
                const MessageMeta(
                  time: '14:33',
                  status: Icon(Icons.check, size: 14),
                  receipt: '8人已读',
                  read: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('点击打开'));
    expect(opens, 1);
    expect(tester.takeException(), isNull);
    debugPrint('MESSAGE_DETAILS_READY');
    final deadline = DateTime.now().add(const Duration(seconds: 20));
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
