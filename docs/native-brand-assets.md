# 原生图标与启动画面

日期：2026-09-03。Chat 仍是开发占位名称，当前使用现有 Material forum_rounded 标识，不是最终原创 Logo。

## 范围

- iOS：根据 AppIcon 的 Contents.json 导出全部尺寸；不透明方形图标由系统裁切圆角。启动图为 64pt 圆角标识，提供 1x / 2x / 3x，背景支持明暗模式。
- Android：传统桌面图标五档密度；API 26+ 自适应图标，前景留有安全边距；传统启动窗口与 API 31+ 系统启动屏分别配置，背景跟随明暗模式。
- 品牌色取 Flutter 浅色主题 primary，当前 #525A92；页面深色主题仍使用主题对应的亮色。背景对应 #F7F8FC / #111318。
- 不增加固定展示时长，不改变账号和应用 ID。

## 再生成

在 apps/flutter_chat 目录依次执行：

```sh
flutter test tool/generate_brand_assets.dart
swift tool/opaque_ios_icons.swift
```

第一步从 Flutter 自带 Material 字体渲染现有图形，覆盖对应的生成资源；第二步通过 macOS CoreGraphics 去掉 iOS 图标多余的 alpha 通道。不要对启动图和 Android 前景执行去透明操作。若更换主题色，须同步 Android colors.xml，导出工具会检查品牌色一致性。

正式品牌确定后需同时替换 BrandHeader、原生资源和 AppIdentity，并重新核查名称和标识使用权。当前标识来自 Material 资源，发布时需保留相应许可说明。

## 检查

- 导出工具通过；15 个唯一 iOS 图标完成不透明导出，1024px 图标检查无 alpha 通道。
- 已查看导出图标，图形与当前页面标识一致。
- flutter analyze 无问题；68 项回归测试通过。
- iOS 模拟器 Debug 和 Android Debug APK 均构建成功；两台 iOS 模拟器已安装并启动正常 main.dart 入口。
- 构建仍提示现有插件的后续兼容风险：iOS 的 SPM 支持和 Android 的 Built-in Kotlin 迁移，本轮未升级依赖。
- 原生启动画面出现时间由系统决定，构建成功不等于完成所有系统版本的冷启动视觉验收。

## 冷启动录屏复查

- 使用正常 Debug App（不是测试入口），通过 simctl 重启 App 进程；并非重启设备后的首次启动。
- iPhone 17 Pro 浅色、Pro Max 深色均进入登录页，未登录状态下布局可用。本轮未重新登录，不能据此宣称已验证登录态启动直达首页。
- 深色启动观察到浅色空白帧。排查发现 Main.storyboard 的宿主背景为固定白色，现已改为 LaunchBackground；启动 storyboard 启用 trait collections，并改名 ChatLaunch，Info.plist 与 Xcode 工程引用同步。
- Android NormalTheme 宿主窗口背景也统一为 launch_surface，避免使用系统默认背景。
- 新增原生启动配置回归测试，校验 iOS 两个 storyboard 的动态背景，以及两平台原生背景与 Flutter 明暗主题色的一致性。
- 重录仍出现浅色空白帧，说明配置修正及独立 storyboard 名称尚不足以消除问题。原因未确认，不能归因于缓存，也不能宣称闪屏已修复。未卸载 App、清除数据或重置模拟器。
- 证据：/tmp/chat-start-dark-0903.mp4（修改前）、/tmp/chat-start-dark-fixed-0903.mp4（背景修正后）、/tmp/chat-start-dark-named-0903.mp4（独立启动资源后）。
- 第二台模拟器的外观已恢复原来的浅色模式；两台均保留正常 App。
- 后续应进一步区分系统启动快照、宿主首帧与 Flutter 首帧，并在 iOS 真机 Profile/Release 模式复查；Android 的实际冷启动录屏仍待补。

## 后续定位：旧安装实例与系统快照状态

本节更新上面的“原因未确认”状态，但不将模拟器结论扩大到所有真机。

1. 增加按 `--startup-probe` 启动参数启用的原生诊断，只编译进 Swift Debug；正常启动不输出。补齐 Runner Debug 的 Swift DEBUG 编译条件（原先只有 Objective-C 的 DEBUG 和 RunnerTests 的 Swift DEBUG）。
2. 2026-09-03 15:07:16.246，原 App 的场景外观为 dark（style=2），LaunchBackground 解析为 RGB 17/19/24；原生 splash 是动态颜色。15:07:17.317 收到 Flutter 首帧已显示回调，说明此时原生外观和背景配置正确。
3. 同一构建复制到临时目录，用独立 bundle ID `com.chatapp.flutterChat.startupProbe` 安装到同一模拟器；首次启动及重复启动均没有复现浅色闪帧。这不是另改了一套 UI，也没有读取原 App 的登录数据。
4. 只 shutdown/boot 第二台模拟器，未卸载原 App、清空数据或改动原应用 ID。随后原 App 连续两次启动录屏均未再出现浅色闪帧。
5. 因此证据指向原安装实例关联的系统启动快照/缓存状态，而不是 Flutter 登录页的主题错误；未直接检查或删除系统内部缓存文件，不对具体缓存机制作更强断言。

新增证据位于 /tmp：

- chat-start-isolated-0903.mp4：临时副本首次启动。
- chat-start-isolated-repeat-0903.mp4：临时副本重复启动。
- chat-start-reboot-0903.mp4：重启模拟器后原 App 首次启动。
- chat-start-reboot-repeat-0903.mp4：原 App 再次启动。

诊断副本测试完成后从模拟器移除；原 App 保留。第二台外观恢复浅色，两台使用正常 main.dart 入口且不携带诊断参数。后续遇到原生启动资源更新不及时，优先保留数据重启测试设备并做干净安装对照，不能将卸载重装当作面向真实用户的修复。

当前 iOS Debug 构建、flutter analyze 和 70 项回归测试通过。真机 Profile/Release、Android 冷启动和已登录直达首页的视觉验收仍未覆盖。

参考：本机 FlutterViewController.h 说明原生 splash 保留到 Flutter 首帧；[Flutter 官方启动屏文档](https://docs.flutter.dev/platform-integration/ios/launch-screen)说明原生 storyboard 的配置入口。本次定位结论来自上述本地日志和对照录屏。

## 横屏等待页与会话恢复回归

- 640×240、2 倍字体的启动等待页在明暗主题下均复现底部溢出 64px。现增加滚动容器与边距；没有添加人为等待时长。
- 新增延迟返回已有凭据的测试，逐帧检查等待过程中不出现 LoginPage，最终进入 HomePage。
- flutter analyze 无问题，73 项测试通过。
- auth_entry_flow_test.dart 增加真实登录后的 App 重建与已有会话恢复检查，使用同一个内存 TokenStore。该场景不等于操作系统杀进程后的原生安全存储恢复验收。
- 本轮此真实服务集成测试未执行：提交测试凭据的命令被权限审核拒绝，需用户明确授权后再运行。不能把 73 项本地测试通过当作该集成场景已通过。
- Android 检查时 adb 无连接设备，emulator -list-avds 为空。未自动创建或下载 Android 系统镜像；实际 Android 冷启动和真机安全存储恢复仍待设备就绪后验证。
