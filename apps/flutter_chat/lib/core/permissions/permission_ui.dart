import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/app_feedback.dart';
import 'app_permission_service.dart';

const _permissions = AppPermissionService();

Future<bool> ensureAppPermission(
  BuildContext context,
  AppPermission permission, {
  required String title,
  required String rationale,
  AppPermissionService service = _permissions,
}) async {
  var status = await service.check(permission);
  if (status == AppPermissionStatus.granted) return true;
  if (!context.mounted) return false;

  if (status == AppPermissionStatus.denied) {
    final proceed = await AppFeedback.confirm(
      context,
      title: title,
      message: rationale,
      confirmLabel: '继续',
    );
    if (!proceed || !context.mounted) return false;
    status = await service.request(permission);
    if (status == AppPermissionStatus.granted) return true;
    if (!context.mounted) return false;
  }

  if (status == AppPermissionStatus.restricted) {
    AppFeedback.show(
      context,
      '此权限受到系统或家长控制限制，当前无法启用。',
      kind: FeedbackKind.error,
    );
    return false;
  }

  AppFeedback.show(
    context,
    '权限已被关闭，请前往系统设置允许后再试。',
    kind: FeedbackKind.error,
    actionLabel: '前往设置',
    onAction: () => unawaited(service.openSettings()),
  );
  return false;
}

/// Returns the effective call mode, or null when the call must not start.
Future<bool?> prepareCallPermissions(
  BuildContext context, {
  required bool video,
  AppPermissionService service = _permissions,
}) async {
  final microphone = await ensureAppPermission(
    context,
    AppPermission.microphone,
    title: '允许使用麦克风',
    rationale: '语音和视频通话需要麦克风权限。权限只会在通话期间使用。',
    service: service,
  );
  if (!microphone || !context.mounted) return null;

  var effectiveVideo = video;
  if (video) {
    final camera = await ensureAppPermission(
      context,
      AppPermission.camera,
      title: '允许使用摄像头',
      rationale: '视频通话需要摄像头权限。你也可以关闭摄像头，改用语音通话。',
      service: service,
    );
    if (!camera && context.mounted) {
      final audioOnly = await AppFeedback.confirm(
        context,
        title: '改用语音通话？',
        message: '摄像头当前不可用，仍可只使用麦克风继续通话。',
        confirmLabel: '使用语音',
      );
      if (!audioOnly) return null;
      effectiveVideo = false;
    }
  }

  // Notification permission affects Android call visibility, not whether an
  // already-authorised microphone call may start.
  if (Platform.isAndroid && context.mounted) {
    await ensureAppPermission(
      context,
      AppPermission.notifications,
      title: '允许显示通话通知',
      rationale: '进入后台后，通过常驻通知保持通话并让你快速返回。',
      service: service,
    );
    if (context.mounted) {
      await ensureAppPermission(
        context,
        AppPermission.bluetoothConnect,
        title: '允许连接蓝牙设备',
        rationale: '用于在通话中使用蓝牙耳机。拒绝后仍可使用听筒或扬声器。',
        service: service,
      );
    }
  }
  return effectiveVideo;
}
