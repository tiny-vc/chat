import { Alert } from "antd";
import { useEffect, useRef, useState } from "react";

export function NetworkStatus() {
  const [online, setOnline] = useState(() => navigator.onLine);
  const [restored, setRestored] = useState(false);
  const wasOffline = useRef(!navigator.onLine);

  useEffect(() => {
    let timer: number | undefined;
    const handleOffline = () => {
      if (timer) window.clearTimeout(timer);
      wasOffline.current = true;
      setRestored(false);
      setOnline(false);
    };
    const handleOnline = () => {
      setOnline(true);
      if (!wasOffline.current) return;
      wasOffline.current = false;
      setRestored(true);
      timer = window.setTimeout(() => setRestored(false), 3_000);
    };
    window.addEventListener("offline", handleOffline);
    window.addEventListener("online", handleOnline);
    return () => {
      window.removeEventListener("offline", handleOffline);
      window.removeEventListener("online", handleOnline);
      if (timer) window.clearTimeout(timer);
    };
  }, []);

  if (online && !restored) return null;
  return (
    <div className="network-status" role="status" aria-live="polite">
      <Alert
        banner
        showIcon
        type={online ? "success" : "warning"}
        message={
          online
            ? "网络连接已恢复，可以继续操作"
            : "当前设备已离线，请恢复网络后再执行管理操作"
        }
      />
    </div>
  );
}
