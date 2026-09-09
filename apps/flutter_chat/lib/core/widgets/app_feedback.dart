import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum FeedbackKind { success, error, info }

/// Keeps form controllers alive until the dialog's exit animation is complete.
Future<T?> showAppFormDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<T>(context: context, builder: builder);
  final result = await navigator.push(route);
  await route.completed;
  return result;
}

class AppFeedback {
  static void show(
    BuildContext context,
    String message, {
    FeedbackKind kind = FeedbackKind.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colors = Theme.of(context).colorScheme;
    final icon = switch (kind) {
      FeedbackKind.success => Icons.check_circle_outline,
      FeedbackKind.error => Icons.error_outline,
      FeedbackKind.info => Icons.info_outline,
    };
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: kind == FeedbackKind.error
            ? colors.errorContainer
            : colors.inverseSurface,
        content: Row(
          children: [
            Icon(
              icon,
              color: kind == FeedbackKind.error
                  ? colors.onErrorContainer
                  : colors.onInverseSurface,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: kind == FeedbackKind.error
                      ? colors.onErrorContainer
                      : colors.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
        showCloseIcon: true,
        action: actionLabel == null || onAction == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: kind == FeedbackKind.error
                    ? colors.onErrorContainer
                    : colors.inversePrimary,
                onPressed: onAction,
              ),
        closeIconColor: kind == FeedbackKind.error
            ? colors.onErrorContainer
            : colors.onInverseSurface,
      ),
    );
  }

  static void error(
    BuildContext context,
    Object error, {
    String fallback = '操作失败，请稍后重试',
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final message = messageForError(error, fallback: fallback);
    // Do not display raw exceptions, request URLs or internal server details.
    show(
      context,
      message,
      kind: FeedbackKind.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static String messageForError(
    Object error, {
    String fallback = '操作失败，请稍后重试',
  }) {
    String message = fallback;
    if (error is DioException) {
      final capability = _disabledCapability(error.response?.data);
      if (capability != null) {
        return switch (capability) {
          'registration' => '服务器暂时关闭了用户注册',
          'messaging' => '服务器暂时停止了消息发送',
          'files' => '服务器暂时停止了图片和文件发送',
          'groups' => '服务器暂时关闭了群组操作',
          'audioCalls' => '服务器暂时关闭了语音通话',
          'videoCalls' => '服务器暂时关闭了视频通话',
          _ => '服务器暂时关闭了此功能',
        };
      }
      message = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => '请求超时，请检查网络后重试',
        DioExceptionType.connectionError => '网络连接失败，请检查网络设置',
        _ => switch (error.response?.statusCode) {
          401 => '登录状态已失效，请重新登录',
          403 => '暂无权限执行此操作',
          429 => '操作过于频繁，请稍后重试',
          _ => fallback,
        },
      };
    }
    return message;
  }

  static String? _disabledCapability(Object? data) {
    if (data is! Map || data['code'] != 'CAPABILITY_DISABLED') return null;
    final details = data['details'];
    return details is Map && details['capability'] is String
        ? details['capability'] as String
        : null;
  }

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            destructive ? Icons.warning_amber_rounded : Icons.help_outline,
            color: destructive ? Theme.of(context).colorScheme.error : null,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    )
                  : null,
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;
}

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message = '正在加载…'});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      label: message,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LoadingMark(),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _LoadingMark extends StatelessWidget {
  const _LoadingMark();

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 48,
    child: Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox.square(
          dimension: 44,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        Icon(
          Icons.forum_rounded,
          size: 19,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}

class AppStatus extends StatelessWidget {
  const AppStatus({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
  });
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusIllustration(icon: icon),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _StatusIllustration extends StatelessWidget {
  const _StatusIllustration({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: '状态提示',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 5,
                right: 4,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: colors.tertiaryContainer,
                ),
              ),
              Positioned(
                left: 3,
                bottom: 5,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: colors.secondaryContainer,
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: .18),
                  ),
                ),
                child: Icon(icon, size: 28, color: colors.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
