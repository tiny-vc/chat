import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_chat/core/im/im_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'late HTTP failure after disposal does not notify a dead service',
    () async {
      final dio = Dio();
      final service = ImService(dio);
      final started = Completer<void>();
      final release = Completer<void>();
      var notifications = 0;
      service.addListener(() => notifications++);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) async {
            started.complete();
            await release.future;
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );
      final pending = service.syncChannelMessages(
        'peer',
        1,
        0,
        0,
        50,
        0,
        (result) => expect(result, isNull),
      );
      await started.future;
      service.dispose();
      release.complete();
      await pending;
      expect(notifications, 0);
      dio.close(force: true);
    },
  );
  test(
    'SDK latest cursor -1 maps to zero; normal pagination is preserved',
    () async {
      final dio = Dio();
      final service = ImService(dio);
      addTearDown(() {
        service.dispose();
        dio.close(force: true);
      });
      final requests = <Map>[];
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request.data as Map);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: 200,
                data: {
                  'start_message_seq': 0,
                  'end_message_seq': 0,
                  'more': 0,
                  'messages': [],
                },
              ),
            );
          },
        ),
      );
      for (final cursor in [-1, 0, 150]) {
        await service.syncChannelMessages(
          'peer',
          1,
          cursor,
          20,
          50,
          0,
          (result) => expect(result?.messages, isEmpty),
        );
      }
      await service.syncChannelMessages('group', 2, 150, 220, 30, 1, (_) {});
      expect(requests.map((r) => r['startMessageSeq']), [0, 0, 150, 150]);
      expect(requests.last, {
        'channelId': 'group',
        'channelType': 2,
        'startMessageSeq': 150,
        'endMessageSeq': 220,
        'limit': 30,
        'pullMode': 1,
      });
    },
  );

  test(
    'failed history request returns SDK failure, not empty success',
    () async {
      final dio = Dio();
      final service = ImService(dio);
      addTearDown(() {
        service.dispose();
        dio.close(force: true);
      });
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.connectionError,
              ),
            );
          },
        ),
      );
      var completions = 0;
      await service.syncChannelMessages('peer', 1, 0, 0, 50, 0, (result) {
        completions++;
        expect(result, isNull);
      });
      expect(completions, 1);
      expect(service.error, isA<DioException>());
    },
  );
}
