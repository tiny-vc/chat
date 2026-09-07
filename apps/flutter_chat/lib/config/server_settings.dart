import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/widgets.dart';

String serverNamespace(String address) =>
    sha256.convert(utf8.encode(Uri.parse(address).origin)).toString();

String scopedFileCacheKey(String address, String fileId) =>
    '${serverNamespace(address)}_${sha256.convert(utf8.encode(fileId))}';

bool shouldRefreshServerInfo({
  required DateTime now,
  DateTime? lastAttempt,
  Duration maxAge = const Duration(minutes: 5),
}) =>
    lastAttempt == null ||
    now.isBefore(lastAttempt) ||
    now.difference(lastAttempt) >= maxAge;

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
    required this.apiVersion,
    required this.registrationEnabled,
    required this.capabilities,
    required this.uploadLimits,
  });
  final String address;
  final String name;
  final int apiVersion;
  final bool registrationEnabled;
  final ServerCapabilities capabilities;
  final UploadLimits uploadLimits;

  Map<String, Object> toCacheJson() => {
    'address': address,
    'name': name,
    'apiVersion': apiVersion,
    'registrationEnabled': registrationEnabled,
    'capabilities': capabilities.toJson(),
    'uploadLimits': uploadLimits.toJson(),
  };

  static ServerInfo? fromCacheJson(Object? value, String expectedAddress) {
    if (value is! Map ||
        value['address'] != expectedAddress ||
        value['name'] is! String ||
        (value['name'] as String).trim().isEmpty ||
        (value['name'] as String).length > 80 ||
        value['apiVersion'] != 1 ||
        value['registrationEnabled'] is! bool) {
      return null;
    }
    final capabilities = ServerCapabilities.fromJson(value['capabilities']);
    final uploadLimits = UploadLimits.fromJson(value['uploadLimits']);
    if (capabilities == null || uploadLimits == null) return null;
    return ServerInfo(
      address: expectedAddress,
      name: value['name'] as String,
      apiVersion: 1,
      registrationEnabled: value['registrationEnabled'] as bool,
      capabilities: capabilities,
      uploadLimits: uploadLimits,
    );
  }
}

class UploadLimits {
  const UploadLimits({
    required this.avatar,
    required this.chatImage,
    required this.chatVoice,
    required this.chatVideo,
    required this.chatFile,
  });

  final int avatar;
  final int chatImage;
  final int chatVoice;
  final int chatVideo;
  final int chatFile;

  Map<String, int> toJson() => {
    'AVATAR': avatar,
    'CHAT_IMAGE': chatImage,
    'CHAT_VOICE': chatVoice,
    'CHAT_VIDEO': chatVideo,
    'CHAT_FILE': chatFile,
  };

  static UploadLimits? fromJson(Object? value) {
    if (value is! Map) return null;
    int? read(String key) {
      final raw = value[key];
      return raw is int && raw > 0 && raw <= 10 * 1024 * 1024 * 1024
          ? raw
          : null;
    }

    final values = [
      read('AVATAR'),
      read('CHAT_IMAGE'),
      read('CHAT_VOICE'),
      read('CHAT_VIDEO'),
      read('CHAT_FILE'),
    ];
    if (values.any((item) => item == null)) return null;
    return UploadLimits(
      avatar: values[0]!,
      chatImage: values[1]!,
      chatVoice: values[2]!,
      chatVideo: values[3]!,
      chatFile: values[4]!,
    );
  }

  static const defaults = UploadLimits(
    avatar: 5 * 1024 * 1024,
    chatImage: 20 * 1024 * 1024,
    chatVoice: 10 * 1024 * 1024,
    chatVideo: 100 * 1024 * 1024,
    chatFile: 100 * 1024 * 1024,
  );
}

class ServerCapabilities {
  const ServerCapabilities({
    required this.messaging,
    required this.files,
    required this.groups,
    required this.audioCalls,
    required this.videoCalls,
  });

  final bool messaging;
  final bool files;
  final bool groups;
  final bool audioCalls;
  final bool videoCalls;

  bool get canSendFiles => messaging && files;
  bool get canAudioCall => messaging && audioCalls;
  bool get canVideoCall => messaging && videoCalls;

  Map<String, bool> toJson() => {
    'messaging': messaging,
    'files': files,
    'groups': groups,
    'audioCalls': audioCalls,
    'videoCalls': videoCalls,
  };

