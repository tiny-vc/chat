import 'package:flutter/material.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/features/home/presentation/storage_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _Files implements FileTransferService {
  _Files({this.serverUsage});

  final ServerFileUsage? serverUsage;
  var stats = const DownloadCacheStats(fileCount: 2, totalBytes: 1536);
  var clears = 0;
  var serverReads = 0;
  var localReads = 0;

  @override
  Future<ServerFileUsage> serverFileUsage() async {
    serverReads++;
    return serverUsage ??
        const ServerFileUsage(
          usedBytes: 1024 * 1024 * 1024,
          quotaBytes: 10 * 1024 * 1024 * 1024,
          remainingBytes: 9 * 1024 * 1024 * 1024,
          fileCount: 4,
        );
  }

  @override
  Future<DownloadCacheStats> downloadCacheStats() async {
    localReads++;
    return stats;
  }

  @override
  Future<void> clearDownloadCache() async {
    clears++;
    stats = const DownloadCacheStats(fileCount: 0, totalBytes: 0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('shows scoped usage and confirms before clearing', (
    tester,
  ) async {
    final files = _Files();
    await tester.pumpWidget(MaterialApp(home: StoragePage(files: files)));
    await tester.pumpAndSettle();

    expect(find.text('1.5 KB · 2 个文件'), findsOneWidget);
    expect(find.textContaining('已使用 1.0 GB / 10.0 GB'), findsOneWidget);
    expect(find.text('剩余 9.0 GB'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('refresh-storage')));
    await tester.pumpAndSettle();
    expect(files.serverReads, 2);
    expect(files.localReads, 2);
    await tester.tap(find.text('清理下载缓存'));
    await tester.pumpAndSettle();
    expect(find.textContaining('聊天记录和消息中的文件不会删除'), findsOneWidget);
    expect(files.clears, 0);

    await tester.tap(find.widgetWithText(FilledButton, '清理'));
    await tester.pumpAndSettle();
    expect(files.clears, 1);
    expect(find.text('0 B · 0 个文件'), findsOneWidget);
  });

  testWidgets('warns when server storage is nearly full', (tester) async {
    final files = _Files(
      serverUsage: const ServerFileUsage(
        usedBytes: 95,
        quotaBytes: 100,
        remainingBytes: 5,
        fileCount: 8,
      ),
    );
    await tester.pumpWidget(MaterialApp(home: StoragePage(files: files)));
    await tester.pumpAndSettle();

    expect(find.textContaining('服务器空间即将用完'), findsOneWidget);
  });
}
