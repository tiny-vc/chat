import {
  AdminUserResponseRoleEnum,
  AdminUserResponseStatusEnum,
  AdminListUsersRoleEnum,
  AdminListUsersStatusEnum,
  SetUserRoleDtoRoleEnum,
  type AdminDeviceSessionResponse,
  type AdminUserResponse,
} from "@chat/admin-api-client";
import {
  ProDescriptions,
  ProTable,
  type ActionType,
  type ProColumns,
} from "@ant-design/pro-components";
import { App, Button, Drawer, Popconfirm, Space, Tag } from "antd";
import dayjs from "dayjs";
import { useRef, useState } from "react";
import { adminApi } from "../api";
import { cursorPagination, useCursorPagination } from "../cursorPagination";

export function UsersPage() {
  const actionRef = useRef<ActionType | undefined>(undefined);
  const [selected, setSelected] = useState<AdminUserResponse>();
  const [detailLoading, setDetailLoading] = useState(false);
  const [revokingId, setRevokingId] = useState<string>();
  const [roleChangingId, setRoleChangingId] = useState<string>();
  const { message } = App.useApp();
  const loadPage = useCursorPagination<AdminUserResponse>();
  const loadDevicePage = useCursorPagination<AdminDeviceSessionResponse>();

  async function loadDetail(userId: string) {
    setDetailLoading(true);
    try {
      setSelected((await adminApi().adminGetUser({ userId })).data);
    } catch {
      message.error("用户详情加载失败");
    } finally {
      setDetailLoading(false);
    }
  }

  async function changeStatus(user: AdminUserResponse) {
    try {
      if (user.status === AdminUserResponseStatusEnum.Active)
        await adminApi().adminSuspendUser({ userId: user.id });
      else await adminApi().adminActivateUser({ userId: user.id });
      message.success(
        user.status === AdminUserResponseStatusEnum.Active
          ? "用户已封禁"
          : "用户已恢复",
      );
      void actionRef.current?.reload();
      if (selected?.id === user.id) await loadDetail(user.id);
    } catch {
      message.error("操作失败，用户状态未改变");
    }
  }

  async function changeRole(user: AdminUserResponse) {
    setRoleChangingId(user.id);
    try {
      const role =
        user.role === AdminUserResponseRoleEnum.Admin
          ? SetUserRoleDtoRoleEnum.User
          : SetUserRoleDtoRoleEnum.Admin;
      await adminApi().adminSetUserRole({
        userId: user.id,
        setUserRoleDto: { role },
      });
      message.success(
        role === SetUserRoleDtoRoleEnum.Admin
          ? "已设为管理员"
          : "已取消管理员权限",
      );
      void actionRef.current?.reload();
      if (selected?.id === user.id) await loadDetail(user.id);
    } catch {
      message.error("权限变更失败；不能修改自己或移除最后一个管理员");
    } finally {
      setRoleChangingId(undefined);
    }
  }

  async function revokeDevice(userId: string, sessionId: string) {
    setRevokingId(sessionId);
    try {
      await adminApi().adminRevokeUserDevice({ userId, sessionId });
      message.success("设备已下线");
      await loadDetail(userId);
    } catch {
      message.error("设备下线失败");
    } finally {
      setRevokingId(undefined);
    }
  }

  const columns: ProColumns<AdminUserResponse>[] = [
    { title: "用户名", dataIndex: "username", copyable: true },
    { title: "昵称", dataIndex: "nickname", search: false },
    {
      title: "角色",
      dataIndex: "role",
      valueType: "select",
      valueEnum: { USER: { text: "用户" }, ADMIN: { text: "管理员" } },
      render: (_, row) => (
        <Tag
          color={
            row.role === AdminUserResponseRoleEnum.Admin ? "purple" : "default"
          }
        >
          {row.role}
        </Tag>
      ),
    },
    {
      title: "状态",
      dataIndex: "status",
      valueType: "select",
      valueEnum: {
        ACTIVE: { text: "正常", status: "Success" },
        SUSPENDED: { text: "已封禁", status: "Error" },
        DELETED: { text: "已注销", status: "Default" },
      },
    },
    {
      title: "注册时间",
      dataIndex: "createdAt",
      valueType: "dateTime",
      search: false,
    },
    {
      title: "操作",
      valueType: "option",
      render: (_, row) => (
        <Space>
          <Button
            type="link"
            loading={detailLoading}
            onClick={() => {
              void loadDetail(row.id);
            }}
          >
            详情
          </Button>
          {row.status !== AdminUserResponseStatusEnum.Deleted && (
            <Popconfirm
              title={
                row.status === AdminUserResponseStatusEnum.Active
                  ? "确认封禁该用户？所有设备将立即下线。"
                  : "确认解除封禁？"
              }
              onConfirm={() => {
                void changeStatus(row);
              }}
            >
              <Button
                danger={row.status === AdminUserResponseStatusEnum.Active}
              >
                {row.status === AdminUserResponseStatusEnum.Active
                  ? "封禁"
                  : "恢复"}
              </Button>
            </Popconfirm>
          )}
          {row.status !== AdminUserResponseStatusEnum.Deleted && (
            <Popconfirm
              title={
                row.role === AdminUserResponseRoleEnum.Admin
                  ? "确认取消该账号的管理员权限？"
                  : "确认授予该账号管理员权限？"
              }
              description="角色变更会记录到审计日志。"
              onConfirm={() => {
                void changeRole(row);
              }}
            >
              <Button loading={roleChangingId === row.id}>
                {row.role === AdminUserResponseRoleEnum.Admin
                  ? "取消管理员"
                  : "设为管理员"}
              </Button>
            </Popconfirm>
          )}
        </Space>
      ),
    },
  ];

  return (
    <>
      <ProTable<AdminUserResponse>
        actionRef={actionRef}
        rowKey="id"
        columns={columns}
        pagination={cursorPagination}
        search={{ labelWidth: "auto" }}
        request={async (params) => {
          return loadPage(params, async (cursor, limit) => {
            const response = await adminApi().adminListUsers({
              cursor,
              limit,
              search: params.username as string | undefined,
              status: params.status as AdminListUsersStatusEnum | undefined,
              role: params.role as AdminListUsersRoleEnum | undefined,
            });
            return response.data;
          });
        }}
      />
      <Drawer
        title="用户详情"
        width={760}
        open={Boolean(selected)}
        onClose={() => !revokingId && setSelected(undefined)}
      >
        {selected && (
          <>
            <ProDescriptions
              column={2}
              dataSource={selected}
              columns={[
                { title: "用户名", dataIndex: "username", copyable: true },
                { title: "昵称", dataIndex: "nickname" },
                { title: "用户 ID", dataIndex: "id", copyable: true },
                { title: "角色", dataIndex: "role" },
                { title: "状态", dataIndex: "status" },
                {
                  title: "注册时间",
                  dataIndex: "createdAt",
                  valueType: "dateTime",
                },
                {
                  title: "加入群组",
                  render: () => selected._count?.groupMemberships ?? "—",
                },
                {
                  title: "文件数量",
                  render: () => selected._count?.files ?? "—",
                },
              ]}
            />
            <ProTable<AdminDeviceSessionResponse>
              key={selected.id}
              headerTitle="设备会话"
              rowKey="id"
              search={{ labelWidth: "auto" }}
              pagination={cursorPagination}
              options={false}
              request={(params) =>
                loadDevicePage(
                  { ...params, userId: selected.id },
                  async (cursor, limit) => {
                    const response = await adminApi().adminListUserDevices({
                      userId: selected.id,
                      cursor,
                      limit,
                      search: params.search as string | undefined,
                    });
                    return response.data;
                  },
                )
              }
              columns={[
                {
                  title: "设备 / IP",
                  dataIndex: "search",
                  hideInTable: true,
                },
                {
                  title: "设备",
                  render: (_, row) => row.deviceName || row.deviceId,
                },
                {
                  title: "类型",
                  dataIndex: "deviceType",
                  render: (_, row) => <Tag>{row.deviceType}</Tag>,
                },
                { title: "IP", dataIndex: "ipAddress", copyable: true },
                {
                  title: "最后活动",
                  dataIndex: "lastSeenAt",
                  valueType: "dateTime",
                },
                {
                  title: "状态",
                  render: (_, row) =>
                    row.revokedAt ? (
                      <Tag>已撤销</Tag>
                    ) : dayjs(row.expiresAt).isBefore(dayjs()) ? (
                      <Tag>已过期</Tag>
                    ) : (
                      <Tag color="green">有效</Tag>
                    ),
                },
                {
                  title: "操作",
                  valueType: "option",
                  render: (_, row) =>
                    !row.revokedAt && dayjs(row.expiresAt).isAfter(dayjs()) ? (
                      <Popconfirm
                        title="确认强制下线该设备？API 和 IM 连接都会被撤销。"
                        onConfirm={() => {
                          void revokeDevice(selected.id, row.id);
                        }}
                      >
                        <Button danger loading={revokingId === row.id}>
                          强制下线
                        </Button>
                      </Popconfirm>
                    ) : null,
                },
              ]}
            />
          </>
        )}
      </Drawer>
    </>
  );
}
