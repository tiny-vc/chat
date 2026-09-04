# LiveKit 弱网与 TURN/TLS 部署

## App 侧策略

- 房间启用 `adaptiveStream` 和 `dynacast`，视频默认 720p、最高 24 fps，开启 simulcast，并使用 balanced degradation。
- LiveKit 先根据订阅画面尺寸、可见性和带宽选择合适的视频层。
- 若本端或对端连续 8 秒处于 poor/lost，App 关闭本地摄像头发布，但不修改麦克风状态。
- 网络连续恢复 12 秒后提示用户手动恢复视频。不会自动打开摄像头，避免意外开启和质量抖动。
- 重连由 LiveKit SDK 负责；App 显示恢复状态，并允许不可恢复时重新获取 token 连接。

这是一套产品级兜底，不等于网络层 QoS 保证。最终必须用两台真机覆盖 Wi-Fi/蜂窝切换、丢包、延迟、无 UDP 和仅 443 可用等场景。

## 生产部署

本地 `docker-compose.yml` 的 `--dev` 只用于开发。生产环境：

1. 为信令准备 `livekit.example.com` 和可信 CA 证书，由 HTTPS/WSS 反向代理终止 TLS。
2. 为 TURN 准备独立的 `turn.example.com` 和匹配的可信 CA 证书。
3. 复制 `deploy/livekit/livekit.production.example.yaml` 为 `livekit.production.yaml`，填写强随机 API key/secret、域名和证书路径，并将文件权限设为 600。
4. 将证书放入 `deploy/livekit/certs/`。私钥和实际配置已被该目录的 `.gitignore` 排除。
5. 执行 `npm run verify:livekit-production`。静态校验通过后，再使用生产 compose 示例启动。

Linux 单机模板使用 host networking。防火墙至少允许：

- TCP 7881：WebRTC over TCP；
- UDP 50000-50100：RTC 媒体端口范围；
- TCP 443：TURN/TLS；
- UDP 443：TURN/UDP；
- WSS/HTTPS 信令域名经反向代理暴露 443。

如果前方使用四层负载均衡，可把 TURN TLS 监听/广告端口按拓扑调整为 5349；不要在 TURN 前使用普通七层 HTTP 代理。多节点部署还应加入 Redis，并让每个媒体节点正确广告自己的公网 IP。

## 校验命令

```sh
cp deploy/livekit/livekit.production.example.yaml deploy/livekit/livekit.production.yaml
# 修改配置并放入真实证书后
npm run verify:livekit-production
docker compose -f deploy/livekit/docker-compose.production.example.yml up -d
```

静态校验不会验证 DNS、证书链、公网 NAT 或防火墙。上线前仍需从受限网络的真机完成 TURN/TLS 连通性测试。

