type LoginErrorResponse = {
  status?: number;
  data?: {
    details?: { retryAfter?: unknown };
  };
};

export type LoginFailure = {
  message: string;
  retryAt?: number;
};

export function describeAdminLoginFailure(
  error: unknown,
  now = Date.now(),
): LoginFailure {
  const response =
    error && typeof error === "object" && "response" in error
      ? (error as { response?: LoginErrorResponse }).response
      : undefined;
  if (!response) {
    return { message: "无法连接服务器，请检查网络和服务器状态。" };
  }
  if (response.status === 429) {
    const raw = response.data?.details?.retryAfter;
    const retryAt = typeof raw === "string" ? Date.parse(raw) : Number.NaN;
    return {
      message: "登录尝试过多，请稍后再试。",
      ...(Number.isFinite(retryAt) && retryAt > now ? { retryAt } : {}),
    };
  }
  if (response.status === 401 || response.status === 403) {
    return { message: "账号、密码或管理员权限不正确。" };
  }
  return { message: "登录失败，服务器暂时无法处理请求。" };
}
