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
  request('/auth/login', { method: 'POST', status: 201, body: { username, password, deviceId } });
const alice = await login('alice_test', 'secure-password-123', 'join-smoke-alice');
const bob = await login('bob_test', 'secure-password-456', 'join-smoke-bob');
const group = await request('/groups', {
  method: 'POST', status: 201, token: alice.accessToken,
  body: { name: `Join Flow ${Date.now()}`, memberIds: [] },
});

const application = await request(`/groups/${group.id}/join-requests`, {
  method: 'POST', status: 201, token: bob.accessToken, body: { message: 'Please add me' },
});
await request(`/groups/${group.id}/join-requests`, {
  method: 'POST', status: 409, token: bob.accessToken, body: {},
});
const pending = await request(`/groups/${group.id}/join-requests`, { token: alice.accessToken });
if (!pending.some((item) => item.id === application.id)) throw new Error('Application not visible');
await request(`/groups/join-requests/${application.id}/approve`, {
  method: 'POST', status: 201, token: alice.accessToken,
});
await request(`/groups/${group.id}/leave`, { method: 'POST', status: 201, token: bob.accessToken });

const invitation = await request(`/groups/${group.id}/invitations`, {
  method: 'POST', status: 201, token: alice.accessToken,
  body: { userId: bob.user.id, message: 'Come back' },
});
await request(`/groups/${group.id}/invitations`, {
  method: 'POST', status: 409, token: alice.accessToken, body: { userId: bob.user.id },
});
const count = await request('/groups/join-requests/pending-count', { token: bob.accessToken });
if (count.count < 1) throw new Error('Pending invitation count was not updated');
await request(`/groups/join-requests/${invitation.id}/reject`, {
  method: 'POST', status: 201, token: bob.accessToken, body: { message: 'Not now' },
});

const acceptedInvitation = await request(`/groups/${group.id}/invitations`, {
  method: 'POST', status: 201, token: alice.accessToken, body: { userId: bob.user.id },
});
await request(`/groups/join-requests/${acceptedInvitation.id}/approve`, {
  method: 'POST', status: 201, token: bob.accessToken,
});
await request(`/groups/${group.id}/leave`, { method: 'POST', status: 201, token: bob.accessToken });
const cancelled = await request(`/groups/${group.id}/join-requests`, {
  method: 'POST', status: 201, token: bob.accessToken, body: {},
});
await request(`/groups/join-requests/${cancelled.id}/cancel`, {
  method: 'POST', status: 201, token: bob.accessToken,
});
await request(`/groups/${group.id}`, { method: 'DELETE', token: alice.accessToken });

console.log(JSON.stringify({ ok: true, apply: true, invite: true, reject: true, cancel: true }));
