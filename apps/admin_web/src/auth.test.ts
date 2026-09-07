import { beforeEach, describe, expect, it, vi } from "vitest";
import { adminDeviceId, authStore } from "./auth";

describe("admin auth storage", () => {
  beforeEach(() => {
    sessionStorage.clear();
    localStorage.clear();
  });

  it("keeps access tokens in the current browser session only", () => {
    authStore.write({ accessToken: "access", refreshToken: "refresh" });
    expect(authStore.read()).toEqual({
      accessToken: "access",
      refreshToken: "refresh",
    });
    authStore.clear();
    expect(authStore.read()).toBeNull();
  });

  it("rejects malformed stored sessions", () => {
    sessionStorage.setItem("chat.admin.session", "{bad json");
    expect(authStore.read()).toBeNull();
  });

  it("reuses a stable installation device id", () => {
    vi.spyOn(crypto, "randomUUID").mockReturnValue(
      "00000000-0000-4000-8000-000000000001",
    );
    expect(adminDeviceId()).toBe(
      "admin-web-00000000-0000-4000-8000-000000000001",
    );
    expect(adminDeviceId()).toBe(
      "admin-web-00000000-0000-4000-8000-000000000001",
    );
  });
});
