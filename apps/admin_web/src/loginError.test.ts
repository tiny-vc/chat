import { describe, expect, it } from "vitest";
import { describeAdminLoginFailure } from "./loginError";

describe("administrator login errors", () => {
  it("extracts a future lock deadline from a 429 response", () => {
    const now = Date.parse("2026-09-04T00:00:00.000Z");
    expect(
      describeAdminLoginFailure(
        {
          response: {
            status: 429,
            data: { details: { retryAfter: "2026-09-04T00:02:00.000Z" } },
          },
        },
        now,
      ),
    ).toEqual({
      message: "登录尝试过多，请稍后再试。",
      retryAt: now + 120_000,
    });
  });

  it("does not trust malformed or expired retry deadlines", () => {
    expect(
      describeAdminLoginFailure({
        response: { status: 429, data: { details: { retryAfter: "bad" } } },
      }).retryAt,
    ).toBeUndefined();
  });

  it("distinguishes credentials, network and server failures", () => {
    expect(
      describeAdminLoginFailure({ response: { status: 401 } }).message,
    ).toContain("管理员权限");
    expect(describeAdminLoginFailure(new Error("offline")).message).toContain(
      "无法连接",
    );
    expect(
      describeAdminLoginFailure({ response: { status: 500 } }).message,
    ).toContain("服务器");
  });
});
