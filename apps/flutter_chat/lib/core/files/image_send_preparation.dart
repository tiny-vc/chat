import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class PreparedChatImage {
  const PreparedChatImage({
    required this.file,
    required this.previewBytes,
    required this.originalSize,
    required this.compressed,
  });

  final PlatformFile file;
  final Uint8List previewBytes;
  final int originalSize;
  final bool compressed;
}

bool canCompressChatImage(PlatformFile file) {
  final extension = file.extension?.toLowerCase();
  return extension == 'jpg' || extension == 'jpeg';
}

Future<Uint8List> readPlatformFileBytes(PlatformFile file) async =>
    file.readAsBytes();

final class MemoryPlatformFile extends PlatformFile {
  MemoryPlatformFile({required this.name, required Uint8List bytes})
    : _bytes = bytes,
      uri = Uri.dataFromBytes(bytes);

  @override
  final String name;

  @override
  final Uri uri;

  final Uint8List _bytes;

  @override
  XFile get xFile => XFile.fromData(_bytes, name: name);

  @override
  Future<int> length() async => _bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => _bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(_bytes);
}

Future<PreparedChatImage> prepareChatImage(
  PlatformFile source, {
  required bool compress,
}) async {
  final bytes = await readPlatformFileBytes(source);
  if (!compress || !canCompressChatImage(source)) {
    return PreparedChatImage(
      file: source,
      previewBytes: bytes,
      originalSize: bytes.length,
      compressed: false,
    );
  }

  final output = await compute(_compressJpeg, bytes);
  if (output == null || output.length >= bytes.length) {
    return PreparedChatImage(
      file: source,
      previewBytes: bytes,
      originalSize: bytes.length,
      compressed: false,
    );
  }
  final baseName = source.name.replaceFirst(RegExp(r'\.[^.]+$'), '');
  return PreparedChatImage(
    file: MemoryPlatformFile(name: '$baseName.jpg', bytes: output),
    previewBytes: output,
    originalSize: bytes.length,
    compressed: true,
  );
}

Uint8List? _compressJpeg(Uint8List bytes) {
  var decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  decoded = img.bakeOrientation(decoded);
  const maxSide = 2048;
  if (decoded.width > maxSide || decoded.height > maxSide) {
    decoded = decoded.width >= decoded.height
        ? img.copyResize(decoded, width: maxSide)
        : img.copyResize(decoded, height: maxSide);
  }
  return Uint8List.fromList(img.encodeJpg(decoded, quality: 82));
}
