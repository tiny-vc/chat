import {
  AdminReportResponseStatusEnum,
  AdminListReportsStatusEnum,
  DecideReportDtoStatusEnum,
  type AdminReportResponse,
} from "@chat/admin-api-client";
import {
  ProTable,
  type ActionType,
  type ProColumns,
} from "@ant-design/pro-components";
import {
  App,
  Button,
  Descriptions,
  Drawer,
  Input,
  Space,
  Tag,
  Typography,
} from "antd";
import { useRef, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const statuses = {
  PENDING: { text: "待处理", status: "Warning" },
  RESOLVED: { text: "已处理", status: "Success" },
  DISMISSED: { text: "已驳回", status: "Default" },
} as const;

export function ReportsPage() {
  const loadPage = useCursorPagination<AdminReportResponse>();
  const { message } = App.useApp();
  const actionRef = useRef<ActionType | undefined>(undefined);
  const [selected, setSelected] = useState<AdminReportResponse>();
  const [note, setNote] = useState("");
  const [deciding, setDeciding] = useState(false);

  const decide = async (status: DecideReportDtoStatusEnum) => {
    if (!selected) return;
    setDeciding(true);
    try {
      const response = await adminApi().adminDecideReport({
        reportId: selected.id,
        decideReportDto: { status, note: note.trim() || undefined },
      });
      setSelected(response.data);
      message.success(
        status === DecideReportDtoStatusEnum.Resolved
          ? "举报已处理"
          : "举报已驳回",
      );
      void actionRef.current?.reload();
    } catch {
      message.error("处理失败，举报状态未改变");
    } finally {
      setDeciding(false);
    }
  };

  const columns: ProColumns<AdminReportResponse>[] = [
    { title: "原因 / 用户", dataIndex: "search", hideInTable: true },
    { title: "原因", dataIndex: "reason", search: false },
    {
      title: "举报人",
      search: false,
      render: (_, row) =>
        String(row.reporter.nickname ?? row.reporter.username),
    },
    {
      title: "被举报人",
      search: false,
      render: (_, row) => String(row.target.nickname ?? row.target.username),
    },
    {
      title: "状态",
      dataIndex: "status",
      valueType: "select",
      valueEnum: statuses,
    },
    {
      title: "提交时间",
      dataIndex: "createdAt",
      valueType: "dateTime",
      search: false,
    },
    {
      title: "操作",
      valueType: "option",
      render: (_, row) => (
        <Button
          type="link"
          onClick={() => {
            setSelected(row);
            setNote(row.decisionNote ?? "");
          }}
        >
          查看
        </Button>
      ),
    },
  ];

  return (
    <>
      <ProTable<AdminReportResponse>
        actionRef={actionRef}
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        request={async (params) => {
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListReports({
              cursor,
              limit,
              status: params.status as AdminListReportsStatusEnum | undefined,
              search: params.search as string | undefined,
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="举报详情"
        width={620}
        open={Boolean(selected)}
        onClose={() => !deciding && setSelected(undefined)}
      >
        {selected && (
          <Space direction="vertical" size="large" style={{ width: "100%" }}>
            <Descriptions column={1} bordered size="small">
              <Descriptions.Item label="状态">
                <Tag>{statuses[selected.status]?.text}</Tag>
              </Descriptions.Item>
              <Descriptions.Item label="举报人">
                {String(
                  selected.reporter.nickname ?? selected.reporter.username,
                )}
                <Typography.Text copyable type="secondary">
                  {" "}
                  {selected.reporterUserId}
                </Typography.Text>
              </Descriptions.Item>
              <Descriptions.Item label="被举报人">
                {String(selected.target.nickname ?? selected.target.username)}
                <Typography.Text copyable type="secondary">
                  {" "}
                  {selected.targetUserId}
                </Typography.Text>
              </Descriptions.Item>
              <Descriptions.Item label="原因">
                {selected.reason}
              </Descriptions.Item>
              <Descriptions.Item label="说明">
                {selected.details || "—"}
              </Descriptions.Item>
              <Descriptions.Item label="提交时间">
                {new Date(selected.createdAt).toLocaleString()}
              </Descriptions.Item>
              {selected.decidedAt && (
                <Descriptions.Item label="处理时间">
                  {new Date(selected.decidedAt).toLocaleString()}
                </Descriptions.Item>
              )}
            </Descriptions>
            {selected.status === AdminReportResponseStatusEnum.Pending ? (
              <>
                <Input.TextArea
                  rows={4}
                  maxLength={500}
                  showCount
                  placeholder="填写处理备注（可选）"
                  value={note}
                  onChange={(event) => setNote(event.target.value)}
                />
                <Space>
                  <Button
                    type="primary"
                    loading={deciding}
                    onClick={() => {
                      void decide(DecideReportDtoStatusEnum.Resolved);
                    }}
                  >
                    标记已处理
                  </Button>
                  <Button
                    loading={deciding}
                    onClick={() => {
                      void decide(DecideReportDtoStatusEnum.Dismissed);
                    }}
                  >
                    驳回举报
                  </Button>
                </Space>
              </>
            ) : (
              <Typography.Paragraph>
                处理备注：{selected.decisionNote || "无"}
              </Typography.Paragraph>
            )}
          </Space>
        )}
      </Drawer>
    </>
  );
}
