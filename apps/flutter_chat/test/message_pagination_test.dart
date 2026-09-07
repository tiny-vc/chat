import 'package:flutter_chat/core/im/message_pagination.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

WKMsg message(String id, int orderSeq) => WKMsg()
  ..clientMsgNO = id
  ..orderSeq = orderSeq;

void main() {
  test('older pages are deduplicated and merged in display order', () {
    final result = mergeOlderMessagePage(
      [message('m3', 3000), message('m4', 4000)],
      [message('m1', 1000), message('m2', 2000), message('m3', 3000)],
    );

    expect(result.addedCount, 2);
    expect(result.messages.map((item) => item.clientMsgNO), [
      'm1',
      'm2',
      'm3',
      'm4',
    ]);
  });

  test('a repeated page adds nothing', () {
    final result = mergeOlderMessagePage(
      [message('m1', 1000), message('m2', 2000)],
      [message('m1', 1000), message('m2', 2000)],
    );

    expect(result.addedCount, 0);
    expect(result.messages, hasLength(2));
  });
}
