# 生产部署

第一阶段支持两种明确分离的部署模式：

- `standalone`：一台 Linux 服务器运行 API、管理平台、PostgreSQL、WuKongIM、
  LiveKit、MinIO 和 Nginx，使用 `docker-compose.production.yml`；
- `external`：应用服务器只运行 gateway、API、worker、migrate 和管理平台，
  PostgreSQL、WuKongIM、LiveKit 和 S3/MinIO 使用远程或托管服务，使用
  `docker-compose.external-services.yml`。

外部模式中的 API 固定为 `INSTANCE_ROLE=api`，worker 固定为
`INSTANCE_ROLE=worker`。两者使用同一个 API 镜像和环境配置，只有 API 对 gateway
提供服务。现有单机部署无需修改命令，未设置 `DEPLOYMENT_MODE` 时仍默认为
`standalone`。

## 1. 域名和网络

只需购买一个根域名，并添加四条 DNS 记录；它们可以全部解析到同一公网 IP：

| DNS 记录           | 用途                         |
| ------------------ | ---------------------------- |
| `chat.example.com` | App 业务 API、管理平台和文件 |
| `im.example.com`   | WuKongIM WSS                 |
| `rtc.example.com`  | LiveKit WSS 信令             |
| `turn.example.com` | LiveKit TURN                 |

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
Docker Engine、Docker Compose plugin、OpenSSL 和 curl。生产服务器不构建源码；
业务镜像可以在开发机打包上传，也可以从 GHCR 拉取固定版本。

默认发布方式是在开发机将三个 AMD64 业务镜像构建并上传到服务器。GHCR 仍作为
备用方案，可从 GitHub Actions 手动运行 `.github/workflows/publish-production-images.yml`
发布三个 AMD64 镜像：

```text
ghcr.io/tiny-vc/chat-api:sha-<完整提交SHA>
ghcr.io/tiny-vc/chat-migrate:sha-<完整提交SHA>
ghcr.io/tiny-vc/chat-admin:sha-<完整提交SHA>
```

API 与数据库迁移使用独立镜像：`chat-api` 只包含编译后的业务服务和生产依赖；
`chat-migrate` 只包含 Prisma CLI、schema 与迁移记录，不包含 API 源码或 NestJS
运行依赖。这样迁移可以在新 API 启动前作为一次性任务执行，失败时阻止发布，并且
不会让常驻 API 容器携带不需要的迁移工具。

服务器只需保存部署文件，可以克隆仓库，也可以仅复制以下内容：

```text
docker-compose.production.yml
docker-compose.external-services.yml
scripts/deploy-production.sh
scripts/setup-production-interactive.sh
scripts/renew-production-certificate.sh
scripts/bootstrap-admin-production.sh
scripts/verify-livekit-production.mjs
scripts/backup-postgres.sh
scripts/verify-postgres-backup.sh
scripts/backup-minio.sh
scripts/verify-minio-backup.sh
scripts/backup-wukongim.sh
scripts/verify-wukongim-backup.sh
deploy/nginx/nginx.production.example.conf
deploy/nginx/nginx.external-services.example.conf
deploy/livekit/livekit.production.example.yaml
.env.production.example
.env.external-services.example
```

推荐在开发机仓库根目录运行上传脚本。它只上传上述部署文件和配置模板，不上传
源码、Git 历史、`.env.production`、正式配置或 TLS 证书，也不会覆盖服务器上
已经存在的这些敏感文件：

```sh
sh scripts/upload-production-files.sh root@服务器IP /opt/chat
```

SSH 不是 22 端口时使用 `SSH_PORT=端口号`。目标账户必须对 `/opt/chat` 有写权限；
普通账户可先在服务器执行 `sudo mkdir -p /opt/chat` 并修改目录所有者。

要在本机构建三个 AMD64 镜像，并把部署文件、镜像压缩包、SHA-256 校验文件和
镜像变量清单一次上传到服务器，执行：

```sh
sh scripts/build-upload-production.sh root@服务器IP /opt/chat 2026.09.07-1
```

如果仅修改了 `apps/admin_web` 管理平台，可使用增量脚本，只构建和上传管理端
镜像，API 与数据库迁移镜像保持不变：

```bash
sh scripts/build-upload-admin-production.sh root@服务器IP /opt/chat
```

脚本完成后会输出服务器端的校验、导入镜像、更新 `CHAT_ADMIN_IMAGE` 和部署命令。
只有管理端代码发生变化时才使用此脚本；包含服务端、数据库结构或生成客户端的
修改仍必须使用完整的 `build-upload-production.sh`。

频繁调整管理平台样式时，推荐使用更小的静态产物包：

```bash
sh scripts/build-upload-admin-assets-production.sh root@服务器IP /opt/chat
```

该方式只上传本地编译后的 `dist`、Nginx 配置和运行时 Dockerfile，不上传
TypeScript/React 源码，也不传输完整 Nginx 镜像。上传后按照脚本提示，在服务器
运行 `install-admin-assets-production.sh`；服务器会校验压缩包、使用已有
`nginx:1.29-alpine` 组装不可变镜像、更新环境文件并执行健康检查部署。

