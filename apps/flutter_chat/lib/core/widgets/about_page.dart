import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/app_identity.dart';
import 'app_feedback.dart';
import 'brand_header.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.versionLoader});

  final Future<String> Function()? versionLoader;

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
      AppFeedback.show(
        context,
        '反馈模板已复制，请填写后交给项目负责人',
        kind: FeedbackKind.success,
      );
    } catch (_) {
      if (!context.mounted) return;
      AppFeedback.show(context, '复制失败，请稍后重试', kind: FeedbackKind.error);
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
            padding: const EdgeInsets.all(16),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: BrandHeader(compact: true),
              ),
              const SizedBox(height: 24),
              const _SectionTitle('当前版本'),
              Card(
                margin: EdgeInsets.zero,
                child: _AppVersionTile(loader: versionLoader),
              ),
              const SizedBox(height: 24),
              const _SectionTitle('权限用途'),
              const Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _AboutTile(
                      icon: Icons.mic_none,
                      title: '麦克风',
                      subtitle: '录制语音消息，以及语音、视频通话。',
                    ),
                    Divider(height: 1, indent: 56),
                    _AboutTile(
                      icon: Icons.camera_alt_outlined,
                      title: '摄像头',
                      subtitle: '仅用于视频通话。',
                    ),
                    Divider(height: 1, indent: 56),
                    _AboutTile(
                      icon: Icons.folder_open_outlined,
                      title: '图片与文件',
                      subtitle: '通过系统选择器选取要发送的内容或头像。',
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 0),
                child: Text('若之前拒绝权限，可前往系统设置中查看并调整。'),
              ),
              const SizedBox(height: 24),
              const _SectionTitle('帮助与反馈'),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.copy_outlined),
                      title: const Text('复制反馈模板'),
                      subtitle: const Text('不会自动上传日志或聊天内容'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _copyFeedback(context),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('开源许可'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: AppIdentity.name,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionTitle('协议与政策'),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('隐私政策'),
                      subtitle: const Text('了解信息处理、权限和账号管理规则'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: const Text('用户协议'),
                      subtitle: const Text('了解账号使用和内容管理规则'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const UserAgreementPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _AppVersionTile extends StatefulWidget {
  const _AppVersionTile({this.loader});

  final Future<String> Function()? loader;

  @override
  State<_AppVersionTile> createState() => _AppVersionTileState();
}

class _AppVersionTileState extends State<_AppVersionTile> {
  late final Future<String> _version =
      widget.loader?.call() ?? _loadInstalledVersion();

  static Future<String> _loadInstalledVersion() async {
    final info = await PackageInfo.fromPlatform();
    final version = info.version.trim();
    final build = info.buildNumber.trim();
    if (version.isEmpty) return '版本信息不可用';
    return build.isEmpty ? version : '$version ($build)';
  }

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.info_outline),
    title: FutureBuilder<String>(
      future: _version,
      builder: (context, snapshot) => Text(
        snapshot.hasData
            ? '${AppIdentity.name} ${snapshot.data}'
            : snapshot.hasError
            ? AppIdentity.name
            : '${AppIdentity.name} ···',
      ),
    ),
    subtitle: const Text(AppIdentity.tagline),
  );
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => const _LegalDocumentPage(
    title: '隐私政策',
    introduction: '本政策说明你使用${AppIdentity.name}时，服务会处理哪些信息、为何处理，以及你可以如何管理这些信息。',
    sections: [
      _LegalSection(
        '处理的信息',
        '为创建和保护账号，服务会处理用户名、昵称、头像、登录设备和会话信息。使用聊天功能时，会处理联系人、群组、消息、文件及必要的发送状态；使用音视频通话时，会处理通话参与者、时间、状态及建立实时连接所需的网络信息。',
      ),
      _LegalSection(
        '权限使用',
        '麦克风仅用于语音消息和音视频通话；摄像头仅用于视频通话；照片与文件仅在你主动选择内容或头像时访问。你可以在系统设置中撤回权限，但相关功能可能无法继续使用。',
      ),
      _LegalSection(
        '存储与传输',
        '账号、消息和文件由你连接的业务服务器处理。生产环境通过 HTTPS/WSS 等加密传输；这不代表消息具备端到端加密。应用会在设备上保存登录凭据、消息缓存、草稿和待同步状态，以维持登录并支持可靠恢复。',
      ),
      _LegalSection(
        '本地诊断',
        '应用可能在设备内保存经过敏感字段遮盖的异常日志，用于定位故障。日志容量受限，不包含主动上传机制；除非你明确选择提供，否则不会自动发送。',
      ),
      _LegalSection(
        '信息管理',
        '你可以修改头像和昵称、管理登录设备、清理本地缓存或注销账号。注销是不可恢复的操作；服务端数据的删除和必要留存按照适用法律及服务提供方公布的规则执行。',
      ),
    ],
  );
}

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) => const _LegalDocumentPage(
    title: '用户协议',
    introduction: '使用${AppIdentity.name}即表示你应遵守本协议以及服务提供方依法公布的相关规则。',
    sections: [
      _LegalSection(
        '账号与安全',
        '请提供真实、有效且合法的信息，并妥善保管账号凭据。发现异常登录时，应及时修改密码并下线未知设备。不得转让账号或利用账号从事违法活动。',
      ),
      _LegalSection(
        '内容与行为',
        '你应对发送的文字、图片、音视频和文件负责，不得发送违法侵权、欺诈、骚扰、恶意程序或其他危害网络安全的内容。群主和管理员应合理管理群组。',
      ),
      _LegalSection(
        '服务变更',
        '服务可能因维护、安全风险、不可抗力或网络条件暂时中断。服务提供方可在合理范围内调整功能，并应通过适当方式告知对用户权益有重大影响的变更。',
      ),
      _LegalSection(
        '账号处置',
        '违反法律法规或本协议时，服务提供方可依法采取限制功能、暂停或终止账号等措施。你也可以在“安全与隐私”中申请注销账号。',
      ),
      _LegalSection(
        '责任边界',
        '服务提供方将采取合理措施保障服务安全和连续性，但不对超出合理控制范围的网络、设备或第三方基础设施故障作无条件保证。法律另有规定的，从其规定。',
      ),
    ],
  );
}

class _LegalDocumentPage extends StatelessWidget {
  const _LegalDocumentPage({
    required this.title,
    required this.introduction,
    required this.sections,
  });

  final String title;
  final String introduction;
  final List<_LegalSection> sections;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Text(introduction, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              for (final section in sections) ...[
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(section.content),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _LegalSection {
  const _LegalSection(this.title, this.content);
  final String title;
  final String content;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
  );
}
