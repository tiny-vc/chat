import {
  JobRunResponseStatusEnum,
  type AdminListJobRunsStatusEnum,
  type JobRunResponse,
} from "@chat/admin-api-client";
import {
  ProTable,
  type ActionType,
  type ProColumns,
} from "@ant-design/pro-components";
import { ToolOutlined } from "@ant-design/icons";
import {
  Alert,
  App,
  Button,
  Descriptions,
  Drawer,
  Popconfirm,
  Space,
  Tag,
  Typography,
} from "antd";
import { useRef, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const colors: Record<JobRunResponseStatusEnum, string> = {
  RUNNING: "processing",
  SUCCESS: "success",
  FAILED: "error",
  SKIPPED: "default",
};

const statusLabels: Record<JobRunResponseStatusEnum, string> = {
  RUNNING: "运行中",
  SUCCESS: "成功",
  FAILED: "失败",
  SKIPPED: "已跳过",
};

const triggerLabels: Record<string, string> = {
  MANUAL: "管理员手动执行",
  SCHEDULED: "系统定时执行",
  STARTUP: "服务启动执行",
};

export function JobsPage() {
  const loadPage = useCursorPagination<JobRunResponse>();
  const actionRef = useRef<ActionType | undefined>(undefined);
  const [running, setRunning] = useState(false);
  const [selected, setSelected] = useState<JobRunResponse>();
  const { message } = App.useApp();

  async function runCleanup() {
    setRunning(true);
    try {
      await adminApi().adminRunCleanup();
      message.success("清理任务执行完成");
      void actionRef.current?.reload();
    } catch {
      message.error("清理任务执行失败，请查看服务日志");
    } finally {
      setRunning(false);
    }
  }

  const columns: ProColumns<JobRunResponse>[] = [
    { title: "任务", dataIndex: "jobName", search: false },
    {
      title: "状态",
      dataIndex: "status",
      valueType: "select",
      valueEnum: {
        RUNNING: { text: "运行中", status: "Processing" },
        SUCCESS: { text: "成功", status: "Success" },
        FAILED: { text: "失败", status: "Error" },
        SKIPPED: { text: "已跳过", status: "Default" },
      },
      render: (_, row) => (
        <Tag color={colors[row.status]}>{statusLabels[row.status]}</Tag>
      ),
    },
    {
      title: "触发方式",
      dataIndex: "trigger",
      search: false,
      render: (_, row) => triggerLabels[row.trigger] ?? row.trigger,
    },
    {
      title: "开始时间",
      dataIndex: "startedAt",
      valueType: "dateTime",
      search: false,
    },
    {
      title: "结束时间",
      dataIndex: "finishedAt",
      valueType: "dateTime",
      search: false,
    },
    {
      title: "错误",
      dataIndex: "error",
      ellipsis: true,
      search: false,
      render: (_, row) => row.error || "—",
    },
    {
      title: "操作",
      valueType: "option",
      render: (_, row) => (
        <Button type="link" onClick={() => setSelected(row)}>
          查看详情
        </Button>
      ),
    },
  ];
  return (
    <Space direction="vertical" size="large" style={{ width: "100%" }}>
      <Alert
        type="info"
        showIcon
        message="维护任务只清理已经过期的数据"
        description="手动执行会清理过期上传和过期会话记录，不会删除有效聊天文件或当前登录会话。每次执行结果都会保留在下方。"
      />
      <ProTable<JobRunResponse>
        actionRef={actionRef}
        rowKey="id"
        headerTitle="任务执行记录"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        toolBarRender={() => [
          <Popconfirm
            key="cleanup"
            title="确认立即执行清理？"
            description="任务会删除过期上传和过期会话记录。"
            onConfirm={() => {
              void runCleanup();
            }}
          >
            <Button type="primary" icon={<ToolOutlined />} loading={running}>
              立即执行清理
            </Button>
          </Popconfirm>,
        ]}
        request={async (params) => {
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListJobRuns({
              cursor,
              limit,
              status: params.status as AdminListJobRunsStatusEnum | undefined,
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="任务执行详情"
        width={600}
        open={Boolean(selected)}
        onClose={() => setSelected(undefined)}
      >
        {selected && (
          <Space direction="vertical" size="large" style={{ width: "100%" }}>
            <Descriptions column={1} bordered size="small">
              <Descriptions.Item label="任务">
                {selected.jobName}
              </Descriptions.Item>
              <Descriptions.Item label="状态">
                <Tag color={colors[selected.status]}>
                  {statusLabels[selected.status]}
                </Tag>
              </Descriptions.Item>
              <Descriptions.Item label="触发方式">
                {triggerLabels[selected.trigger] ?? selected.trigger}
              </Descriptions.Item>
              <Descriptions.Item label="开始时间">
                {new Date(selected.startedAt).toLocaleString()}
              </Descriptions.Item>
              <Descriptions.Item label="结束时间">
                {selected.finishedAt
                  ? new Date(selected.finishedAt).toLocaleString()
                  : "—"}
              </Descriptions.Item>
              <Descriptions.Item label="任务 ID">
                <Typography.Text copyable>{selected.id}</Typography.Text>
              </Descriptions.Item>
            </Descriptions>
            {selected.error && (
              <Alert
                type="error"
                showIcon
                message="执行错误"
                description={selected.error}
              />
            )}
            <div>
              <Typography.Title level={5}>执行指标</Typography.Title>
              <pre className="json-panel">
                {JSON.stringify(selected.metrics ?? {}, null, 2)}
              </pre>
            </div>
          </Space>
        )}
      </Drawer>
    </Space>
  );
}
