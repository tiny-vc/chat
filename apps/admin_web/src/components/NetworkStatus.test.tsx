import { act, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { NetworkStatus } from "./NetworkStatus";

describe("NetworkStatus", () => {
  it("shows offline and restored feedback", async () => {
    vi.useFakeTimers();
    render(<NetworkStatus />);

    await act(() => window.dispatchEvent(new Event("offline")));
    expect(screen.getByText(/当前设备已离线/)).toBeTruthy();

    await act(() => window.dispatchEvent(new Event("online")));
    expect(screen.getByText(/网络连接已恢复/)).toBeTruthy();

    await act(() => vi.advanceTimersByTime(3_000));
    expect(screen.queryByText(/网络连接已恢复/)).toBeNull();
    vi.useRealTimers();
  });
});
