import 'dart:async';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/config/app_config.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/widgets/app_avatar.dart';
import 'package:flutter_chat/features/home/presentation/group_settings_page.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'group_management_test.dart' as fixtures;

final class FakeFile extends PlatformFile {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class AvatarFiles implements FileTransferService {
  int uploads = 0;
  bool fail = false;
  Completer<void>? pending;
  @override
  Future<UploadedChatFile> uploadAvatar({
    required PlatformFile file,
    ProgressCallback? onProgress,
  }) async {
    uploads++;
    onProgress?.call(1, 2);
    await pending?.future;
    if (fail) throw StateError('upload failed');
    return const UploadedChatFile(
      fileId: 'new',
      name: 'a.png',
      size: 2,
      mimeType: 'image/png',
    );
  }

  @override
  Future<ResolvedUrl> downloadUrl(String id) async =>
      throw StateError('offline preview');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class AvatarRepo extends fixtures.GroupsFake {
  bool failBind = false;
  @override
  Future<void> setGroupAvatar(String id, String fileId) async {
    calls++;
    if (failBind) throw StateError('bind failed');
    this.group = this.group.rebuild((b) => b.avatarFileId = fileId);
  }

  @override
  Future<void> removeGroupAvatar(String id) async {
    calls++;
    this.group = this.group.rebuild((b) => b.avatarFileId = null);
  }
}

Future<void> openAvatar(
  WidgetTester tester,
  AvatarRepo repo,
  AvatarFiles files, {
  Future<PlatformFile?> Function()? picker,
}) async {
  final controller = HomeController(repo);
  await controller.load();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: GroupSettingsPage(
        groupId: 'g',
        controller: controller,
        fileTransferService: files,
        pickAvatar: picker ?? () async => FakeFile(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ordinary members see avatar without management actions', (
    tester,
  ) async {
    final repo = AvatarRepo()..me = 'member';
    await openAvatar(tester, repo, AvatarFiles());
    expect(find.byType(AppAvatar), findsOneWidget);
    expect(find.text('上传群头像'), findsNothing);
    expect(find.text('移除群头像'), findsNothing);
  });

  testWidgets('cancel and picker errors recover without upload', (
    tester,
  ) async {
    final files = AvatarFiles();
    final repo = AvatarRepo();
    int picks = 0;
    await openAvatar(
      tester,
      repo,
      files,
      picker: () async {
        if (++picks == 1) throw StateError('picker failed');
        return null;
      },
    );
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('上传群头像'));
      await tester.pumpAndSettle();
    }
    expect(picks, 2);
    expect(files.uploads, 0);
    expect(repo.calls, 0);
  });

  testWidgets('admin upload locks duplicate actions and refreshes avatar', (
    tester,
  ) async {
    final repo = AvatarRepo()..me = 'admin';
    final files = AvatarFiles()..pending = Completer<void>();
    await openAvatar(tester, repo, files);
    await tester.tap(find.text('上传群头像'));
    await tester.pump();
    await tester.tap(find.text('上传群头像'));
    expect(files.uploads, 1);
    expect(repo.calls, 0);
    files.pending!.complete();
    await tester.pumpAndSettle();
    expect(repo.calls, 1);
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId, 'new');
    expect(find.text('更换群头像'), findsOneWidget);
  });

  testWidgets('upload and bind failures retain old avatar and allow retry', (
    tester,
  ) async {
    final repo = AvatarRepo()
      ..group = AvatarRepo().group.rebuild((b) => b.avatarFileId = 'old');
    final files = AvatarFiles()..fail = true;
    await openAvatar(tester, repo, files);
    await tester.tap(find.text('更换群头像'));
    await tester.pumpAndSettle();
    expect(repo.calls, 0);
    files.fail = false;
    repo.failBind = true;
    await tester.tap(find.text('更换群头像'));
    await tester.pumpAndSettle();
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId, 'old');
    repo.failBind = false;
    await tester.tap(find.text('更换群头像'));
    await tester.pumpAndSettle();
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId, 'new');
  });

  testWidgets('remove requires confirmation then restores default', (
    tester,
  ) async {
    final repo = AvatarRepo()
      ..group = AvatarRepo().group.rebuild((b) => b.avatarFileId = 'old');
    final files = AvatarFiles();
    await openAvatar(tester, repo, files);
    await tester.tap(find.text('移除群头像'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(repo.calls, 0);
    await tester.tap(find.text('移除群头像'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '移除群头像'));
    await tester.pumpAndSettle();
    expect(repo.calls, 1);
    expect(files.uploads, 0);
    expect(tester.widget<AppAvatar>(find.byType(AppAvatar)).fileId, isNull);
  });
}
