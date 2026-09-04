# 第一阶段本机联调（2026-09-03）

用户明确允许本地测试，不连接外部部署。使用 localhost:3000、本机 WuKongIM/LiveKit/对象存储及两台 iOS 模拟器。全部新建隔离账号，未修改既有账号/群；测试标记和测试图片保留供核对。

## 本轮隔离数据

- fixture run：260903v2；账号 av_260903v2_a / b / c。
- 头像测试群：ee74e146-6307-4ea2-8b0b-05fed2d5468f。
- UI 审批申请：28a0daed-cdaf-4168-908a-02ea59e341c8（由 c 申请，A 模拟器实际点击审批）。
- 不在文档中记录访问令牌；每个脚本和测试结束尝试撤销自己创建的会话。

## 已通过的本机接口检查

`AVATAR_RUN=260903v2 SMOKE_API_URL=http://localhost:3000/api/v1 node scripts/smoke-avatar.mjs` 通过：好友互相下载头像字节一致、陌生人拒绝、双方拉黑限制、替换后的旧头像拒绝、群成员可读/非成员拒绝。

`AVATAR_RUN=260903v2 SMOKE_API_URL=http://localhost:3000/api/v1 node scripts/smoke-local-join-inbox.mjs` 通过：

- 管理员待办列表与计数一致，包含群名称和申请人；申请人无法自批，管理员审批成功。
- 入群后可获取群头像下载授权，退群后拒绝。
- 邀请出现在接收人的待办中，发送邀请的管理员不能代替接收人决定；接收人拒绝成功。
- 个人记录使用实际创建时间/ID 游标获取下一段与空末页；缺少配对游标参数返回 400。本轮真实记录数少于 100，超过 100 条的交互仍由替身测试覆盖。
- 归档状态可由新登录会话读回，恢复只改 archived，保留 pinned/muted。
- 此脚本拒绝非回环 API 地址，并拒绝 HTTP 重定向。只使用 smoke-avatar 新建的隔离数据；脚本有状态，不应在旧 run 上盲目重复。

## 模拟器验收范围

`avatar_flow_test.dart` 新增可选 TEST_JOIN_INBOX / TEST_FIXTURE_RUN：使用真实 GroupJoinPage 点击并确认审批，等待空列表和总数归零；实际 AppAvatar 在通讯录、好友资料、群资料解码为 64×64。测试不是登录页到首页的全流程，也不覆盖原生选图器。

`messages_flow_test.dart` 新增 TEST_JOIN_APPROVAL（与 TEST_OFFLINE_GROUP 配合）：创建空测试群，由接收人调用真实接口接受邀请后再发送群消息，验证 WuKongIM 订阅实际生效。新增 TEST_ARCHIVE_UI：真实 ConversationsView 长按归档、进入归档列表、恢复，并核对服务端历史条数不变。归档期间新消息/跨设备即时刷新不包含在该断言内。

本轮不申请麦克风/相机权限，不做语音/视频质量判断；既有双向 RTP、真机视频、Android 和弱网缺口不因本轮通过而关闭。

## 真实执行结果

