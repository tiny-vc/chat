# Chat Server

Backend foundation for a Flutter chat application. WuKongIM owns message delivery,
ordering and synchronization; LiveKit owns real-time media; this service owns users,
relationships, groups, files, call authorization and product policy.

第一阶段服务端范围和验收基线见 [Server MVP baseline](docs/server-mvp-baseline.md)。

## Current scope

- Health endpoint
- Username/password registration and login
- Business JWT issuance
- WuKongIM user credential provisioning
- User profiles and search
- Friend requests, acceptance, rejection, listing and removal
- Group creation, membership, roles and WuKongIM subscriber synchronization
- S3-compatible presigned file upload, verification and authorized download
- One-to-one call invitation, accept, reject, cancel, end and LiveKit token issuance
- Versioned message protocol for text, media, files, stickers, calls and system events
- Per-user conversation pin, mute and archive settings
- User blocking synchronized to the WuKongIM personal-channel blacklist
- Rotating refresh tokens and revocable multi-device sessions
- Database-backed login throttling, security audit logs and password changes
- Distributed-lock background cleanup with persisted run history
- Request IDs, JSON access logs, unified errors and dependency readiness checks
- Secure avatar/thumbnail binding, file deletion rules and per-user storage quota
- Group administrators, ownership transfer, timed member mute and group avatars
- Group applications and invitations with approval, cancellation and expiration states
- Local PostgreSQL, WuKongIM, LiveKit and MinIO development stack

Offline OS push remains intentionally deferred.

## Requirements

- Node.js 24+
- Docker with Compose

## 使用 Docker 启动完整服务

Compose 会先等待 PostgreSQL 健康、执行 `prisma migrate deploy`，迁移成功后才启动 API：

```bash
docker compose up -d --build --wait
docker compose ps
```

API 地址为 `http://localhost:3000/api/v1`。停止容器但保留数据库和文件：

```bash
docker compose down
```

`docker compose down -v` 会删除数据库、WuKongIM 和 MinIO 数据，不要在需要保留数据时执行。

## PostgreSQL 备份

创建经过归档读取验证并附带 SHA-256 校验和的备份：

```bash
npm run backup:postgres
```

备份默认写入 `backups/postgres`，不会自动删除旧文件。可通过 `BACKUP_DIR=/安全的外部目录` 改变位置。再次验证指定备份：

```bash
npm run backup:verify -- backups/postgres/chat-postgres-时间.dump
```

备份必须复制到另一台机器或对象存储；只保存在同一台服务器不能防止磁盘或主机故障。本阶段不提供自动恢复命令，因为恢复会覆盖现有数据，应在维护窗口内明确选择目标数据库并人工执行。

## MinIO 文件备份

以只读对象镜像方式备份 `chat-files` bucket，并为每个文件生成 SHA-256 清单：

```bash
npm run backup:minio
npm run backup:minio:verify -- backups/minio/chat-minio-时间
```

默认输出到 `backups/minio`，可通过 `BACKUP_DIR` 指向外部磁盘。备份不会使用 `--remove`，因此不会删除 MinIO 源对象；也不会自动清理旧备份。当前 bucket 未启用对象版本控制，所以该备份保存当前对象内容，不包含历史版本。

## WuKongIM 备份

WuKongIM 数据必须持久化到容器内的 `/home/wukongimdata`；Compose 已将 `wukongim_data` 命名卷挂载到该实际数据目录。创建并验证一致性备份：

```bash
npm run backup:wukongim
npm run backup:wukongim:verify -- backups/wukongim/chat-wukongim-时间.tar.gz
```

当前 WuKongIM 版本没有可依赖的在线一致性快照，因此备份脚本会短暂停止 WuKongIM，归档只读命名卷后立即启动并等待健康检查通过。期间实时消息连接会短暂中断，API 的 readiness 也可能暂时失败，应在低峰期执行。脚本即使归档失败也会尝试恢复服务；备份默认写入 `backups/wukongim`，支持 `BACKUP_DIR`，不会删除源数据或旧备份。生成的 `.sha256` 和 `.info` 文件必须与归档一起异机保存。

Compose 为每个容器启用了 JSON 日志轮转（单文件 10 MB，最多 3 个），API 在停止时有 30 秒优雅退出时间。开发环境允许所有 CORS Origin；不要把该设置复制到公网环境。

## 本机开发 API

如需使用 NestJS watch 模式，只启动依赖服务，避免与容器 API 争用 3000 端口：

```bash
cp .env.example .env
docker compose up -d postgres wukongim livekit minio
npm install
npm run prisma:generate
npm run prisma:deploy
npm run start:dev
```

The API is available at `http://localhost:3000/api/v1`.

## Useful endpoints

