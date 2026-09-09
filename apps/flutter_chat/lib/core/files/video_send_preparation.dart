import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:cross_file/cross_file.dart';

class PreparedChatVideo {
  const PreparedChatVideo({required this.file, required this.temporaryPath});
  final PlatformFile file;
  final String temporaryPath;

  Future<void> dispose() async {
    try {
      final output = File(temporaryPath);
      if (await output.exists()) await output.delete();
    } on FileSystemException {
      // The operating system also reclaims files in the temporary directory.
    }
  }
}

class VideoSendPreparation {
  static const _channel = MethodChannel('chat/video_transcoder');

  static Future<PreparedChatVideo> prepare(PlatformFile source) async {
    final path = source.path;
    if (path == null || path.isEmpty) {
      throw StateError('当前平台没有提供可读取的视频文件');
    }
    final outputPath = await _channel.invokeMethod<String>('transcode', {
      'path': path,
    });
    if (outputPath == null || outputPath.isEmpty) {
      throw StateError('视频转换没有生成输出文件');
    }
    final output = File(outputPath);
    if (!await output.exists() || await output.length() <= 0) {
      throw StateError('视频转换结果无效');
    }
    final baseName = source.name.replaceFirst(RegExp(r'\.[^.]+$'), '');
    return PreparedChatVideo(
      file: _PathPlatformFile(
        name: '${baseName.isEmpty ? 'video' : baseName}.mp4',
        path: outputPath,
      ),
      temporaryPath: outputPath,
    );
  }
}

final class _PathPlatformFile extends PlatformFile {
  _PathPlatformFile({required this.name, required String path})
    : uri = Uri.file(path);

  @override
  final String name;
  @override
  final Uri uri;

  File get _file => File.fromUri(uri);

  @override
  XFile get xFile => XFile(path!);

  @override
  Future<int> length() => _file.length();

  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();

  @override
  Stream<Uint8List> readAsByteStream() =>
      _file.openRead().map(Uint8List.fromList);
}
