import {
  EditOutlined,
  LaptopOutlined,
  LockOutlined,
  LogoutOutlined,
  UserOutlined,
} from "@ant-design/icons";
import {
  DeviceSessionResponseDeviceTypeEnum,
  type DeviceSessionResponse,
  type UserResponse,
} from "@chat/admin-api-client";
import {
  App,
  Avatar,
  Button,
  Dropdown,
  Form,
  Input,
  List,
  Modal,
  Popconfirm,
  Space,
  Typography,
} from "antd";
import dayjs from "dayjs";
import { useEffect, useState } from "react";
import { authenticatedAuthApi, usersApi } from "../api";

type PasswordValues = {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
};
type ProfileValues = { nickname: string };

export function AccountMenu({ onLogout }: { onLogout: () => void }) {
  const [profile, setProfile] = useState<UserResponse>();
  const [passwordOpen, setPasswordOpen] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);
  const [devicesOpen, setDevicesOpen] = useState(false);
  const [devices, setDevices] = useState<DeviceSessionResponse[]>([]);
  const [devicesLoading, setDevicesLoading] = useState(false);
  const [revokingId, setRevokingId] = useState<string>();
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<PasswordValues>();
  const [profileForm] = Form.useForm<ProfileValues>();
  const { message } = App.useApp();

  useEffect(() => {
    usersApi()
      .usersGetMe()
      .then((response) => setProfile(response.data))
      .catch(() => undefined);
  }, []);

  async function changePassword(values: PasswordValues) {
    setSaving(true);
    try {
      await authenticatedAuthApi().authChangePassword({
        changePasswordDto: {
          currentPassword: values.currentPassword,
          newPassword: values.newPassword,
        },
      });
      message.success("密码已修改，其他设备已安全退出");
      form.resetFields();
      setPasswordOpen(false);
    } catch {
      message.error("密码修改失败，请检查当前密码和新密码");
    } finally {
      setSaving(false);
    }
  }

  async function updateProfile(values: ProfileValues) {
    setSaving(true);
    try {
      const response = await usersApi().usersUpdateMe({
        updateProfileDto: { nickname: values.nickname.trim() },
      });
      setProfile(response.data);
      message.success("管理员资料已更新");
      setProfileOpen(false);
    } catch {
      message.error("资料更新失败，请稍后重试");
    } finally {
      setSaving(false);
    }
  }

  async function openDevices() {
    setDevicesOpen(true);
    setDevicesLoading(true);
    try {
      const response = await authenticatedAuthApi().authDevices();
      setDevices(response.data);
    } catch {
      message.error("登录设备加载失败");
    } finally {
      setDevicesLoading(false);
    }
  }

  async function revokeDevice(sessionId: string) {
    setRevokingId(sessionId);
    try {
      await authenticatedAuthApi().authRevokeDevice({ sessionId });
      setDevices((current) => current.filter((item) => item.id !== sessionId));
      message.success("该设备已安全退出");
    } catch {
      message.error("设备退出失败，请稍后重试");
    } finally {
      setRevokingId(undefined);
    }
  }

  const name = profile?.nickname || profile?.username || "管理员";
  return (
    <>
      <Dropdown
        trigger={["click"]}
        menu={{
          items: [
            {
              key: "identity",
              disabled: true,
              label: (
                <div className="account-identity">
                  <Typography.Text strong>{name}</Typography.Text>
                  {profile?.username && (
                    <Typography.Text type="secondary">
                      @{profile.username}
                    </Typography.Text>
                  )}
                </div>
              ),
            },
            { type: "divider" },
            { key: "profile", icon: <EditOutlined />, label: "编辑资料" },
            { key: "devices", icon: <LaptopOutlined />, label: "登录设备" },
            { key: "password", icon: <LockOutlined />, label: "修改密码" },
            {
              key: "logout",
              icon: <LogoutOutlined />,
              label: "安全退出",
              danger: true,
            },
          ],
          onClick: ({ key }) => {
            if (key === "profile") {
              profileForm.setFieldsValue({ nickname: profile?.nickname ?? "" });
              setProfileOpen(true);
            }
            if (key === "devices") void openDevices();
            if (key === "password") setPasswordOpen(true);
            if (key === "logout") onLogout();
          },
        }}
      >
        <Button
          type="text"
          className="account-trigger"
          aria-label="管理员账号菜单"
        >
          <Space size={8}>
            <Avatar
              size={28}
              src={profile?.avatarUrl}
              icon={<UserOutlined />}
            />
            <span className="account-trigger-name">{name}</span>
          </Space>
        </Button>
      </Dropdown>
      <Modal
        title="编辑管理员资料"
        open={profileOpen}
        confirmLoading={saving}
        okText="保存资料"
        cancelText="取消"
        destroyOnHidden
        onCancel={() => !saving && setProfileOpen(false)}
        onOk={() => profileForm.submit()}
      >
        <Form<ProfileValues>
          form={profileForm}
          layout="vertical"
          requiredMark={false}
          onFinish={(values) => void updateProfile(values)}
        >
          <Form.Item label="用户名">
            <Input value={profile?.username ?? ""} disabled />
          </Form.Item>
          <Form.Item
            name="nickname"
            label="显示名称"
            rules={[
              { required: true, whitespace: true, message: "请输入显示名称" },
              { max: 80, message: "显示名称不能超过 80 个字符" },
            ]}
          >
            <Input maxLength={80} showCount autoComplete="nickname" />
          </Form.Item>
        </Form>
      </Modal>
      <Modal
        title="登录设备"
        open={devicesOpen}
        footer={null}
        width={640}
        onCancel={() => !revokingId && setDevicesOpen(false)}
      >
        <Typography.Paragraph type="secondary">
          撤销设备后，该设备的 API 会话和 WuKongIM 连接都会失效。
        </Typography.Paragraph>
        <List
          className="account-device-list"
          loading={devicesLoading}
          locale={{ emptyText: "没有其他登录设备" }}
          dataSource={devices}
          renderItem={(device) => (
            <List.Item
              actions={
                device.current
                  ? [
                      <Typography.Text key="current" type="success">
                        当前设备
                      </Typography.Text>,
                    ]
                  : [
                      <Popconfirm
                        key="revoke"
                        title="让该设备退出登录？"
                        description="该设备需要重新输入管理员账号和密码。"
                        okText="确认退出"
                        cancelText="取消"
                        onConfirm={() => void revokeDevice(device.id)}
                      >
                        <Button
                          danger
                          type="link"
                          loading={revokingId === device.id}
                        >
                          强制退出
                        </Button>
                      </Popconfirm>,
                    ]
              }
            >
              <List.Item.Meta
                avatar={<Avatar icon={<LaptopOutlined />} />}
                title={device.deviceName || "未命名设备"}
                description={
                  <Space direction="vertical" size={1}>
                    <Typography.Text type="secondary">
                      {device.deviceType ===
                      DeviceSessionResponseDeviceTypeEnum.App
                        ? "移动 App"
                        : device.deviceType ===
                            DeviceSessionResponseDeviceTypeEnum.Web
                          ? "网页"
                          : "桌面端"}
                      {device.ipAddress ? ` · ${device.ipAddress}` : ""}
                    </Typography.Text>
                    <Typography.Text type="secondary">
                      最近活动：
                      {dayjs(device.lastSeenAt).format("YYYY-MM-DD HH:mm:ss")}
                    </Typography.Text>
                  </Space>
                }
              />
            </List.Item>
          )}
        />
      </Modal>
      <Modal
        title="修改管理员密码"
        open={passwordOpen}
        confirmLoading={saving}
        okText="确认修改"
        cancelText="取消"
        destroyOnHidden
        onCancel={() => !saving && setPasswordOpen(false)}
        onOk={() => form.submit()}
      >
        <Typography.Paragraph type="secondary">
          修改成功后，其他设备上的管理会话和 IM 连接将被撤销，当前设备保持登录。
        </Typography.Paragraph>
        <Form<PasswordValues>
          form={form}
          layout="vertical"
          requiredMark={false}
          onFinish={(values) => void changePassword(values)}
        >
          <Form.Item
            name="currentPassword"
            label="当前密码"
            rules={[{ required: true, message: "请输入当前密码" }]}
          >
            <Input.Password autoComplete="current-password" />
          </Form.Item>
          <Form.Item
            name="newPassword"
            label="新密码"
            rules={[
              { required: true, message: "请输入新密码" },
              { min: 12, max: 72, message: "密码长度必须为 12–72 个字符" },
              ({ getFieldValue }) => ({
                validator(_, value: string) {
                  return !value || value !== getFieldValue("currentPassword")
                    ? Promise.resolve()
                    : Promise.reject(new Error("新密码不能与当前密码相同"));
                },
              }),
            ]}
          >
            <Input.Password autoComplete="new-password" />
          </Form.Item>
          <Form.Item
            name="confirmPassword"
            label="确认新密码"
            dependencies={["newPassword"]}
            rules={[
              { required: true, message: "请再次输入新密码" },
              ({ getFieldValue }) => ({
                validator(_, value: string) {
                  return !value || value === getFieldValue("newPassword")
                    ? Promise.resolve()
                    : Promise.reject(new Error("两次输入的新密码不一致"));
                },
              }),
            ]}
          >
            <Input.Password autoComplete="new-password" />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}
