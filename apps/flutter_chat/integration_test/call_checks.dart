import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/calls/presentation/incoming_call_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';

Future<void> runCallChecks({
  required WidgetTester tester,
  required String role,
  required String run,
  required String peerId,
  required ImService im,
  required CallService calls,
  required List<String> incoming,
  required Future<void> Function(bool Function(), String) wait,
}) async {
  final signals = <ChatCallSignalContent>[];
  final subscription = im.callSignals.listen(signals.add);
  String marker(String step) => 'integration:$run:CALL_$step';
  Future<void> signal(String step) async {
    await WKIM.shared.messageManager.sendMessage(
      WKTextContent(marker(step)),
      WKChannel(peerId, 1),
    );
  }

  Future<void> terminal(String id, String expected) async {
    final deadline = DateTime.now().add(const Duration(seconds: 90));
    while (DateTime.now().isBefore(deadline)) {
      final item = (await calls.history()).where((c) => c.id == id).firstOrNull;
      if (item?.status == expected) {
        expect(item!.endedAt, isNotNull);
        return;
      }
      await tester.pump(const Duration(milliseconds: 500));
    }
    fail('Call $id did not reach $expected');
  }

  try {
    if (role == 'B') {
      await signal('READY');
    } else {
      await wait(() => incoming.contains(marker('READY')), 'callee ready');
    }
    for (final scenario in ['reject', 'cancel', 'timeout', 'retry']) {
      final expected = scenario == 'reject'
          ? 'REJECTED'
          : scenario == 'timeout'
          ? 'MISSED'
          : 'CANCELLED';
      if (role == 'A') {
        final call = await calls.create(peerId, video: false);
        await signal('${scenario}_ID:${call.id}');
        await wait(
          () => incoming.contains(marker('${scenario}_VISIBLE')),
          'incoming dialog visible',
        );
        if (scenario == 'cancel' || scenario == 'retry') {
          await calls.cancel(call.id);
        }
        await terminal(call.id, expected);
        if (scenario == 'reject') {
          await wait(
            () =>
                signals.any((s) => s.callId == call.id && s.action == 'reject'),
            'caller received rejection',
          );
        }
        await signal('${scenario}_DONE');
        await wait(
          () => incoming.contains(marker('${scenario}_ACK')),
          'callee confirmed $scenario',
        );
        debugPrint('CALL_${scenario}_VERIFIED id=${call.id} status=$expected');
      } else {
        final prefix = marker('${scenario}_ID:');
        await wait(
          () => incoming.any((s) => s.startsWith(prefix)),
          'call ID received',
        );
        final id = incoming
            .firstWhere((s) => s.startsWith(prefix))
            .substring(prefix.length);
        await wait(
          () => signals.any((s) => s.callId == id && s.action == 'invite'),
          'real IM invite received',
        );
        final future = showIncomingCallDialog(
          context: tester.element(find.byType(Scaffold).first),
          callId: id,
          caller: 'Integration caller',
          video: false,
          signals: im.callSignals,
        );
        await wait(
          () => find.text('语音来电').evaluate().isNotEmpty,
          'real incoming dialog shown',
        );
        await signal('${scenario}_VISIBLE');
        if (scenario == 'reject') await tester.tap(find.text('拒绝'));
        await wait(
          () => find.text('语音来电').evaluate().isEmpty,
          'dialog dismissed for $scenario',
        );
        final result = await future;
        if (scenario == 'reject') {
          expect(result, IncomingCallResult.reject);
          await calls.reject(id);
        } else if (scenario == 'timeout') {
          expect(
            result,
            anyOf(IncomingCallResult.ended, IncomingCallResult.timedOut),
          );
        } else {
          expect(result, IncomingCallResult.ended);
        }
        await wait(
          () => incoming.contains(marker('${scenario}_DONE')),
          'caller confirms terminal state',
        );
        await terminal(id, expected);
        await signal('${scenario}_ACK');
      }
    }
  } finally {
    await subscription.cancel();
  }
}
