import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

const _portableAvatarPickerOptions = DarwinOptions(
  assetRepresentationMode: DarwinAssetRepresentationMode.compatible,
);

/// Requests an Apple-compatible representation so an iPhone HEIC photo is
/// exported as a format that Android can decode as well.
Future<PlatformFile?> pickPortableAvatar() => FilePicker.pickFile(
  type: FileType.image,
  darwinOptions: _portableAvatarPickerOptions,
);

Future<PlatformFile?> pickPortableChatImage() => FilePicker.pickFile(
  type: FileType.image,
  darwinOptions: _portableAvatarPickerOptions,
);

Future<PlatformFile?> pickPortableChatVideo() => FilePicker.pickFile(
  type: FileType.video,
  darwinOptions: _portableAvatarPickerOptions,
);

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

class PreparedChatThumbnail {
  const PreparedChatThumbnail({required this.file});

  final PlatformFile file;
}

bool canCompressChatImage(PlatformFile file) {
  final extension = file.extension?.toLowerCase();
  return extension == 'jpg' || extension == 'jpeg';
}

bool isPortableChatImage(PlatformFile file) {
  final extension = file.extension?.toLowerCase();
  return extension == 'jpg' ||
      extension == 'jpeg' ||
      extension == 'png' ||
      extension == 'gif' ||
      extension == 'webp';
}

bool isPortableChatVideo(PlatformFile file) {
  final extension = file.extension?.toLowerCase();
  return extension == 'mp4' || extension == 'm4v' || extension == 'mov';
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
  Uint8List? sourceBytes,
}) async {
  if (!isPortableChatImage(source)) {
    throw UnsupportedError('暂不支持此图片格式，请选择 JPEG、PNG、GIF 或 WebP 图片');
  }
  final bytes = sourceBytes ?? await readPlatformFileBytes(source);
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

/// Creates a small, orientation-correct preview that can be downloaded before
/// the original image. Unsupported formats return null and keep the historical
/// full-image fallback working.
Future<PreparedChatThumbnail?> prepareChatThumbnail(
  Uint8List bytes, {
  String baseName = 'image',
}) async {
  final output = await compute(_createThumbnailJpeg, bytes);
  if (output == null || output.isEmpty) return null;
  final safeBase = baseName.replaceFirst(RegExp(r'\.[^.]+$'), '');
  return PreparedChatThumbnail(
    file: MemoryPlatformFile(name: '${safeBase}_thumb.jpg', bytes: output),
  );
}

Uint8List? _createThumbnailJpeg(Uint8List bytes) {
  try {
    var decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    decoded = img.bakeOrientation(decoded);
    const maxSide = 480;
    if (decoded.width > maxSide || decoded.height > maxSide) {
      decoded = decoded.width >= decoded.height
          ? img.copyResize(decoded, width: maxSide)
          : img.copyResize(decoded, height: maxSide);
    }
    return Uint8List.fromList(img.encodeJpg(decoded, quality: 74));
  } catch (_) {
    return null;
  }
}
