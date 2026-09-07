import { access, readFile } from "node:fs/promises";
import { constants } from "node:fs";
import { resolve } from "node:path";

const configPath = resolve(
  process.argv[2] ?? "deploy/livekit/livekit.production.yaml",
);

function valueFor(source, key) {
  const match = source.match(new RegExp(`^\\s*${key}:\\s*([^#\\n]+)`, "m"));
  return match?.[1].trim();
}

function sectionValue(source, section, key) {
  const block = source.match(
    new RegExp(`^${section}:\\s*\\n((?:[ \\t]+[^\\n]*\\n?)*)`, "m"),
  )?.[1];
  return block ? valueFor(block, key) : undefined;
}

function fail(message) {
  console.error(`LiveKit production config invalid: ${message}`);
  process.exitCode = 1;
}

let source;
try {
  source = await readFile(configPath, "utf8");
} catch {
  fail(`cannot read ${configPath}`);
  process.exit();
}

for (const placeholder of ["example.com", "replace-with", "<"]) {
  if (source.includes(placeholder))
    fail(`contains placeholder '${placeholder}'`);
}

if (valueFor(source, "enabled") !== "true") fail("TURN must be enabled");

const domain = valueFor(source, "domain");
if (!domain || domain === "localhost" || !domain.includes(".")) {
  fail("TURN domain must be a public DNS name");
}

for (const key of ["tls_port", "udp_port"]) {
  const port = Number(valueFor(source, key));
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    fail(`${key} must be a valid port`);
  }
}

const rangeStart = Number(valueFor(source, "port_range_start"));
const rangeEnd = Number(valueFor(source, "port_range_end"));
if (
  !Number.isInteger(rangeStart) ||
  !Number.isInteger(rangeEnd) ||
  rangeStart >= rangeEnd
) {
  fail("RTC UDP port range is missing or invalid");
}

const configuredKey = source.match(/^keys:\s*\n\s+([^:\s]+):\s*\S+/m)?.[1];
const webhookKey = sectionValue(source, "webhook", "api_key");
if (!configuredKey || webhookKey !== configuredKey) {
  fail("webhook.api_key must match a configured LiveKit API key");
}
const webhookUrl = source.match(
  /^webhook:\s*\n(?:[ \t]+[^\n]*\n)*?\s+urls:\s*\n\s+-\s*([^#\s]+)/m,
)?.[1];
if (!webhookUrl) {
  fail("webhook URL is required");
} else {
  try {
    const parsed = new URL(webhookUrl);
    if (
      parsed.protocol !== "https:" ||
      parsed.pathname !== "/api/v1/webhooks/livekit"
    ) {
      fail("webhook URL must use HTTPS and /api/v1/webhooks/livekit");
    }
  } catch {
    fail("webhook URL must be valid");
  }
}

for (const key of ["cert_file", "key_file"]) {
  const containerPath = valueFor(source, key);
  if (!containerPath?.startsWith("/certs/")) {
    fail(`${key} must point inside /certs`);
    continue;
  }
  const hostPath = resolve(
    "deploy/certs",
    containerPath.slice("/certs/".length),
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
