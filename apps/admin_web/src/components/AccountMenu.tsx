import { LockOutlined, LogoutOutlined, UserOutlined } from "@ant-design/icons";
import type { UserResponse } from "@chat/admin-api-client";
import {
  App,
  Avatar,
  Button,
  Dropdown,
  Form,
  Input,
  Modal,
  Space,
  Typography,
} from "antd";
import { useEffect, useState } from "react";
import { authenticatedAuthApi, usersApi } from "../api";

type PasswordValues = {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
};

export function AccountMenu({ onLogout }: { onLogout: () => void }) {
  const [profile, setProfile] = useState<UserResponse>();
  const [passwordOpen, setPasswordOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form] = Form.useForm<PasswordValues>();
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
            { key: "password", icon: <LockOutlined />, label: "修改密码" },
            {
              key: "logout",
              icon: <LogoutOutlined />,
              label: "安全退出",
              danger: true,
            },
          ],
          onClick: ({ key }) => {
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
