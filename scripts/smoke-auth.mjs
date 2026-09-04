const baseUrl = process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1';

async function request(path, { method = 'GET', token, body, status = 200 } = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'content-type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await response.text();
  if (response.status !== status) {
    throw new Error(`${method} ${path}: expected ${status}, got ${response.status} ${text}`);
  }
  return text ? JSON.parse(text) : undefined;
}

const credentials = { username: 'alice_test', password: 'secure-password-123' };
const first = await request('/auth/login', {
  method: 'POST', status: 201,
  body: { ...credentials, deviceId: 'auth-smoke-app', deviceType: 'APP', deviceName: 'Smoke App' },
});
const refreshed = await request('/auth/refresh', {
  method: 'POST', status: 201, body: { refreshToken: first.refreshToken },
});
await request('/auth/refresh', {
  method: 'POST', status: 401, body: { refreshToken: first.refreshToken },
});

const second = await request('/auth/login', {
  method: 'POST', status: 201,
  body: { ...credentials, deviceId: 'auth-smoke-web', deviceType: 'WEB', deviceName: 'Smoke Web' },
});
const devices = await request('/auth/devices', { token: refreshed.accessToken });
const web = devices.find((device) => device.deviceId === 'auth-smoke-web');
if (!web || !devices.some((device) => device.current)) throw new Error('Device list is incomplete');

await request(`/auth/devices/${web.id}`, {
  method: 'DELETE', token: refreshed.accessToken,
});
await request('/users/me', { token: second.accessToken, status: 401 });
await request('/auth/logout', { method: 'POST', token: refreshed.accessToken, status: 201 });
await request('/users/me', { token: refreshed.accessToken, status: 401 });

console.log(JSON.stringify({ ok: true, refreshRotated: true, revokedDeviceRejected: true }));
