const sessionKey = "chat.admin.session";
const deviceKey = "chat.admin.device_id";

export type AdminSession = { accessToken: string; refreshToken: string };

export const authStore = {
  read(): AdminSession | null {
    const value = sessionStorage.getItem(sessionKey);
    if (!value) return null;
    try {
      const parsed = JSON.parse(value) as Partial<AdminSession>;
      return typeof parsed.accessToken === "string" &&
        typeof parsed.refreshToken === "string"
        ? { accessToken: parsed.accessToken, refreshToken: parsed.refreshToken }
        : null;
    } catch {
      return null;
    }
  },
  write: (session: AdminSession) =>
    sessionStorage.setItem(sessionKey, JSON.stringify(session)),
  clear: () => sessionStorage.removeItem(sessionKey),
};

export function adminDeviceId() {
  const existing = localStorage.getItem(deviceKey);
  if (existing) return existing;
  const created = `admin-web-${crypto.randomUUID()}`;
  localStorage.setItem(deviceKey, created);
  return created;
}
