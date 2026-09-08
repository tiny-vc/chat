import {
  DesktopOutlined,
  MoonOutlined,
  SunOutlined,
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
  Dropdown,
  Result,
  Spin,
  Tooltip,
  theme,
} from "antd";
import { lazy, Suspense, useEffect, useState } from "react";
import { adminApi, logoutAdmin } from "./api";
import { authStore } from "./auth";
import { LoginPage } from "./pages/LoginPage";
import { hrefForRoute, routeFromPath, type RouteKey } from "./routing";
import { startIdleSessionMonitor } from "./idleSession";
import { BrandMark } from "./components/BrandMark";
import { PageErrorBoundary } from "./components/PageErrorBoundary";
import { NetworkStatus } from "./components/NetworkStatus";
import { AccountMenu } from "./components/AccountMenu";

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

const descriptions: Record<RouteKey, string> = {
  overview: "查看核心业务指标与依赖服务健康状态",
  users: "管理用户状态、管理员权限与登录设备",
  groups: "查看群组成员并调整群组运行策略",
  calls: "查询语音、视频通话记录和连接结果",
  files: "追踪上传文件的归属、用途与处理状态",
  reports: "审核用户举报并记录处理结论",
  audit: "追溯管理员和系统执行的关键操作",
  jobs: "查看维护任务执行记录并按需手动触发",
  settings: "控制客户端公开能力和服务降级策略",
};

type ThemeMode = "system" | "light" | "dark";

const themeModeLabels: Record<ThemeMode, string> = {
  system: "跟随系统",
  light: "浅色模式",
  dark: "深色模式",
};

function readThemeMode(): ThemeMode {
  const saved = window.localStorage.getItem("chat-admin-theme");
  return saved === "light" || saved === "dark" ? saved : "system";
}

function ThemeSwitcher({
  mode,
  onChange,
}: {
  mode: ThemeMode;
  onChange: (mode: ThemeMode) => void;
}) {
  const icon =
    mode === "dark" ? (
      <MoonOutlined />
    ) : mode === "light" ? (
      <SunOutlined />
    ) : (
      <DesktopOutlined />
    );
  return (
    <Dropdown
      trigger={["click"]}
      menu={{
        selectedKeys: [mode],
        onClick: ({ key }) => onChange(key as ThemeMode),
        items: [
          { key: "system", icon: <DesktopOutlined />, label: "跟随系统" },
          { key: "light", icon: <SunOutlined />, label: "浅色模式" },
          { key: "dark", icon: <MoonOutlined />, label: "深色模式" },
        ],
      }}
    >
      <Tooltip title={`外观：${themeModeLabels[mode]}`}>
        <Button
          type="text"
          icon={icon}
          aria-label={`切换外观，当前${themeModeLabels[mode]}`}
        />
      </Tooltip>
    </Dropdown>
  );
}

export function App() {
  const [themeMode, setThemeMode] = useState<ThemeMode>(readThemeMode);
  const [systemDark, setSystemDark] = useState(
    () => window.matchMedia("(prefers-color-scheme: dark)").matches,
  );
  const dark = themeMode === "dark" || (themeMode === "system" && systemDark);

  useEffect(() => {
    const media = window.matchMedia("(prefers-color-scheme: dark)");
    const update = () => setSystemDark(media.matches);
    media.addEventListener("change", update);
    return () => media.removeEventListener("change", update);
  }, []);

  useEffect(() => {
    window.localStorage.setItem("chat-admin-theme", themeMode);
    document.documentElement.dataset.theme = dark ? "dark" : "light";
    document.documentElement.style.colorScheme = dark ? "dark" : "light";
    document
      .querySelector('meta[name="theme-color"]')
      ?.setAttribute("content", dark ? "#121116" : "#6750a4");
  }, [dark, themeMode]);

  return (
    <ConfigProvider
      theme={{
        algorithm: dark ? theme.darkAlgorithm : theme.defaultAlgorithm,
        token: {
          colorPrimary: "#6750a4",
          borderRadius: 10,
          fontFamily:
            'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
        },
      }}
    >
      <AntApp>
        <NetworkStatus />
        <AppContent themeMode={themeMode} onThemeModeChange={setThemeMode} />
      </AntApp>
    </ConfigProvider>
  );
}

