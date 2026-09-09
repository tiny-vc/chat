import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';

void main() {
  test('same-account signaling conversation is never shown as a chat', () {
    final self = WKUIConversationMsg()
      ..channelID = 'current-user-uuid'
      ..channelType = 1;
    final friend = WKUIConversationMsg()
      ..channelID = 'friend-uuid'
      ..channelType = 1;
    final group = WKUIConversationMsg()
      ..channelID = 'group-uuid'
      ..channelType = 2;

    expect(ImService.isVisibleConversation(self, 'current-user-uuid'), isFalse);
    expect(
      ImService.isVisibleConversation(friend, 'current-user-uuid'),
      isTrue,
    );
    expect(ImService.isVisibleConversation(group, 'current-user-uuid'), isTrue);
  });
}