第三个参数是发布版本；省略时使用当前完整 Git 提交 SHA。脚本默认拒绝打包尚未
提交的代码，防止镜像版本与源码记录不一致。Apple Silicon Mac 会通过 Buildx
明确构建 `linux/amd64`，与 AMD64 服务器匹配。生成的本地压缩包保存在
`production-bundles/`，该目录不会提交到 Git。

上传完成后，在服务器校验并导入（文件名以脚本输出为准）：

```sh
cd /opt/chat
sha256sum -c chat-production-images-2026.09.07-1-amd64.tar.gz.sha256
gzip -dc chat-production-images-2026.09.07-1-amd64.tar.gz | docker load
cat production-images-2026.09.07-1.env
```

将最后一个命令显示的三个 `CHAT_*_IMAGE` 值写入 `.env.production`。服务器不需要
GitHub Token，也不会收到应用源码。

完成 DNS 解析后，可以在服务器使用交互式初始化脚本完成其余首次部署步骤：

```sh
cd /opt/chat
sh scripts/setup-production-interactive.sh
```

脚本会选择已上传的镜像包、校验并导入镜像，询问根域名和各服务域名，生成全部
随机密钥，创建 `.env.production`、Nginx 和 LiveKit 配置，并可通过固定版本的
Certbot 官方容器申请证书或复制已有证书，
拉取公开基础镜像、执行生产预检，并在最终确认后启动服务。已有配置不会被静默
覆盖；证书尚未准备好时会保存配置后安全退出，可放置证书后再次运行。API 启动
后，脚本还会询问是否立即通过隐藏密码输入创建首个管理员。

Certbot 容器使用固定的 `certbot/certbot:v5.8.0` 镜像，HTTP-01 签发要求四个域名
都已解析到服务器且 TCP 80 可从公网访问。脚本会在必要时征得确认后短暂停止
gateway 释放端口。签发资料保存在 `deploy/letsencrypt/`，正式证书会复制到
`deploy/certs/`；这些目录中的证书和账户资料都不会提交到 Git。

使用交互脚本申请证书后，可为 root 添加每日续期检查：

```cron
17 3 * * * cd /opt/chat && sh scripts/renew-production-certificate.sh >> /var/log/chat-cert-renew.log 2>&1
```

续期脚本仅在证书剩余不足 30 天时才停止 gateway 并调用 Certbot，平时不会影响
服务；续期成功后会复制新证书并恢复 gateway。使用外部证书或 DNS API 签发时，
应使用对应服务商自己的续期机制，不运行此脚本。

创建配置：

```sh
cp .env.production.example .env.production
cp deploy/nginx/nginx.production.example.conf deploy/nginx/nginx.production.conf
cp deploy/livekit/livekit.production.example.yaml deploy/livekit/livekit.production.yaml
chmod 600 .env.production deploy/livekit/livekit.production.yaml
```

### 外部基础服务模式

应用服务器执行：

```sh
cp .env.external-services.example .env.production
cp deploy/nginx/nginx.external-services.example.conf deploy/nginx/nginx.production.conf
chmod 600 .env.production
```

编辑 `.env.production`，配置可由容器访问的 `DATABASE_URL`、
`WUKONGIM_API_URL`、`LIVEKIT_HTTP_URL` 和 `S3_ENDPOINT`，以及 App 使用的
`WUKONGIM_WS_URL`、`LIVEKIT_URL`、`S3_PUBLIC_ENDPOINT`。私网地址不需要公网
DNS，但必须允许应用服务器访问；公网地址必须使用可信 TLS。

外部 PostgreSQL 必须已经创建数据库和账号，外部 bucket 也必须已经创建；应用
不会尝试创建远程基础设施。WuKongIM 的 `msg.notify` webhook 应设置为
`https://chat.example.com/api/v1/webhooks/wukongim/<WUKONGIM_WEBHOOK_SECRET>`，
LiveKit webhook 设置为 `https://chat.example.com/api/v1/webhooks/livekit`，并保证
双方密钥一致。外部服务分别维护自己的证书、端口、防火墙、备份和高可用。

检查和部署命令与单机一致；脚本根据 `DEPLOYMENT_MODE=external` 自动选择编排：

```sh
sh scripts/deploy-production.sh --check-only
sh scripts/deploy-production.sh --skip-pull
```

也可以显式传入 `--mode external`，用于检查某份尚未写入部署模式的环境文件。
交互式 `setup-production-interactive.sh` 仍专用于一体化单机安装，外部模式使用上述
模板显式配置，避免脚本替你生成与远程服务不一致的密钥。

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

部署脚本会在启动前通过一次性 Node 容器执行 LiveKit 静态检查，服务器不需要
安装 Node.js 或 npm。

