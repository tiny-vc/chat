import { MessageFilled } from "@ant-design/icons";
import { appName } from "../branding";

export function BrandMark({ size = 34 }: { size?: number }) {
  return (
    <span
      className="brand-mark"
      style={{ width: size, height: size, fontSize: Math.round(size * 0.48) }}
      role="img"
      aria-label={appName}
    >
      <MessageFilled />
    </span>
  );
}
