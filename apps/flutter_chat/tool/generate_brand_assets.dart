// Run from apps/flutter_chat:
// flutter test tool/generate_brand_assets.dart
// Export the approved brand master into native Android and iOS sizes.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('export native brand assets from the master artwork', () async {
    final masterBytes = await File(
      'assets/branding/app_icon.png',
    ).readAsBytes();
    final codec = await ui.instantiateImageCodec(masterBytes);
    final master = (await codec.getNextFrame()).image;

    Future<void> export(String path, int size) async {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final side = size.toDouble();
      canvas.drawImageRect(
        master,
        ui.Rect.fromLTWH(
          0,
          0,
          master.width.toDouble(),
          master.height.toDouble(),
        ),
        ui.Rect.fromLTWH(0, 0, side, side),
        ui.Paint()..filterQuality = ui.FilterQuality.high,
      );
      final picture = recorder.endRecording();
      final image = await picture.toImage(size, size);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
      picture.dispose();
    }

    const assets = 'ios/Runner/Assets.xcassets';
    final catalog =
        jsonDecode(
              await File(
                '$assets/AppIcon.appiconset/Contents.json',
              ).readAsString(),
            )
            as Map;
    for (final item in catalog['images'] as List) {
      final size = double.parse((item['size'] as String).split('x').first);
      final scale = double.parse((item['scale'] as String).replaceAll('x', ''));
      await export(
        '$assets/AppIcon.appiconset/${item['filename']}',
        (size * scale).round(),
      );
    }
    for (var scale = 1; scale <= 3; scale++) {
      final suffix = scale == 1 ? '' : '@${scale}x';
      await export(
        '$assets/LaunchImage.imageset/LaunchImage$suffix.png',
        64 * scale,
      );
    }
    const res = 'android/app/src/main/res';
    for (final entry in {
      'mdpi': 1.0,
      'hdpi': 1.5,
      'xhdpi': 2.0,
      'xxhdpi': 3.0,
      'xxxhdpi': 4.0,
    }.entries) {
      await export(
        '$res/mipmap-${entry.key}/ic_launcher.png',
        (48 * entry.value).round(),
      );
      await export(
        '$res/mipmap-${entry.key}/ic_launcher_foreground.png',
        (108 * entry.value).round(),
      );
      await export(
        '$res/drawable-${entry.key}/launch_mark.png',
        (64 * entry.value).round(),
      );
    }
    master.dispose();
    codec.dispose();
  });
}
