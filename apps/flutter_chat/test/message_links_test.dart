import 'package:flutter_chat/core/text/message_links.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('finds http links and keeps punctuation outside', () {
    final parts = parseMessageText('查看 https://example.com/a?x=1，谢谢。');
    final link = parts.singleWhere((part) => part.isLink);
    expect(link.text, 'https://example.com/a?x=1');
    expect(link.uri?.host, 'example.com');
    expect(parts.last.text, '，谢谢。');
  });

  test('normalizes www links to https', () {
    expect(
      safeMessageUri('www.example.com/a')?.toString(),
      'https://www.example.com/a',
    );
  });

  test('never accepts dangerous or credential-bearing schemes', () {
    expect(safeMessageUri('javascript:alert(1)'), isNull);
    expect(safeMessageUri('data:text/html,test'), isNull);
    expect(safeMessageUri('file:///tmp/a'), isNull);
    expect(safeMessageUri('https://user:pass@example.com'), isNull);
  });
}
