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
  const data = text ? JSON.parse(text) : undefined;
  if (options.status !== undefined && response.status !== options.status) {
    throw new Error(
      `${options.method ?? "GET"} ${path}: expected ${options.status}, got ${response.status} ${text}`,
    );
  }
  if (options.status === undefined && !response.ok) {
    throw new Error(`${options.method ?? "GET"} ${path}: ${response.status} ${text}`);
  }
  return { status: response.status, data };
}

async function assertDisabled(path, capability, options = {}) {
  const result = await request(path, { ...options, status: 503 });
  if (
    result.data?.code !== "CAPABILITY_DISABLED" ||
    result.data?.details?.capability !== capability
  ) {
    throw new Error(`${path}: missing disabled capability payload for ${capability}`);
  }
}

const admin = (
  await request("/auth/admin-login", {
    method: "POST",
    body: {
      username: process.env.SMOKE_ADMIN_USERNAME ?? "admin_smoke",
      password:
        process.env.SMOKE_ADMIN_PASSWORD ?? "secure-admin-password-123",
      deviceId: "runtime-enforcement-admin",
      deviceType: "WEB",
      deviceName: "Runtime Enforcement Smoke",
    },
  })
).data;
const user = (
  await request("/auth/login", {
    method: "POST",
    body: {
      username: "alice_test",
      password: "secure-password-123",
      deviceId: "runtime-enforcement-user",
      deviceType: "WEB",
      deviceName: "Runtime Enforcement User",
    },
  })
).data;
const original = (
  await request("/admin/runtime-settings", { token: admin.accessToken })
).data;
const originalBody = {
  registrationEnabled: original.registrationEnabled,
  ...original.capabilities,
};

try {
  await request("/admin/runtime-settings", {
    method: "PATCH",
    token: admin.accessToken,
    body: {
      registrationEnabled: false,
      messaging: false,
      files: false,
      groups: false,
      audioCalls: false,
      videoCalls: false,
    },
  });

  await assertDisabled("/auth/register", "registration", {
    method: "POST",
    body: {},
  });
  await assertDisabled("/messages/protocol/validate", "messaging", {
    method: "POST",
    token: user.accessToken,
    body: {},
  });
  await assertDisabled("/files/uploads", "files", {
    method: "POST",
    token: user.accessToken,
    body: {},
  });
  await assertDisabled("/groups", "groups", {
    method: "POST",
    token: user.accessToken,
    body: {},
  });
  await assertDisabled("/calls", "audioCalls", {
    method: "POST",
    token: user.accessToken,
    body: { type: "AUDIO" },
  });
  await assertDisabled("/calls", "videoCalls", {
    method: "POST",
    token: user.accessToken,
    body: { type: "VIDEO" },
  });

  await request("/groups", { token: user.accessToken, status: 200 });
  await request("/files/usage", { token: user.accessToken, status: 200 });
  await request("/calls", { token: user.accessToken, status: 200 });
} finally {
  await request("/admin/runtime-settings", {
    method: "PATCH",
    token: admin.accessToken,
    body: originalBody,
  });
}

console.log(
  JSON.stringify({
    ok: true,
    disabledCapabilitiesChecked: 6,
    readPathsChecked: 3,
    restored: true,
  }),
);
