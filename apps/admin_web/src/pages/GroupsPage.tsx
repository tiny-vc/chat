import {
  AdminGroupMemberResponseRoleEnum,
  AdminGroupResponseStatusEnum,
  type AdminGroupMemberResponse,
  type AdminGroupResponse,
  type AdminListGroupsStatusEnum,
} from "@chat/admin-api-client";
import {
  ProDescriptions,
  ProTable,
  type ActionType,
  type ProColumns,
} from "@ant-design/pro-components";
import { App, Button, Drawer, Popconfirm, Space, Switch, Tag } from "antd";
import { useRef, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

const statusLabels = {
  ACTIVE: { text: "正常", color: "green" },
  SUSPENDED: { text: "已停用", color: "red" },
  DISBANDED: { text: "已解散", color: "default" },
} as const;

const memberRoleLabels = {
  OWNER: "群主",
  ADMIN: "管理员",
  MEMBER: "成员",
} as const;
const memberStatusLabels = {
  ACTIVE: "正常",
  LEFT: "已退出",
  REMOVED: "已移除",
} as const;

export function GroupsPage() {
  const loadPage = useCursorPagination<AdminGroupResponse>();
  const actionRef = useRef<ActionType | undefined>(undefined);
  const [selected, setSelected] = useState<AdminGroupResponse>();
  const [working, setWorking] = useState(false);
  const { message } = App.useApp();

  async function updatePolicy(
    group: AdminGroupResponse,
    policy: { suspended?: boolean; muteAll?: boolean },
  ) {
    setWorking(true);
    try {
      const response = await adminApi().adminSetGroupPolicy({
        groupId: group.id,
        setGroupPolicyDto: policy,
      });
      setSelected(response.data);
      void actionRef.current?.reload();
      message.success("群组策略已更新");
    } catch {
      message.error("操作失败，群组状态未改变");
    } finally {
      setWorking(false);
    }
  }

  const columns: ProColumns<AdminGroupResponse>[] = [
    { title: "群名称", dataIndex: "name", ellipsis: true },
    {
      title: "群 ID",
      dataIndex: "id",
      copyable: true,
      ellipsis: true,
      search: false,
    },
    {
      title: "成员",
      search: false,
      render: (_, row) => row._count?.members ?? "—",
    },
    {
      title: "全员禁言",
      dataIndex: "muteAll",
      search: false,
      render: (_, row) =>
        row.muteAll ? <Tag color="orange">已开启</Tag> : <Tag>关闭</Tag>,
    },
    {
      title: "状态",
      dataIndex: "status",
      valueType: "select",
      valueEnum: {
        ACTIVE: { text: "正常", status: "Success" },
        SUSPENDED: { text: "已停用", status: "Error" },
        DISBANDED: { text: "已解散", status: "Default" },
      },
      render: (_, row) => (
        <Tag color={statusLabels[row.status].color}>
          {statusLabels[row.status].text}
        </Tag>
      ),
    },
    {
      title: "创建时间",
      dataIndex: "createdAt",
      valueType: "dateTime",
      search: false,
    },
    {
      title: "操作",
      valueType: "option",
      render: (_, row) => (
        <Button type="link" onClick={() => setSelected(row)}>
          查看与管理
        </Button>
      ),
    },
  ];

  return (
    <>
      <ProTable<AdminGroupResponse>
        actionRef={actionRef}
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        request={async (params) => {
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListGroups({
              cursor,
              limit,
              search: params.name as string | undefined,
              status: params.status as AdminListGroupsStatusEnum | undefined,
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="群组详情"
        width={720}
        open={Boolean(selected)}
        onClose={() => !working && setSelected(undefined)}
        destroyOnClose
      >
        {selected && (
          <>
            <ProDescriptions
              column={{ xs: 1, sm: 2 }}
              dataSource={selected}
              columns={[
                { title: "群名称", dataIndex: "name" },
                { title: "群 ID", dataIndex: "id", copyable: true },
                {
                  title: "群主",
                  render: () =>
                    String(
                      selected.owner?.nickname ??
                        selected.owner?.username ??
                        selected.ownerId,
                    ),
                },
                { title: "成员上限", dataIndex: "memberLimit" },
                {
                  title: "状态",
                  render: () => statusLabels[selected.status].text,
                },
                {
                  title: "创建时间",
                  dataIndex: "createdAt",
                  valueType: "dateTime",
                },
              ]}
            />
            {selected.status !== AdminGroupResponseStatusEnum.Disbanded && (
              <Space wrap className="policy-actions">
                <span>全员禁言</span>
                <Switch
                  checked={selected.muteAll}
                  loading={working}
                  disabled={
                    working ||
                    selected.status !== AdminGroupResponseStatusEnum.Active
                  }
                  onChange={(muteAll) => {
                    void updatePolicy(selected, { muteAll });
                  }}
                />
                <Popconfirm
                  title={
                    selected.status === AdminGroupResponseStatusEnum.Active
                      ? "确认停用该群？群成员将无法继续发送消息。"
                      : "确认恢复该群？"
                  }
                  onConfirm={() => {
                    void updatePolicy(selected, {
                      suspended:
                        selected.status === AdminGroupResponseStatusEnum.Active,
                    });
                  }}
                >
                  <Button
                    danger={
                      selected.status === AdminGroupResponseStatusEnum.Active
                    }
                    loading={working}
                  >
                    {selected.status === AdminGroupResponseStatusEnum.Active
                      ? "停用群组"
                      : "恢复群组"}
                  </Button>
                </Popconfirm>
              </Space>
            )}
            <MemberTable groupId={selected.id} />
          </>
        )}
      </Drawer>
    </>
  );
}

function MemberTable({ groupId }: { groupId: string }) {
  const loadPage = useCursorPagination<AdminGroupMemberResponse>();
  const columns: ProColumns<AdminGroupMemberResponse>[] = [
    {
      title: "用户",
      render: (_, row) =>
        String(row.user.nickname ?? row.user.username ?? row.userId),
    },
    {
      title: "角色",
      dataIndex: "role",
      render: (_, row) => (
        <Tag
          color={
            row.role === AdminGroupMemberResponseRoleEnum.Owner
              ? "purple"
              : row.role === AdminGroupMemberResponseRoleEnum.Admin
                ? "blue"
                : "default"
          }
        >
          {memberRoleLabels[row.role]}
        </Tag>
      ),
    },
    {
      title: "状态",
      dataIndex: "status",
      render: (_, row) => memberStatusLabels[row.status],
    },
    { title: "加入时间", dataIndex: "joinedAt", valueType: "dateTime" },
  ];
  return (
    <ProTable<AdminGroupMemberResponse>
      headerTitle="群成员"
      rowKey="userId"
      columns={columns}
      search={false}
      pagination={cursorPagination}
      options={{ density: false, setting: false }}
      request={(params) =>
        loadPage({ ...params, groupId }, async (cursor, limit) => {
          const response = await adminApi().adminListGroupMembers({
            groupId,
            cursor,
            limit,
          });
          return response.data;
        })
      }
    />
  );
}
