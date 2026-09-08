import {
  AdminListFilesScopeEnum,
  AdminListFilesStatusEnum,
  type AdminFileResponse,
} from "@chat/admin-api-client";
import { ProTable, type ProColumns } from "@ant-design/pro-components";
import { Button, Descriptions, Drawer, Tag, Typography } from "antd";
import { useMemo, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const statuses = {
  PENDING: { text: "待上传", status: "Processing" },
  UPLOADED: { text: "已上传", status: "Processing" },
  READY: { text: "可用", status: "Success" },
  REJECTED: { text: "已拒绝", status: "Error" },
  DELETED: { text: "已删除", status: "Default" },
} as const;

const scopeLabels = {
  PRIVATE: "私有",
  DIRECT: "单聊",
  GROUP: "群聊",
} as const;

function readableBytes(value: string) {
  const size = Number(value);
  if (!Number.isFinite(size)) return value;
  const units = ["B", "KB", "MB", "GB", "TB"];
  let amount = size;
  let unit = 0;
  while (amount >= 1024 && unit < units.length - 1) {
    amount /= 1024;
    unit += 1;
  }
  return `${amount.toFixed(unit === 0 ? 0 : 1)} ${units[unit]}`;
}

function iso(value: unknown) {
  if (!value) return undefined;
  if (typeof value === "string") return new Date(value).toISOString();
  if (typeof value === "object" && "toISOString" in value)
    return (value as { toISOString(): string }).toISOString();
  return undefined;
}

export function FilesPage() {
  const loadPage = useCursorPagination<AdminFileResponse>();
  const [selected, setSelected] = useState<AdminFileResponse>();
  const columns = useMemo<ProColumns<AdminFileResponse>[]>(
    () => [
      { title: "文件名 / 用户", dataIndex: "search", hideInTable: true },
      {
        title: "文件名",
        dataIndex: "originalName",
        search: false,
        ellipsis: true,
      },
      {
        title: "所有者",
        search: false,
        render: (_, row) =>
          String(row.owner.nickname ?? row.owner.username ?? row.ownerUserId),
      },
      {
        title: "大小",
        dataIndex: "sizeBytes",
        search: false,
        render: (_, row) => readableBytes(row.sizeBytes),
      },
      {
        title: "范围",
        dataIndex: "scope",
        valueType: "select",
        valueEnum: {
          PRIVATE: { text: "私有" },
          DIRECT: { text: "单聊" },
          GROUP: { text: "群聊" },
        },
      },
      {
        title: "状态",
        dataIndex: "status",
        valueType: "select",
        valueEnum: statuses,
      },
      { title: "用途", dataIndex: "purpose", search: false },
      {
        title: "创建时间",
        dataIndex: "createdAt",
        valueType: "dateTime",
        search: false,
      },
      {
        title: "创建时间",
        dataIndex: "createdAtRange",
        valueType: "dateTimeRange",
        hideInTable: true,
      },
      {
        title: "操作",
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
      <ProTable<AdminFileResponse>
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        request={async (params) => {
          const range = params.createdAtRange as unknown[] | undefined;
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListFiles({
              cursor,
              limit,
              search: params.search as string | undefined,
              scope: params.scope as AdminListFilesScopeEnum | undefined,
              status: params.status as AdminListFilesStatusEnum | undefined,
              from: iso(range?.[0]),
              to: iso(range?.[1]),
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="文件详情"
        width={600}
        open={Boolean(selected)}
        onClose={() => setSelected(undefined)}
      >
        {selected && (
          <Descriptions column={1} bordered size="small">
            <Descriptions.Item label="文件名">
              {selected.originalName}
            </Descriptions.Item>
            <Descriptions.Item label="文件 ID">
              <Typography.Text copyable>{selected.id}</Typography.Text>
            </Descriptions.Item>
            <Descriptions.Item label="状态">
              <Tag>{statuses[selected.status]?.text ?? selected.status}</Tag>
            </Descriptions.Item>
            <Descriptions.Item label="MIME 类型">
              {selected.mimeType}
            </Descriptions.Item>
            <Descriptions.Item label="大小">
              {readableBytes(selected.sizeBytes)} ({selected.sizeBytes} 字节)
            </Descriptions.Item>
            <Descriptions.Item label="所有者 ID">
              <Typography.Text copyable>{selected.ownerUserId}</Typography.Text>
            </Descriptions.Item>
            <Descriptions.Item label="范围目标">
              {scopeLabels[selected.scope]} / {selected.scopeId ?? "—"}
            </Descriptions.Item>
            <Descriptions.Item label="SHA-256">
              <Typography.Text copyable>
                {selected.sha256 ?? "—"}
              </Typography.Text>
            </Descriptions.Item>
            <Descriptions.Item label="缩略图 ID">
              {selected.thumbnailFileId ?? "—"}
            </Descriptions.Item>
            <Descriptions.Item label="创建时间">
              {new Date(selected.createdAt).toLocaleString()}
            </Descriptions.Item>
            <Descriptions.Item label="上传完成">
              {selected.uploadedAt
                ? new Date(selected.uploadedAt).toLocaleString()
                : "—"}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>
    </>
  );
}
