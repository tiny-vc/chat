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
| 2 | 图片 | `fileId`, `width`, `height` |
| 3 | 文件 | `fileId`, `name`, `size`, `mimeType` |
| 4 | 语音 | `fileId`, `durationMs` |
| 5 | 视频 | `fileId`, `thumbnailFileId`, `durationMs`, `width`, `height` |
| 6 | 表情 | `packId`, `stickerId` |
| 2001 | 通话信令 | `callId`, `callType`, `action`, `roomName` |
| 9001 | 撤回事件 | `originalClientMsgNo` |
| 9002 | 系统事件 | `event` |

## 文件消息流程

1. Flutter 请求 `POST /files/uploads` 获取预签名上传地址。
2. Flutter 将文件直接上传到 S3/MinIO。
3. Flutter 请求 `POST /files/:fileId/complete`。
4. 服务器确认对象大小和类型后返回 `READY`。
5. Flutter 才能发送带该 `fileId` 的聊天消息。
6. 接收者通过 `GET /files/:fileId/download` 获取短期下载地址。

群文件上传时使用 `scope=GROUP` 和群 ID；单聊文件使用 `scope=DIRECT` 和对方用户 ID。不要把对象存储的永久公网 URL 放进消息。

## Flutter 兼容规则

- 已知类型出现未知字段：忽略未知字段。
- 未知 `type`：保留原始 payload，并显示“当前版本不支持此消息”。
- `version` 高于客户端版本：不要崩溃或删除消息，应走不支持消息的占位 UI。
- 数据库存储原始 payload；解析后的 UI 模型可以重新生成。
- 撤回事件不是删除数据库记录，而是将目标消息展示状态改为 `revoked`。

服务器提供 `GET /api/v1/messages/protocol` 查询类型表，以及需要登录的 `POST /api/v1/messages/protocol/validate` 用于联调校验。
