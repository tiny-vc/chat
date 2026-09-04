const baseUrl = process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1';

async function request(path, method, token, body, expectedStatus = 200) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'content-type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await response.text();
  if (response.status !== expectedStatus) {
    throw new Error(`${method} ${path}: expected ${expectedStatus}, got ${response.status} ${text}`);
  }
  return text ? JSON.parse(text) : undefined;
}

const login = (username, password) =>
  request('/auth/login', 'POST', undefined, { username, password }, 201);

const alice = await login('alice_test', 'secure-password-123');
const bob = await login('bob_test', 'secure-password-456');

try {
  await request('/conversations/settings', 'PATCH', alice.accessToken, {
    channelId: bob.user.id,
    channelType: 1,
    pinned: true,
    muted: true,
  });
  const settings = await request('/conversations/settings', 'GET', alice.accessToken);
  if (!settings.some((item) => item.channelId === bob.user.id && item.pinned && item.muted)) {
    throw new Error('Conversation setting was not persisted');
  }

  await request(`/blocks/${bob.user.id}`, 'POST', alice.accessToken, undefined, 201);
  const blocks = await request('/blocks', 'GET', alice.accessToken);
  if (!blocks.some((item) => item.user.id === bob.user.id)) throw new Error('Block was not persisted');
  await request(
    '/calls',
    'POST',
    alice.accessToken,
    { targetUserId: bob.user.id, type: 'AUDIO' },
    403,
  );
} finally {
  await request(`/blocks/${bob.user.id}`, 'DELETE', alice.accessToken).catch(() => undefined);
  await request(`/conversations/settings/1/${bob.user.id}`, 'DELETE', alice.accessToken).catch(
    () => undefined,
  );
}

console.log(JSON.stringify({ ok: true, restored: true }));
