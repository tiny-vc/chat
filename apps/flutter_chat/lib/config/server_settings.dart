import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String serverNamespace(String address) =>
    sha256.convert(utf8.encode(Uri.parse(address).origin)).toString();

String scopedFileCacheKey(String address, String fileId) =>
    '${serverNamespace(address)}_${sha256.convert(utf8.encode(fileId))}';

String normalizeServerAddress(String input) {
  final uri = Uri.tryParse(input.trim());
  if (input.length > 2048 ||
      uri == null ||
      !['https', 'http'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      !['', '/', '/api/v1', '/api/v1/'].contains(uri.path) ||
      uri.port < 1 ||
      uri.port > 65535) {
    throw const FormatException(
      '请输入完整服务器地址，例如 https://chat.example.com，不要包含账号、查询参数或其他路径。',
    );
  }
  final host = uri.host.toLowerCase();
  final ip = host.split('.').map(int.tryParse).toList();
  final privateIpv4 =
      ip.length == 4 &&
      ip.every((v) => v != null && v >= 0 && v <= 255) &&
      (ip[0] == 10 ||
          ip[0] == 127 ||
          (ip[0] == 192 && ip[1] == 168) ||
          (ip[0] == 172 && ip[1]! >= 16 && ip[1]! <= 31));
  if (uri.scheme == 'http' &&
      !(host == 'localhost' || host == '::1' || privateIpv4)) {
    throw const FormatException('公网服务器必须使用 HTTPS；HTTP 仅用于本机或私有 IPv4 局域网调试。');
  }
  return uri.origin;
}

class ServerInfo {
  const ServerInfo({
    required this.address,
    required this.name,
    required this.registrationEnabled,
  });
  final String address;
  final String name;
  final bool registrationEnabled;
}

class ServerProbe {
  ServerProbe({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              sendTimeout: const Duration(seconds: 8),
            ),
          );
  final Dio _dio;

  Future<ServerInfo> check(String input) async {
    final address = normalizeServerAddress(input);
    final cancel = CancelToken();
    // Separate unauthenticated client, no session interceptor, cookies or redirect.
    final response = await _dio
        .get<String>(
          '$address/api/v1/server-info',
          options: Options(
            followRedirects: false,
            maxRedirects: 0,
            responseType: ResponseType.plain,
            validateStatus: (status) => status == 200,
          ),
          cancelToken: cancel,
          onReceiveProgress: (received, _) {
            if (received > 65536) cancel.cancel('Server info is too large');
          },
        )
        .timeout(
          const Duration(seconds: 12),
          onTimeout: () {
            cancel.cancel('Server detection deadline exceeded');
            throw TimeoutException('Server detection timed out');
          },
        );
    final raw = response.data;
    if (raw is! String || raw.length > 65536) {
      throw const FormatException('服务器信息格式无效或内容过大。');
    }
    final data = jsonDecode(raw);
    if (data is! Map ||
        data['product'] != 'chat' ||
        data['apiVersion'] != 1 ||
        data['name'] is! String ||
        (data['name'] as String).trim().isEmpty ||
        (data['name'] as String).length > 80 ||
        data['registrationEnabled'] is! bool ||
        data['uploadLimits'] is! Map) {
      throw const FormatException('不是兼容的聊天服务器，或服务器协议版本不受支持。');
    }
    return ServerInfo(
      address: address,
      name: data['name'] as String,
      registrationEnabled: data['registrationEnabled'] as bool,
    );
  }

  void dispose() => _dio.close(force: true);
}

class ServerSettingsStore {
  ServerSettingsStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const key = 'chat.selected_server.v1';
  Future<String?> read() => _storage.read(key: key);
  Future<void> clear() => _storage.delete(key: key);
  Future<void> save(String address) =>
      _storage.write(key: key, value: normalizeServerAddress(address));
}
