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

  test('image message carries a thumbnail while old payloads remain valid', () {
    final content = ChatImageContent(
      fileId: 'original',
      width: 1200,
      height: 800,
      thumbnailFileId: 'thumbnail',
    );

    expect(content.encodeJson()['thumbnailFileId'], 'thumbnail');
    final decoded = ChatImageContent()
      ..decodeJson({
        'fileId': 'original',
        'width': 1200,
        'height': 800,
        'thumbnailFileId': 'thumbnail',
      });
    expect(decoded.thumbnailFileId, 'thumbnail');

    final historical = ChatImageContent()
      ..decodeJson({'fileId': 'old', 'width': 640, 'height': 480});
    expect(historical.thumbnailFileId, isEmpty);
    expect(historical.encodeJson().containsKey('thumbnailFileId'), isFalse);
  });

  test('video message matches the server protocol and carries dimensions', () {
    final content = ChatVideoContent(
      fileId: 'video',
      name: 'clip.mov',
      size: 42,
      durationMs: 3000,
      width: 1920,
      height: 1080,
    );
    expect(content.contentType, 5);
    expect(content.encodeJson(), {
      'fileId': 'video',
      'name': 'clip.mov',
      'size': 42,
      'durationMs': 3000,
      'width': 1920,
      'height': 1080,
    });
  });

  test('audio message carries integrity metadata for the download cache', () {
    final content = ChatAudioContent(
      fileId: 'voice',
      durationMs: 1500,
      size: 2048,
      mimeType: 'audio/mp4',
    );
    expect(content.encodeJson(), {
      'fileId': 'voice',
      'durationMs': 1500,
      'size': 2048,
      'mimeType': 'audio/mp4',
    });
  });
}
