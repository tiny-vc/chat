import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/im/chat_message_content.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_chat/features/calls/presentation/call_page.dart';
import 'package:flutter_chat/features/calls/presentation/incoming_call_dialog.dart';
import 'package:flutter_chat/features/chat/presentation/chat_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/wkim.dart';

Future<void> runConnectedCallChecks({
  required WidgetTester tester,
  required String role,
  required String run,
  required ImService im,
  required CallService calls,
  required String peerId,
  required List<String> incoming,
  required Future<void> Function(bool Function(), String) wait,
}) async {
  final invites = <ChatCallSignalContent>[];
  const remoteAudio = bool.fromEnvironment('TEST_REMOTE_AUDIO');
  if (remoteAudio) {
    final cameras = await Hardware.instance.videoInputs();
    debugPrint('RTC_${role}_CAMERA_INPUTS=${cameras.length}');
  }
  String? activeCallId;
  final subscription = im.callSignals.listen((s) {
    if (s.action == 'invite') invites.add(s);
  });
  String marker(String step) => 'integration:$run:RTC_$step';
  Future<void> signal(String step) async {
    await WKIM.shared.messageManager.sendMessage(
      WKTextContent(marker(step)),
      WKChannel(peerId, 1),
    );
  }

  Future<void> receiving(CallPageState state, String phase) async {
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    num? firstPackets;
    num? firstBytes;
    num? firstSentPackets;
    num? firstSentBytes;
    Object? lastStats;
    Object? lastSent;
    while (DateTime.now().isBefore(deadline)) {
      final stats = await state.readRemoteAudioStats(peerId);
      lastStats = stats ?? lastStats;
      final sent = await state.readLocalAudioStats();
      lastSent = sent ?? lastSent;
      firstSentPackets ??= sent?.packets;
      firstSentBytes ??= sent?.bytes;
      if (stats != null &&
          stats.subscribed &&
          !stats.muted &&
          stats.packets != null &&
          stats.bytes != null) {
        firstPackets ??= stats.packets;
        firstBytes ??= stats.bytes;
        if (stats.packets! > firstPackets! &&
            stats.bytes! > firstBytes! &&
            sent?.packets != null &&
            sent?.bytes != null &&
            sent!.packets! > firstSentPackets! &&
            sent.bytes! > firstSentBytes!) {
          debugPrint(
            'REMOTE_AUDIO_${role}_$phase packetsDelta=${stats.packets! - firstPackets} bytesDelta=${stats.bytes! - firstBytes} sentPacketsDelta=${sent.packets! - firstSentPackets} sentBytesDelta=${sent.bytes! - firstSentBytes}',
          );
          return;
        }
      }
      await tester.pump(const Duration(milliseconds: 300));
    }
    fail(
      'Audio send/receive counters did not increase: $role $phase '
      'last=$lastStats initialPackets=$firstPackets initialBytes=$firstBytes '
      'sent=$lastSent initialSentPackets=$firstSentPackets initialSentBytes=$firstSentBytes',
    );
  }

  Future<void> remoteMuted(CallPageState state, bool muted) async {
    final deadline = DateTime.now().add(const Duration(seconds: 15));
    while (DateTime.now().isBefore(deadline)) {
      final stats = await state.readRemoteAudioStats(peerId);
      if (stats != null && stats.muted == muted) return;
      await tester.pump(const Duration(milliseconds: 200));
    }
    fail('Remote microphone state did not become muted=$muted');
  }

  try {
    for (var round = 0; round < 2; round++) {
      final existing = invites.map((s) => s.callId).toSet();
      if (role == 'B') {
        await signal('${round}_READY');
        await wait(
          () => invites.any((s) => !existing.contains(s.callId)),
          'incoming RTC invitation',
        );
        final invite = invites.firstWhere((s) => !existing.contains(s.callId));
        activeCallId = invite.callId;
        final result = showIncomingCallDialog(
          context: tester.element(find.byType(Scaffold).first),
          callId: invite.callId,
          caller: 'Integration caller',
          video: false,
          signals: im.callSignals,
        );
        await wait(
          () => find.text('语音来电').evaluate().isNotEmpty,
          'incoming dialog',
        );
        await tester.tap(find.text('接听'));
        expect(await result, IncomingCallResult.accept);
        final context = tester.element(find.byType(ChatPage));
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CallPage(
              callId: invite.callId,
              title: 'Integration caller',
              video: false,
              incoming: true,
              callService: calls,
              imService: im,
            ),
          ),
        );
      } else {
        await wait(
          () => incoming.contains(marker('${round}_READY')),
          'receiver ready',
        );
        await tester.tap(find.byTooltip('语音通话'));
      }
      await wait(
        () => find.byType(CallPage).evaluate().isNotEmpty,
        'call page open',
      );
      final page = tester.widget<CallPage>(find.byType(CallPage));
      final state = tester.state<CallPageState>(find.byType(CallPage));
      activeCallId = page.callId;
      await wait(() {
        if (find.text('连接失败，请查看下方提示').evaluate().isNotEmpty) {
          fail('CallPage connection failed; inspect CALL_START_FAILED stage');
        }
        return find.text('通话中').evaluate().isNotEmpty;
      }, 'LiveKit room and microphone connected');
      await signal('${round}_${role}_CONNECTED');
      final other = role == 'A' ? 'B' : 'A';
      await wait(
        () => incoming.contains(marker('${round}_${other}_CONNECTED')),
        'both call pages connected',
      );
      if (remoteAudio) {
        await receiving(state, '${round}_initial');
        await signal('${round}_${role}_RECEIVING');
        await wait(
          () => incoming.contains(marker('${round}_${other}_RECEIVING')),
          'both receiving audio',
        );
      }
      await tester.tap(find.byTooltip('静音'));
      await wait(
        () => find.text('取消静音').evaluate().isNotEmpty,
        'microphone muted',
      );
      if (remoteAudio) {
        await signal('${round}_${role}_MUTED');
        await wait(
          () => incoming.contains(marker('${round}_${other}_MUTED')),
          'both muted',
        );
        await remoteMuted(state, true);
        await signal('${round}_${role}_MUTE_SEEN');
        await wait(
          () => incoming.contains(marker('${round}_${other}_MUTE_SEEN')),
          'remote mute observed by both',
        );
      }
      await tester.tap(find.byTooltip('取消静音'));
      await wait(
        () => find.text('静音').evaluate().isNotEmpty,
        'microphone unmuted',
      );
      if (remoteAudio) {
        await remoteMuted(state, false);
        await receiving(state, '${round}_resumed');
      }
      await signal('${round}_${role}_CONTROLS');
      await wait(
        () => incoming.contains(marker('${round}_${other}_CONTROLS')),
        'both controls verified',
      );
      // Exercise each side as the terminating participant across two calls.
      if ((round == 0 && role == 'A') || (round == 1 && role == 'B')) {
        await tester.tap(find.byTooltip('挂断'));
      }
      await wait(
        () => find.byType(CallPage).evaluate().isEmpty,
        'call page closed',
      );
      expect(
        find.byType(ChatPage),
        findsOneWidget,
        reason: 'hangup must not pop underlying chat',
      );
      final history = await calls.history();
      final ended = history.singleWhere((c) => c.id == page.callId);
      expect(ended.status, 'ENDED');
      expect(ended.answeredAt, isNotNull);
      expect(ended.endedAt, isNotNull);
      await signal('${round}_${role}_CLOSED');
      await wait(
        () => incoming.contains(marker('${round}_${other}_CLOSED')),
        'both returned to chat',
      );
      debugPrint('RTC_${role}_${round}_VERIFIED id=${page.callId}');
      activeCallId = null;
    }
  } finally {
    // Only release the specific call created by this test on failure.
    if (activeCallId != null) {
      await calls.end(activeCallId).catchError((Object _) {});
    }
    await subscription.cancel();
  }
}
