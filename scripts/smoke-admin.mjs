const baseUrl = process.env.SMOKE_API_URL ?? "http://localhost:3000/api/v1";
const adminCredentials = {
  username: process.env.SMOKE_ADMIN_USERNAME ?? "admin_smoke",
  password: process.env.SMOKE_ADMIN_PASSWORD ?? "secure-admin-password-123",
};
const targetCredentials = {
  username: process.env.SMOKE_TARGET_USERNAME ?? "bob_test",
  password: process.env.SMOKE_TARGET_PASSWORD ?? "secure-password-456",
};

async function request(
  path,
  { method = "GET", token, body, status = 200 } = {},
) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { "content-type": "application/json" } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await response.text();
  if (response.status !== status) {
    throw new Error(
      `${method} ${path}: expected ${status}, got ${response.status} ${text}`,
    );
  }
  return text ? JSON.parse(text) : undefined;
}

const admin = await request("/auth/login", {
  method: "POST",
  status: 201,
  body: {
    ...adminCredentials,
    deviceId: "admin-smoke",
    deviceType: "WEB",
    deviceName: "Admin Smoke",
  },
});
const target = await request("/auth/login", {
  method: "POST",
  status: 201,
  body: {
    ...targetCredentials,
    deviceId: "admin-smoke-target",
    deviceType: "WEB",
    deviceName: "Revocation Target",
  },
});

const overview = await request("/admin/overview", { token: admin.accessToken });
if (overview.users.total < 2)
  throw new Error("Admin overview user count is incomplete");

const users = await request(
  `/admin/users?search=${encodeURIComponent(targetCredentials.username)}&limit=10`,
  {
    token: admin.accessToken,
  },
);
const targetUser = users.items.find((user) => user.id === target.user.id);
if (!targetUser)
  throw new Error("Target user was not returned by admin search");

const detail = await request(`/admin/users/${target.user.id}`, {
  token: admin.accessToken,
});
const targetDevice = detail.deviceSessions.find(
  (device) => device.deviceId === "admin-smoke-target",
);
if (!targetDevice)
  throw new Error("Temporary target device was not returned by user detail");
await request(`/admin/users/${target.user.id}/devices/${targetDevice.id}`, {
  method: "DELETE",
  token: admin.accessToken,
});
await request("/users/me", { token: target.accessToken, status: 401 });

const groups = await request("/admin/groups?status=ACTIVE&limit=10", {
  token: admin.accessToken,
});
if (groups.items[0]) {
  await request(`/admin/groups/${groups.items[0].id}/policy`, {
    method: "PATCH",
    token: admin.accessToken,
    body: { muteAll: true },
  });
  await request(`/admin/groups/${groups.items[0].id}/policy`, {
    method: "PATCH",
    token: admin.accessToken,
    body: { muteAll: false },
  });
}

const audit = await request("/admin/audit-logs?limit=10", {
  token: admin.accessToken,
});
if (
  !audit.items.some((item) => item.action === "DEVICE_SESSION_REVOKE_ADMIN")
) {
  throw new Error(
    "Administrative device revocation audit log was not recorded",
  );
}
await request("/admin/jobs/runs?limit=10", { token: admin.accessToken });
await request("/admin/jobs/cleanup/run", {
  method: "POST",
  token: admin.accessToken,
  status: 201,
});

console.log(
  JSON.stringify({
    ok: true,
    overview: { users: overview.users.total, groups: overview.groups.total },
    targetUserId: target.user.id,
    revokedSessionId: targetDevice.id,
    groupPolicyChecked: Boolean(groups.items[0]),
  }),
);
