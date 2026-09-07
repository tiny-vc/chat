import type {
  MessagingPolicySyncDto,
  RuntimeSettingsResponseDto,
  UpdateRuntimeSettingsDto,
} from "@chat/admin-api-client";
import { MessagingPolicySyncDtoStatusEnum } from "@chat/admin-api-client";
import { ProCard } from "@ant-design/pro-components";
import {
  Alert,
  App,
  Button,
  Popconfirm,
  Skeleton,
  Space,
  Switch,
  Tag,
  Typography,
} from "antd";
import dayjs from "dayjs";
import { useEffect, useState } from "react";
import { adminApi } from "../api";

type SettingKey = keyof UpdateRuntimeSettingsDto;

const settingItems: Array<{
  key: SettingKey;
  title: string;
  description: string;
}> = [
  {
    key: "registrationEnabled",
    title: "开放用户注册",
    description: "关闭后，App 不再允许创建新账号。已有账号仍可登录。",
  },
  {
    key: "messaging",
    title: "文字与表情消息",
    description: "控制单聊和群聊中的消息发送能力。",
  },
  {
    key: "files",
    title: "图片与文件",
    description: "控制图片、视频附件和普通文件的上传与发送入口。",
  },
  {
    key: "groups",
    title: "群组功能",
    description: "控制创建群组、邀请成员和群组管理入口。",
  },
  {
    key: "audioCalls",
    title: "音频通话",
    description: "控制发起新的语音通话；不应中断已经建立的通话。",
  },
  {
    key: "videoCalls",
    title: "视频通话",
    description: "控制发起新的视频通话；关闭时仍可保留语音通话。",
  },
];

export function editableSettings(
  value: RuntimeSettingsResponseDto,
): UpdateRuntimeSettingsDto {
  return {
    registrationEnabled: value.registrationEnabled,
    messaging: value.capabilities.messaging,
    files: value.capabilities.files,
    groups: value.capabilities.groups,
    audioCalls: value.capabilities.audioCalls,
    videoCalls: value.capabilities.videoCalls,
  };
}

export function settingsChanged(
  saved: UpdateRuntimeSettingsDto,
  draft: UpdateRuntimeSettingsDto,
) {
  return settingItems.some(({ key }) => saved[key] !== draft[key]);
}

export function SettingsPage() {
  const [saved, setSaved] = useState<UpdateRuntimeSettingsDto>();
  const [draft, setDraft] = useState<UpdateRuntimeSettingsDto>();
  const [updatedAt, setUpdatedAt] = useState<string>();
  const [messagingPolicy, setMessagingPolicy] =
    useState<MessagingPolicySyncDto>();
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [loadError, setLoadError] = useState(false);
  const { message } = App.useApp();

  async function load() {
    setLoading(true);
    setLoadError(false);
    try {
      const response = await adminApi().adminGetRuntimeSettings();
      const next = editableSettings(response.data);
      setSaved(next);
      setDraft(next);
      setUpdatedAt(response.data.updatedAt);
      setMessagingPolicy(response.data.messagingPolicy);
    } catch {
      setLoadError(true);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void load();
  }, []);

  async function save() {
    if (!draft) return;
    setSaving(true);
    try {
      const response = await adminApi().adminUpdateRuntimeSettings({
        updateRuntimeSettingsDto: draft,
      });
      const next = editableSettings(response.data);
      setSaved(next);
      setDraft(next);
      setUpdatedAt(response.data.updatedAt);
      setMessagingPolicy(response.data.messagingPolicy);
      message.success("运行配置已保存");
    } catch {
      message.error("保存失败，服务器配置未改变");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <Skeleton active paragraph={{ rows: 8 }} />;
  if (loadError || !saved || !draft) {
    return (
      <Alert
        type="error"
        showIcon
        message="运行配置加载失败"
        description="未读取到服务器当前值，为避免覆盖配置，页面已禁止编辑。"
        action={<Button onClick={() => void load()}>重试</Button>}
      />
    );
  }

  const dirty = settingsChanged(saved, draft);
  return (
    <Space direction="vertical" size="large" style={{ width: "100%" }}>
      <Alert
        type="warning"
        showIcon
        message="关闭能力会影响所有 App 用户"
        description="请在维护或故障降级时使用。保存后 App 会在刷新服务器信息时更新入口，业务 API 也会拒绝新操作；关闭消息还会轮换活跃终端的 WuKongIM 凭据并断开现有连接。"
      />
      <ProCard title="WuKongIM 消息策略同步状态">
        <Space wrap>
          <Tag
            color={
              messagingPolicy?.status === MessagingPolicySyncDtoStatusEnum.Synced
                ? "green"
                : messagingPolicy?.status === MessagingPolicySyncDtoStatusEnum.Failed
                  ? "red"
                  : "processing"
            }
          >
            {messagingPolicy?.status === MessagingPolicySyncDtoStatusEnum.Synced
              ? "已生效"
              : messagingPolicy?.status === MessagingPolicySyncDtoStatusEnum.Failed
                ? "同步失败，等待重试"
                : "正在同步"}
          </Tag>
          <Typography.Text type="secondary">
            重试次数：{messagingPolicy?.attempts ?? 0}
          </Typography.Text>
          {messagingPolicy?.syncedAt && (
            <Typography.Text type="secondary">
              最近生效：
              {dayjs(messagingPolicy.syncedAt).format("YYYY-MM-DD HH:mm:ss")}
            </Typography.Text>
          )}
        </Space>
        {messagingPolicy?.lastError && (
          <Alert
            style={{ marginTop: 16 }}
            type="error"
            showIcon
            message="最近一次同步失败"
            description={messagingPolicy.lastError}
          />
        )}
      </ProCard>
      <ProCard gutter={[16, 16]} wrap>
        {settingItems.map((item) => (
          <ProCard
            key={item.key}
            bordered
            colSpan={{ xs: 24, md: 12, xl: 8 }}
          >
            <Space
              align="start"
              style={{ width: "100%", justifyContent: "space-between" }}
            >
              <Space direction="vertical" size={4}>
                <Typography.Text strong>{item.title}</Typography.Text>
                <Typography.Text type="secondary">
                  {item.description}
                </Typography.Text>
              </Space>
              <Switch
                aria-label={item.title}
                checked={draft[item.key]}
                disabled={saving}
                onChange={(checked) =>
                  setDraft((current) =>
                    current ? { ...current, [item.key]: checked } : current,
                  )
                }
              />
            </Space>
          </ProCard>
        ))}
      </ProCard>
      <ProCard>
        <Space wrap>
          <Popconfirm
            title="确认保存运行配置？"
            description="修改将对所有客户端生效，并记录到审计日志。"
            disabled={!dirty || saving}
            onConfirm={() => void save()}
          >
            <Button type="primary" disabled={!dirty} loading={saving}>
              保存配置
            </Button>
          </Popconfirm>
          <Button
            disabled={!dirty || saving}
            onClick={() => setDraft({ ...saved })}
          >
            放弃修改
          </Button>
          <Typography.Text type="secondary">
            上次更新：
            {updatedAt ? dayjs(updatedAt).format("YYYY-MM-DD HH:mm:ss") : "—"}
          </Typography.Text>
        </Space>
      </ProCard>
    </Space>
  );
}
