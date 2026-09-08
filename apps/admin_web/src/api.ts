import {
  AdminApi,
  AuthApi,
  Configuration,
  HealthApi,
  UsersApi,
} from "@chat/admin-api-client";
import axios, { AxiosError, type InternalAxiosRequestConfig } from "axios";
import { authStore } from "./auth";

// Generated operation paths already contain /api/v1. Keep this as an optional
// origin (for example https://api.example.com), not another path prefix.
const basePath = (import.meta.env.VITE_API_ORIGIN || "").replace(/\/+$/, "");

export const publicAuthApi = new AuthApi(new Configuration({ basePath }));
const http = axios.create();
let refreshing: Promise<string> | undefined;

type RetryConfig = InternalAxiosRequestConfig & { _retried?: boolean };

async function refreshAccessToken() {
  const session = authStore.read();
  if (!session) throw new Error("No admin session");
  const response = await publicAuthApi.authRefresh({
    refreshTokenDto: { refreshToken: session.refreshToken },
  });
  authStore.write({
    accessToken: response.data.accessToken,
    refreshToken: response.data.refreshToken,
  });
  return response.data.accessToken;
}

http.interceptors.response.use(undefined, async (error: AxiosError) => {
  const config = error.config as RetryConfig | undefined;
  if (error.response?.status !== 401 || !config || config._retried) {
    throw error;
  }
  config._retried = true;
  try {
    refreshing ??= refreshAccessToken().finally(() => {
      refreshing = undefined;
    });
    const token = await refreshing;
    config.headers.set("Authorization", `Bearer ${token}`);
    return http.request(config);
  } catch {
    authStore.clear();
    window.dispatchEvent(new Event("chat-admin-session-expired"));
    throw error;
  }
});

function authenticatedConfig() {
  return new Configuration({
    basePath,
    accessToken: () => authStore.read()?.accessToken ?? "",
  });
}

export function adminApi() {
  return new AdminApi(authenticatedConfig(), basePath, http);
}

export function authenticatedAuthApi() {
  return new AuthApi(authenticatedConfig(), basePath, http);
}

export function usersApi() {
  return new UsersApi(authenticatedConfig(), basePath, http);
}

export function healthApi() {
  return new HealthApi(new Configuration({ basePath }), basePath, http);
}

export async function logoutAdmin() {
  try {
    await new AuthApi(authenticatedConfig(), basePath, http).authLogout();
  } finally {
    authStore.clear();
  }
}
