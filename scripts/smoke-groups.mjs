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

const login = (username, password, deviceId) =>
  request('/auth/login', {
    method: 'POST', status: 201, body: { username, password, deviceId },
  });
const alice = await login('alice_test', 'secure-password-123', 'group-smoke-alice');
const bob = await login('bob_test', 'secure-password-456', 'group-smoke-bob');
const group = await request('/groups', {
  method: 'POST', status: 201, token: alice.accessToken,
  body: { name: `Managed ${Date.now()}`, memberIds: [bob.user.id] },
});

await request(`/groups/${group.id}/members/${bob.user.id}/role`, {
  method: 'PATCH', token: alice.accessToken, body: { role: 'ADMIN' },
});
await request(`/groups/${group.id}/members/${bob.user.id}/mute`, {
  method: 'PATCH', token: alice.accessToken, body: { muted: true, durationMinutes: 1 },
});
await request(`/groups/${group.id}/members/${bob.user.id}/mute`, {
  method: 'PATCH', token: alice.accessToken, body: { muted: false },
});
await request(`/groups/${group.id}/transfer-owner`, {
  method: 'POST', status: 201, token: alice.accessToken, body: { userId: bob.user.id },
});
await request(`/groups/${group.id}/transfer-owner`, {
  method: 'POST', status: 201, token: bob.accessToken, body: { userId: alice.user.id },
});

const bytes = new Uint8Array([137, 80, 78, 71, 13, 10, 26, 10]);
const upload = await request('/files/uploads', {
  method: 'POST', status: 201, token: alice.accessToken,
  body: {
    fileName: 'group-avatar.png', mimeType: 'image/png', size: bytes.length,
    purpose: 'AVATAR', scope: 'PRIVATE',
  },
});
const put = await fetch(upload.uploadUrl, { method: upload.method, headers: upload.headers, body: bytes });
if (!put.ok) throw new Error(`Group avatar upload failed: ${put.status}`);
await request(`/files/${upload.fileId}/complete`, { method: 'POST', status: 201, token: alice.accessToken });
const withAvatar = await request(`/groups/${group.id}/avatar`, {
  method: 'PUT', token: alice.accessToken, body: { fileId: upload.fileId },
});
if (withAvatar.avatarFileId !== upload.fileId) throw new Error('Group avatar was not bound');
await request(`/groups/${group.id}/avatar`, { method: 'DELETE', token: alice.accessToken });
await request(`/files/${upload.fileId}`, { method: 'DELETE', token: alice.accessToken });
await request(`/groups/${group.id}`, { method: 'DELETE', token: alice.accessToken });

console.log(JSON.stringify({ ok: true, roles: true, mute: true, transfer: true, avatar: true }));
