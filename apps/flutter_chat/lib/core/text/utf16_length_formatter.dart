import 'package:flutter/services.dart';

/// Matches JavaScript/server string length without splitting a surrogate pair.
class Utf16LengthLimitingTextInputFormatter extends TextInputFormatter {
  const Utf16LengthLimitingTextInputFormatter(this.maxLength);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length <= maxLength) return newValue;
    var end = maxLength;
    if (end > 0 &&
        end < newValue.text.length &&
        _isHighSurrogate(newValue.text.codeUnitAt(end - 1)) &&
        _isLowSurrogate(newValue.text.codeUnitAt(end))) {
      end--;
    }
    final text = newValue.text.substring(0, end);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: newValue.selection.extentOffset.clamp(0, text.length),
      ),
    );
  }

  bool _isHighSurrogate(int value) => value >= 0xD800 && value <= 0xDBFF;
  bool _isLowSurrogate(int value) => value >= 0xDC00 && value <= 0xDFFF;
}
