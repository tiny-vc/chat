import 'package:wukongimfluttersdk/entity/msg.dart';

class MessagePageMerge {
  const MessagePageMerge({required this.messages, required this.addedCount});

  final List<WKMsg> messages;
  final int addedCount;
}

MessagePageMerge mergeOlderMessagePage(List<WKMsg> current, List<WKMsg> older) {
  final existing = current.map((message) => message.clientMsgNO).toSet();
  final additions = older
      .where((message) => existing.add(message.clientMsgNO))
      .toList();
  final merged = [...current, ...additions]
    ..sort((a, b) => a.orderSeq.compareTo(b.orderSeq));
  return MessagePageMerge(messages: merged, addedCount: additions.length);
}

/// Inserts or replaces one message while preserving `orderSeq` order.
///
/// New realtime messages normally append in O(1). Out-of-order delivery uses
/// a binary search instead of sorting the complete conversation every time.
void upsertMessageInOrder(List<WKMsg> messages, WKMsg message) {
  final existing = messages.indexWhere(
    (item) => item.clientMsgNO == message.clientMsgNO,
  );
  if (existing >= 0) {
    final previous = messages.removeAt(existing);
    if (previous.orderSeq == message.orderSeq) {
      messages.insert(existing, message);
      return;
    }
  }
  if (messages.isEmpty || messages.last.orderSeq <= message.orderSeq) {
    messages.add(message);
    return;
  }
  var low = 0;
  var high = messages.length;
  while (low < high) {
    final middle = low + ((high - low) >> 1);
    if (messages[middle].orderSeq <= message.orderSeq) {
      low = middle + 1;
    } else {
      high = middle;
    }
  }
  messages.insert(low, message);
}
