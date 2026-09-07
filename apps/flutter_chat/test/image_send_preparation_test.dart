import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/core/files/image_send_preparation.dart';
import 'package:flutter_chat/core/files/file_size.dart';
import 'package:image/image.dart' as img;

void main() {
  test('compresses a large JPEG and limits its longest side', () async {
    final sourceImage = img.Image(width: 2600, height: 1300)
      ..clear(img.ColorRgb8(120, 70, 210));
    final bytes = Uint8List.fromList(img.encodeJpg(sourceImage, quality: 100));
    final file = MemoryPlatformFile(name: 'photo.jpeg', bytes: bytes);

    final prepared = await prepareChatImage(file, compress: true);
    final decoded = img.decodeImage(prepared.previewBytes)!;

    expect(prepared.compressed, isTrue);
    expect(prepared.file.name, 'photo.jpg');
    expect(await prepared.file.length(), lessThan(bytes.length));
    expect(decoded.width, 2048);
    expect(decoded.height, 1024);
  });

  test('keeps PNG and GIF files in their original format', () async {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    for (final extension in ['png', 'gif']) {
      final file = MemoryPlatformFile(name: 'asset.$extension', bytes: bytes);
      final prepared = await prepareChatImage(file, compress: true);
      expect(prepared.compressed, isFalse);
      expect(prepared.file, same(file));
      expect(prepared.previewBytes, bytes);
    }
  });

  test('formats file sizes for the confirmation sheet', () {
    expect(formatFileSize(512), '512 B');
    expect(formatFileSize(1536), '1.5 KB');
    expect(formatFileSize(2 * 1024 * 1024), '2.0 MB');
    expect(formatFileSize(3 * 1024 * 1024 * 1024), '3.0 GB');
    expect(formatFileSize(2 * 1024 * 1024 * 1024 * 1024), '2.0 TB');
    expect(formatFileSize(-1), '0 B');
  });
}
