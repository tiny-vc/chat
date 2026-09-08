import { fireEvent, render, screen } from "@testing-library/react";
import { beforeEach, describe, expect, it, vi } from "vitest";
import { PageErrorBoundary } from "./PageErrorBoundary";

describe("PageErrorBoundary", () => {
  beforeEach(() =>
    vi.spyOn(console, "error").mockImplementation(() => undefined),
  );

  it("contains a page failure and can retry", () => {
    let broken = true;
    function BrokenPage() {
      if (broken) throw new Error("page failed");
      return <div>页面正常</div>;
    }
    render(
      <PageErrorBoundary resetKey="users">
        <BrokenPage />
      </PageErrorBoundary>,
    );

    expect(screen.getByText("页面加载失败")).toBeTruthy();
    broken = false;
    fireEvent.click(screen.getByRole("button", { name: "重试当前页面" }));
    expect(screen.getByText("页面正常")).toBeTruthy();
  });
});
