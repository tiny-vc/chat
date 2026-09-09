import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/diagnostics/app_diagnostics.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final diagnostics = AppDiagnostics.instance;

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        unawaited(
          diagnostics.record(
            details.exception,
            details.stack ?? StackTrace.current,
            source: 'flutter',
          ),
        );
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(diagnostics.record(error, stack, source: 'platform'));
        return true;
      };

      runApp(const ChatApp());
    },
    (error, stack) {
      unawaited(AppDiagnostics.instance.record(error, stack, source: 'zone'));
    },
  );
}
