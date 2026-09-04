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

const session = await request('/auth/login', {
  method: 'POST', status: 201,
  body: { username: 'alice_test', password: 'secure-password-123', deviceId: 'media-smoke' },
});
const token = session.accessToken;
const bytes = new Uint8Array([137, 80, 78, 71, 13, 10, 26, 10]);
const before = await request('/files/usage', { token });
const upload = await request('/files/uploads', {
  method: 'POST', status: 201, token,
  body: {
    fileName: 'avatar.png', mimeType: 'image/png', size: bytes.length,
    purpose: 'AVATAR', scope: 'PRIVATE',
  },
});
const uploaded = await fetch(upload.uploadUrl, {
  method: upload.method, headers: upload.headers, body: bytes,
});
if (!uploaded.ok) throw new Error(`Avatar upload failed: ${uploaded.status}`);
await request(`/files/${upload.fileId}/complete`, { method: 'POST', status: 201, token });
await request('/users/me/avatar', {
  method: 'PUT', token, body: { fileId: upload.fileId },
});
const me = await request('/users/me', { token });
if (me.avatarFileId !== upload.fileId) throw new Error('Avatar was not bound');
await request(`/files/${upload.fileId}`, { method: 'DELETE', token, status: 409 });
await request('/users/me/avatar', { method: 'DELETE', token });
await request(`/files/${upload.fileId}`, { method: 'DELETE', token });
const after = await request('/files/usage', { token });
if (before.usedBytes !== after.usedBytes) throw new Error('Deleted avatar still consumes quota');

console.log(JSON.stringify({ ok: true, avatarBound: true, protectedWhileBound: true }));
