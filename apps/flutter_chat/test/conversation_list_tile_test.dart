import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/core/theme/chat_styles.dart';
import 'package:flutter_chat/core/widgets/conversation_list_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'conversation actions and long text at 320px / 2x, dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var taps = 0;
        var holds = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: ListView(
                  children: [
                    ConversationListTile(
                      leading: const SizedBox.square(
                        dimension: 48,
                        child: Icon(Icons.person),
                      ),
                      title: const Text('很长的讨论群名称，需要保持在一行内'),
                      subtitle: const Text('一段很长的消息摘要，包括图片和文件的说明'),
                      trailing: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '昨天',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Badge(label: Text('99+')),
                        ],
                      ),
                      onTap: () => taps++,
                      onLongPress: () => holds++,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(ConversationListTile));
        await tester.longPress(find.byType(ConversationListTile));
        expect(taps, 1);
        expect(holds, 1);
        expect(
          tester.getSize(find.byType(ConversationListTile)).height,
          greaterThanOrEqualTo(76),
        );
      },
    );
  }

  test(
    'composer uses the same shape when focused with a visible focus outline',
    () {
      final colors = AppTheme.light().colorScheme;
      final decoration = ChatStyles.composer(colors);
      final normal = decoration.enabledBorder! as OutlineInputBorder;
      final focused = decoration.focusedBorder! as OutlineInputBorder;
      expect(normal.borderRadius, focused.borderRadius);
      expect(focused.borderSide.color, colors.primary);
      expect(focused.borderSide.width, greaterThan(0));
    },
  );
}
