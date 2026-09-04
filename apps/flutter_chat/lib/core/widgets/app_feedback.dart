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
  }) {
    String message = fallback;
    if (error is DioException) {
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
    // Do not display raw exceptions, request URLs or internal server details.
    show(context, message, kind: FeedbackKind.error);
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
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
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
          Icon(icon, size: 44, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
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
