import 'package:flutter/services.dart';

class FileOpenService {
  const FileOpenService._();

  static const _channel = MethodChannel('chat/file_opener');

  static Future<void> open(String path) async {
    if (path.trim().isEmpty) throw ArgumentError.value(path, 'path');
    await _channel.invokeMethod<void>('open', {'path': path});
  }
}
