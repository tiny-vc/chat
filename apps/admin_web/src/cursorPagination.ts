import { useRef } from "react";

type CursorPage<T> = { items: T[]; nextCursor?: string | null };
type TableParams = Record<string, unknown> & {
  current?: number;
  pageSize?: number;
};

export const cursorPagination = {
  defaultPageSize: 30,
  showSizeChanger: false,
  showQuickJumper: false,
};

export function useCursorPagination<T>() {
  const cursors = useRef(new Map<number, string | undefined>([[1, undefined]]));
  const fingerprint = useRef("");

  return async (
    params: TableParams,
    fetchPage: (
      cursor: string | undefined,
      limit: number,
    ) => Promise<CursorPage<T>>,
  ) => {
    const { current = 1, pageSize = 30, ...filters } = params;
    const nextFingerprint = JSON.stringify(filters);
    if (nextFingerprint !== fingerprint.current) {
      fingerprint.current = nextFingerprint;
      cursors.current = new Map([[1, undefined]]);
    }
    const cursor = cursors.current.get(current);
    if (current > 1 && !cursor) {
      return { data: [], success: false, total: (current - 1) * pageSize };
    }
    const result = await fetchPage(cursor, pageSize);
    if (result.nextCursor) cursors.current.set(current + 1, result.nextCursor);
    else cursors.current.delete(current + 1);
    return {
      data: result.items,
      success: true,
      total:
        (current - 1) * pageSize +
        result.items.length +
        (result.nextCursor ? 1 : 0),
    };
  };
}
