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
