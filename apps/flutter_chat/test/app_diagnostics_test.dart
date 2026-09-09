import 'dart:io';

import 'package:flutter_chat/core/diagnostics/app_diagnostics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redacts credentials from errors and URLs', () {
    final value = redactDiagnosticsText(
      'Authorization: Bearer abc token=def&key=ghi password: secret',
    );

    expect(value, isNot(contains('abc')));
    expect(value, isNot(contains('def')));
    expect(value, isNot(contains('ghi')));
    expect(value, isNot(contains('secret')));
    expect(value, contains('<redacted>'));
    expect(value, isNot(contains(r'$1')));
    expect(value, contains('password: <redacted>'));
  });

  test('persists failures and bounds the local journal', () async {
    final directory = await Directory.systemTemp.createTemp(
      'chat-diagnostics-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final diagnostics = AppDiagnostics(
      directoryProvider: () async => directory,
      maxBytes: 256,
    );

    for (var index = 0; index < 8; index++) {
      await diagnostics.record(
        StateError('failure-$index token=private-$index'),
        StackTrace.fromString('frame-$index'),
        source: 'test',
      );
    }

    final file = await diagnostics.logFile;
    final text = await file.readAsString();
    expect(await file.length(), lessThanOrEqualTo(256));
    expect(text, contains('failure-7'));
    expect(text, isNot(contains('private-7')));
  });
}
