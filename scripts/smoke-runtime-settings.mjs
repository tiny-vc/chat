const api = process.env.SMOKE_API_URL ?? "http://127.0.0.1:3000/api/v1";

async function request(path, options = {}) {
  const response = await fetch(`${api}${path}`, {
    method: options.method ?? "GET",
    headers: {
      ...(options.token ? { authorization: `Bearer ${options.token}` } : {}),
      ...(options.body ? { "content-type": "application/json" } : {}),
    },
    ...(options.body ? { body: JSON.stringify(options.body) } : {}),
  });
  const text = await response.text();
  if (!response.ok) throw new Error(`${path}: ${response.status} ${text}`);
  return text ? JSON.parse(text) : undefined;
}

const login = await request("/auth/admin-login", {
  method: "POST",
  body: {
    username: process.env.SMOKE_ADMIN_USERNAME ?? "admin_smoke",
    password:
      process.env.SMOKE_ADMIN_PASSWORD ?? "secure-admin-password-123",
    deviceId: "runtime-settings-smoke",
    deviceType: "WEB",
    deviceName: "Runtime Settings Smoke",
  },
});
const token = login.accessToken;
const original = await request("/admin/runtime-settings", { token });
const updateBody = (messaging) => ({
  registrationEnabled: original.registrationEnabled,
  ...original.capabilities,
  messaging,
});

try {
  const disabled = await request("/admin/runtime-settings", {
    method: "PATCH",
    token,
    body: updateBody(false),
  });
  if (disabled.capabilities.messaging !== false)
    throw new Error("Messaging setting was not disabled");
  const publicInfo = await request("/server-info");
  if (publicInfo.capabilities.messaging !== false)
    throw new Error("Public capability did not reflect the disabled setting");
  const holdDisabledMs = Number(process.env.HOLD_DISABLED_MS ?? 0);
  if (holdDisabledMs > 0)
    await new Promise((resolve) => setTimeout(resolve, holdDisabledMs));
} finally {
  await request("/admin/runtime-settings", {
    method: "PATCH",
    token,
    body: updateBody(original.capabilities.messaging),
  });
}

console.log(JSON.stringify({ ok: true, restored: true }));
