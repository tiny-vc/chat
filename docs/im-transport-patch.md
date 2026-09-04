# IM Socket 并发写入修复（2026-09-03）

## 复现与根因

媒体联调曾记录 `Bad state: StreamSink is bound to a stream`，随后同一图片再次投递。SDK 1.7.9 的 `_WKSocket.send` 直接调用 `Socket.add` 并返回 `flush`，多个发送/心跳/接收回执并发调用时，没有等待前一次 flush 完成就再次 add。

独立回环复现脚本 `scripts/repro-im-socket.dart` 不调用 API 或真实账号。在本机 Dart 运行时，原模式 100 次写入中收到 1 个字节，出现 99 次写入错误。脚本保留原错误模式用于对照，不是生产发送实现。

## 修复范围

使用项目内 `packages/wukongimfluttersdk`，基于原 1.7.9 的 lib、assets 和 metadata，保留 Apache-2.0 LICENSE、README、CHANGELOG；未修改 pub cache，未升级协议或其它依赖。

- 每个 Socket 的 add/flush 串行执行，入队时复制数据。
- 关闭/失败后不继续向旧连接写入排队数据；重连新建独立写入器，不把旧加密帧带到新连接。
- 同一连接首次写入失败后关闭旧 Socket、报告连接失败，安排有状态保护的重连；旧连接失败不会关闭新连接，显式退出后不由该回调重连。
- 保留既有消息发送确认、重试和数据库逻辑。补丁不是全局“恰好一次”投递保证，也未解决 SDK 所有其它连接生命周期边界。

SDK 源码仅新增 `lib/common/serialized_socket_writer.dart` 和修改 `lib/manager/connect_manager.dart`，详见包内 `PATCHES.md`。升级时对照上游修复并通过回归后再移除此本地依赖。

## 自动化验证

`apps/flutter_chat/test/socket_writer_test.dart` 覆盖串行写入、缓冲复制、flush 失败、关闭时排队取消、新旧连接隔离及真实回环 1000 个并发包。全部通过；完整 Flutter 38 项测试通过，静态检查通过。

双端测试使用 `messages_flow_test.dart`，在两个终端原消息测试命令增加 `--dart-define=TEST_TRANSPORT_BURST=true`，两端使用同一新 run ID。每端并发发送 40 条消息，收到对方 40 条后继续观察 70 秒，断言每条只收到一次并保持连接。此测试包含原先的令牌刷新重连流程，不会打开原生文件预览。

该观察窗口不能替代长时间压测、真实断网/丢包、Android 或大文件/音视频验收。

## 双端测试过程与未关闭问题

后续状态：下面是本轮当时的发现。刷新竞态与历史 400 已在应用层追加修复，详见 [刷新与历史同步修复](im-refresh-history-fix.md)，原始失败记录保留以便追溯。

- `20260903-transport-04` 两台 iOS 26.5 模拟器均通过（A 1:59，B 1:15）：基础文字/刷新重连/历史检查及双端各 40 条并发消息完成，双方在收到全部消息后观察 70 秒，每条回调恰好一次、连接保持正常。本轮收集的输出未出现 StreamSink bound 或 Socket write failed。保留带 run ID 的开发测试消息；该成功样本不消除下列偶发失败。
- `20260903-transport-01` 被中止：B 提前进入连发阶段，把 A 仍在检查的基础消息挤出列表可见区域。测试现增加双端阶段握手，双方完成基础检查后才开始连发。
- `20260903-transport-02`、`03` 在刷新相关检查失败后中止，不计为通过。后端刷新请求记录为 201；当时断言缺少阶段说明，且测试过程中格式化导致源文件行号变化，不能只凭行号认定是 HTTP 失败。现为刷新成功、令牌轮换及 SDK 凭据匹配分别补充失败原因。
- 刷新期间观察到 SDK 收到 DisconnectPacket。上游处理会清除 SDK uid/token，而应用更新凭据要求 uid 匹配；这存在待验证的时序风险，本 Socket 写入补丁不解决该认证生命周期问题。
- `04` 的测试诊断还记录 `/api/v1/im/messages/sync` 返回 400，尚未确定对应历史请求的参数与原因。不能用并发消息测试替代历史同步接口验收。
- 临时认证诊断已移除；集成测试保留只输出路径、错误类型及状态码的 HTTP 诊断，不打印令牌、请求头或响应正文。