- iPhone 17 Pro：avatar_flow_test + TEST_JOIN_INBOX=true 通过（36 秒）。实际点击 c 的申请并确认同意，收到空待办列表、计数为 0；通讯录、好友资料、群资料的真实头像解码通过。
- iPhone 17 Pro Max：avatar_flow_test 通过（35 秒），验证另一账号的好友/群头像及群资料页解码。
- 双端消息轮次 260903-inbox-01：A 通过（1 分 42 秒，含等待 B 构建），B 通过（11 秒）。参数 TEST_OFFLINE_GROUP=true、TEST_JOIN_APPROVAL=true、TEST_ARCHIVE_UI=true。
- B 输出 JOIN_INVITATION_ACCEPTED_BEFORE_GROUP_MESSAGES；A/B 均输出 ARCHIVE_UI_RESTORE_PRESERVED_HISTORY。两端整体测试通过，历史同步失败列表为空。
- 此轮包括：真实文本双向收发、1 次令牌刷新后 IM 重连、重新进入聊天页读历史、3 条离线私聊及 3 条离线群消息补回、群内回复/确认及服务端历史唯一性、两端真实会话归档/恢复且历史条数不变。HTTP 在 IM 断开期间保持可达，不代表系统网络故障测试。
- 入群审批 UI 使用账号 c 的申请；消息验收是 B 通过真实接口接受另一测试群邀请后收发。两条路径都通过，但不宣称同一条入群申请完成了所有 UI→消息步骤。
- 本轮保留三个专用账号、两个测试群及标记消息/色块文件。不删除既有数据；API/设备测试会话均正常结束并退出登录。
- 联调后 flutter analyze 与 105 项 Flutter 回归测试通过。重新构建正常 lib/main.dart（不传测试账号参数），两台模拟器均已恢复安装正常 App；没有把测试入口留作正常应用。

## 仍未验收

- HEIC/大图及其他原生文件选择器、头像通知失败/离线恢复；群头像原生 PNG 选图到上传及在线变更通知在下文后续复测中通过。
- 超过 100 条真实入群记录的翻页、权限在页面打开后变化的双端 UI、并发审批竞争。
- 归档期间新消息、同一账号两设备的归档实时同步（当前只有服务端持久化＋主动刷新）。
- LiveKit 双向 RTP、真机声音质量/视频、Android 实机、系统断网/弱网、生产部署安全及正式品牌/隐私内容。

## 原生选图链路：准备与环境阻断

新增 native_group_avatar_test.dart，使用指定的 av_ 隔离账号及群 ID，只允许回环 API。设计覆盖系统相册取消不改变旧头像、重新选择后真实上传/绑定并解码、UI 移除恢复默认头像，以及另一测试账号读取新头像。相册点击需要人工操作，不使用注入的 PlatformFile 替代原生选择器。

此次尝试尚未执行到业务测试：第一台模拟器的 simctl addmedia 与测试 App 安装卡住；仅停止本轮相关进程并重启该模拟器（未擦除数据），再次导入仍未完成。已停止导入/自动启动照片进程，请用户手动检查“照片”是否能完成首次初始化。未观察到头像上传失败，不将模拟器环境问题判断为业务缺陷，也未标记原生选图验收通过。

测试已修正为通过可见按钮的启用状态判断取消/完成，避免把未构建的屏幕外进度文本误判成操作已结束。静态检查通过；原生执行及另一账号验证需待相册可用后继续。

已重新构建不含测试参数的正常 iOS App，但恢复安装也未完成，已停止本轮安装进程。不能声称本次已恢复安装；待模拟器服务恢复后先安装正常 App，再继续原生选图验收。

## 原生选图后续：复现并修复取消/重开竞态

用户手动打开“照片”后，simctl addmedia 恢复，测试安装也恢复。并不能据此确定系统卡住的底层原因；未擦除相册/模拟器数据。

未修复的第一次原生选图测试：取消后按钮恢复，立即重开却没有弹窗，页面停留忙碌状态；最终等待上传超时。UIKit 日志明确报告试图在已经离开 window hierarchy 的 PHPicker 上呈现另一个 PHPicker。根因是 file_picker_darwin 1.0.4 在 dismiss 动画完成前就返回 Flutter 取消结果。

将该适配包和 MIT 许可纳入 packages/file_picker_darwin，通过 App 的 dependency_overrides 使用项目内补丁，不改全局 pub 缓存：取消等待 UIKit dismiss completion；选中图片等待关闭和文件加载均完成；交互关闭在 didDismiss 而非 willDismiss 返回；防止重复媒体完成回调。未使用固定延时掩盖竞态。补丁说明见该包 LOCAL_PATCH.md。

