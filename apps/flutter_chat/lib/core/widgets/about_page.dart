import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_identity.dart';
import 'brand_header.dart';

/// Product help, not a substitute for reviewed release privacy terms.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static String get feedbackTemplate =>
      '''应用：${AppIdentity.name}
平台：${kIsWeb ? 'web' : defaultTargetPlatform.name}
问题描述：
发生时间：
复现步骤：
预期结果：
实际结果：

请勿附上密码、验证码、访问令牌或私人聊天内容。''';

  Future<void> _copyFeedback(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: feedbackTemplate));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('反馈模板已复制，请填写后交给项目负责人')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('复制失败，请稍后重试')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('关于与使用说明')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const BrandHeader(),
              const SizedBox(height: 24),
              const Text('开发版本', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Chat 为临时名称，视觉标识尚未定稿。当前用于开发与测试，不代表正式发布版本。'),
              const SizedBox(height: 24),
              Text('权限用途', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              const Text(
                '麦克风：录制语音消息，以及语音、视频通话。\n\n摄像头：视频通话。\n\n文件选择：通过系统选择器选取要发送的图片、文件或头像。',
              ),
              const SizedBox(height: 12),
              const Text('若之前拒绝了麦克风或摄像头权限，可在系统设置中查看并调整。'),
              const SizedBox(height: 24),
              Text('测试与反馈', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text(
                '暂未配置客服或在线反馈渠道。你可以复制模板，填写问题后交给项目负责人。复制操作不会自动上传日志或发送反馈。',
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _copyFeedback(context),
                icon: const Icon(Icons.copy_outlined),
                label: const Text('复制反馈模板'),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.description_outlined),
                title: const Text('开源许可'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: AppIdentity.name,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '发布前须知',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                '正式隐私政策和用户协议尚未提供；本页仅为开发使用说明，不替代正式条款。发布前需明确运营主体、数据处理规则和联系方式。测试时请勿发送敏感资料。',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
