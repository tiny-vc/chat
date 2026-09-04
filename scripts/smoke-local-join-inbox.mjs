import assert from 'node:assert/strict';

// Requires isolated fixtures created by smoke-avatar.mjs; refuses non-loopback APIs.
const run = process.env.AVATAR_RUN;
assert.match(run ?? '', /^[a-z0-9_]{1,20}$/);
const base = new URL(process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1');
assert.ok(['localhost', '127.0.0.1', '[::1]'].includes(base.hostname));
const sessions = [];
async function request(path, token, method = 'GET', body, status = 200) {
  const result = await fetch(`${base.href}${path}`, {
    method, redirect: 'error',
    headers: { ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'content-type': 'application/json' } : {}) },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  assert.equal(result.status, status, `${method} ${path}`);
  return result.json();
}
async function login(role, device) {
  const session = await request('/auth/login', null, 'POST', {
    username: `av_${run}_${role}`, password: 'Avatar-test-2026-pass', deviceId: device,
  }, 201);
  sessions.push(session.accessToken);
  return { token: session.accessToken, me: await request('/users/me', session.accessToken) };
}
try {
  const a = await login('a', `inbox-${run}-a`);
  const b = await login('b', `inbox-${run}-b`);
  const c = await login('c', `inbox-${run}-c`);
  const groups = await request('/groups', a.token);
  assert.equal(groups.length, 1, 'Use fresh isolated fixtures');
  const group = groups[0];
  assert.equal(group.ownerId, a.me.id);
  await request(`/groups/${group.id}/members/${b.me.id}/role`, a.token, 'PATCH', { role: 'ADMIN' });
  const apply = await request(`/groups/${group.id}/join-requests`, c.token, 'POST', { message: `local-${run}` }, 201);
  const inbox = await request('/groups/join-requests/actionable', b.token);
  assert.ok(inbox.some((r) => r.id === apply.id && r.user.nickname && r.group.name));
  assert.equal((await request('/groups/join-requests/pending-count', b.token)).count, inbox.length);
  assert.equal((await request('/groups/join-requests/actionable', c.token)).length, 0);
  await request(`/groups/join-requests/${apply.id}/approve`, c.token, 'POST', undefined, 403);
  await request(`/groups/join-requests/${apply.id}/approve`, b.token, 'POST', undefined, 201);
  assert.equal((await request('/groups/join-requests/actionable', b.token)).length, 0);
  const joined = await request(`/groups/${group.id}`, c.token);
  assert.ok(joined.members.some((m) => m.userId === c.me.id && m.status === 'ACTIVE'));
  await request(`/files/${group.avatarFileId}/download`, c.token);
  await request(`/groups/${group.id}/leave`, c.token, 'POST', undefined, 201);
  await request(`/files/${group.avatarFileId}/download`, c.token, 'GET', undefined, 403);
  const invite = await request(`/groups/${group.id}/invitations`, b.token, 'POST', { userId: c.me.id }, 201);
  assert.ok((await request('/groups/join-requests/actionable', c.token)).some((r) => r.id === invite.id));
  assert.equal((await request('/groups/join-requests/actionable', b.token)).length, 0);
  await request(`/groups/join-requests/${invite.id}/approve`, b.token, 'POST', undefined, 403);
  await request(`/groups/join-requests/${invite.id}/reject`, c.token, 'POST', {}, 201);
  const history = await request('/groups/join-requests/me', c.token);
  assert.equal(history.length, 2);
  const cursor = new URLSearchParams({ before: history[0].createdAt, beforeId: history[0].id });
  assert.deepEqual((await request(`/groups/join-requests/me?${cursor}`, c.token)).map((r) => r.id), history.slice(1).map((r) => r.id));
  const end = new URLSearchParams({ before: history.at(-1).createdAt, beforeId: history.at(-1).id });
  assert.deepEqual(await request(`/groups/join-requests/me?${end}`, c.token), []);
  await request(`/groups/join-requests/me?beforeId=${apply.id}`, c.token, 'GET', undefined, 400);
  await request('/conversations/settings', a.token, 'PATCH', { channelId: group.id, channelType: 2, archived: true, pinned: true, muted: true });
  const second = await login('a', `inbox-${run}-second-device`);
  const setting = (await request('/conversations/settings', second.token)).find((r) => r.channelId === group.id);
  assert.equal(setting.archived, true);
  await request('/conversations/settings', second.token, 'PATCH', { channelId: group.id, channelType: 2, archived: false });
  const restored = (await request('/conversations/settings', second.token)).find((r) => r.channelId === group.id);
  assert.equal(restored.archived, false);
  assert.equal(restored.pinned, true);
  assert.equal(restored.muted, true);
  // Leave one labelled application for the real App inbox acceptance test.
  const uiRequest = await request(`/groups/${group.id}/join-requests`, c.token, 'POST', { message: `UI-${run}` }, 201);
  console.log(JSON.stringify({ ok: true, run, groupId: group.id, uiRequestId: uiRequest.id,
    checks: ['cross-group inbox and count', 'applicant cannot approve', 'admin approval',
      'member avatar access and leave denial', 'only recipient decides invitation',
      'history cursor and validation', 'new-session archive persistence and restore'] }));
} finally {
  for (const token of sessions) await request('/auth/logout', token, 'POST', undefined, 201);
}
