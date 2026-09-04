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

for (let attempt = 0; attempt < 5; attempt += 1) {
  await request('/auth/login', {
    method: 'POST', status: 401,
    body: { username: 'rate_limit_probe', password: 'wrong-password-123' },
  });
}
await request('/auth/login', {
  method: 'POST', status: 429,
  body: { username: 'rate_limit_probe', password: 'wrong-password-123' },
});

const username = 'alice_test';
const originalPassword = 'secure-password-123';
const temporaryPassword = 'temporary-password-789';
let passwordChanged = false;

const login = (password, deviceId) =>
  request('/auth/login', {
    method: 'POST', status: 201,
    body: { username, password, deviceId, deviceType: 'APP', deviceName: deviceId },
  });

try {
  const current = await login(originalPassword, 'security-current');
  const other = await login(originalPassword, 'security-other');
  const changed = await request('/auth/change-password', {
    method: 'POST', status: 201, token: current.accessToken,
    body: { currentPassword: originalPassword, newPassword: temporaryPassword },
  });
  passwordChanged = true;
  if (changed.revokedSessions < 1) throw new Error('Other device was not revoked');
  await request('/users/me', { token: other.accessToken, status: 401 });

  const recovery = await login(temporaryPassword, 'security-recovery');
  await request('/auth/change-password', {
    method: 'POST', status: 201, token: recovery.accessToken,
    body: { currentPassword: temporaryPassword, newPassword: originalPassword },
  });
  passwordChanged = false;
  await request('/auth/logout-all', { method: 'POST', token: recovery.accessToken, status: 201 });
} finally {
  if (passwordChanged) {
    const recovery = await login(temporaryPassword, 'security-emergency-restore');
    await request('/auth/change-password', {
      method: 'POST', status: 201, token: recovery.accessToken,
      body: { currentPassword: temporaryPassword, newPassword: originalPassword },
    });
  }
}

console.log(JSON.stringify({ ok: true, rateLimited: true, passwordRestored: true }));
