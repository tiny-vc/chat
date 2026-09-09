import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _DownloadUrlAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return ResponseBody.fromString(
      jsonEncode({
        'downloadUrl': 'https://storage.example/file?signature=one',
        'expiresIn': 600,
        'file': {
          'id': 'file-1',
          'originalName': 'avatar.jpg',
          'mimeType': 'image/jpeg',
          'sizeBytes': '10',
          'purpose': 'AVATAR',
          'scope': 'PRIVATE',
          'status': 'READY',
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory temporaryDirectory;
  late File cached;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'chat-file-cache-test-',
    );
    cached = File('${temporaryDirectory.path}/cached-file');
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('cache accepts a complete file with the expected size', () async {
    await cached.writeAsBytes([1, 2, 3, 4]);
    expect(await cachedDownloadIsValid(cached, expectedSize: 4), isTrue);
  });

  test('cache rejects missing, empty and truncated files', () async {
    expect(await cachedDownloadIsValid(cached, expectedSize: 4), isFalse);

    await cached.writeAsBytes([]);
    expect(await cachedDownloadIsValid(cached, expectedSize: 0), isFalse);

    await cached.writeAsBytes([1, 2]);
    expect(await cachedDownloadIsValid(cached, expectedSize: 4), isFalse);
  });

  test('cache rejects content that does not match its SHA-256', () async {
    await cached.writeAsBytes([1, 2, 3, 4]);
    expect(
      await cachedDownloadIsValid(
        cached,
        expectedSize: 4,
        expectedSha256:
            '9f64a747e1b97f131fabb6b447296c9b6f0201e79fb3c5356e6c77e89b6a806a',
      ),
      isTrue,
    );
    expect(
      await cachedDownloadIsValid(
        cached,
        expectedSize: 4,
        expectedSha256: '0' * 64,
      ),
      isFalse,
    );
  });

  test('legacy callers without a known size accept non-empty cache', () async {
    await cached.writeAsBytes([1]);
    expect(await cachedDownloadIsValid(cached), isTrue);
  });

  test(
    'signed download URLs are shared by concurrent and repeated widgets',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://chat.example'));
      final adapter = _DownloadUrlAdapter();
      dio.httpClientAdapter = adapter;
      final service = FileTransferService(
        ChatApiClient(dio: dio, interceptors: const []),
      );

      final urls = await Future.wait([
        service.downloadUrl('file-1'),
        service.downloadUrl('file-1'),
        service.downloadUrl('file-1'),
      ]);
      expect(adapter.calls, 1);
      expect(urls.map((item) => item.url).toSet(), hasLength(1));
      expect((await service.downloadUrl('file-1')).url, urls.first.url);
      expect(adapter.calls, 1);
      service.dispose();
    },
  );

  test('opening a cached file refreshes its eviction timestamp', () async {
    await cached.writeAsBytes([1]);
    final old = DateTime(2026, 8, 1);
    final accessed = DateTime(2026, 9, 6);
    await cached.setLastModified(old);

    await markCachedDownloadAccessed(cached, now: accessed);

    expect((await cached.stat()).modified, accessed);
  });

  test('cache listing only returns the requested server namespace', () async {
    await File('${temporaryDirectory.path}/server-a_one').writeAsBytes([1]);
    await File(
      '${temporaryDirectory.path}/server-a_two.part',
    ).writeAsBytes([1]);
    await File('${temporaryDirectory.path}/server-b_one').writeAsBytes([1]);

    final files = await chatDownloadCacheFiles(
      temporaryDirectory,
      namespace: 'server-a',
    );

    expect(files.map((file) => file.path), hasLength(2));
    expect(files.every((file) => file.path.contains('server-a_')), isTrue);
  });

  test(
    'pruning is scoped, preserves active files and removes partials',
    () async {
      const namespace = 'server-a';
      final old = File('${temporaryDirectory.path}/${namespace}_old');
      final recent = File('${temporaryDirectory.path}/${namespace}_recent');
      final active = File(
        '${temporaryDirectory.path}/${namespace}_active.part',
      );
      final partial = File(
        '${temporaryDirectory.path}/${namespace}_stale.part',
      );
      final otherServer = File('${temporaryDirectory.path}/server-b_file');
      for (final file in [old, recent, active, partial, otherServer]) {
        await file.writeAsBytes([1, 2, 3, 4]);
      }
      final now = DateTime(2026, 9, 6);
      await old.setLastModified(now.subtract(const Duration(days: 31)));
      await recent.setLastModified(now.subtract(const Duration(days: 1)));

      final deleted = await pruneChatDownloadCache(
        temporaryDirectory,
        namespace: namespace,
        preservedPaths: {active.path},
        now: now,
      );

      expect(deleted, 2);
      expect(await old.exists(), isFalse);
      expect(await partial.exists(), isFalse);
      expect(await recent.exists(), isTrue);
      expect(await active.exists(), isTrue);
      expect(await otherServer.exists(), isTrue);
    },
  );

  test('pruning evicts oldest complete files above the size budget', () async {
    const namespace = 'server-a';
    final oldest = File('${temporaryDirectory.path}/${namespace}_oldest');
    final newest = File('${temporaryDirectory.path}/${namespace}_newest');
    await oldest.writeAsBytes(List.filled(4, 1));
    await newest.writeAsBytes(List.filled(4, 2));
    final now = DateTime(2026, 9, 6);
    await oldest.setLastModified(now.subtract(const Duration(days: 2)));
    await newest.setLastModified(now.subtract(const Duration(days: 1)));

    expect(
      await pruneChatDownloadCache(
        temporaryDirectory,
        namespace: namespace,
        maxBytes: 4,
        now: now,
      ),
      1,
    );
    expect(await oldest.exists(), isFalse);
    expect(await newest.exists(), isTrue);
  });
}
