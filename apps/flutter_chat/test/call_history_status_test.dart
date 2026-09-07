import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/features/calls/presentation/call_history_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _HistoryCalls implements CallService {
  _HistoryCalls(this.items, {this.moreItems = const []});

  final List<CallHistoryItem> items;
  final List<CallHistoryItem> moreItems;
  int loads = 0;

  @override
  Future<List<CallHistoryItem>> history({CallHistoryItem? before}) async {
    loads++;
    return before == null ? items : moreItems;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  CallHistoryItem item({
    String id = 'call',
    String peerName = '好友',
    String status = 'ENDED',
    String? endReason,
    bool outgoing = true,
    bool video = false,
    DateTime? answeredAt,
    DateTime? endedAt,
  }) => CallHistoryItem(
    id: id,
    video: video,
    status: status,
    outgoing: outgoing,
    startedAt: DateTime(2026),
    answeredAt: answeredAt,
    endedAt: endedAt,
    peerId: 'peer',
    peerName: peerName,
    endReason: endReason,
  );

  test('terminal copy distinguishes direction and reason', () {
    expect(callHistoryStatus(item(endReason: 'BUSY')), '对方忙线中');
    expect(
      callHistoryStatus(item(endReason: 'BUSY', outgoing: false)),
      '已回复忙线',
    );
    expect(
      callHistoryStatus(item(endReason: 'CANCELLED', outgoing: false)),
      '对方已取消',
    );
    expect(callHistoryStatus(item(endReason: 'SIGNAL_FAILED')), '呼叫发送失败');
  });

  test('duration preserves abnormal media termination and supports hours', () {
    final answered = DateTime(2026, 1, 1, 10);
    expect(
      callHistoryStatus(
        item(
          video: true,
          endReason: 'MEDIA_DISCONNECTED',
          answeredAt: answered,
          endedAt: answered.add(
            const Duration(hours: 1, minutes: 2, seconds: 3),
          ),
        ),
      ),
      '视频通话 1:02:03 · 连接中断',
    );
  });

  test('invalid negative server duration is never displayed', () {
    final answered = DateTime(2026, 1, 1, 10);
    expect(
      callHistoryStatus(
        item(
          status: 'FAILED',
          answeredAt: answered,
          endedAt: answered.subtract(const Duration(seconds: 1)),
        ),
      ),
      '呼叫失败',
    );
  });

  testWidgets('a valid history row exposes the redial action', (tester) async {
    final record = item(endReason: 'NO_ANSWER');
    CallHistoryItem? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: CallHistoryPage(
          callService: _HistoryCalls([record]),
          onRedial: (value) async => selected = value,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.call_outlined), findsOneWidget);
    await tester.tap(find.text('好友'));
    await tester.pump();
    expect(selected, same(record));
  });

  testWidgets('redial is locked while active and refreshes after returning', (
    tester,
  ) async {
    final record = item(endReason: 'NO_ANSWER');
    final calls = _HistoryCalls([record]);
    final pending = Completer<void>();
    var redials = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: CallHistoryPage(
          callService: calls,
          onRedial: (_) {
            redials++;
            return pending.future;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('好友'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('好友'));
    expect(redials, 1);

    pending.complete();
    await tester.pumpAndSettle();
    expect(calls.loads, 2);
    expect(find.byIcon(Icons.call_outlined), findsOneWidget);
  });

  testWidgets('loads and deduplicates the next history page', (tester) async {
    final first = List.generate(
      100,
      (index) => item(id: 'call-$index', peerName: '好友 $index'),
    );
    final duplicate = first.last;
    final next = item(id: 'call-next', peerName: '更早的好友');
    final calls = _HistoryCalls(first, moreItems: [duplicate, next]);
    await tester.pumpWidget(
      MaterialApp(home: CallHistoryPage(callService: calls)),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('加载更多'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('加载更多'));
    await tester.pumpAndSettle();

    expect(calls.loads, 2);
    expect(find.text('更早的好友'), findsOneWidget);
    expect(find.text('好友 99'), findsOneWidget);
    expect(find.text('加载更多'), findsNothing);
  });
}
