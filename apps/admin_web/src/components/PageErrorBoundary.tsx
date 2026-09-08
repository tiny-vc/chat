import { ReloadOutlined } from "@ant-design/icons";
import { Button, Result, Space } from "antd";
import { Component, type ErrorInfo, type ReactNode } from "react";

type Props = {
  children: ReactNode;
  resetKey: string;
};

type State = {
  error?: Error;
};

export class PageErrorBoundary extends Component<Props, State> {
  state: State = {};

  static getDerivedStateFromError(error: Error): State {
    return { error };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    console.error("Management page failed to render", error, info);
  }

  componentDidUpdate(previous: Props) {
    if (previous.resetKey !== this.props.resetKey && this.state.error) {
      this.setState({ error: undefined });
    }
  }

  render() {
    if (!this.state.error) return this.props.children;
    return (
      <Result
        status="error"
        title="页面加载失败"
        subTitle="可能是网络暂时中断，或浏览器仍在使用旧版本资源。其他管理功能不会受到影响。"
        extra={
          <Space wrap>
            <Button onClick={() => this.setState({ error: undefined })}>
              重试当前页面
            </Button>
            <Button
              type="primary"
              icon={<ReloadOutlined />}
              onClick={() => window.location.reload()}
            >
              刷新管理平台
            </Button>
          </Space>
        }
      />
    );
  }
}
