import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

typedef DiagnosticsDirectoryProvider = Future<Directory> Function();

/// Small, privacy-conscious crash journal for failures that happen before a
/// screen can show an error. It is intentionally local-only; a future crash
/// reporting integration may explicitly upload an approved, redacted copy.
class AppDiagnostics {
  AppDiagnostics({
    DiagnosticsDirectoryProvider? directoryProvider,
    this.maxBytes = 256 * 1024,
  }) : _directoryProvider = directoryProvider ?? getApplicationSupportDirectory;

  static final instance = AppDiagnostics();

  final DiagnosticsDirectoryProvider _directoryProvider;
  final int maxBytes;
  Future<void> _pendingWrite = Future<void>.value();

  Future<File> get logFile async {
    final directory = await _directoryProvider();
    await directory.create(recursive: true);
    return File('${directory.path}/diagnostics.log');
  }

  Future<void> record(
    Object error,
    StackTrace stack, {
    String source = 'unhandled',
  }) {
    final timestamp = DateTime.now().toUtc().toIso8601String();
    final safeError = redactDiagnosticsText(error.toString());
    final safeStack = redactDiagnosticsText(stack.toString());
    final entry = '[$timestamp] [$source] $safeError\n$safeStack\n\n';
    debugPrint('[$source] $safeError');

    // Serialize writes so simultaneous Flutter/platform errors cannot corrupt
    // the journal. A failed write must not block later diagnostics.
    _pendingWrite = _pendingWrite
        .catchError((_) {})
        .then((_) => _appendBounded(entry));
    return _pendingWrite;
  }

  Future<void> _appendBounded(String entry) async {
    try {
      final file = await logFile;
      await file.writeAsString(entry, mode: FileMode.append, flush: true);
      final length = await file.length();
      if (length <= maxBytes) return;

      final bytes = await file.readAsBytes();
      final keep = maxBytes ~/ 2;
      final start = bytes.length > keep ? bytes.length - keep : 0;
      await file.writeAsBytes(bytes.sublist(start), flush: true);
    } catch (error) {
      // Diagnostics must never become another startup or runtime failure.
      debugPrint('Unable to persist local diagnostics: $error');
    }
  }
}

@visibleForTesting
String redactDiagnosticsText(String value) {
  var redacted = value.replaceAllMapped(
    RegExp(r'(authorization[=: ]+)(bearer )?[^\s,;]+', caseSensitive: false),
    (match) => '${match.group(1)}<redacted>',
  );
  redacted = redacted.replaceAllMapped(
    RegExp(
      r'(access_token|refresh_token|im_token|token|password)([=: ]+)[^\s,;&]+',
      caseSensitive: false,
    ),
    (match) => '${match.group(1)}${match.group(2)}<redacted>',
  );
  return redacted.replaceAllMapped(
    RegExp(r'([?&](?:token|key|secret)=)[^&\s]+', caseSensitive: false),
    (match) => '${match.group(1)}<redacted>',
  );
}
