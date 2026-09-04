// Run from apps/flutter_chat:
// flutter test tool/generate_brand_assets.dart
// Export the existing code-native Material mark; not final brand artwork.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('export native brand assets from the existing Material mark', () async {
    final loader = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await loader.load();
    final primary = AppTheme.light().colorScheme.primary;
    // Keep native adaptive-icon background in sync with Flutter's theme.
    final nativeColors = await File(
      'android/app/src/main/res/values/colors.xml',
    ).readAsString();
    expect(
      nativeColors.toUpperCase(),
      contains(primary.toARGB32().toRadixString(16).substring(2).toUpperCase()),
    );

    Future<void> export(String path, int size, String kind) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final side = size.toDouble();
      final rect = Rect.fromLTWH(0, 0, side, side);
      if (kind == 'icon') {
        canvas.drawRect(rect, Paint()..color = primary);
      } else if (kind == 'launch') {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(side * 20 / 64)),
          Paint()..color = primary,
        );
      }
      final glyphSize = side * (kind == 'foreground' ? 48 / 108 : 0.5);
      final painter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.forum_rounded.codePoint),
          style: TextStyle(
            fontFamily: 'MaterialIcons',
            fontSize: glyphSize,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset((side - painter.width) / 2, (side - painter.height) / 2),
      );
      final picture = recorder.endRecording();
      final image = await picture.toImage(size, size);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
      picture.dispose();
      painter.dispose();
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
        'icon',
      );
    }
    for (var scale = 1; scale <= 3; scale++) {
      final suffix = scale == 1 ? '' : '@${scale}x';
      await export(
        '$assets/LaunchImage.imageset/LaunchImage$suffix.png',
        64 * scale,
        'launch',
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
        'icon',
      );
      await export(
        '$res/mipmap-${entry.key}/ic_launcher_foreground.png',
        (108 * entry.value).round(),
        'foreground',
      );
      await export(
        '$res/drawable-${entry.key}/launch_mark.png',
        (64 * entry.value).round(),
        'launch',
      );
    }
  });
}
