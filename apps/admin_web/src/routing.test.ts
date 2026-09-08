import { describe, expect, it } from "vitest";
import { hrefForRoute, routeFromPath } from "./routing";

describe("management routes", () => {
  it("reads supported history routes", () => {
    expect(routeFromPath("/reports")).toBe("reports");
    expect(routeFromPath("/users/")).toBe("users");
    expect(routeFromPath("/settings")).toBe("settings");
  });

  it("falls back safely for unknown routes", () => {
    expect(routeFromPath("/not-a-page")).toBe("overview");
    expect(routeFromPath("/")).toBe("overview");
  });

  it("creates shareable route links", () => {
    expect(hrefForRoute("calls")).toBe("/calls");
    expect(hrefForRoute("settings")).toBe("/settings");
  });
});