function AppContent({
  themeMode,
  onThemeModeChange,
}: {
  themeMode: ThemeMode;
  onThemeModeChange: (mode: ThemeMode) => void;
}) {
  const [authenticated, setAuthenticated] = useState(Boolean(authStore.read()));
  const [checking, setChecking] = useState(authenticated);
  const [loginNotice, setLoginNotice] = useState<string>();
  const [settingsDirty, setSettingsDirty] = useState(false);
  const { modal } = AntApp.useApp();
  const [route, setRoute] = useState<RouteKey>(() =>
    routeFromPath(window.location.pathname),
  );

  useEffect(() => {
    const updateRoute = () => {
      const nextRoute = routeFromPath(window.location.pathname);
      setRoute(nextRoute);
      const canonicalPath = hrefForRoute(nextRoute);
      if (window.location.pathname !== canonicalPath || window.location.hash) {
        window.history.replaceState(null, "", canonicalPath);
      }
    };
    window.addEventListener("popstate", updateRoute);
    updateRoute();
    return () => {
      window.removeEventListener("popstate", updateRoute);
    };
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
      <div className="login-shell">
        <div className="login-theme-switcher">
          <ThemeSwitcher mode={themeMode} onChange={onThemeModeChange} />
        </div>
        <LoginPage
          notice={loginNotice}
          onSuccess={() => {
            setLoginNotice(undefined);
            setChecking(true);
            setAuthenticated(true);
          }}
        />
      </div>
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
      <SettingsPage onDirtyChange={setSettingsDirty} />
    ) : (
      <OverviewPage />
    );
  return (
    <ProLayout
      title="Chat 管理平台"
      logo={<BrandMark />}
      layout="mix"
      contentWidth="Fluid"
      fixedHeader
      breakpoint="lg"
      route={{
        routes: [
          { path: "/overview", name: "概览", icon: <DashboardOutlined /> },
          { path: "/users", name: "用户管理", icon: <TeamOutlined /> },
          {
            path: "/groups",
            name: "群组管理",
            icon: <UsergroupAddOutlined />,
          },
          { path: "/calls", name: "通话管理", icon: <PhoneOutlined /> },
          { path: "/files", name: "文件管理", icon: <FolderOpenOutlined /> },
          {
            path: "/reports",
            name: "举报处理",
            icon: <SafetyCertificateOutlined />,
          },
          { path: "/audit", name: "审计日志", icon: <AuditOutlined /> },
          { path: "/jobs", name: "后台任务", icon: <ToolOutlined /> },
          {
            path: "/settings",
            name: "运行配置",
            icon: <SettingOutlined />,
          },
        ],
      }}
      location={{ pathname: `/${route}` }}
      menuItemRender={(item, dom) => {
        const nextRoute = routeFromPath(item.path ?? "");
        const href = hrefForRoute(nextRoute);
        const navigate = () => {
          setRoute(nextRoute);
          if (window.location.pathname !== href) {
            window.history.pushState(null, "", href);
          }
        };
        return (
          <a
            href={href}
            onClick={(event) => {
              event.preventDefault();
              if (
                route === "settings" &&
                settingsDirty &&
                nextRoute !== "settings"
              ) {
                modal.confirm({
                  title: "放弃未保存的配置？",
                  content: "离开此页面后，尚未保存的修改将丢失。",
                  okText: "放弃并离开",
                  okButtonProps: { danger: true },
                  cancelText: "继续编辑",
                  onOk: navigate,
                });
                return;
              }
              navigate();
            }}
          >
            {dom}
          </a>
        );
      }}
      actionsRender={() => [
        <ThemeSwitcher
          key="theme"
          mode={themeMode}
          onChange={onThemeModeChange}
        />,
        <AccountMenu
          key="logout"
          onLogout={() => {
            void logoutAdmin()
              .catch(() => undefined)
              .then(() => setAuthenticated(false));
          }}
        />,
      ]}
    >
      <PageContainer
        title={titles[route]}
        subTitle={descriptions[route]}
        className="admin-page-container"
      >
        <PageErrorBoundary resetKey={route}>
          <Suspense
            fallback={
              <div className="page-loading-state">
                <Spin size="large" tip="正在加载页面…" />
              </div>
            }
          >
            {content}
          </Suspense>
        </PageErrorBoundary>
      </PageContainer>
    </ProLayout>
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
