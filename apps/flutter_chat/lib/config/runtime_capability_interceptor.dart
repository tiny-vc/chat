import 'dart:async';

import 'package:dio/dio.dart';

String? disabledCapabilityFrom(Object? data) {
  if (data is! Map || data['code'] != 'CAPABILITY_DISABLED') return null;
  final details = data['details'];
  if (details is! Map || details['capability'] is! String) return null;
  return details['capability'] as String;
}

class RuntimeCapabilityInterceptor extends Interceptor {
  RuntimeCapabilityInterceptor({required this.onCapabilitiesChanged});

  final Future<void> Function() onCapabilitiesChanged;
  Future<void>? _refreshing;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (disabledCapabilityFrom(err.response?.data) != null) {
      _refreshing ??= onCapabilitiesChanged().whenComplete(() {
        _refreshing = null;
      });
      unawaited(_refreshing);
    }
    handler.next(err);
  }
}
