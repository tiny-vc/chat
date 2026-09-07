import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';

void main() {
  test('only user-authored message types are forwardable', () {
    expect(isForwardableChatContent(WKTextContent('hello')), isTrue);
    expect(isForwardableChatContent(ChatImageContent()), isTrue);
    expect(isForwardableChatContent(ChatVideoContent()), isTrue);
    expect(isForwardableChatContent(ChatAudioContent()), isTrue);
    expect(isForwardableChatContent(ChatFileContent()), isTrue);

    expect(isForwardableChatContent(null), isFalse);
    expect(isForwardableChatContent(ChatSystemContent()), isFalse);
    expect(isForwardableChatContent(ChatCallSignalContent()), isFalse);
    expect(isForwardableChatContent(ChatRevokeContent()), isFalse);
  });
}
