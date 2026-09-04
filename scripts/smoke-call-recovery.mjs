import assert from 'node:assert/strict';
import { setTimeout as delay } from 'node:timers/promises';

// Local-only, isolated accounts previously created by smoke-avatar.mjs.
const run = process.env.AVATAR_RUN;
assert.match(run ?? '', /^[a-z0-9_]{1,20}$/);
const password = process.env.TEST_PASSWORD;
assert.ok(password, 'TEST_PASSWORD is required');
const base = new URL(process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1');
assert.ok(['localhost', '127.0.0.1', '[::1]'].includes(base.hostname));
const tokens = [];
const ownedCalls = [];
async function request(path, token, method = 'GET', body, expected = 200) {
  const response = await fetch(`${base.href}${path}`, {
    method, redirect: 'error', signal: AbortSignal.timeout(8000),
    headers: { ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'content-type': 'application/json' } : {}) },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  assert.equal(response.status, expected, `${method} ${path}`);
  return response.json();
}
async function login(role) {
  const session = await request('/auth/login', null, 'POST', {
    username: `av_${run}_${role}`, password, deviceId: `recovery-${run}-${role}`,
  }, 201);
  tokens.push(session.accessToken);
  return { token: session.accessToken, me: await request('/users/me', session.accessToken) };
}
try {
  const a = await login('a');
  const b = await login('b');
  const c = await login('c');
  const call = await request('/calls', a.token, 'POST', { targetUserId: b.me.id, type: 'AUDIO' }, 201);
  ownedCalls.push({ id: call.id, token: a.token });
  await request(`/calls/${call.id}/accept`, b.token, 'POST', undefined, 201);
  const retry = await request(`/calls/${call.id}/accept`, b.token, 'POST', undefined, 201);
  assert.equal(retry.status, 'ACCEPTED');
  await request(`/calls/${call.id}/end`, c.token, 'POST', undefined, 403);
  // Intentionally do not join LiveKit: exercise accepted-but-no-media cleanup,
  // not packet loss, microphone quality, or SDK reconnection.
  console.log('CALL_RECOVERY_ACCEPT_RETRY_AND_AUTH_PASSED; waiting for media absence grace');
  await delay(30_000);
  const early = (await request('/calls', a.token)).find((row) => row.id === call.id);
  assert.equal(early.status, 'ACCEPTED', 'Must not end during grace');
  const deadline = Date.now() + 150_000;
  let ended;
  while (Date.now() < deadline) {
    ended = (await request('/calls', a.token)).find((row) => row.id === call.id);
    if (ended.status === 'ENDED') break;
    await delay(5000);
  }
  assert.equal(ended.status, 'ENDED');
  assert.equal(ended.endReason, 'MEDIA_DISCONNECTED');
  await request(`/calls/${call.id}/token`, a.token, 'POST', undefined, 403);
  await request(`/calls/${call.id}/end`, a.token, 'POST', undefined, 201);
  const next = await request('/calls', a.token, 'POST', { targetUserId: b.me.id, type: 'VIDEO' }, 201);
  ownedCalls.push({ id: next.id, token: a.token });
  await request(`/calls/${next.id}/end`, a.token, 'POST', undefined, 201);
  await request(`/calls/${next.id}/end`, a.token, 'POST', undefined, 201);
  console.log(JSON.stringify({ ok: true, callId: call.id, checks: [
    'accept retry', 'outsider cannot hang up', '30s grace preserved',
    'absent media eventually ended', 'ended token denied', 'no stale busy lock',
    'caller hangup before answer', 'idempotent hangup',
  ] }));
} finally {
  // Never clean up unrelated pre-existing calls.
  for (const call of ownedCalls) {
    await request(`/calls/${call.id}/end`, call.token, 'POST', undefined, 201).catch(() => {
      console.error(`Could not finalize isolated call ${call.id}; server maintenance remains the fallback`);
    });
  }
  for (const token of tokens) await request('/auth/logout', token, 'POST', undefined, 201);
}
