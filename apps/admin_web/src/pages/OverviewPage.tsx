import { ProCard, StatisticCard } from "@ant-design/pro-components";
import type { AdminOverviewResponse } from "@chat/admin-api-client";
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
  postgresql: "PostgreSQL",
  wukongim: "WuKongIM",
  livekit: "LiveKit",
  objectStorage: "对象存储",
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
  return (
    <Space direction="vertical" size="large" style={{ width: "100%" }}>
      <ProCard gutter={[16, 16]} wrap>
        <StatisticCard
          statistic={{ title: "用户总数", value: data.users.total }}
        />
        <StatisticCard
          statistic={{ title: "24 小时新增", value: data.users.new24h }}
        />
        <StatisticCard
          statistic={{ title: "群组总数", value: data.groups.total }}
        />
        <StatisticCard
          statistic={{ title: "活跃通话", value: data.calls.active }}
        />
        <StatisticCard
          statistic={{ title: "24 小时失败通话", value: data.calls.failed24h }}
        />
        <StatisticCard
          statistic={{
            title: "待处理举报",
            value: data.moderation.pendingReports,
          }}
        />
        <StatisticCard
          statistic={{
            title: "待处理入群申请",
            value: data.moderation.pendingGroupJoinRequests,
          }}
        />
        <StatisticCard
          statistic={{
            title: "异常文件",
            value: data.moderation.abnormalFiles,
          }}
        />
      </ProCard>
      <ProCard
        title="服务状态"
        extra={
          <Button size="small" onClick={() => void load()}>
            刷新
          </Button>
        }
        gutter={[16, 16]}
        wrap
      >
        {health ? (
          Object.entries(health.dependencies).map(([name, item]) => (
            <ProCard key={name} bordered colSpan={{ xs: 24, sm: 12, lg: 6 }}>
              <Space direction="vertical">
                <Typography.Text strong>
                  {dependencyNames[name] ?? name}
                </Typography.Text>
                <Tag color={item.status === "ok" ? "green" : "red"}>
                  {item.status === "ok" ? "正常" : "异常"}
                </Tag>
                <Typography.Text type="secondary">
                  延迟 {item.latencyMs} ms
                </Typography.Text>
              </Space>
            </ProCard>
          ))
        ) : (
          <Alert type="warning" showIcon message="暂时无法读取依赖服务状态" />
        )}
      </ProCard>
    </Space>
  );
}
