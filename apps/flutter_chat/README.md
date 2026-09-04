# Flutter Chat

核心网络与认证层已经接入 `clients/dart/chat_api`。本机安装 Flutter SDK 后执行：

```bash
cd apps/flutter_chat
flutter create --platforms=android,ios .
flutter pub get
flutter analyze
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

`API_BASE_URL` 现在是未保存设置时的默认地址。登录页可通过“服务器设置”修改、检测、确认保存，无需重新打包；已登录需先退出。只填写服务器根地址（允许输入 `/api/v1` 后自动规范化），公网使用 HTTPS；HTTP 限制为本机/私有 IPv4 局域网调试。检测要求服务器支持 `GET /api/v1/server-info`，不跟随跳转，也不会跳过证书校验。

Android 模拟器会自动把默认配置中的 `localhost` 转为 `10.0.2.2`。真机在登录页填开发电脑局域网 IP，服务器同时使用 `docker-compose.lan.yml` 配置客户端可达的 IM、LiveKit 和文件地址。检测成功只验证公开 API，不代表这些链路都已联通。

登录凭据、聊天数据库/迁移状态、草稿及文件缓存按服务器 origin 隔离。本次未迁移旧版未隔离数据，升级后需重新登录；旧数据不会被自动删除。详见 `docs/server-settings.md`（仓库根目录）。
