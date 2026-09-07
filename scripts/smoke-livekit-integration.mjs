import { randomUUID } from "node:crypto";
import { PrismaClient } from "@prisma/client";
import { LiveKitAPI } from "livekit-server-sdk";

const apiKey = process.env.LIVEKIT_API_KEY;
const apiSecret = process.env.LIVEKIT_API_SECRET;
const host = process.env.LIVEKIT_HTTP_URL;
if (!apiKey || !apiSecret || !host) {
  throw new Error("LiveKit API URL and credentials are required");
}

const prisma = new PrismaClient();
const livekit = new LiveKitAPI({
  host,
  apiKey,
  secret: apiSecret,
  requestTimeout: 5,
});
const roomName = `webhook-integration-${randomUUID()}`;
const startedAfter = new Date(Date.now() - 2_000);

async function waitForEvent(
  eventType,
  targetRoom = roomName,
  timeoutMs = 10_000,
) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    const events = await prisma.webhookEvent.findMany({
      where: {
        source: "livekit",
        eventType,
        receivedAt: { gte: startedAfter },
      },
      orderBy: { receivedAt: "desc" },
      take: 50,
    });
    const found = events.find((event) => {
      const payload = event.payload;
      return (
        payload &&
        typeof payload === "object" &&
        !Array.isArray(payload) &&
        payload.room &&
        typeof payload.room === "object" &&
        !Array.isArray(payload.room) &&
        payload.room.name === targetRoom
      );
    });
    if (found) return found;
    await new Promise((resolve) => setTimeout(resolve, 200));
  }
  throw new Error(`timed out waiting for ${eventType} for ${targetRoom}`);
}

let roomCreated = false;
const staleRoomName = `call_${randomUUID()}`;
let staleRoomCreated = false;
try {
  await prisma.$connect();
  await livekit.room.createRoom({
    name: roomName,
    emptyTimeout: 60,
    maxParticipants: 2,
  });
  roomCreated = true;
  const started = await waitForEvent("room_started");

  await livekit.room.deleteRoom(roomName);
  roomCreated = false;
  const finished = await waitForEvent("room_finished");

  // A call-prefixed room with no active business call simulates reuse of an
  // old join token. The business webhook must close it automatically.
  await livekit.room.createRoom({ name: staleRoomName, emptyTimeout: 60 });
  staleRoomCreated = true;
  await waitForEvent("room_started", staleRoomName);
  const staleFinished = await waitForEvent("room_finished", staleRoomName);
  staleRoomCreated = false;

  console.log(
    JSON.stringify({
      ok: true,
      livekitCreatedRoom: true,
      roomStartedDelivered: true,
      roomFinishedDelivered: true,
      staleCallRoomRejected: true,
      eventIds: [started.eventKey, finished.eventKey, staleFinished.eventKey],
    }),
  );
} finally {
  if (roomCreated) {
    await livekit.room.deleteRoom(roomName).catch(() => undefined);
  }
  if (staleRoomCreated) {
    await livekit.room.deleteRoom(staleRoomName).catch(() => undefined);
  }
  await prisma.$disconnect();
}