  static ServerCapabilities? fromJson(Object? value) {
    if (value is! Map) return null;
    const keys = ['messaging', 'files', 'groups', 'audioCalls', 'videoCalls'];
    if (keys.any((key) => value[key] is! bool)) return null;
    return ServerCapabilities(
      messaging: value['messaging'] as bool,
      files: value['files'] as bool,
      groups: value['groups'] as bool,
      audioCalls: value['audioCalls'] as bool,
      videoCalls: value['videoCalls'] as bool,
    );
  }

  static const all = ServerCapabilities(
    messaging: true,
    files: true,
    groups: true,
    audioCalls: true,
    videoCalls: true,
  );

  List<String> get labels => [
    if (messaging) '文字消息',
    if (files) '文件',
    if (groups) '群聊',
    if (audioCalls) '语音通话',
    if (videoCalls) '视频通话',
  ];

  Map<String, bool> get availability => {
    '文字消息': messaging,
    '文件': files,
    '群聊': groups,
    '语音通话': audioCalls,
    '视频通话': videoCalls,
  };
}

class ServerCapabilitiesScope extends InheritedWidget {
  const ServerCapabilitiesScope({
    super.key,
    required this.capabilities,
    this.uploadLimits = UploadLimits.defaults,
    required super.child,
  });

  final ServerCapabilities capabilities;
  final UploadLimits uploadLimits;

  static ServerCapabilities? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ServerCapabilitiesScope>()
      ?.capabilities;

  static UploadLimits uploadLimitsOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<ServerCapabilitiesScope>()
          ?.uploadLimits ??
      UploadLimits.defaults;

  @override
  bool updateShouldNotify(ServerCapabilitiesScope oldWidget) =>
      oldWidget.capabilities != capabilities ||
      oldWidget.uploadLimits != uploadLimits;
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
  final Set<CancelToken> _activeRequests = {};

  Future<ServerInfo> check(String input) async {
    final address = normalizeServerAddress(input);
    final cancel = CancelToken();
    _activeRequests.add(cancel);
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
        )
        .whenComplete(() => _activeRequests.remove(cancel));
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
        data['uploadLimits'] is! Map ||
        data['capabilities'] is! Map) {
      throw const FormatException('不是兼容的聊天服务器，或服务器协议版本不受支持。');
    }
    final capabilities = Map<String, dynamic>.from(data['capabilities'] as Map);
    final uploadLimits = UploadLimits.fromJson(data['uploadLimits']);
    const requiredCapabilities = [
      'messaging',
      'files',
      'groups',
      'audioCalls',
      'videoCalls',
    ];
    if (requiredCapabilities.any((key) => capabilities[key] is! bool) ||
        uploadLimits == null) {
      throw const FormatException('服务器功能信息格式无效。');
    }
    return ServerInfo(
      address: address,
      name: data['name'] as String,
      apiVersion: data['apiVersion'] as int,
      registrationEnabled: data['registrationEnabled'] as bool,
      capabilities: ServerCapabilities(
        messaging: capabilities['messaging'] as bool,
        files: capabilities['files'] as bool,
        groups: capabilities['groups'] as bool,
        audioCalls: capabilities['audioCalls'] as bool,
        videoCalls: capabilities['videoCalls'] as bool,
      ),
      uploadLimits: uploadLimits,
    );
  }

  void dispose() {
    for (final request in _activeRequests) {
      request.cancel('Server probe disposed');
    }
    _activeRequests.clear();
    _dio.close(force: true);
  }
}

class ServerSettingsStore {
  ServerSettingsStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const key = 'chat.selected_server.v1';
  static const _infoKeyPrefix = 'chat.server_info.v1.';
  Future<String?> read() => _storage.read(key: key);
  Future<void> clear() => _storage.delete(key: key);
  Future<void> save(String address) =>
      _storage.write(key: key, value: normalizeServerAddress(address));

  Future<ServerInfo?> readInfo(String address) async {
    final normalized = normalizeServerAddress(address);
    final cacheKey = '$_infoKeyPrefix${serverNamespace(normalized)}';
    try {
      final raw = await _storage.read(key: cacheKey);
      if (raw == null) return null;
      final cached = ServerInfo.fromCacheJson(jsonDecode(raw), normalized);
      if (cached != null) return cached;
    } catch (_) {
      // Corrupt or obsolete metadata is never trusted.
    }
    await _storage.delete(key: cacheKey);
    return null;
  }

  Future<void> saveInfo(ServerInfo info) {
    final normalized = normalizeServerAddress(info.address);
    return _storage.write(
      key: '$_infoKeyPrefix${serverNamespace(normalized)}',
      value: jsonEncode({...info.toCacheJson(), 'address': normalized}),
    );
  }
}
