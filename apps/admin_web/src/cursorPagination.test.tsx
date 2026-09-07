import { renderHook } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";
import { useCursorPagination } from "./cursorPagination";

describe("cursor pagination", () => {
  it("passes the next cursor to the following page", async () => {
    const { result } = renderHook(() => useCursorPagination<{ id: string }>());
    const fetchPage = vi
      .fn()
      .mockResolvedValueOnce({
        items: [{ id: "one" }],
        nextCursor: "cursor-one",
      })
      .mockResolvedValueOnce({ items: [{ id: "two" }], nextCursor: null });

    await result.current({ current: 1, pageSize: 1 }, fetchPage);
    const second = await result.current({ current: 2, pageSize: 1 }, fetchPage);

    expect(fetchPage).toHaveBeenNthCalledWith(1, undefined, 1);
    expect(fetchPage).toHaveBeenNthCalledWith(2, "cursor-one", 1);
    expect(second).toEqual({ data: [{ id: "two" }], success: true, total: 2 });
  });

  it("clears saved cursors when filters change", async () => {
    const { result } = renderHook(() => useCursorPagination<{ id: string }>());
    const fetchPage = vi
      .fn()
      .mockResolvedValue({ items: [], nextCursor: null });

    await result.current(
      { current: 1, pageSize: 30, status: "ACTIVE" },
      fetchPage,
    );
    await result.current(
      { current: 1, pageSize: 30, status: "SUSPENDED" },
      fetchPage,
    );

    expect(fetchPage).toHaveBeenLastCalledWith(undefined, 30);
  });
});
