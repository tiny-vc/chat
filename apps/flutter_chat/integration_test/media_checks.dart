import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat/features/chat/presentation/message_details.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';

final class _FixtureFile extends PlatformFile {
  _FixtureFile(this.name, this.bytes);
  @override
  final String name;
  final Uint8List bytes;
  @override
  Uri get uri => Uri.dataFromBytes(bytes);
  @override
  Never get xFile => throw UnsupportedError('Not used by streaming upload');
  @override
  Future<int> length() async => bytes.length;
  @override
  Future<Uint8List> readAsBytes() async => bytes;
  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(bytes);
}

Future<void> runMediaChecks({
  required WidgetTester tester,
  required String role,
  required String run,
  required String peerId,
  required FileTransferService files,
  required List<String> incoming,
  required List<WKMsg> receivedMedia,
  required Future<void> Function(bool Function(), String) wait,
}) async {
  final textBytes = Uint8List.fromList(
    utf8.encode('文件联调 $run\n${'hello\n' * 256}'),
  );
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    const Rect.fromLTWH(0, 0, 64, 48),
    Paint()..color = Colors.blue,
  );
  canvas.drawRect(
    const Rect.fromLTWH(8, 8, 16, 16),
    Paint()..color = Colors.orange,
  );
  final picture = recorder.endRecording();
  final fixtureImage = await picture.toImage(64, 48);
  final png = (await fixtureImage.toByteData(
    format: ui.ImageByteFormat.png,
  ))!.buffer.asUint8List();
  picture.dispose();
  fixtureImage.dispose();
  final prefix = 'integration:$run:MEDIA_IDS|';
  final ack = 'integration:$run:MEDIA_OK';
  final fileName = 'integration-$run.txt';
  if (role == 'A') {
    final uploadedFile = await files.upload(
      file: _FixtureFile(fileName, textBytes),
      channelId: peerId,
      channelType: 1,
      image: false,
    );
    final uploadedImage = await files.upload(
      file: _FixtureFile('integration-$run.png', png),
      channelId: peerId,
      channelType: 1,
      image: true,
    );
    await WKIM.shared.messageManager.sendMessage(
      ChatFileContent(
        fileId: uploadedFile.fileId,
        name: uploadedFile.name,
        size: uploadedFile.size,
        mimeType: uploadedFile.mimeType,
      ),
      WKChannel(peerId, 1),
    );
    await WKIM.shared.messageManager.sendMessage(
      ChatImageContent(fileId: uploadedImage.fileId, width: 64, height: 48),
      WKChannel(peerId, 1),
    );
    await WKIM.shared.messageManager.sendMessage(
      WKTextContent('$prefix${uploadedFile.fileId}|${uploadedImage.fileId}'),
      WKChannel(peerId, 1),
    );
    await wait(() => incoming.contains(ack), 'peer verified media');
    return;
  }
  await wait(
    () => incoming.any((m) => m.startsWith(prefix)),
    'media IDs received',
  );
  final ids = incoming
      .firstWhere((m) => m.startsWith(prefix))
      .substring(prefix.length)
      .split('|');
  await wait(
    () =>
        receivedMedia.any(
          (m) =>
              m.messageContent is ChatFileContent &&
              (m.messageContent as ChatFileContent).fileId == ids[0],
        ) &&
        receivedMedia.any(
          (m) =>
              m.messageContent is ChatImageContent &&
              (m.messageContent as ChatImageContent).fileId == ids[1],
        ),
    'typed file/image messages received',
  );
  final fileContent = receivedMedia
      .map((m) => m.messageContent)
      .whereType<ChatFileContent>()
      .firstWhere((m) => m.fileId == ids[0]);
  expect(fileContent.name, fileName);
  expect(fileContent.size, textBytes.length);
  final downloaded = await files.download(fileId: ids[0], fileName: fileName);
  expect(await downloaded.readAsBytes(), orderedEquals(textBytes));
  final cached = await files.download(fileId: ids[0], fileName: fileName);
  expect(await cached.readAsBytes(), orderedEquals(textBytes));
  final imageFile = await files.download(
    fileId: ids[1],
    fileName: 'integration-$run.png',
  );
  expect(await imageFile.readAsBytes(), orderedEquals(png));
  final codec = await ui.instantiateImageCodec(await imageFile.readAsBytes());
  final frame = await codec.getNextFrame();
  expect(frame.image.width, 64);
  expect(frame.image.height, 48);
  frame.image.dispose();
  codec.dispose();

  final thumbnail = find.byKey(ValueKey('message-image-${ids[1]}'));
  await wait(
    () => thumbnail.evaluate().isNotEmpty,
    'this run thumbnail mounted',
  );
  await tester.ensureVisible(thumbnail);
  await wait(
    () => find
        .descendant(of: thumbnail, matching: find.byType(RawImage))
        .evaluate()
        .any((element) => (element.widget as RawImage).image?.width == 64),
    'this run network thumbnail decoded',
  );
  final imageSize = tester.getSize(thumbnail);
  expect(imageSize.width / imageSize.height, closeTo(64 / 48, .01));
  debugPrint('MEDIA_THUMBNAIL_VERIFIED file=${ids[1]}');
  await tester.tap(thumbnail);
  await wait(
    () => find.text('图片预览').evaluate().isNotEmpty,
    'full-screen preview opened',
  );
  await wait(
    () => find
        .byType(RawImage)
        .evaluate()
        .any((element) => (element.widget as RawImage).image?.width == 64),
    'preview decoded',
  );
  await tester.tap(find.byType(BackButton));
  await tester.pump(const Duration(milliseconds: 350));

  final fileTile = find.byWidgetPredicate(
    (w) => w is FileMessageTile && w.name == fileName,
  );
  await tester.ensureVisible(fileTile);
  await tester.tap(fileTile);
  await wait(
    () => tester.widget<FileMessageTile>(fileTile).downloading,
    'real file bubble entered downloading/opening state',
  );
  debugPrint('MEDIA_NATIVE_OPEN_READY file=${ids[0]}');
  // Human closes the native iOS preview; do not automate macOS permissions.
  await wait(
    () => !tester.widget<FileMessageTile>(fileTile).downloading,
    'native preview closed and file bubble available again',
  );
  expect(find.text('文件打开失败，请稍后重试'), findsNothing);
  expect(
    find.byType(SnackBar),
    findsNothing,
    reason: 'download/open failure must not be mistaken for completion',
  );
  debugPrint('MEDIA_FILE_BUBBLE_VERIFIED file=${ids[0]}');
  await WKIM.shared.messageManager.sendMessage(
    WKTextContent(ack),
    WKChannel(peerId, 1),
  );
}
