import { describe, expect, it } from "vitest";
import { hrefForRoute, routeFromHash } from "./routing";

describe("management routes", () => {
  it("reads supported hash routes", () => {
    expect(routeFromHash("#/reports")).toBe("reports");
    expect(routeFromHash("#users")).toBe("users");
    expect(routeFromHash("#/settings")).toBe("settings");
  });

  it("falls back safely for unknown routes", () => {
    expect(routeFromHash("#/not-a-page")).toBe("overview");
    expect(routeFromHash("")).toBe("overview");
  });

  it("creates shareable route links", () => {
    expect(hrefForRoute("calls")).toBe("#/calls");
    expect(hrefForRoute("settings")).toBe("#/settings");
  });
});
