import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.path.endsWith('/messages/receipts')
        ? [
            {'messageId': 'message-1', 'readCount': 2, 'unreadCount': 1},
          ]
        : {'success': true};
    return ResponseBody.fromString(
      jsonEncode(body),
      201,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('IM acknowledgements use typed request bodies', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://chat.example'));
    final adapter = _Adapter();
    dio.httpClientAdapter = adapter;
    final service = ImService(dio);
    addTearDown(() {
      service.dispose();
      dio.close(force: true);
    });

    await service.revokeMessage(
      channelId: 'peer-1',
      channelType: 1,
      clientMsgNo: 'client-1',
    );
    expect(adapter.requests.last.path, '/api/v1/im/messages/revoke');
    expect(adapter.requests.last.data, {
      'channelId': 'peer-1',
      'channelType': 1,
      'clientMsgNo': 'client-1',
    });

    await expectLater(
      service.revokeMessage(
        channelId: 'peer-1',
        channelType: 3,
        clientMsgNo: 'client-1',
      ),
      throwsArgumentError,
    );
  });

  test('typed receipt response maps to the app model', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://chat.example'));
    final adapter = _Adapter();
    dio.httpClientAdapter = adapter;
    final service = ImService(dio);
    addTearDown(() {
      service.dispose();
      dio.close(force: true);
    });
    final message = WKMsg()
      ..messageID = 'message-1'
      ..messageSeq = 42;

    final receipts = await service.loadReceipts(
      channelId: 'group-1',
      channelType: 2,
      messages: [message],
    );

    expect(adapter.requests.single.path, '/api/v1/im/messages/receipts');
    expect(adapter.requests.single.data, {
      'channelId': 'group-1',
      'channelType': 2,
      'messages': [
        {'messageId': 'message-1', 'messageSeq': 42},
      ],
    });
    expect(receipts.single.messageId, 'message-1');
    expect(receipts.single.readCount, 2);
    expect(receipts.single.unreadCount, 1);
  });
}
