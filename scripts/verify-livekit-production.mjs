import { access, readFile } from 'node:fs/promises';
import { constants } from 'node:fs';
import { resolve } from 'node:path';

const configPath = resolve(
  process.argv[2] ?? 'deploy/livekit/livekit.production.yaml',
);

function valueFor(source, key) {
  const match = source.match(new RegExp(`^\\s*${key}:\\s*([^#\\n]+)`, 'm'));
  return match?.[1].trim();
}

function fail(message) {
  console.error(`LiveKit production config invalid: ${message}`);
  process.exitCode = 1;
}

let source;
try {
  source = await readFile(configPath, 'utf8');
} catch {
  fail(`cannot read ${configPath}`);
  process.exit();
}

for (const placeholder of ['example.com', 'replace-with', '<']) {
  if (source.includes(placeholder)) fail(`contains placeholder '${placeholder}'`);
}

if (valueFor(source, 'enabled') !== 'true') fail('TURN must be enabled');

const domain = valueFor(source, 'domain');
if (!domain || domain === 'localhost' || !domain.includes('.')) {
  fail('TURN domain must be a public DNS name');
}

for (const key of ['tls_port', 'udp_port']) {
  const port = Number(valueFor(source, key));
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    fail(`${key} must be a valid port`);
  }
}

const rangeStart = Number(valueFor(source, 'port_range_start'));
const rangeEnd = Number(valueFor(source, 'port_range_end'));
if (!Number.isInteger(rangeStart) || !Number.isInteger(rangeEnd) || rangeStart >= rangeEnd) {
  fail('RTC UDP port range is missing or invalid');
}

for (const key of ['cert_file', 'key_file']) {
  const containerPath = valueFor(source, key);
  if (!containerPath?.startsWith('/certs/')) {
    fail(`${key} must point inside /certs`);
    continue;
  }
  const hostPath = resolve(
    'deploy/livekit/certs',
    containerPath.slice('/certs/'.length),
  );
  try {
    await access(hostPath, constants.R_OK);
  } catch {
    fail(`${key} host file is not readable: ${hostPath}`);
  }
}

if (!process.exitCode) {
  console.log(`LiveKit production config passed static checks: ${configPath}`);
}

