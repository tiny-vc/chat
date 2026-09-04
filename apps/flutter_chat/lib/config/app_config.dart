import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String get resolvedApiBaseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return apiBaseUrl.replaceFirst('localhost', '10.0.2.2');
    }
    return apiBaseUrl;
  }

  static String resolveDeviceHost(String address) {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return address.replaceFirst('localhost', '10.0.2.2');
    }
    return address;
  }

  static ResolvedUrl resolveSignedUrl(String address) {
    final uri = Uri.parse(address);
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        uri.host == 'localhost') {
      return ResolvedUrl(
        uri.replace(host: '10.0.2.2').toString(),
        headers: {'Host': uri.hasPort ? 'localhost:${uri.port}' : 'localhost'},
      );
    }
    return ResolvedUrl(address);
  }
}

class ResolvedUrl {
  const ResolvedUrl(this.url, {this.headers = const {}});

  final String url;
  final Map<String, String> headers;
}
