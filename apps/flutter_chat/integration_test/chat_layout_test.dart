import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/core/theme/chat_styles.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/core/widgets/conversation_list_tile.dart';
import 'package:flutter_chat/features/chat/presentation/composer_action_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Visual component fixture, not an end-to-end messaging test.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('conversation and composer visual layout', (tester) async {
    var taps = 0;
    var sends = 0;
    final theme = AppTheme.light();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          appBar: AppBar(title: const Text('会话')),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (final entry in [
                      ('林夏', '图片收到了，稍后一起确认。', '14:20'),
                      ('产品讨论组', '陈屿：周五下午讨论新版界面', '昨天'),
                      ('设计反馈', '这版的排版清晰多了', '星期一'),
                    ])
                      ConversationListTile(
                        leading: AppAvatar(
                          name: entry.$1,
                          group: entry.$1 != '林夏',
                          resolveUrl: (_) =>
                              throw StateError('No image in layout fixture'),
                        ),
                        title: Text(entry.$1),
                        subtitle: Text(entry.$2),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(entry.$3, style: theme.textTheme.labelSmall),
                            if (entry.$1 == '林夏') ...[
                              const SizedBox(height: 6),
                              const Badge(label: Text('2')),
                            ],
                          ],
                        ),
                        onTap: () => taps++,
                        onLongPress: () {},
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('输入区样式预览', style: TextStyle(color: Colors.grey)),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        tooltip: '发送图片或文件',
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: ChatStyles.composer(theme.colorScheme),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        tooltip: '表情',
                        icon: const Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                        ),
                      ),
                      ComposerActionButton(
                        hasText: true,
                        recording: false,
                        voiceBusy: false,
                        onSend: () => sends++,
                        onVoice: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('林夏'));
    expect(taps, 1);
    await tester.tap(find.byTooltip('发送'));
    expect(sends, 1);
    debugPrint('CHAT_LAYOUT_READY');
    final deadline = DateTime.now().add(const Duration(seconds: 20));
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
