import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/features/calls/presentation/call_overlay.dart';

void main() {
  testWidgets(
    'minimized call bar keeps call mounted and underlying UI usable',
    (tester) async {
      var underlyingTaps = 0;
      var callDisposals = 0;
      late BuildContext pageContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              pageContext = context;
              return Scaffold(
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () => underlyingTaps++,
                    child: const Text('底层操作'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      late VoidCallback close;
      final completed = presentCallOverlay(
        context: pageContext,
        title: '测试好友',
        video: false,
        builder: (minimize, closeOverlay) {
          close = closeOverlay;
          return _TrackedCall(
            onMinimize: minimize,
            onDispose: () {
              callDisposals++;
            },
          );
        },
      );
      await tester.pump();
      expect(find.text('通话页面'), findsOneWidget);

      await tester.tap(find.text('缩小'));
      await tester.pump();
      expect(find.text('测试好友'), findsOneWidget);
      expect(callDisposals, 0);

      await tester.tap(find.text('底层操作'));
      expect(underlyingTaps, 1);

      await tester.tap(find.byTooltip('恢复通话'));
      await tester.pump();
      expect(find.text('通话页面'), findsOneWidget);

      close();
      await tester.pump();
      await completed;
      expect(callDisposals, 1);
    },
  );
}

class _TrackedCall extends StatefulWidget {
  const _TrackedCall({required this.onMinimize, required this.onDispose});

  final VoidCallback onMinimize;
  final VoidCallback onDispose;

  @override
  State<_TrackedCall> createState() => _TrackedCallState();
}

class _TrackedCallState extends State<_TrackedCall> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Column(
      children: [
        const Text('通话页面'),
        TextButton(onPressed: widget.onMinimize, child: const Text('缩小')),
      ],
    ),
  );
}