修复后的一次试跑，用户第一次打开即选图，实际产生新头像文件，但不满足“先取消、旧头像不变”的测试步骤，因此未计完整通过。分开提示后重跑，iPhone 17 Pro 完整通过（1 分 5 秒）：取消不改头像 → 立即重开相册实际呈现（有截图确认）→ 原生选择 Chat 图标 → 上传/绑定 → 1024×1024 实际解码 → UI 移除并恢复默认 → API 重新绑定新头像供另一账号验证。原生选择由用户点击，其余步骤自动验证。

测试日志为 NATIVE_AVATAR_UPLOADED_AND_DECODED_1024、NATIVE_AVATAR_REMOVE_AND_REBIND_VERIFIED、All tests passed。测试完成会撤销测试会话并退出 App；用户观察到本次选图后 App 退出是测试生命周期，不是本次测试中的崩溃。正常入口不会执行这段测试退出逻辑。

适配包原有 7 项 Flutter 通道测试通过。此结果覆盖选定 PNG，不扩展为 HEIC、大图压缩、全部原生文件选择器或 Android 的验收。

第二台 iPhone 17 Pro Max 的只读测试随后通过（4 秒），输出 NATIVE_AVATAR_PEER_DECODED_1024；另一个账号实际读取新群头像并解码为 1024×1024。之后加强未来测试的等待条件：同时确认 AppAvatar 的 fileId 已切换到新上传 ID，避免相同尺寸的旧图造成假阳性。此次第一台原生成功记录是在该额外断言加入前完成，第二台独立读取已验证新图可用。

最终回归：flutter analyze 无问题，105 项 App 测试通过；正常 lib/main.dart 的 iOS 模拟器及 Android Debug 构建成功。已将不带测试参数的正常 App 安装并启动到两台模拟器，替换会在完成后自动退出的集成测试入口。Android 构建仍提示部分插件的 Kotlin Gradle Plugin 未来兼容性警告；构建通过不代表 Android 实机验收通过。

## 群头像在线通知：真实 WuKongIM 联调

新增 integration_test/group_avatar_notice_test.dart，限制回环地址、av_ 隔离测试账号及显式群 ID。本轮复用 av_260903v2_a / b 与群 ee74e146-6307-4ea2-8b0b-05fed2d5468f；不使用新用户照片，不删除存储文件。账号 a 通过 API 修改头像，账号 b 在 iPhone 17 Pro Max 上通过真实 Flutter WuKongIM SDK 在线接收通知。不是两台设备同时操作的用例。

群资料页通过正常 HomePage 路由打开，使用产品代码中的通知订阅，测试没有直接调用刷新方法。管理员移除头像后，页面自动显示默认头像；重新绑定原头像后，页面自动显示原文件 ID 并实际解码。输出 AVATAR_NOTICE_PEER_REMOVAL_PASSED、AVATAR_NOTICE_PEER_RESTORE_DECODED_PASSED，10 秒内 All tests passed。WuKongIM 日志确认两条 9002 / group.avatar_changed 消息通过真实 TCP 连接到达。测试最终恢复原头像并退出两账号测试会话；保留两个群通知作为测试记录。

后端 14 套件 / 69 项测试、lint/build、Flutter 108 项回归测试通过。/api/v1/ready 返回 ok，PostgreSQL、WuKongIM、LiveKit、对象存储均就绪。本地 API 已更新为 chat-api:avatar-notices-local（docker-compose.yml + docker-compose.avatar-notices.yml），不修改数据卷。IM 通知失败不回滚已保存的头像，未实现可靠重试队列；离线批量补回、弱网及 Android 实机通知仍未验收。

最终 flutter analyze 无问题；正常 lib/main.dart 的 iOS 模拟器和 Android Debug 构建成功。两台 iOS 模拟器均已重新安装并打开不带测试参数的正常 App。既有 SPM / Built-in Kotlin 插件迁移提示及后端 3 项 high 依赖告警未在本轮解决。

