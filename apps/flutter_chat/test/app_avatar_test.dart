import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty avatar uses a grapheme and makes no request', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppAvatar(
          name: '👩‍💻小明',
          resolveUrl: (_) async {
            requests++;
            throw StateError('must not resolve');
          },
        ),
      ),
    );
    expect(find.text('👩‍💻'), findsOneWidget);
    expect(requests, 0);
  });

  testWidgets('failed resolution falls back without a framework error', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppAvatar(
          name: '小明',
          fileId: 'private-avatar',
          resolveUrl: (_) async => throw StateError('denied'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('小'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rebuild does not refetch and new file ID resolves once', (
    tester,
  ) async {
    final requests = <String>[];
    final pending = <String, Completer<ResolvedUrl>>{};
    Future<ResolvedUrl> resolve(String id) {
      requests.add(id);
      return (pending[id] = Completer<ResolvedUrl>()).future;
    }

    Future<void> mount(String? id, String name) => tester.pumpWidget(
      MaterialApp(
        home: AppAvatar(name: name, fileId: id, resolveUrl: resolve),
      ),
    );
    await mount('old', '旧');
    await mount('old', '新');
    expect(requests, ['old']);
    await mount('new', '新');
    expect(requests, ['old', 'new']);
    pending['old']!.completeError(StateError('late response'));
    await tester.pump();
    expect(find.text('新'), findsOneWidget);
    await mount(null, '新');
    pending['new']!.completeError(StateError('removed avatar'));
    await tester.pump();
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('group fallback uses a group icon and fixed size', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: AppAvatar(
            name: '项目组',
            group: true,
            size: 48,
            resolveUrl: (_) async => throw StateError('unused'),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.group_outlined), findsOneWidget);
    expect(tester.getSize(find.byType(AppAvatar)), const Size(48, 48));
  });

  testWidgets('network avatar decodes near its rendered pixel size', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(devicePixelRatio: 3),
          child: AppAvatar(
            name: '小明',
            fileId: 'avatar',
            size: 40,
            resolveUrl: (_) async => const ResolvedUrl(
              'https://invalid.example/avatar.jpg',
              headers: {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as ResizeImage;
    expect(provider.width, 120);
    expect(provider.height, 120);
  });
}
