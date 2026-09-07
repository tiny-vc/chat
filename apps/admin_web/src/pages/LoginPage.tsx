import { LockOutlined, UserOutlined } from "@ant-design/icons";
import { LoginFormPage, ProFormText } from "@ant-design/pro-components";
import { Alert, App as AntApp, ConfigProvider } from "antd";
import { publicAuthApi } from "../api";
import { adminDeviceId, authStore } from "../auth";
import { LoginDtoDeviceTypeEnum } from "@chat/admin-api-client";
import { useEffect, useState } from "react";
import { describeAdminLoginFailure } from "../loginError";

export function LoginPage({
  onSuccess,
  notice,
}: {
  onSuccess: () => void;
  notice?: string;
}) {
  return (
    <ConfigProvider
      theme={{ token: { colorPrimary: "#6750a4", borderRadius: 10 } }}
    >
      <AntApp>
        <LoginContent onSuccess={onSuccess} notice={notice} />
      </AntApp>
    </ConfigProvider>
  );
}

function LoginContent({
  onSuccess,
  notice,
}: {
  onSuccess: () => void;
  notice?: string;
}) {
  const { message } = AntApp.useApp();
  const [retryAt, setRetryAt] = useState<number>();
  const [now, setNow] = useState(Date.now());
  const remainingSeconds = retryAt
    ? Math.max(0, Math.ceil((retryAt - now) / 1_000))
    : 0;

  useEffect(() => {
    if (!retryAt) return;
    const timer = window.setInterval(() => {
      const current = Date.now();
      setNow(current);
      if (current >= retryAt) setRetryAt(undefined);
    }, 1_000);
    return () => window.clearInterval(timer);
  }, [retryAt]);

  return (
    <LoginFormPage
      title="Chat 管理平台"
      subTitle="使用管理员账号登录"
      backgroundImageUrl="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='1600' height='900'%3E%3Cdefs%3E%3ClinearGradient id='g' x2='1' y2='1'%3E%3Cstop stop-color='%23f4efff'/%3E%3Cstop offset='1' stop-color='%23e8def8'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='100%25' height='100%25' fill='url(%23g)'/%3E%3C/svg%3E"
      submitter={{
        searchConfig: {
          submitText:
            remainingSeconds > 0 ? `${remainingSeconds} 秒后重试` : "登录",
        },
        submitButtonProps: { disabled: remainingSeconds > 0 },
      }}
      onFinish={async (values) => {
        if (remainingSeconds > 0) return false;
        try {
          const response = await publicAuthApi.authAdminLogin({
            loginDto: {
              username: values.username,
              password: values.password,
              deviceId: adminDeviceId(),
              deviceType: LoginDtoDeviceTypeEnum.Web,
              deviceName: "管理平台",
            },
          });
          authStore.write({
            accessToken: response.data.accessToken,
            refreshToken: response.data.refreshToken,
          });
          onSuccess();
          return true;
        } catch (error) {
          const failure = describeAdminLoginFailure(error);
          if (failure.retryAt) {
            setNow(Date.now());
            setRetryAt(failure.retryAt);
          }
          message.error(failure.message);
          return false;
        }
      }}
    >
      {notice && (
        <Alert
          type="warning"
          showIcon
          message={notice}
          style={{ marginBottom: 16 }}
        />
      )}
      <ProFormText
        name="username"
        fieldProps={{ prefix: <UserOutlined />, autoComplete: "username" }}
        placeholder="管理员用户名"
        rules={[{ required: true, message: "请输入用户名" }]}
      />
      <ProFormText.Password
        name="password"
        fieldProps={{
          prefix: <LockOutlined />,
          autoComplete: "current-password",
        }}
        placeholder="密码"
        rules={[{ required: true, message: "请输入密码" }]}
      />
    </LoginFormPage>
  );
}
