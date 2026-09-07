import { createHash, randomUUID } from "node:crypto";
import { AccessToken } from "livekit-server-sdk";

const api = process.env.SMOKE_API_URL ?? "http://127.0.0.1:3000/api/v1";
const apiKey = process.env.LIVEKIT_API_KEY;
const apiSecret = process.env.LIVEKIT_API_SECRET;
if (!apiKey || !apiSecret) throw new Error("LiveKit credentials are required");

async function post(body, authorization, expectedStatus) {
  const response = await fetch(`${api}/webhooks/livekit`, {
    method: "POST",
    headers: {
      "content-type": "application/webhook+json",
      authorization,
    },
    body,
  });
  const responseBody = await response.text();
  if (response.status !== expectedStatus) {
    throw new Error(
      `expected ${expectedStatus}, got ${response.status}: ${responseBody}`,
    );
  }
  return responseBody ? JSON.parse(responseBody) : undefined;
}

const eventId = randomUUID();
const body = JSON.stringify({
  event: "room_started",
  id: eventId,
  room: { name: `webhook-smoke-${eventId}` },
  created_at: String(Math.floor(Date.now() / 1000)),
});

await post(body, "forged-token", 401);

const token = new AccessToken(apiKey, apiSecret, { ttl: "2m" });
token.sha256 = createHash("sha256").update(body).digest("base64");
const authorization = await token.toJwt();
const first = await post(body, authorization, 201);
if (first?.accepted !== true || first?.duplicate !== false) {
  throw new Error(`first delivery was not accepted: ${JSON.stringify(first)}`);
}
const duplicate = await post(body, authorization, 201);
if (duplicate?.accepted !== true || duplicate?.duplicate !== true) {
  throw new Error(
    `duplicate delivery was not idempotent: ${JSON.stringify(duplicate)}`,
  );
}

console.log(
  JSON.stringify({
    ok: true,
    forgedRejected: true,
    signedAccepted: true,
    duplicateIdempotent: true,
    eventId,
  }),
);