```text
GET  /api/v1/health
GET  /api/v1/ready
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
GET  /api/v1/auth/devices
DELETE /api/v1/auth/devices/:sessionId
POST /api/v1/auth/logout
POST /api/v1/auth/logout-all
POST /api/v1/auth/change-password
GET  /api/v1/users/search?q=alice
POST /api/v1/friends/requests
POST /api/v1/friends/requests/:requestId/accept
GET  /api/v1/friends
POST /api/v1/groups
POST /api/v1/groups/:groupId/members
PATCH /api/v1/groups/:groupId/members/:memberId/role
PATCH /api/v1/groups/:groupId/members/:memberId/mute
POST /api/v1/groups/:groupId/transfer-owner
PUT /api/v1/groups/:groupId/avatar
DELETE /api/v1/groups/:groupId/avatar
POST /api/v1/groups/:groupId/join-requests
POST /api/v1/groups/:groupId/invitations
GET /api/v1/groups/:groupId/join-requests
GET /api/v1/groups/join-requests/me
GET /api/v1/groups/join-requests/pending-count
POST /api/v1/groups/join-requests/:requestId/approve
POST /api/v1/groups/join-requests/:requestId/reject
POST /api/v1/groups/join-requests/:requestId/cancel
POST /api/v1/files/uploads
POST /api/v1/files/:fileId/complete
GET  /api/v1/files/:fileId/download
GET  /api/v1/files/usage
POST /api/v1/files/:fileId/thumbnail
DELETE /api/v1/files/:fileId
PUT  /api/v1/users/me/avatar
DELETE /api/v1/users/me/avatar
POST /api/v1/calls
POST /api/v1/calls/:callId/accept
POST /api/v1/calls/:callId/reject
POST /api/v1/calls/:callId/cancel
POST /api/v1/calls/:callId/end
POST /api/v1/calls/:callId/token
GET  /api/v1/messages/protocol
POST /api/v1/messages/protocol/validate
GET  /api/v1/conversations/settings
PATCH /api/v1/conversations/settings
GET  /api/v1/blocks
POST /api/v1/blocks/:userId
DELETE /api/v1/blocks/:userId
GET  /api/v1/admin/jobs/runs
POST /api/v1/admin/jobs/cleanup/run
```

Every response includes `x-request-id`. Clients may provide a safe request ID using the same header. Error responses consistently include `statusCode`, `code`, `message`, `requestId`, `timestamp`, and `path`. Requests slower than `SLOW_REQUEST_MS` are logged as `http.slow_request`. Logs go to stdout for Docker collection; Prometheus is intentionally not required in the initial phase.

Helmet security headers are enabled globally. JSON and URL-encoded request bodies default to `JSON_BODY_LIMIT=1mb`; oversized requests return `413 PAYLOAD_TOO_LARGE` with the normal error envelope and request ID. Media files are not uploaded through the API body—they continue to use presigned object-storage uploads.

## OpenAPI 与客户端

开发环境默认提供 Swagger UI：

```text
http://localhost:3000/api/v1/docs
http://localhost:3000/api/v1/openapi.json
```

生产环境可设置 `SWAGGER_ENABLED=false` 关闭在线文档。接口或 DTO 发生变化后，重新生成规范、Flutter Dart 客户端和 React 管理端 TypeScript 客户端：

```bash
npm run openapi:generate
npm run client:dart
npm run client:typescript
```

Dart 客户端输出在 `clients/dart/chat_api`；TypeScript Axios 客户端输出在 `clients/typescript/admin_api`，可作为 Ant Design Pro 的本地 workspace 依赖。两个客户端都来自同一份 `openapi/chat-api.json`，不要手改生成目录。Flutter 项目可通过本地 path dependency 引入，并使用生成的 `ChatApi`、请求 DTO 和响应模型。登录成功后，将 `accessToken` 设置给客户端的 Bearer 鉴权；遇到 401 时只允许串行执行一次 refresh，并原子替换 access/refresh token，防止多个并发请求重复轮换 refresh token。

## Background cleanup

With `JOBS_ENABLED=true`, each API instance attempts cleanup on the configured interval. A PostgreSQL advisory lock ensures only one instance runs it. The job marks stale pending/rejected uploads as deleted after removing their objects, prunes old revoked/expired device sessions, and removes old login throttle rows. Every run is stored in `job_runs` with status and counters. Administrator endpoints can inspect history or trigger the same idempotent job manually.

The same cleanup can be run from a trusted server shell with `npm run job:cleanup`.

Flutter 接入前请先阅读 [消息协议](docs/message-protocol.md)。普通消息由 Flutter 直连 WuKongIM，文件先直传对象存储并完成服务端确认，然后只在消息中携带 `fileId`。

