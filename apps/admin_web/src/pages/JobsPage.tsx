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
import { App, Button, Popconfirm, Tag } from "antd";
import { useRef, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const colors: Record<JobRunResponseStatusEnum, string> = {
  RUNNING: "processing",
  SUCCESS: "success",
  FAILED: "error",
  SKIPPED: "default",
};

export function JobsPage() {
  const loadPage = useCursorPagination<JobRunResponse>();
  const actionRef = useRef<ActionType | undefined>(undefined);
  const [running, setRunning] = useState(false);
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
      render: (_, row) => <Tag color={colors[row.status]}>{row.status}</Tag>,
    },
    { title: "触发方式", dataIndex: "trigger", search: false },
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
    { title: "错误", dataIndex: "error", ellipsis: true, search: false },
  ];
  return (
    <ProTable<JobRunResponse>
      actionRef={actionRef}
      rowKey="id"
      columns={columns}
      pagination={cursorPagination}
      search={{ labelWidth: "auto" }}
      toolBarRender={() => [
        <Popconfirm
          key="cleanup"
          title="确认立即执行清理？任务会删除过期上传和过期会话记录。"
          onConfirm={() => {
            void runCleanup();
          }}
        >
          <Button type="primary" loading={running}>
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
  );
}
