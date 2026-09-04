const baseUrl = process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1';

async function request(path, options = {}) {
  const response = await fetch(`${baseUrl}${path}`, options);
  const text = await response.text();
  const body = text ? JSON.parse(text) : undefined;
  if (!response.ok) {
    throw new Error(`${options.method ?? 'GET'} ${path} failed: ${response.status} ${text}`);
  }
  return body;
}

const json = (method, token, body) => ({
  method,
  headers: {
    'content-type': 'application/json',
    ...(token ? { authorization: `Bearer ${token}` } : {}),
  },
  ...(body ? { body: JSON.stringify(body) } : {}),
});

const alice = await request(
  '/auth/login',
  json('POST', undefined, { username: 'alice_test', password: 'secure-password-123' }),
);
const bob = await request(
  '/auth/login',
  json('POST', undefined, { username: 'bob_test', password: 'secure-password-456' }),
);

let friendship;
const aliceFriends = await request('/friends', json('GET', alice.accessToken));
if (!aliceFriends.some((item) => item.user.id === bob.user.id)) {
  friendship = await request(
    '/friends/requests',
    json('POST', alice.accessToken, { userId: bob.user.id }),
  );
  await request(
    `/friends/requests/${friendship.id}/accept`,
    json('POST', bob.accessToken),
  );
}

const group = await request(
  '/groups',
  json('POST', alice.accessToken, { name: `Smoke ${Date.now()}`, memberIds: [bob.user.id] }),
);

const bytes = new TextEncoder().encode('smoke upload');
const upload = await request(
  '/files/uploads',
  json('POST', alice.accessToken, {
    fileName: 'smoke.txt',
    mimeType: 'text/plain',
    size: bytes.length,
    purpose: 'CHAT_FILE',
    scope: 'DIRECT',
    scopeId: bob.user.id,
  }),
);
const uploadResponse = await fetch(upload.uploadUrl, {
  method: upload.method,
  headers: upload.headers,
  body: bytes,
});
if (!uploadResponse.ok) throw new Error(`Object upload failed: ${uploadResponse.status}`);
await request(`/files/${upload.fileId}/complete`, json('POST', alice.accessToken));
await request(`/files/${upload.fileId}/download`, json('GET', bob.accessToken));

const call = await request(
  '/calls',
  json('POST', alice.accessToken, { targetUserId: bob.user.id, type: 'VIDEO' }),
);
await request(`/calls/${call.id}/accept`, json('POST', bob.accessToken));
await request(`/calls/${call.id}/token`, json('POST', alice.accessToken));
await request(`/calls/${call.id}/end`, json('POST', alice.accessToken));

console.log(
  JSON.stringify({
    ok: true,
    users: [alice.user.id, bob.user.id],
    groupId: group.id,
    fileId: upload.fileId,
    callId: call.id,
  }),
);
