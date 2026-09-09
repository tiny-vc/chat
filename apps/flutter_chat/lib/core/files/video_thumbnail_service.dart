import 'package:flutter/services.dart';

class VideoThumbnailService {
  const VideoThumbnailService._();

  static const _channel = MethodChannel('chat/video_thumbnail');

  static Future<Uint8List?> create(String path) async {
    if (path.trim().isEmpty) return null;
    return _channel.invokeMethod<Uint8List>('create', {'path': path});
  }
}
