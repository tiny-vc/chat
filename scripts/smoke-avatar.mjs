import assert from 'node:assert/strict';
import { deflateSync } from 'node:zlib';

// Isolated, retained fixtures: never replaces an existing user's avatar.
const run = process.env.AVATAR_RUN;
assert.match(run ?? '', /^[a-z0-9_]{1,20}$/);
const base = process.env.SMOKE_API_URL ?? 'http://localhost:3000/api/v1';
const password = 'Avatar-test-2026-pass';
async function request(path, token, method = 'GET', body, status = 200) {
  const response = await fetch(`${base}${path}`, {
    method, headers: { ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'content-type': 'application/json' } : {}) },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  assert.equal(response.status, status, `${method} ${path}`);
  return response.json();
}
function png(color) {
  function chunk(type, data) {
    const payload = Buffer.concat([Buffer.from(type), data]);
    let crc = 0xffffffff;
    for (const byte of payload) {
      crc ^= byte;
      for (let i = 0; i < 8; i++) crc = (crc >>> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
    }
    const size = Buffer.alloc(4); size.writeUInt32BE(data.length);
    const checksum = Buffer.alloc(4); checksum.writeUInt32BE((crc ^ 0xffffffff) >>> 0);
    return Buffer.concat([size, payload, checksum]);
  }
  const header = Buffer.alloc(13);
  header.writeUInt32BE(64, 0); header.writeUInt32BE(64, 4); header[8] = 8; header[9] = 2;
  const pixels = Buffer.alloc(64 * (1 + 64 * 3));
  for (let y = 0; y < 64; y++) for (let x = 0; x < 64; x++) {
    const mark = x > 20 && x < 44 && y > 16 && y < 48;
    for (let c = 0; c < 3; c++) pixels[y * 193 + 1 + x * 3 + c] = mark ? 245 : color[c];
  }
  return Buffer.concat([Buffer.from([137,80,78,71,13,10,26,10]), chunk('IHDR', header),
    chunk('IDAT', deflateSync(pixels)), chunk('IEND', Buffer.alloc(0))]);
}
const accounts = [];
try {
  for (const [role, nickname] of [['a', '林夏'], ['b', '陈屿'], ['c', '头像权限测试']]) {
    const username = `av_${run}_${role}`;
    const session = await request('/auth/register', null, 'POST',
      { username, nickname, password, deviceId: `avatar-smoke-${run}` }, 201);
    accounts.push({ username, token: session.accessToken,
      me: await request('/users/me', session.accessToken) });
  }
  const [a, b, c] = accounts;
  const invitation = await request('/friends/requests', a.token, 'POST', { userId: b.me.id }, 201);
  await request(`/friends/requests/${invitation.id}/accept`, b.token, 'POST', undefined, 201);
  async function upload(token, color) {
    const bytes = png(color);
    const result = await request('/files/uploads', token, 'POST', {
      fileName: `avatar-${run}.png`, mimeType: 'image/png', size: bytes.length,
      purpose: 'AVATAR', scope: 'PRIVATE',
    }, 201);
    const response = await fetch(result.uploadUrl, { method: 'PUT', headers: result.headers, body: bytes });
    assert.equal(response.ok, true);
    await request(`/files/${result.fileId}/complete`, token, 'POST', undefined, 201);
    return { id: result.fileId, bytes };
  }
  const first = await upload(a.token, [70, 104, 160]);
  const second = await upload(b.token, [56, 128, 115]);
  for (const [account, file] of [[a, first], [b, second]])
    await request('/users/me/avatar', account.token, 'PUT', { fileId: file.id });
  async function download(token, file) {
    const result = await request(`/files/${file.id}/download`, token);
    const response = await fetch(result.downloadUrl);
    assert.equal(response.ok, true);
    assert.deepEqual(Buffer.from(await response.arrayBuffer()), file.bytes);
  }
  await download(b.token, first); await download(a.token, second);
  await request(`/files/${first.id}/download`, c.token, 'GET', undefined, 403);
  await request(`/blocks/${b.me.id}`, a.token, 'POST', undefined, 201);
  try {
    await request(`/files/${first.id}/download`, b.token, 'GET', undefined, 403);
    await request(`/files/${second.id}/download`, a.token, 'GET', undefined, 403);
  } finally { await request(`/blocks/${b.me.id}`, a.token, 'DELETE'); }
  const replacement = await upload(a.token, [70, 104, 160]);
  await request('/users/me/avatar', a.token, 'PUT', { fileId: replacement.id });
  await request(`/files/${first.id}/download`, b.token, 'GET', undefined, 403);
  await download(b.token, replacement);
  const group = await request('/groups', a.token, 'POST', { name: '产品讨论组', memberIds: [b.me.id] }, 201);
  const groupAvatar = await upload(a.token, [147, 114, 76]);
  await request(`/groups/${group.id}/avatar`, a.token, 'PUT', { fileId: groupAvatar.id });
  await download(b.token, groupAvatar);
  await request(`/files/${groupAvatar.id}/download`, c.token, 'GET', undefined, 403);
  console.log(JSON.stringify({ ok: true, run, accounts: [a.username, b.username], groupId: group.id,
    checks: ['mutual download bytes', 'stranger denied', 'both block directions denied',
      'replaced avatar denied', 'group member download', 'nonmember denied'] }));
} finally {
  for (const account of accounts) await request('/auth/logout', account.token, 'POST', undefined, 201);
}
