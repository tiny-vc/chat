import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('iOS launch and host use the same appearance-aware background', () {
    for (final name in ['Main', 'ChatLaunch']) {
      final xml = File(
        'ios/Runner/Base.lproj/$name.storyboard',
      ).readAsStringSync();
      expect(xml, contains('useTraitCollections="YES"'));
      expect(
        xml,
        contains('<color key="backgroundColor" name="LaunchBackground"/>'),
      );
    }
    final catalog =
        jsonDecode(
              File(
                'ios/Runner/Assets.xcassets/LaunchBackground.colorset/Contents.json',
              ).readAsStringSync(),
            )
            as Map;
    final colors = catalog['colors'] as List;
    expect(colors.length, 2);
    expect(colors[1]['appearances'][0]['value'], 'dark');
    for (var index = 0; index < 2; index++) {
      final components = colors[index]['color']['components'] as Map;
      final rgb = [
        'red',
        'green',
        'blue',
      ].map((key) => (components[key] as String).substring(2)).join();
      final theme = index == 0 ? AppTheme.light() : AppTheme.dark();
      expect(
        int.parse('FF$rgb', radix: 16),
        theme.colorScheme.surface.toARGB32(),
      );
    }
  });

  test('Android host and launch windows use the theme surface', () {
    for (final directory in ['values', 'values-night']) {
      final styles = File(
        'android/app/src/main/res/$directory/styles.xml',
      ).readAsStringSync();
      expect(
        styles,
        contains(
          '<item name="android:windowBackground">@color/launch_surface</item>',
        ),
      );
      final colors = File(
        'android/app/src/main/res/$directory/colors.xml',
      ).readAsStringSync();
      final theme = directory == 'values' ? AppTheme.light() : AppTheme.dark();
      expect(
        colors.toUpperCase(),
        contains(
          theme.colorScheme.surface
              .toARGB32()
              .toRadixString(16)
              .substring(2)
              .toUpperCase(),
        ),
      );
    }
  });
}
