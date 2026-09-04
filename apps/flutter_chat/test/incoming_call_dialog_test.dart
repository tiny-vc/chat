import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_chat/features/calls/presentation/incoming_call_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final action in ['cancel', 'miss', 'end']) {
    testWidgets('$action closes only matching invitation and permits another', (
      tester,
    ) async {
      final signals = StreamController<ChatCallSignalContent>.broadcast();
      final results = <IncomingCallResult?>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  results.add(
                    await showIncomingCallDialog(
                      context: context,
                      callId: 'call',
                      caller: 'Test',
                      video: false,
                      signals: signals.stream,
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      signals.add(
        ChatCallSignalContent()
          ..callId = 'other'
          ..action = action,
      );
      await tester.pump();
      expect(find.text('语音来电'), findsOneWidget);
      signals.add(
        ChatCallSignalContent()
          ..callId = 'call'
          ..action = action,
      );
      signals.add(
        ChatCallSignalContent()
          ..callId = 'call'
          ..action = action,
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('语音来电'), findsNothing);
      expect(signals.hasListener, isFalse);
      // Stream cancellation completion can use a future from the real zone.
      await tester.runAsync(() async => Future<void>.delayed(Duration.zero));
      expect(results, [IncomingCallResult.ended]);
      expect(find.text('open'), findsOneWidget);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('拒绝'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(() async => Future<void>.delayed(Duration.zero));
      expect(results.last, IncomingCallResult.reject);
      await signals.close();
    });
  }
  testWidgets('timeout removes invitation, not an unrelated route above it', (
    tester,
  ) async {
    final signals = StreamController<ChatCallSignalContent>.broadcast();
    final nav = GlobalKey<NavigatorState>();
    IncomingCallResult? result;
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: nav,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showIncomingCallDialog(
                  context: context,
                  callId: 'call',
                  caller: 'Test',
                  video: false,
                  signals: signals.stream,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    unawaited(
      nav.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('other page')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 46));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(() async => Future<void>.delayed(Duration.zero));
    expect(result, IncomingCallResult.timedOut);
    expect(find.text('other page'), findsOneWidget);
    nav.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('语音来电'), findsNothing);
    await signals.close();
  });
}
