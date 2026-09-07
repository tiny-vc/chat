import 'package:permission_handler/permission_handler.dart' as handler;

enum AppPermission { microphone, camera, notifications }

enum AppPermissionStatus { granted, denied, permanentlyDenied, restricted }

abstract interface class AppPermissionGateway {
  Future<AppPermissionStatus> status(AppPermission permission);
  Future<AppPermissionStatus> request(AppPermission permission);
  Future<bool> openSettings();
}

class DevicePermissionGateway implements AppPermissionGateway {
  const DevicePermissionGateway();

  handler.Permission _permission(AppPermission permission) =>
      switch (permission) {
        AppPermission.microphone => handler.Permission.microphone,
        AppPermission.camera => handler.Permission.camera,
        AppPermission.notifications => handler.Permission.notification,
      };

  AppPermissionStatus _status(handler.PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return AppPermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return AppPermissionStatus.permanentlyDenied;
    }
    if (status.isRestricted) return AppPermissionStatus.restricted;
    return AppPermissionStatus.denied;
  }

  @override
  Future<AppPermissionStatus> status(AppPermission permission) async =>
      _status(await _permission(permission).status);

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async =>
      _status(await _permission(permission).request());

  @override
  Future<bool> openSettings() => handler.openAppSettings();
}

class AppPermissionService {
  const AppPermissionService({this.gateway = const DevicePermissionGateway()});

  final AppPermissionGateway gateway;

  Future<AppPermissionStatus> check(AppPermission permission) =>
      gateway.status(permission);

  Future<AppPermissionStatus> request(AppPermission permission) =>
      gateway.request(permission);

  Future<bool> openSettings() => gateway.openSettings();
}
