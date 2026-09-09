# 消息协议 v1

Flutter 通过 WuKongIM SDK 直接发送普通聊天消息。业务服务器只负责用户、权限、文件授权和需要可信校验的业务事件。消息体使用 UTF-8 JSON；调用 WuKongIM HTTP API 时再编码成 Base64，客户端 SDK 按其原生方式传入 JSON 字节。

## 公共字段

每种消息必须包含：

```json
{
  "version": 1,
  "type": 1,
  "clientMsgNo": "7cf951dd-716a-42b8-9d9b-515923ad1248",
  "sentAt": 1788250000000
}
```

- `version`：协议版本，当前固定为 `1`。
- `type`：消息类型编号。
- `clientMsgNo`：发送端生成的 UUID。失败重试必须复用，不能重新生成。
- `sentAt`：发送端 Unix 毫秒时间。最终排序以 WuKongIM 的 `message_seq` 为准，不能依赖它排序。
- `replyTo`：可选，被回复消息的 `clientMsgNo`。

## 类型表

| type | 名称 | 必需业务字段 |
|---:|---|---|
| 1 | 文字 | `text` |
| 2 | 图片 | `fileId`, `size`, `mimeType`, `width`, `height`, `thumbnailFileId`, `thumbnailSize` |
| 3 | 文件 | `fileId`, `name`, `size`, `mimeType` |
| 4 | 语音 | `fileId`, `durationMs` |
| 5 | 视频 | `fileId`, `name`, `size`, `thumbnailFileId`, `durationMs`, `width`, `height` |
| 6 | 表情 | `packId`, `stickerId` |
| 2001 | 通话信令 | `callId`, `callType`, `action`, `roomName` |
| 9001 | 撤回事件 | `originalClientMsgNo` |
| 9002 | 系统事件 | `event` |

## 文件消息流程

内联媒体采用统一移动端格式：静态/动画图片只接受 JPEG、PNG、GIF、WebP；语音为 AAC 的 M4A/MP4；视频由官方 App 在上传前转换为 MP4，Android 明确输出 H.264/AAC，iOS 使用 AVFoundation 的兼容 MP4 导出。服务器再次校验声明 MIME 与真实容器，并拒绝 HEIC、WebM、MKV、AVI、MOV 等未经规范化的聊天媒体。普通文件附件保持原格式，由接收设备的系统应用决定能否打开。

1. Flutter 流式计算文件 SHA-256，并请求 `POST /files/uploads` 获取预签名上传地址。
2. Flutter 携带返回的全部签名头将文件直接上传到 S3/MinIO；对象存储使用原生 SHA-256 checksum 校验实际字节。
3. Flutter 请求 `POST /files/:fileId/complete`。
4. 服务器确认对象大小、类型和对象存储确认的 checksum 后返回 `READY`。
5. Flutter 才能发送带该 `fileId` 的聊天消息。
6. 接收者通过 `GET /files/:fileId/download` 获取短期下载地址，下载完成后 App 再校验大小和 SHA-256 才写入正式缓存。

群文件上传时使用 `scope=GROUP` 和群 ID；单聊文件使用 `scope=DIRECT` 和对方用户 ID。不要把对象存储的永久公网 URL 放进消息。

## Flutter 兼容规则

- 已知类型出现未知字段：忽略未知字段。
- 未知 `type`：保留原始 payload，并显示“当前版本不支持此消息”。
- `version` 高于客户端版本：不要崩溃或删除消息，应走不支持消息的占位 UI。
- 数据库存储原始 payload；解析后的 UI 模型可以重新生成。
- 撤回事件不是删除数据库记录，而是将目标消息展示状态改为 `revoked`。

服务器提供 `GET /api/v1/messages/protocol` 查询类型表，以及需要登录的 `POST /api/v1/messages/protocol/validate` 用于联调校验。
