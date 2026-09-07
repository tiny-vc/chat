import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/core/files/image_send_preparation.dart';
import 'package:flutter_test/flutter_test.dart';

class _ApiAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.method == 'POST'
        ? {
            'fileId': 'file-1',
            'uploadUrl': 'https://storage.example/upload',
            'method': 'PUT',
            'headers': <String, String>{},
            'expiresIn': 300,
          }
        : {'success': true};
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FailingStorageAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => throw DioException(
    requestOptions: options,
    type: DioExceptionType.connectionError,
    message: 'upload failed',
  );

  @override
  void close({bool force = false}) {}
}

class _ForwardAdapter implements HttpClientAdapter {
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode({
        'id': 'forwarded-file',
        'originalName': 'a.txt',
        'mimeType': 'text/plain',
        'sizeBytes': '1',
        'purpose': 'CHAT_FILE',
        'scope': 'GROUP',
        'status': 'READY',
      }),
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
  test('failed object upload immediately deletes its pending record', () async {
    final apiDio = Dio(BaseOptions(baseUrl: 'https://chat.example/api/v1'));
    final apiAdapter = _ApiAdapter();
    apiDio.httpClientAdapter = apiAdapter;
    final storage = Dio()..httpClientAdapter = _FailingStorageAdapter();
    final service = FileTransferService(
      ChatApiClient(dio: apiDio, interceptors: const []),
      storage: storage,
    );

    await expectLater(
      service.upload(
        file: MemoryPlatformFile(name: 'a.txt', bytes: Uint8List.fromList([1])),
        channelId: 'friend-1',
        channelType: 1,
        image: false,
      ),
      throwsA(isA<DioException>()),
    );

    expect(apiAdapter.requests.map((request) => request.method), [
      'POST',
      'DELETE',
    ]);
    expect(apiAdapter.requests.last.path, '/api/v1/files/file-1');
    service.dispose();
  });

  test('file forwarding uses the typed API and returns its new id', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://chat.example'));
    final adapter = _ForwardAdapter();
    dio.httpClientAdapter = adapter;
    final service = FileTransferService(
      ChatApiClient(dio: dio, interceptors: const []),
    );

    expect(
      await service.forwardFile(
        fileId: 'source-file',
        channelId: 'group-1',
        channelType: 2,
      ),
      'forwarded-file',
    );
    expect(adapter.request?.path, '/api/v1/files/source-file/forward');
    expect(adapter.request?.data, {'scope': 'GROUP', 'scopeId': 'group-1'});
    service.dispose();
  });
}
