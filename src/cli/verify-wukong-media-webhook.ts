import { PrismaClient } from "@prisma/client";
import { randomUUID } from "node:crypto";

const prisma = new PrismaClient();
const apiUrl = (process.env.WUKONGIM_API_URL ?? "").replace(/\/$/, "");
const managerToken = process.env.WUKONGIM_MANAGER_TOKEN;

async function main() {
  if (!apiUrl) throw new Error("WUKONGIM_API_URL is required");
  const runId = randomUUID().replaceAll("-", "");
  const [sender, recipient] = await prisma.$transaction([
    prisma.user.create({
      data: {
        username: `wkprobe_a_${runId.slice(0, 16)}`,
        nickname: "Webhook probe sender",
        passwordHash: "disabled-webhook-probe-account",
      },
      select: { id: true },
    }),
    prisma.user.create({
      data: {
        username: `wkprobe_b_${runId.slice(0, 16)}`,
        nickname: "Webhook probe recipient",
        passwordHash: "disabled-webhook-probe-account",
      },
      select: { id: true },
    }),
  ]);
  let fileId: string | undefined;
  try {
    await prisma.friendship.create({
      data: {
        pairKey: [sender.id, recipient.id].sort().join(":"),
        requesterId: sender.id,
        addresseeId: recipient.id,
        status: "ACCEPTED",
      },
    });
    const file = await prisma.storedFile.create({
      data: {
        ownerUserId: sender.id,
        objectKey: `webhook-probe/${runId}`,
        originalName: "probe.txt",
        mimeType: "text/plain",
        sizeBytes: 1n,
        purpose: "CHAT_FILE",
        scope: "DIRECT",
        scopeId: recipient.id,
        status: "READY",
        uploadedAt: new Date(),
      },
      select: { id: true },
    });
    fileId = file.id;
    const response = await fetch(`${apiUrl}/message/send`, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        ...(managerToken ? { authorization: `Bearer ${managerToken}` } : {}),
      },
      body: JSON.stringify({
        header: { no_persist: 0, red_dot: 0, sync_once: 0 },
        client_msg_no: randomUUID(),
        from_uid: sender.id,
        channel_id: recipient.id,
        channel_type: 1,
        expire: 60,
        payload: Buffer.from(
          JSON.stringify({
            type: 8,
            fileId: file.id,
            name: "probe.txt",
            size: 1,
            mimeType: "text/plain",
          }),
        ).toString("base64"),
      }),
      signal: AbortSignal.timeout(5_000),
    });
    if (!response.ok) {
      throw new Error(
        `WuKongIM send failed (${response.status}): ${(await response.text()).slice(0, 300)}`,
      );
    }
    const deadline = Date.now() + 30_000;
    while (Date.now() < deadline) {
      const current = await prisma.storedFile.findUnique({
        where: { id: file.id },
        select: { referencedAt: true },
      });
      if (current?.referencedAt) {
        console.log(
          JSON.stringify({
            ok: true,
            messageNotifyDelivered: true,
            mediaReferenceRecorded: true,
            referencedAt: current.referencedAt.toISOString(),
          }),
        );
        return;
      }
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
    throw new Error(
      "Timed out waiting for msg.notify; check WuKongIM webhook URL, token and API logs",
    );
  } finally {
    if (fileId) await prisma.storedFile.deleteMany({ where: { id: fileId } });
    await prisma.friendship.deleteMany({
      where: {
        OR: [
          { requesterId: sender.id },
          { addresseeId: sender.id },
          { requesterId: recipient.id },
          { addresseeId: recipient.id },
        ],
      },
    });
    await prisma.user.deleteMany({
      where: { id: { in: [sender.id, recipient.id] } },
    });
  }
}

void main()
  .catch((error: unknown) => {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
