# 单机生产部署

本文档适用于第一阶段的小规模部署：一台 Linux 服务器运行 API、管理平台、
PostgreSQL、WuKongIM、LiveKit、MinIO 和 Nginx。它不是多节点高可用方案。

## 1. 域名和网络

只需购买一个根域名，并添加四条 DNS 记录；它们可以全部解析到同一公网 IP：

| DNS 记录 | 用途 |
| --- | --- |
| `chat.example.com` | App 业务 API、管理平台和文件 |
| `im.example.com` | WuKongIM WSS |
| `rtc.example.com` | LiveKit WSS 信令 |
| `turn.example.com` | LiveKit TURN |

App 用户只填写 `https://chat.example.com`。IM、RTC 和文件地址由业务 API 返回。

单公网 IP 上，Nginx 使用 TCP 443，因此 TURN/TLS 使用 TCP 5349；TURN/UDP
可以使用 UDP 443，两者不冲突。如果必须让 TURN/TLS 使用 TCP 443，需要为
TURN 准备第二个公网 IP 或四层负载均衡。

公网防火墙只开放：

- TCP 80、443：证书签发、API、管理平台、IM WSS、LiveKit WSS；
- TCP 5100：WuKongIM 原生 TCP 备用通道；
- TCP 7881：LiveKit WebRTC over TCP；
- TCP 5349：TURN/TLS；
- UDP 443：TURN/UDP；
- UDP 50000–50100：LiveKit RTC 媒体。

不要公开 PostgreSQL 5432、WuKongIM API/管理端口 5001/5300、MinIO 9000/9001
或业务 API 容器端口 3000。

## 2. 服务器准备

建议 Ubuntu LTS、4 核 CPU、8 GB 内存和 100 GB SSD 起步。服务器只需安装
Docker Engine、Docker Compose plugin、OpenSSL 和 curl。生产环境不构建源码，
而是从 GHCR 拉取 GitHub Actions 发布的固定版本镜像。

每次推送 `main` 或 `v*` 标签时，`.github/workflows/publish-production-images.yml`
会发布三个多架构镜像：

```text
ghcr.io/tiny-vc/chat-api:sha-<完整提交SHA>
ghcr.io/tiny-vc/chat-migrate:sha-<完整提交SHA>
ghcr.io/tiny-vc/chat-admin:sha-<完整提交SHA>
```

服务器只需保存部署文件，可以克隆仓库，也可以仅复制以下内容：

```text
docker-compose.production.yml
scripts/deploy-production.sh
scripts/verify-livekit-production.mjs
deploy/nginx/nginx.production.example.conf
deploy/livekit/livekit.production.example.yaml
.env.production.example
```

创建配置：

```sh
cp .env.production.example .env.production
cp deploy/nginx/nginx.production.example.conf deploy/nginx/nginx.production.conf
cp deploy/livekit/livekit.production.example.yaml deploy/livekit/livekit.production.yaml
chmod 600 .env.production deploy/livekit/livekit.production.yaml
```

将所有 `example.com`、`replace-with-*` 替换为真实值。强密钥可使用：

```sh
openssl rand -base64 48
```

把 `.env.production` 中三个 `CHAT_*_IMAGE` 设置成同一次构建产生的相同
`sha-<完整提交SHA>` 或同一 `v*` 版本标签。禁止使用 `latest` 或 `main`，否则
升级结果无法复现。私有 GHCR 包还需要先执行 `docker login ghcr.io`；也可以在
GitHub 中把这三个容器包设为公开读取。

`POSTGRES_PASSWORD` 如果含有 URL 特殊字符，Compose 会直接构造数据库 URL，
因此建议使用只包含字母和数字的高强度随机值；否则必须进行 URL 编码。

## 3. TLS 证书

Nginx 示例使用一个覆盖 `chat`、`im`、`rtc` 的 SAN 或通配符证书：

