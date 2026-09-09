import 'dart:async';

import 'package:flutter_chat/core/files/download_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'bounds concurrency and prioritizes avatars over queued thumbnails',
    () async {
      final scheduler = DownloadScheduler(maxConcurrent: 2);
      final gates = [Completer<void>(), Completer<void>()];
      final started = <String>[];

      Future<String> blocked(String name, int gate) async {
        started.add(name);
        await gates[gate].future;
        return name;
      }

      final first = scheduler.schedule(() => blocked('first', 0));
      final second = scheduler.schedule(() => blocked('second', 1));
      final thumbnail = scheduler.schedule(() async {
        started.add('thumbnail');
        return 'thumbnail';
      }, priority: DownloadPriority.background);
      final avatar = scheduler.schedule(() async {
        started.add('avatar');
        return 'avatar';
      }, priority: DownloadPriority.avatar);

      expect(started, ['first', 'second']);
      gates[0].complete();
      await first;
      await avatar;
      expect(started, ['first', 'second', 'avatar', 'thumbnail']);

      gates[1].complete();
      await Future.wait([second, thumbnail]);
      scheduler.close();
    },
  );

  test('closing fails work that has not started', () async {
    final scheduler = DownloadScheduler(maxConcurrent: 1);
    final gate = Completer<void>();
    final active = scheduler.schedule(() async {
      await gate.future;
      return 1;
    });
    final queued = scheduler.schedule(() async => 2);

    final queuedExpectation = expectLater(queued, throwsStateError);
    scheduler.close();
    await queuedExpectation;
    gate.complete();
    expect(await active, 1);
  });
}
