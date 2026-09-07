import {
  AdminCallResponseTypeEnum,
  AdminListCallsStatusEnum,
  AdminListCallsTypeEnum,
  type AdminCallResponse,
} from "@chat/admin-api-client";
import { ProTable, type ProColumns } from "@ant-design/pro-components";
import { Button, Descriptions, Drawer, Tag, Typography } from "antd";
import { useMemo, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const statusOptions = {
  INVITING: { text: "邀请中", status: "Processing" },
  RINGING: { text: "响铃中", status: "Processing" },
  ACCEPTED: { text: "已接听", status: "Processing" },
  CONNECTED: { text: "通话中", status: "Success" },
  REJECTED: { text: "已拒绝", status: "Default" },
  CANCELLED: { text: "已取消", status: "Default" },
  MISSED: { text: "未接听", status: "Warning" },
  ENDED: { text: "已结束", status: "Success" },
  FAILED: { text: "失败", status: "Error" },
} as const;

function iso(value: unknown) {
  if (!value) return undefined;
  if (typeof value === "string") return new Date(value).toISOString();
  if (typeof value === "object" && "toISOString" in value) {
    return (value as { toISOString(): string }).toISOString();
  }
  return undefined;
}

function duration(row: AdminCallResponse) {
  if (!row.answeredAt || !row.endedAt) return "—";
  const seconds = Math.max(
    0,
    Math.round((Date.parse(row.endedAt) - Date.parse(row.answeredAt)) / 1000),
  );
  const minutes = Math.floor(seconds / 60);
  return minutes ? `${minutes} 分 ${seconds % 60} 秒` : `${seconds} 秒`;
}

export function CallsPage() {
  const loadPage = useCursorPagination<AdminCallResponse>();
  const [selected, setSelected] = useState<AdminCallResponse>();
  const columns = useMemo<ProColumns<AdminCallResponse>[]>(
    () => [
      {
        title: "类型",
        dataIndex: "type",
        valueType: "select",
        valueEnum: {
          AUDIO: { text: "语音" },
          VIDEO: { text: "视频" },
        },
        render: (_, row) => (
          <Tag
            color={
              row.type === AdminCallResponseTypeEnum.Video ? "purple" : "blue"
            }
          >
            {row.type === AdminCallResponseTypeEnum.Video ? "视频" : "语音"}
          </Tag>
        ),
      },
      {
        title: "状态",
        dataIndex: "status",
        valueType: "select",
        valueEnum: statusOptions,
      },
      {
        title: "参与者 / 群组",
        dataIndex: "participant",
        ellipsis: true,
        render: (_, row) =>
          row.groupId
            ? `群组 ${row.groupId}`
            : `${String(row.initiator.nickname ?? row.initiator.username ?? row.initiatorUserId)} → ${row.targetUserId ?? "—"}`,
      },
      {
        title: "开始时间",
        dataIndex: "startedAt",
        valueType: "dateTime",
        search: false,
      },
      {
        title: "持续时间",
        search: false,
        render: (_, row) => duration(row),
      },
      {
        title: "结束原因",
        dataIndex: "endReason",
        search: false,
        ellipsis: true,
        render: (_, row) => row.endReason || "—",
      },
      {
        title: "开始时间",
        dataIndex: "startedAtRange",
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
      <ProTable<AdminCallResponse>
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        request={async (params) => {
          const range = params.startedAtRange as unknown[] | undefined;
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListCalls({
              cursor,
              limit,
              type: params.type as AdminListCallsTypeEnum | undefined,
              status: params.status as AdminListCallsStatusEnum | undefined,
              participant: params.participant as string | undefined,
              from: iso(range?.[0]),
              to: iso(range?.[1]),
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="通话详情"
        width={600}
        open={Boolean(selected)}
        onClose={() => setSelected(undefined)}
      >
        {selected && (
          <Descriptions column={1} bordered size="small">
            <Descriptions.Item label="通话 ID">
              <Typography.Text copyable>{selected.id}</Typography.Text>
            </Descriptions.Item>
            <Descriptions.Item label="LiveKit 房间">
              <Typography.Text copyable>
                {selected.livekitRoomName}
              </Typography.Text>
            </Descriptions.Item>
            <Descriptions.Item label="发起者">
              {String(
                selected.initiator.nickname ??
                  selected.initiator.username ??
                  selected.initiatorUserId,
              )}
            </Descriptions.Item>
            <Descriptions.Item label="目标用户">
              {selected.targetUserId ?? "—"}
            </Descriptions.Item>
            <Descriptions.Item label="群组">
              {selected.groupId ?? "—"}
            </Descriptions.Item>
            <Descriptions.Item label="状态">
              {statusOptions[selected.status]?.text ?? selected.status}
            </Descriptions.Item>
            <Descriptions.Item label="开始">
              {new Date(selected.startedAt).toLocaleString()}
            </Descriptions.Item>
            <Descriptions.Item label="接听">
              {selected.answeredAt
                ? new Date(selected.answeredAt).toLocaleString()
                : "—"}
            </Descriptions.Item>
            <Descriptions.Item label="结束">
              {selected.endedAt
                ? new Date(selected.endedAt).toLocaleString()
                : "—"}
            </Descriptions.Item>
            <Descriptions.Item label="持续时间">
              {duration(selected)}
            </Descriptions.Item>
            <Descriptions.Item label="结束原因">
              {selected.endReason ?? "—"}
            </Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>
    </>
  );
}
