import 'package:flutter/material.dart';

abstract final class ChatStyles {
  static InputDecoration composer(
    ColorScheme colors, {
    String hintText = '输入消息',
  }) {
    const shape = BorderRadius.all(Radius.circular(14));
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: colors.onSurfaceVariant),
      filled: true,
      fillColor: colors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: const OutlineInputBorder(
        borderRadius: shape,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: shape,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: shape,
        borderSide: BorderSide(color: colors.primary, width: 1.2),
      ),
    );
  }
}