```text
deploy/certs/fullchain.pem
deploy/certs/privkey.pem
```

LiveKit TURN 的 `turn.example.com` 也必须被证书覆盖。真实证书、私钥、生产
Nginx 配置和 LiveKit 配置已被忽略，禁止提交到版本库。

证书可以由宿主机 Certbot/acme.sh 维护，再原子替换上述文件并执行：

```sh
docker compose --env-file .env.production -f docker-compose.production.yml exec gateway nginx -s reload
```

首次签发证书前可以临时只启动一个 ACME HTTP 配置；不要用自签名证书发布 App。

## 4. LiveKit

编辑 `deploy/livekit/livekit.production.yaml`，保证：

- `keys` 与 API 中 `LIVEKIT_API_KEY/LIVEKIT_API_SECRET` 完全一致；
- `webhook.api_key` 与 `keys` 中的 key 一致；
- webhook 地址为 `https://chat.example.com/api/v1/webhooks/livekit`；
- TURN 域名和证书正确；
- 单公网 IP 使用 `tls_port: 5349`、`udp_port: 443`。

启动前执行静态检查：

```sh
npm run verify:livekit-production
```

更完整的媒体网络说明见 [LiveKit 弱网与 TURN/TLS 部署](livekit-production-network.md)。

## 5. 首次启动

推荐先运行部署脚本的只检查模式。它会检查必需文件、占位符、生产安全开关、
LiveKit 密钥一致性、证书与私钥匹配、证书有效期、磁盘空间和 Compose 配置，
不会拉取镜像、构建或改变服务：

```sh
sh scripts/deploy-production.sh --check-only
```

检查通过后构建并启动；脚本会等待健康状态并检查 API readiness：

```sh
sh scripts/deploy-production.sh
```

使用其他环境文件时执行 `sh scripts/deploy-production.sh --env-file PATH`；如果镜像
已经提前拉取，可加 `--skip-pull`。生产部署必须在 Linux 执行，因为 LiveKit使用
host networking；macOS 只允许运行 `--check-only` 做静态预检。

`migrate` 会等待 PostgreSQL 健康并执行 `prisma migrate deploy`；只有迁移成功后
API 才会启动。`minio-init` 只负责幂等创建 bucket。不要在生产运行
`prisma migrate dev`。

检查：

```sh
curl --fail https://chat.example.com/api/v1/health
curl --fail https://chat.example.com/api/v1/ready
docker compose --env-file .env.production -f docker-compose.production.yml logs --tail=200 api
```

首次管理员仍通过受信任的服务器终端提升：

```sh
docker compose --env-file .env.production -f docker-compose.production.yml \
  run --rm --no-deps api node dist/cli/promote-admin.js
```

## 6. 升级与回滚

升级前先完成三类备份，再拉取经过验证的版本：

```sh
npm run backup:postgres
npm run backup:minio
npm run backup:wukongim
sh scripts/deploy-production.sh
```

数据库迁移应设计为向前兼容。应用镜像可以回滚到上一固定版本，但已经执行的
数据库迁移不会自动回滚。涉及破坏性迁移时必须另行制定维护窗口和恢复方案。

只把备份留在同一台服务器不构成备份；应复制到独立磁盘或对象存储，并定期执行
仓库提供的验证命令和人工恢复演练。

## 7. 发布验收

上线前至少完成：

- App 服务器检测、登录、Token 刷新；
- 两台真实设备文字、图片、文件和群聊互发；
- WuKongIM WSS 和断线重连；
- LiveKit 双向音视频、Wi-Fi/蜂窝切换；
- 禁用 UDP 后验证 TCP/TURN，再在受限网络验证 TURN/TLS；
- 管理平台登录、封禁、设备下线和审计；
- 服务重启、数据库迁移、备份验证及磁盘容量告警。

第一阶段不包含 Prometheus、多节点高可用、端到端加密和离线推送；这些能力
不应通过临时开放内部端口来替代。