更完整的媒体网络说明见 [LiveKit 弱网与 TURN/TLS 部署](livekit-production-network.md)。

## 5. 首次启动

推荐先运行部署脚本的只检查模式。它会检查必需文件、占位符、生产安全开关、
LiveKit 密钥一致性、证书与私钥匹配、证书有效期、磁盘空间和 Compose 配置，
不会拉取镜像、构建或改变服务：

```sh
sh scripts/deploy-production.sh --check-only
```

检查通过后拉取镜像并启动；脚本会等待健康状态并检查 API readiness：

```sh
sh scripts/deploy-production.sh
```

如果只想先下载三个业务镜像而不启动容器，在服务器执行：

```sh
docker compose --env-file .env.production -f docker-compose.production.yml \
  pull api migrate admin
```

该命令根据 `.env.production` 中的 `CHAT_API_IMAGE`、`CHAT_MIGRATE_IMAGE` 和
`CHAT_ADMIN_IMAGE` 下载镜像。若 GHCR 包是私有的，先用具有 `read:packages`
权限的 GitHub Token 执行 `docker login ghcr.io -u tiny-vc`；公开包无需登录。

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

首次启动或升级 WuKongIM / API 后，建议额外运行一次真实媒体回调检查：

```sh
sh scripts/verify-wukong-media-webhook-production.sh
```

脚本会临时创建两个测试用户和一条媒体记录，通过 WuKongIM 正式
`/message/send` 接口发送一条 60 秒后过期的隔离文件消息，再等待 `msg.notify` 回调把该文件
标记为已引用。成功时输出 `"messageNotifyDelivered":true` 和
`"mediaReferenceRecorded":true`，测试数据随后自动清理。该检查不会上传真实文件，
但必须使用包含 `dist/cli/verify-wukong-media-webhook.js` 的新版 API 镜像。

首次部署不需要开放注册或先创建普通账号。系统尚无管理员时，在受信任的服务器
终端运行一次初始化脚本：

```sh
sh scripts/bootstrap-admin-production.sh
```

脚本交互读取用户名、昵称和两次密码，输入密码时不会回显，也不会把密码写入命令
历史。容器内 CLI 仅在系统不存在管理员时允许创建，并使用与正常注册相同的
bcrypt cost 12 哈希，同时写入 `ADMIN_BOOTSTRAP_CLI` 审计记录。后续管理员应在
管理平台内授权；已有普通账号需要提升时，仍可使用：

```sh
docker compose --env-file .env.production -f docker-compose.production.yml \
  run --rm --no-deps api node dist/cli/promote-admin.js existing_username
```

## 6. 升级与回滚

升级前先完成三类备份，再拉取经过验证的版本：

```sh
export COMPOSE_FILE=docker-compose.production.yml
export COMPOSE_ENV_FILES=.env.production
export CHAT_ENV_FILE=.env.production
sh scripts/backup-postgres.sh
sh scripts/backup-minio.sh
sh scripts/backup-wukongim.sh
sh scripts/deploy-production.sh
```

上述环境变量让备份脚本明确操作生产 Compose，避免误连本地开发栈。验证备份时
分别执行 `verify-postgres-backup.sh`、`verify-minio-backup.sh` 和
`verify-wukongim-backup.sh`，并传入对应备份路径。

数据库迁移应设计为向前兼容。应用镜像可以回滚到上一固定版本，但已经执行的
数据库迁移不会自动回滚。涉及破坏性迁移时必须另行制定维护窗口和恢复方案。

只把备份留在同一台服务器不构成备份；应复制到独立磁盘或对象存储，并定期执行
仓库提供的验证命令和人工恢复演练。

## 7. 从单节点扩展

当前单节点把 `INSTANCE_ROLE` 设为 `all`。扩展业务 API 时，将对外实例设为
`api`，至少部署一个不接收公网请求的实例并设为 `worker`；两类实例使用同一
PostgreSQL、S3/MinIO、WuKongIM 和 LiveKit 配置。API 实例不会启动清理、IM
策略巡检或通话超时定时器，worker 间另由 PostgreSQL advisory lock 防止任务
重叠执行，因此无需使用负载均衡器的会话粘滞。

上传和下载始终使用短期签名 URL 直连对象存储。上传携带 S3 原生 SHA-256
checksum，由对象存储校验实际内容；App 下载后再次校验摘要。文件删除先持久化为
`DELETE_PENDING`，对象存储暂时不可用时由维护任务幂等重试，不会出现数据库显示
已删除但对象永久遗留的静默失败。

真正多节点时，PostgreSQL 和 MinIO 应替换为托管或高可用集群，并让所有实例使用
同一外部地址；LiveKit、WuKongIM 的信令/媒体/IM 集群按各自部署方式扩容。业务
接口只依赖它们的公开 API 和共享标识，不需要改写聊天、文件或通话业务模型。
本仓库的 Compose 仍定位为单机编排，不应跨服务器复制 Compose 后各自创建一套
独立数据库或对象存储。

## 8. 发布验收

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
