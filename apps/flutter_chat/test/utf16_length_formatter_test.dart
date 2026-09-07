import 'package:flutter/services.dart';
import 'package:flutter_chat/core/text/utf16_length_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('limits using the same UTF-16 units as the server', () {
    const formatter = Utf16LengthLimitingTextInputFormatter(4);
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: 'ab😀c',
        selection: TextSelection.collapsed(offset: 5),
      ),
    );
    expect(result.text, 'ab😀');
    expect(result.text.length, 4);
  });

  test('does not split an emoji surrogate pair', () {
    const formatter = Utf16LengthLimitingTextInputFormatter(3);
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: 'ab😀'),
    );
    expect(result.text, 'ab');
  });
}
