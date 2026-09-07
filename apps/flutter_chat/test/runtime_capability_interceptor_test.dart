import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_chat/config/runtime_capability_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestErrorHandler extends ErrorInterceptorHandler {
  Future<void> get settled => future.then<void>((_) {}, onError: (_) {});
}

void main() {
  test('recognizes only the structured disabled capability contract', () {
    expect(
      disabledCapabilityFrom({
        'code': 'CAPABILITY_DISABLED',
        'details': {'capability': 'files'},
      }),
      'files',
    );
    expect(disabledCapabilityFrom({'code': 'SERVICE_UNAVAILABLE'}), isNull);
    expect(disabledCapabilityFrom('internal error'), isNull);
  });

  test('coalesces concurrent disabled responses into one refresh', () async {
    final gate = Completer<void>();
    var refreshes = 0;
    final interceptor = RuntimeCapabilityInterceptor(
      onCapabilitiesChanged: () {
        refreshes++;
        return gate.future;
      },
    );
    final options = RequestOptions(path: '/api/v1/files/uploads');
    final error = DioException(
      requestOptions: options,
      response: Response<Object?>(
        requestOptions: options,
        statusCode: 503,
        data: {
          'code': 'CAPABILITY_DISABLED',
          'details': {'capability': 'files'},
        },
      ),
    );
    final firstHandler = _TestErrorHandler();
    final secondHandler = _TestErrorHandler();
    final firstSettled = firstHandler.settled;
    final secondSettled = secondHandler.settled;
    interceptor.onError(error, firstHandler);
    interceptor.onError(error, secondHandler);
    expect(refreshes, 1);
    gate.complete();
    await Future.wait([gate.future, firstSettled, secondSettled]);
  });
}
