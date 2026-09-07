import {
  LogoutOutlined,
  TeamOutlined,
  DashboardOutlined,
  UsergroupAddOutlined,
  AuditOutlined,
  PhoneOutlined,
  FolderOpenOutlined,
  SafetyCertificateOutlined,
  ToolOutlined,
  SettingOutlined,
} from "@ant-design/icons";
import { PageContainer, ProLayout } from "@ant-design/pro-components";
import {
  App as AntApp,
  Button,
  ConfigProvider,
  Result,
  Spin,
  theme,
} from "antd";
import { lazy, Suspense, useEffect, useState } from "react";
import { adminApi, logoutAdmin } from "./api";
import { authStore } from "./auth";
import { LoginPage } from "./pages/LoginPage";
import { hrefForRoute, routeFromHash, type RouteKey } from "./routing";
import { startIdleSessionMonitor } from "./idleSession";

const OverviewPage = lazy(() =>
  import("./pages/OverviewPage").then((module) => ({
    default: module.OverviewPage,
  })),
);
const UsersPage = lazy(() =>
  import("./pages/UsersPage").then((module) => ({
    default: module.UsersPage,
  })),
);
const GroupsPage = lazy(() =>
  import("./pages/GroupsPage").then((module) => ({
    default: module.GroupsPage,
  })),
);
const AuditPage = lazy(() =>
  import("./pages/AuditPage").then((module) => ({ default: module.AuditPage })),
);
const JobsPage = lazy(() =>
  import("./pages/JobsPage").then((module) => ({ default: module.JobsPage })),
);
const CallsPage = lazy(() =>
  import("./pages/CallsPage").then((module) => ({ default: module.CallsPage })),
);
const FilesPage = lazy(() =>
  import("./pages/FilesPage").then((module) => ({ default: module.FilesPage })),
);
const ReportsPage = lazy(() =>
  import("./pages/ReportsPage").then((module) => ({
    default: module.ReportsPage,
  })),
);
const SettingsPage = lazy(() =>
  import("./pages/SettingsPage").then((module) => ({
    default: module.SettingsPage,
  })),
);

const titles: Record<RouteKey, string> = {
  overview: "系统概览",
  users: "用户管理",
  groups: "群组管理",
  calls: "通话管理",
  files: "文件管理",
  reports: "举报处理",
  audit: "审计日志",
  jobs: "后台任务",
  settings: "运行配置",
};

export function App() {
  const [authenticated, setAuthenticated] = useState(Boolean(authStore.read()));
  const [checking, setChecking] = useState(authenticated);
  const [loginNotice, setLoginNotice] = useState<string>();
  const [route, setRoute] = useState<RouteKey>(() =>
    routeFromHash(window.location.hash),
  );

  useEffect(() => {
    const updateRoute = () => {
      const nextRoute = routeFromHash(window.location.hash);
      setRoute(nextRoute);
      const canonicalHash = hrefForRoute(nextRoute);
      if (window.location.hash !== canonicalHash) {
        window.history.replaceState(null, "", canonicalHash);
      }
    };
    window.addEventListener("hashchange", updateRoute);
    updateRoute();
    return () => window.removeEventListener("hashchange", updateRoute);
  }, []);

  useEffect(() => {
    document.title = authenticated
      ? `${titles[route]} · Chat 管理平台`
      : "Chat 管理平台";
  }, [authenticated, route]);

  useEffect(() => {
    if (!authenticated) return;
    adminApi()
      .adminOverview()
      .then(
        () => setChecking(false),
        async () => {
          await logoutAdmin().catch(() => authStore.clear());
          setAuthenticated(false);
          setChecking(false);
        },
      );
  }, [authenticated]);

  useEffect(() => {
    if (!authenticated) return;
    return startIdleSessionMonitor(() => {
      void logoutAdmin().finally(() => {
        setLoginNotice("因长时间未操作，管理会话已安全退出，请重新登录。");
        setAuthenticated(false);
        setChecking(false);
      });
    });
  }, [authenticated]);

  useEffect(() => {
    const expire = () => {
      setLoginNotice("管理会话已失效，请重新登录。");
      setAuthenticated(false);
      setChecking(false);
    };
    window.addEventListener("chat-admin-session-expired", expire);
    return () =>
      window.removeEventListener("chat-admin-session-expired", expire);
  }, []);

  if (!authenticated) {
    return (
      <LoginPage
        notice={loginNotice}
        onSuccess={() => {
          setLoginNotice(undefined);
          setChecking(true);
          setAuthenticated(true);
        }}
      />
    );
  }
  if (checking)
    return (
      <div className="center-screen">
        <Spin size="large" tip="正在验证管理员权限…" />
      </div>
    );

  const content =
    route === "users" ? (
      <UsersPage />
    ) : route === "groups" ? (
      <GroupsPage />
    ) : route === "audit" ? (
      <AuditPage />
    ) : route === "calls" ? (
      <CallsPage />
    ) : route === "files" ? (
      <FilesPage />
    ) : route === "reports" ? (
      <ReportsPage />
    ) : route === "jobs" ? (
      <JobsPage />
    ) : route === "settings" ? (
      <SettingsPage />
    ) : (
      <OverviewPage />
    );
  return (
    <ConfigProvider
      theme={{
        algorithm: theme.defaultAlgorithm,
        token: { colorPrimary: "#6750a4", borderRadius: 10 },
      }}
    >
      <AntApp>
        <ProLayout
          title="Chat 管理平台"
          logo={false}
          layout="mix"
          route={{
            routes: [
              { path: "overview", name: "概览", icon: <DashboardOutlined /> },
              { path: "users", name: "用户管理", icon: <TeamOutlined /> },
              {
                path: "groups",
                name: "群组管理",
                icon: <UsergroupAddOutlined />,
              },
              { path: "calls", name: "通话管理", icon: <PhoneOutlined /> },
              { path: "files", name: "文件管理", icon: <FolderOpenOutlined /> },
              {
                path: "reports",
                name: "举报处理",
                icon: <SafetyCertificateOutlined />,
              },
              { path: "audit", name: "审计日志", icon: <AuditOutlined /> },
              { path: "jobs", name: "后台任务", icon: <ToolOutlined /> },
              {
                path: "settings",
                name: "运行配置",
                icon: <SettingOutlined />,
              },
            ],
          }}
          location={{ pathname: route }}
          menuItemRender={(item, dom) => (
            <a href={hrefForRoute(item.path as RouteKey)}>{dom}</a>
          )}
          actionsRender={() => [
            <Button
              key="logout"
              type="text"
              icon={<LogoutOutlined />}
              onClick={() => {
                void logoutAdmin()
                  .catch(() => undefined)
                  .then(() => setAuthenticated(false));
              }}
            >
              退出
            </Button>,
          ]}
        >
          <PageContainer title={titles[route]}>
            <Suspense fallback={<Spin tip="正在加载页面…" />}>
              {content}
            </Suspense>
          </PageContainer>
        </ProLayout>
      </AntApp>
    </ConfigProvider>
  );
}

export function ForbiddenResult() {
  return (
    <Result
      status="403"
      title="没有管理员权限"
      subTitle="请使用已提升为 ADMIN 的账号登录。"
    />
  );
}
