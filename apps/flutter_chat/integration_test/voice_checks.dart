import 'package:flutter/material.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';

Future<void> runVoiceChecks({
  required WidgetTester tester,
  required String role,
  required String run,
  required String peerId,
  required FileTransferService files,
  required List<String> incoming,
  required List<WKMsg> receivedMedia,
  required Future<void> Function(bool Function(), String) wait,
}) async {
  String marker(String step) => 'integration:$run:VOICE_$step';
  Future<void> signal(String step) async {
    await WKIM.shared.messageManager.sendMessage(
      WKTextContent(marker(step)),
      WKChannel(peerId, 1),
    );
  }

  final baseline = receivedMedia
      .where((m) => m.messageContent is ChatAudioContent)
      .length;
  List<ChatAudioContent> audios() => receivedMedia
      .map((m) => m.messageContent)
      .whereType<ChatAudioContent>()
      .skip(baseline)
      .toList();
  if (role == 'A') {
    await wait(
      () => incoming.contains(marker('READY')),
      'voice receiver ready',
    );
    await tester.tap(find.byTooltip('录制语音'));
    await wait(
      () => find.textContaining('正在录音').evaluate().isNotEmpty,
      'native recording started',
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.widgetWithText(TextButton, '取消'));
    await wait(
      () => find.text('已取消录音，未发送').evaluate().isNotEmpty,
      'recording cancelled',
    );
    expect(find.byTooltip('录制语音'), findsOneWidget);
    await signal('CANCELLED');
    await wait(
      () => incoming.contains(marker('CANCEL_OK')),
      'cancel delivered no voice',
    );
    // The dismissible feedback bar temporarily covers the bottom composer.
    await wait(
      () => find.text('已取消录音，未发送').evaluate().isEmpty,
      'cancel feedback dismissed before recording again',
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byTooltip('录制语音'));
    await wait(
      () => find.textContaining('正在录音').evaluate().isNotEmpty,
      'second native recording started',
    );
    await tester.pump(const Duration(seconds: 4));
    await tester.tap(find.byTooltip('结束并发送'));
    await wait(
      () => incoming.contains(marker('OK')),
      'receiver decoded and played voice',
    );
    debugPrint('VOICE_A_VERIFIED');
    return;
  }
  await signal('READY');
  await wait(() => incoming.contains(marker('CANCELLED')), 'sender cancelled');
  expect(audios(), isEmpty);
  await signal('CANCEL_OK');
  await wait(() => audios().isNotEmpty, 'typed voice received');
  final content = audios().single;
  expect(content.durationMs, greaterThanOrEqualTo(500));
  final file = await files.download(
    fileId: content.fileId,
    fileName: 'voice-$run.m4a',
  );
  expect(await file.length(), greaterThan(0));
  final probe = AudioPlayer();
  try {
    final duration = await probe.setFilePath(file.path);
    expect(duration?.inMilliseconds, greaterThan(500));
    debugPrint(
      'VOICE_DECODED durationMs=${duration!.inMilliseconds} fileId=${content.fileId}',
    );
  } finally {
    await probe.dispose();
  }
  final bubble = find.byKey(ValueKey('voice-${content.fileId}'));
  await wait(() => bubble.evaluate().isNotEmpty, 'voice bubble visible');
  await tester.ensureVisible(bubble);
  bool icon(IconData data) => find
      .descendant(of: bubble, matching: find.byIcon(data))
      .evaluate()
      .isNotEmpty;
  await tester.tap(bubble);
  await wait(() => icon(Icons.pause_circle), 'first playback can be paused');
  await tester.tap(bubble);
  await wait(() => icon(Icons.play_circle), 'playback paused');
  await tester.tap(bubble);
  await wait(() => icon(Icons.pause_circle), 'playback resumed');
  await wait(() => icon(Icons.play_circle), 'completion returns to play icon');
  await tester.tap(bubble);
  await wait(() => icon(Icons.pause_circle), 'completed voice replays');
  await wait(() => icon(Icons.play_circle), 'replay completed');
  expect(
    audios(),
    hasLength(1),
    reason: 'cancelled recording sends no message',
  );
  await signal('OK');
  debugPrint('VOICE_B_VERIFIED');
}
