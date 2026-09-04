const baseUrl = process.env.SMOKE_API_URL ?? "http://localhost:3000/api/v1";

async function request(path, { method = "GET", token, body } = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { "content-type": "application/json" } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await response.text();
  if (!response.ok)
    throw new Error(`${method} ${path}: ${response.status} ${text}`);
  return text ? JSON.parse(text) : undefined;
}

const credentials = { username: "alice_test", password: "secure-password-123" };
const first = await request("/auth/login", {
  method: "POST",
  body: {
    ...credentials,
    deviceId: "multi-device-a",
    deviceType: "APP",
    deviceName: "Multi Device A",
  },
});
const second = await request("/auth/login", {
  method: "POST",
  body: {
    ...credentials,
    deviceId: "multi-device-b",
    deviceType: "APP",
    deviceName: "Multi Device B",
  },
});

if (first.im.token !== second.im.token) {
  throw new Error(
    "same user/device flag received credentials that invalidate reconnects",
  );
}
const devices = await request("/auth/devices", { token: second.accessToken });
for (const id of ["multi-device-a", "multi-device-b"]) {
  if (!devices.some((device) => device.deviceId === id)) {
    throw new Error(`active session missing: ${id}`);
  }
}

await request("/auth/logout", { method: "POST", token: first.accessToken });
await request("/auth/logout", { method: "POST", token: second.accessToken });
console.log(
  JSON.stringify({ ok: true, stableImCredentials: true, sessions: 2 }),
);
