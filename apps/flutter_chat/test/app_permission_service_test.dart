import 'package:flutter_chat/core/permissions/app_permission_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _Gateway implements AppPermissionGateway {
  _Gateway(this.current, this.requested);

  AppPermissionStatus current;
  final AppPermissionStatus requested;
  int requestCount = 0;
  int settingsCount = 0;

  @override
  Future<bool> openSettings() async {
    settingsCount++;
    return true;
  }

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    requestCount++;
    current = requested;
    return current;
  }

  @override
  Future<AppPermissionStatus> status(AppPermission permission) async => current;
}

void main() {
  test('granted permission does not request again', () async {
    final gateway = _Gateway(
      AppPermissionStatus.granted,
      AppPermissionStatus.denied,
    );
    final service = AppPermissionService(gateway: gateway);
    expect(
      await service.check(AppPermission.microphone),
      AppPermissionStatus.granted,
    );
    expect(gateway.requestCount, 0);
  });

  test('request result and settings action are preserved', () async {
    final gateway = _Gateway(
      AppPermissionStatus.denied,
      AppPermissionStatus.permanentlyDenied,
    );
    final service = AppPermissionService(gateway: gateway);
    expect(
      await service.request(AppPermission.camera),
      AppPermissionStatus.permanentlyDenied,
    );
    expect(await service.openSettings(), isTrue);
    expect(gateway.requestCount, 1);
    expect(gateway.settingsCount, 1);
  });
}
