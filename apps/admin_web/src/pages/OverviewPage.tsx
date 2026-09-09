import { ProCard, StatisticCard } from "@ant-design/pro-components";
import type { AdminOverviewResponse } from "@chat/admin-api-client";
import {
  AlertOutlined,
  CheckCircleFilled,
  FileUnknownOutlined,
  PhoneOutlined,
  ReloadOutlined,
  TeamOutlined,
  UserAddOutlined,
  UserOutlined,
  WarningOutlined,
} from "@ant-design/icons";
import { Alert, Button, Skeleton, Space, Tag, Typography } from "antd";
import axios from "axios";
import { useEffect, useState } from "react";
import { adminApi, healthApi } from "../api";

type DependencyHealth = {
  status: "ok" | "error";
  latencyMs: number;
  message?: string;
};
type Readiness = {
  status: "ok" | "degraded";
  timestamp: string;
  dependencies: Record<string, DependencyHealth>;
};
const dependencyNames: Record<string, string> = {
  postgresql: "数据库",
  wukongim: "即时通信",
  livekit: "音视频服务",
  objectStorage: "文件存储",
};

export function OverviewPage() {
  const [data, setData] = useState<AdminOverviewResponse>();
  const [health, setHealth] = useState<Readiness>();
  const [error, setError] = useState(false);
  const load = async () => {
    setError(false);
    const [overviewResult, healthResult] = await Promise.allSettled([
      adminApi().adminOverview(),
      healthApi().healthGetReadiness(),
    ]);
    if (overviewResult.status === "fulfilled")
      setData(overviewResult.value.data);
    else setError(true);
    if (healthResult.status === "fulfilled") {
      setHealth(healthResult.value.data as Readiness);
    } else if (axios.isAxiosError(healthResult.reason)) {
      setHealth(healthResult.reason.response?.data as Readiness | undefined);
    }
  };
  useEffect(() => {
    void load();
  }, []);
  if (error)
    return (
      <Alert
        type="error"
        showIcon
        message="概览加载失败"
        action={<Button onClick={() => void load()}>重试</Button>}
      />
    );
  if (!data) return <Skeleton active />;
  const dependencies = health ? Object.values(health.dependencies) : [];
  const unhealthyCount = dependencies.filter(
    (item) => item.status !== "ok",
  ).length;
  const attentionCount =
    data.calls.failed24h +
    data.moderation.pendingReports +
    data.moderation.pendingGroupJoinRequests +
    data.moderation.abnormalFiles;
  return (
    <Space
      direction="vertical"
      size="large"
      style={{ width: "100%" }}
      className="overview-page"
    >
      <ProCard className="overview-hero">
        <div className="overview-hero-content">
          <div>
            <Typography.Text className="overview-eyebrow">
              实时运行概况
            </Typography.Text>
            <Typography.Title level={3}>系统运行总览</Typography.Title>
            <Typography.Paragraph type="secondary">
              集中查看用户、内容、通话与基础服务状态。
            </Typography.Paragraph>
          </div>
          <Space wrap>
            <Tag
              className="overview-status-tag"
              icon={
                unhealthyCount === 0 ? (
                  <CheckCircleFilled />
                ) : (
                  <WarningOutlined />
                )
              }
              color={unhealthyCount === 0 ? "success" : "error"}
            >
              {health
                ? unhealthyCount === 0
                  ? "全部服务正常"
                  : `${unhealthyCount} 项服务异常`
                : "状态读取中"}
            </Tag>
            <Button icon={<ReloadOutlined />} onClick={() => void load()}>
              刷新数据
            </Button>
          </Space>
        </div>
      </ProCard>

      <ProCard gutter={[14, 14]} wrap ghost className="overview-stat-grid">
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{ title: "用户总数", value: data.users.total }}
          chart={<UserOutlined className="stat-icon stat-icon-primary" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{ title: "24 小时新增", value: data.users.new24h }}
          chart={<UserAddOutlined className="stat-icon stat-icon-positive" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{ title: "群组总数", value: data.groups.total }}
          chart={<TeamOutlined className="stat-icon stat-icon-secondary" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{ title: "活跃通话", value: data.calls.active }}
          chart={<PhoneOutlined className="stat-icon stat-icon-info" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{ title: "24 小时失败通话", value: data.calls.failed24h }}
          chart={<WarningOutlined className="stat-icon stat-icon-warning" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{
            title: "待处理举报",
            value: data.moderation.pendingReports,
          }}
          chart={<AlertOutlined className="stat-icon stat-icon-danger" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{
            title: "待处理入群申请",
            value: data.moderation.pendingGroupJoinRequests,
          }}
          chart={<TeamOutlined className="stat-icon stat-icon-warning" />}
        />
        <StatisticCard
          colSpan={{ xs: 24, sm: 12, xl: 6 }}
          className="overview-stat-card"
          statistic={{
            title: "异常文件",
            value: data.moderation.abnormalFiles,
          }}
          chart={<FileUnknownOutlined className="stat-icon stat-icon-danger" />}
        />
      </ProCard>
      <ProCard
        title="服务状态"
        subTitle="业务依赖的实时可用性与响应延迟"
        gutter={[16, 16]}
        wrap
      >
        {health ? (
          Object.entries(health.dependencies).map(([name, item]) => (
            <ProCard
              key={name}
              bordered
              colSpan={{ xs: 24, sm: 12, lg: 6 }}
              className="service-health-card"
            >
              <div className="service-health-heading">
                <Typography.Text strong>
                  {dependencyNames[name] ?? name}
                </Typography.Text>
                <span
                  className={`health-dot ${item.status === "ok" ? "is-healthy" : "is-unhealthy"}`}
                  aria-label={item.status === "ok" ? "正常" : "异常"}
                />
              </div>
              <Typography.Text className="service-latency">
                {item.latencyMs}
                <small> ms</small>
              </Typography.Text>
              <Typography.Text type="secondary">当前响应延迟</Typography.Text>
            </ProCard>
          ))
        ) : (
          <Alert type="warning" showIcon message="暂时无法读取依赖服务状态" />
        )}
      </ProCard>
      {attentionCount > 0 && (
        <Typography.Text type="secondary" className="overview-footnote">
          当前共有 {attentionCount}{" "}
          项异常或待处理事项，请通过左侧对应模块进一步处理。
        </Typography.Text>
      )}
    </Space>
  );
}
