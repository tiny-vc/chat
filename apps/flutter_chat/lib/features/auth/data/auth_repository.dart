import 'package:chat_api_client/chat_api_client.dart';
import '../../../config/app_identity.dart';

import '../../../core/auth/session_manager.dart';
import '../../../core/auth/token_store.dart';

class AuthRepository {
  AuthRepository({
    required ChatApiClient api,
    required SessionManager session,
    required InstallationIdStore installationIdStore,
  }) : _api = api,
       _session = session,
       _installationIdStore = installationIdStore;

  final ChatApiClient _api;
  final SessionManager _session;
  final InstallationIdStore _installationIdStore;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final deviceId = await _installationIdStore.getOrCreate();
    final response = await _api.getAuthApi().authLogin(
      loginDto: LoginDto(
        (builder) => builder
          ..username = username.trim()
          ..password = password
          ..deviceId = deviceId
          ..deviceType = LoginDtoDeviceTypeEnum.APP
          ..deviceName = AppIdentity.name,
      ),
    );
    final session = response.data;
    if (session == null) throw StateError('登录响应为空');
    await _session.saveSession(session);
  }

  Future<void> register({
    required String username,
    required String nickname,
    required String password,
  }) async {
    final deviceId = await _installationIdStore.getOrCreate();
    final response = await _api.getAuthApi().authRegister(
      registerDto: RegisterDto(
        (builder) => builder
          ..username = username.trim()
          ..nickname = nickname.trim()
          ..password = password
          ..deviceId = deviceId
          ..deviceType = RegisterDtoDeviceTypeEnum.APP
          ..deviceName = AppIdentity.name,
      ),
    );
    final session = response.data;
    if (session == null) throw StateError('注册响应为空');
    await _session.saveSession(session);
  }

  Future<void> logout() async {
    try {
      await _api.getAuthApi().authLogout();
    } finally {
      await _session.clear();
    }
  }

  Future<void> deactivateAccount(String currentPassword) async {
    await _api.dio.delete<Object>(
      '/api/v1/auth/account',
      data: {'currentPassword': currentPassword},
    );
    await _session.clear();
  }
}
