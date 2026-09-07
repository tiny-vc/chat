import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mobile deployment baselines are explicit', () {
    final android = File('android/app/build.gradle.kts').readAsStringSync();
    final xcode = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();

    expect(android, contains('compileSdk = 36'));
    expect(android, contains('minSdk = 24'));
    expect(android, contains('targetSdk = 36'));
    expect(File('ios/Podfile').existsSync(), isFalse);
    expect(xcode, contains('XCLocalSwiftPackageReference'));
    expect(xcode, contains('FlutterGeneratedPluginSwiftPackage'));
    expect(xcode, contains('IPHONEOS_DEPLOYMENT_TARGET = 15.0;'));
  });

  test('cleartext is allowed only by development manifests', () {
    final main = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final debug = File(
      'android/app/src/debug/AndroidManifest.xml',
    ).readAsStringSync();
    final profile = File(
      'android/app/src/profile/AndroidManifest.xml',
    ).readAsStringSync();

    expect(main, contains('android:usesCleartextTraffic="false"'));
    expect(debug, contains('android:usesCleartextTraffic="true"'));
    expect(profile, contains('android:usesCleartextTraffic="true"'));
  });
}
