# 未接听通话超时回收

- 邀请期限为创建后 45 秒，与 App 的呼叫等待时间一致。
- API 启动时及每 15 秒执行一次回收，故后台回收通常发生在创建后 45–60 秒；数据库不可用时在下一轮重试。
- 新建通话检查忙线前、读取通话历史和签发加入凭证前也会回收相关用户的过期邀请。
- 只将 INVITING/RINGING 改为 MISSED，并记录 endedAt 和 NO_ANSWER；不按时长回收 ACCEPTED/CONNECTED。
- 接听、拒绝、取消等邀请操作使用带状态和期限条件的原子更新。过期或已被其他操作处理的请求不会复活旧邀请。
- 巡检采用幂等条件更新，多实例可安全重复执行，不依赖维护任务的小时级调度。
- 后台回收不发送额外 IM 信令；客户端现有等待计时器负责关闭呼叫 UI，历史状态在下次刷新时更新。

验证：`npm test -- --runInBand`，`npm run build`；本地部署后运行 `node scripts/smoke.mjs` 验证通话创建、接听、凭证签发和结束。

范围限制：已接听后客户端异常退出的回收、LiveKit 房间对账、同时发起多个新呼叫的互斥控制仍需独立完善。本次不宣称已解决所有通话并发及异常挂断情况。

## 2026-09-03 本地联调结果

- Docker Hub 认证端点持续返回 EOF，标准 Dockerfile 完整构建未完成。
- 使用本地 `chat-api:latest` 派生 `chat-api:expiry-local`，仅替换本次编译的 `dist/calls/calls.service.js` 和 source map；没有安装新依赖或修改数据卷。
- 当前本地 API 运行 `chat-api:expiry-local`。临时构建上下文及 Compose 覆盖文件位于 `/tmp/chat-api-expiry.DcuCft/`，临时目录不保证长期保留。
- `/api/v1/ready` 的四项依赖全部正常；2026-09-01 遗留邀请已自动变为 MISSED / NO_ANSWER。
- `node scripts/smoke.mjs` 成功，覆盖好友关系、创建测试群、文件上传/完成/下载授权，以及通话创建/接听/凭证签发/结束。脚本产生的测试群、文件和通话记录保留在本地。
- 此结果不等于真机消息或音视频媒体链路验收。

网络恢复后执行 `docker compose up -d --build --no-deps --wait api` 完成标准构建并重新跑冒烟测试。注意直接用默认 Compose 启动（不重建）可能切回旧的 `chat-api:latest`，丢失本次代码修复。

若确需回退代码，可运行 `docker compose up -d --no-build --no-deps --wait api`，它使用保留的旧镜像；这不会恢复已经按规则回收的历史通话记录。