## WuKongIM Webhook

幂等回调入口为：

```text
POST /api/v1/webhooks/wukongim?token=<WUKONGIM_WEBHOOK_SECRET>
```

将 WuKongIM 的 `webhook.httpAddr` 指向该地址。生产环境应使用容器内网地址，并在网关限制来源 IP。回调保存在 `webhook_events`，同一个事件 ID 的重试不会重复入库。

## 管理接口

这些接口需要 `ADMIN` 角色。管理员权限和用户状态每次都从数据库读取，因此封禁用户后，其已签发 JWT 会立即失效，全部设备会话也会被撤销。

```text
GET   /api/v1/admin/overview
GET   /api/v1/admin/users?search=&status=&role=&cursor=&limit=30
GET   /api/v1/admin/users/:userId
DELETE /api/v1/admin/users/:userId/devices/:sessionId
PATCH /api/v1/admin/users/:userId/suspend
PATCH /api/v1/admin/users/:userId/activate
GET   /api/v1/admin/groups?search=&status=&cursor=&limit=30
GET   /api/v1/admin/groups/:groupId
GET   /api/v1/admin/groups/:groupId/members?search=&cursor=&limit=30
PATCH /api/v1/admin/groups/:groupId/policy
GET   /api/v1/admin/audit-logs?action=&targetType=&targetId=&actorUserId=&from=&to=&cursor=&limit=50
GET   /api/v1/admin/jobs/runs?status=&cursor=&limit=30
```

群策略请求体支持 `suspended` 和 `muteAll`。首次管理员先通过正常注册接口创建账号，再在受信任的服务器终端执行：

```bash
npm run admin:promote -- your_admin
```

使用 Compose 部署时执行容器版命令，无需从宿主机直接连接 PostgreSQL：

```bash
npm run admin:promote:docker -- your_admin
```

命令只允许提升已存在且状态正常的用户，重复执行是幂等的，并写入 `ADMIN_PROMOTE_CLI` 审计记录。不要把该命令暴露给 Web 或 App 客户端。

消息撤回暂未提供服务端 API：WuKongIM 当前公开接口没有稳定的历史消息撤回契约。实现 Flutter 消息模型时，应预留版本化的 `message.revoke` 业务消息，再由服务端校验发送者、会话和撤回时限。

Register request:

```json
{
  "username": "alice",
  "password": "a-secure-password",
  "nickname": "Alice"
}
```

登录和注册可以额外传入 `deviceId`、`deviceType`（`APP`、`WEB`、`DESKTOP`）和 `deviceName`。Flutter 应生成并持久化一个安装级 UUID 作为 `deviceId`。`refreshToken` 只能使用一次，每次刷新后必须原子替换本地旧值，并保存在系统安全存储中，不能放入普通 SharedPreferences。

Create call request (requires `Authorization: Bearer <accessToken>`):

```json
{
  "targetUserId": "the-other-user-uuid",
  "type": "VIDEO"
}
```

## Production notes

The compose file is for local development only. Production requires TLS, private access
to WuKongIM management ports, durable backups, real LiveKit keys, public ICE/TURN
configuration and firewall rules for media traffic. Do not expose WuKongIM port 5001 or
the LiveKit API secret to clients.

生产变量从 [.env.production.example](.env.production.example) 复制到服务器的密钥管理系统或受保护的环境文件。至少必须替换数据库密码、JWT 密钥、WuKongIM webhook/manager token、LiveKit 密钥和 S3 密钥。`S3_ENDPOINT` 是 API 访问对象存储的内部地址，`S3_PUBLIC_ENDPOINT` 是写入预签名上传和下载 URL、供 App 访问的公网地址；使用云对象存储且二者相同时可设置相同值。`CORS_ALLOWED_ORIGINS` 使用逗号分隔的完整 Origin，例如 `https://app.example.com,https://admin.example.com`；生产环境不要设置为 `*`。在线 Swagger 默认应关闭。

## End-to-end smoke test

After the services and API are running, create `alice_test` and `bob_test` with the
credentials used by `scripts/smoke.mjs`, then run:

```bash
npm run smoke
```

It verifies friendship, group subscriber synchronization, direct file upload/download,
WuKongIM call signaling and LiveKit token generation.

管理员账号完成提升后，可执行 `npm run smoke:admin`。默认使用 `admin_smoke` 和 `bob_test`，也可通过 `SMOKE_ADMIN_USERNAME`、`SMOKE_ADMIN_PASSWORD`、`SMOKE_TARGET_USERNAME`、`SMOKE_TARGET_PASSWORD` 覆盖。该检查会验证概览、查询、临时设备强制下线、群策略、审计日志和清理任务。
