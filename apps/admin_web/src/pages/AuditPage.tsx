import type { AuditLogResponse } from "@chat/admin-api-client";
import { ProTable, type ProColumns } from "@ant-design/pro-components";
import { DownloadOutlined } from "@ant-design/icons";
import {
  Alert,
  Button,
  Descriptions,
  Drawer,
  Space,
  Tag,
  Typography,
} from "antd";
import type { Dayjs } from "dayjs";
import { useMemo, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const actionOptions = {
  LOGIN_SUCCESS: { text: "登录成功" },
  LOGIN_FAILED: { text: "登录失败" },
  PASSWORD_CHANGED: { text: "修改密码" },
  USER_SUSPEND: { text: "封禁用户" },
  USER_ACTIVATE: { text: "恢复用户" },
  DEVICE_SESSION_REVOKE_ADMIN: { text: "强制设备下线" },
  GROUP_POLICY_UPDATE: { text: "修改群组策略" },
};

const targetTypeOptions = {
  USER: { text: "用户" },
  DEVICE_SESSION: { text: "设备会话" },
  GROUP: { text: "群组" },
  AUTH: { text: "认证" },
};

function safeCsvCell(value: unknown) {
  let text = typeof value === "string" ? value : JSON.stringify(value ?? "");
  if (/^[=+\-@\t\r]/.test(text)) text = `'${text}`;
  return `"${text.replaceAll('"', '""')}"`;
}

function exportAuditLogs(items: AuditLogResponse[]) {
  const header = ["时间", "动作", "操作人ID", "目标类型", "目标ID", "元数据"];
  const rows = items.map((item) => [
    item.createdAt,
    item.action,
    item.actorUserId ?? "SYSTEM",
    item.targetType,
    item.targetId,
    item.metadata ?? {},
  ]);
  const csv = `\uFEFF${[header, ...rows]
    .map((row) => row.map(safeCsvCell).join(","))
    .join("\r\n")}`;
  const url = URL.createObjectURL(
    new Blob([csv], { type: "text/csv;charset=utf-8" }),
  );
  const link = document.createElement("a");
  link.href = url;
  link.download = `chat-audit-${new Date().toISOString().replaceAll(":", "-")}.csv`;
  link.click();
  URL.revokeObjectURL(url);
}

export function AuditPage() {
  const loadPage = useCursorPagination<AuditLogResponse>();
  const [selected, setSelected] = useState<AuditLogResponse>();
  const [loadedItems, setLoadedItems] = useState<AuditLogResponse[]>([]);
  const columns = useMemo<ProColumns<AuditLogResponse>[]>(
    () => [
      {
        title: "操作人",
        dataIndex: "actorUserId",
        ellipsis: true,
        render: (_, row) =>
          String(
            row.actor?.nickname ??
              row.actor?.username ??
              row.actorUserId ??
              "系统",
          ),
      },
      {
        title: "动作",
        dataIndex: "action",
        valueType: "select",
        valueEnum: actionOptions,
        copyable: true,
      },
      {
        title: "目标类型",
        dataIndex: "targetType",
        valueType: "select",
        valueEnum: targetTypeOptions,
      },
      {
        title: "目标 ID",
        dataIndex: "targetId",
        copyable: true,
        ellipsis: true,
      },
      {
        title: "时间",
        dataIndex: "createdAt",
        valueType: "dateTime",
        search: false,
      },
      {
        title: "发生时间",
        dataIndex: "createdAtRange",
        valueType: "dateTimeRange",
        hideInTable: true,
      },
      {
        title: "详情",
        valueType: "option",
        render: (_, row) => (
          <Button type="link" onClick={() => setSelected(row)}>
            查看
          </Button>
        ),
      },
    ],
    [],
  );
  return (
    <>
      <Alert
        showIcon
        type="info"
        message="审计日志记录管理与安全操作，不包含聊天消息正文。"
        description="当前表格最多返回最近 100 条匹配记录；导出只包含当前筛选结果。"
        style={{ marginBottom: 16 }}
      />
      <ProTable<AuditLogResponse>
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        toolBarRender={() => [
          <Button
            key="export"
            icon={<DownloadOutlined />}
            disabled={loadedItems.length === 0}
            onClick={() => exportAuditLogs(loadedItems)}
          >
            导出当前结果
          </Button>,
        ]}
        request={async (params) => {
          const range = params.createdAtRange as [Dayjs, Dayjs] | undefined;
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListAuditLogs({
              cursor,
              limit,
              action: params.action as string | undefined,
              targetType: params.targetType as string | undefined,
              targetId: params.targetId as string | undefined,
              actorUserId: params.actorUserId as string | undefined,
              from: range?.[0]?.toISOString(),
              to: range?.[1]?.toISOString(),
            });
            setLoadedItems(response.data.items);
            return response.data;
          });
        }}
      />
      <Drawer
        title="审计详情"
        width={560}
        open={Boolean(selected)}
        onClose={() => setSelected(undefined)}
      >
        {selected && (
          <>
            <Descriptions column={1} bordered size="small">
              <Descriptions.Item label="时间">
                {new Date(selected.createdAt).toLocaleString()}
              </Descriptions.Item>
              <Descriptions.Item label="动作">
                <Tag>{selected.action}</Tag>
              </Descriptions.Item>
              <Descriptions.Item label="操作人">
                <Space direction="vertical" size={0}>
                  <span>
                    {selected.actor?.nickname ??
                      selected.actor?.username ??
                      "系统"}
                  </span>
                  {selected.actorUserId && (
                    <Typography.Text copyable type="secondary">
                      {selected.actorUserId}
                    </Typography.Text>
                  )}
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label="目标类型">
                {selected.targetType}
              </Descriptions.Item>
              <Descriptions.Item label="目标 ID">
                <Typography.Text copyable>{selected.targetId}</Typography.Text>
              </Descriptions.Item>
            </Descriptions>
            <Typography.Title level={5}>元数据</Typography.Title>
            <pre className="json-panel">
              {JSON.stringify(selected.metadata ?? {}, null, 2)}
            </pre>
          </>
        )}
      </Drawer>
    </>
  );
}
