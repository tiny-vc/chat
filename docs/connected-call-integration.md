# 通话页与 LiveKit 连接联调（2026-09-03）

## 修复范围

CallPage 收到信令时新增 `_ending` 保护：本地挂断或第一条终止信令已开始关闭页面后，不再处理后续 accept/结束信令，避免本地 HTTP 结束回调与 IM 信令重复弹出页面。

首次连接前仅在 Room 不处于 disconnected 时调用 disconnect。当前 LiveKit SDK 2.3.1 对从未连接的 Room 调用 disconnect 会等待没有触发的 EngineDisconnectedEvent，约 10 秒超时，阻止后续令牌请求。Debug 构建仅记录失败阶段和异常类型，不打印令牌或错误正文。

## 设备测试

双端 `messages_flow_test.dart` 增加 `--dart-define=TEST_CONNECTED_CALLS=true`，使用新的同一 run ID，不能与其它可选阶段同时启用。

`connected_call_checks.dart` 执行两轮语音通话：

- 主叫从真实 ChatPage 点“语音通话”，经过 create API 打开实际 CallPage。
- 被叫接收真实 IM 邀请，显示与正式 App 共用的来电弹窗并点“接听”，再打开实际 CallPage，由页面调用 accept/token 并连接 LiveKit。
- 双方等待页面显示“通话中”，该状态在页面完成 Room.connect、麦克风启用后出现；通过 IM 标记确认两端均已到达此状态。
- 双方实际点击静音、取消静音，验证按钮状态；第一轮主叫挂断、第二轮被叫挂断。
- 双方必须退出 CallPage 且仍停留在 ChatPage，历史状态为 ENDED，answeredAt/endedAt 非空。第二轮用于验证结束后再次呼叫。

边界：被叫测试手动衔接共用来电弹窗和 CallPage，并非完整首页信令协调器验收。页面状态、静音操作及服务器历史不等于双方可听；远端音轨订阅、人声内容/音量、回声、蓝牙/听筒、视频、真实弱网和 Android 仍需专门验证。仅在无敏感谈话环境使用专用测试模拟器，不修改 macOS 麦克风权限。

## 试跑记录

后续更严格的双向 RTP 收发验收尚未通过，不能把下述 rtc-04 的 UI/连接通过扩大为双向语音通过。详见 [远端音轨与设备能力验收](remote-audio-integration.md)。

- `20260903-rtc-01` 在双方显示连接失败后中止，未通过。已结束该轮指定测试通话，避免账号残留忙线。
- `20260903-rtc-02` 双端明确报 `CALL_START_FAILED stage=disconnect type=TimeoutException`，未通过；后端没有该阶段的通话令牌请求。结合本地 SDK 源码确认上述首次断连问题，并结束该轮测试通话。
- 测试增加连接失败界面的快速失败断言，并在失败退出时尝试结束本轮创建的具体通话，不操作其它通话。
- `20260903-rtc-03` 双方已成功连接，LiveKit 日志确认两名参与者通过 UDP active，页面显示“通话中”。测试随后误点按钮下方的静态标签，未触发静音，故中止、不计完整通过。实际图标按钮现增加 tooltip，测试据此点击；已结束该轮指定通话。
- `20260903-rtc-04` 两端均通过（A 1:37、B 0:31）：两轮真实 CallPage/LiveKit 连接、双端静音/取消静音、第一轮主叫挂断、第二轮被叫挂断、返回原聊天页及再次呼叫均通过。双方历史均为 ENDED，answeredAt/endedAt 非空。通话 ID 分别为 `6667842d-b7ac-45ea-902e-73dc2e119253`、`f2298ef4-ce77-4920-a672-e8f7c78df5ce`，保留开发记录。
- 本轮收集日志未发现 HTTP 失败、Socket 写入异常或 CALL_START_FAILED；测试会话正常退出。46 项 Flutter 单元/UI 回归及静态检查通过。房间结束后只读查询第一轮参与者列表为空，不作为通话期间音轨订阅证据。