## 通话恢复第一批：残留业务状态收敛

已实现的范围及限制见 call-network-recovery.md。部署本地 chat-api:call-recovery-local，使用 docker-compose.yml + docker-compose.call-recovery.yml；保留全部数据卷，/api/v1/ready 的四项依赖均为 ok。

真实执行 scripts/smoke-call-recovery.mjs，复用 av_260903v2_a / b / c 隔离账号，仅回环 API。主测试通话 f190716a-daf2-4de3-992f-f7f8399cfaa5：重复 accept 成功、第三人 end 被拒绝、接听后 30 秒仍是 ACCEPTED、持续未加入 LiveKit 房间超过服务端宽限期后成为 ENDED / MEDIA_DISCONNECTED、结束后 token 返回 403、再次发起通话不再被旧忙线阻止、接听前发起人挂断及重复挂断成功。输出 ok:true，脚本退出码 0；测试创建的两条通话记录保留，测试账号退出登录，没有操作既有其他通话。

此测试刻意不进入媒体房间；真实调用了 LiveKit 管理 API 与通话维护任务，但不能替代已建立音视频后的断网、双向 RTP、丢包、弱网、Wi-Fi/蜂窝切换或真实听感验收。90 秒宽限从首次成功观察到缺席开始，且内存计时在 API 重启后重新计算。

后端 15 套件 / 76 项测试、lint/build 通过；Flutter analyze 无问题，最终完整 113 项回归测试通过。正常 lib/main.dart 的 iOS 模拟器、Android Debug 构建成功，两台模拟器均已更新安装正常 App（本轮没有安装集成测试入口）。既有后端 3 项 high 告警及插件 SPM / Built-in Kotlin 迁移告警仍在。

## 登录页服务器设置与公开探测

实现与安全边界详见 server-settings.md。本地 API 已更新到 chat-api:server-settings-local（docker-compose.yml + docker-compose.server-settings.yml），数据卷保留；无 Authorization 的 GET /api/v1/server-info 成功返回产品标识、协议版本、名称、注册状态和真实文件大小上限，不含内部依赖和密钥。后端 16 套件 / 77 项测试、lint/build、OpenAPI 生成通过（79 条路径）。

首次原生测试在检测阶段失败，未记通过：Dio get<Object> 自动把 ResponseType.plain 改为 JSON，探测器收到对象而非预期的有大小限制文本。改为 get<String>，增加经过真实 Dio 转换器的无网络测试后复测。

iPhone 17 Pro Max 的 integration_test/server_settings_test.dart 通过，输出 SERVER_SETTINGS_REAL_DETECT_SAVE_SWITCH_RESTORE_PASSED，5 秒内 All tests passed。实际从登录页打开设置，检测 http://127.0.0.1:3000/api/v1，确认保存并切换到规范化地址，再销毁/重建完整 App 验证原生安全存储读回。使用空登录会话，不发送用户凭据；测试结束还原原服务器设置。localhost 与 127.0.0.1 指向同一本地 API，不是两套独立部署。

Token/草稿的命名空间隔离、SDK 数据库身份及迁移命名、缓存键、路径标识安全校验由代码及无网络测试覆盖；尚未做两台独立服务端相同 UID 的实际消息/文件交叉验收。遵循未上线不做旧版兼容的要求，旧未隔离缓存和凭据不迁移、不删除，需重新登录。

最终 flutter analyze 无问题，完整 122 项 Flutter 测试通过，覆盖真实 Dio 转换、失败不切换、明暗主题及 320px/两倍字体。正常 iOS 模拟器、Android Debug 构建成功，两台 iOS 模拟器均已恢复安装并打开正常入口；不保留自动退出的测试 App。/api/v1/ready 的四项依赖为 ok。既有后端 3 项 high 依赖告警与插件 SPM / Built-in Kotlin 迁移提示仍未在本轮处理。
