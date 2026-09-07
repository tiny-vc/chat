import { afterEach, describe, expect, it, vi } from "vitest";
import { adminIdleTimeoutMs, startIdleSessionMonitor } from "./idleSession";

describe("administrator idle session", () => {
  afterEach(() => vi.useRealTimers());

  it("uses a bounded configuration with a 30 minute default", () => {
    expect(adminIdleTimeoutMs(undefined)).toBe(30 * 60_000);
    expect(adminIdleTimeoutMs("15")).toBe(15 * 60_000);
    expect(adminIdleTimeoutMs("0")).toBe(30 * 60_000);
    expect(adminIdleTimeoutMs("999")).toBe(30 * 60_000);
  });

  it("expires once after the configured idle period", () => {
    vi.useFakeTimers();
    const onIdle = vi.fn();
    const stop = startIdleSessionMonitor(onIdle, 1_000);
    vi.advanceTimersByTime(1_001);
    expect(onIdle).toHaveBeenCalledTimes(1);
    vi.advanceTimersByTime(10_000);
    expect(onIdle).toHaveBeenCalledTimes(1);
    stop();
  });

  it("resets the deadline after administrator activity", () => {
    vi.useFakeTimers();
    const onIdle = vi.fn();
    const stop = startIdleSessionMonitor(onIdle, 1_000);
    vi.advanceTimersByTime(800);
    window.dispatchEvent(new Event("pointerdown"));
    vi.advanceTimersByTime(800);
    expect(onIdle).not.toHaveBeenCalled();
    vi.advanceTimersByTime(201);
    expect(onIdle).toHaveBeenCalledTimes(1);
    stop();
  });
});
