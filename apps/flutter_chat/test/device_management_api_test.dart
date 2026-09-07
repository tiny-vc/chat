import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('设备列表与精准下线使用强类型认证 SDK', () async {
    final api = ChatApiClient();
    final requests = <RequestOptions>[];
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          handler.resolve(
            Response<Object>(
              requestOptions: request,
              statusCode: request.method == 'GET' ? 200 : 200,
              data: request.method == 'GET'
                  ? [
                      {
                        'id': '10000000-0000-4000-8000-000000000001',
                        'deviceId': 'ios-phone',
                        'deviceType': 'APP',
                        'deviceName': 'iPhone',
                        'ipAddress': '192.0.2.1',
                        'lastSeenAt': '2026-09-07T08:00:00.000Z',
                        'createdAt': '2026-09-01T08:00:00.000Z',
                        'current': false,
                      },
                    ]
                  : {'success': true},
            ),
          );
        },
      ),
    );
    addTearDown(() => api.dio.close(force: true));
    final repository = HomeRepository(api);

    final devices = await repository.devices();
    await repository.revokeDevice(devices.single.id);

    expect(devices.single.name, 'iPhone');
    expect(devices.single.type, 'APP');
    expect(devices.single.ipAddress, '192.0.2.1');
    expect(devices.single.current, isFalse);
    expect(requests.map((request) => request.path), [
      '/api/v1/auth/devices',
      '/api/v1/auth/devices/10000000-0000-4000-8000-000000000001',
    ]);
    expect(requests.last.method, 'DELETE');
  });

  test('设备下线未获服务器确认时不报成功', () async {
    final api = ChatApiClient();
    api.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (request, handler) => handler.resolve(
          Response<Object>(
            requestOptions: request,
            statusCode: 200,
            data: {'success': false},
          ),
        ),
      ),
    );
    addTearDown(() => api.dio.close(force: true));

    await expectLater(
      HomeRepository(api).revokeDevice('10000000-0000-4000-8000-000000000001'),
      throwsA(isA<FormatException>()),
    );
  });
}
