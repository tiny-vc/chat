import { PrismaClient } from "@prisma/client";

async function main() {
  const username = process.argv[2]?.trim().toLowerCase();
  if (!username)
    throw new Error("Usage: node dist/cli/promote-admin.js <username>");

  const prisma = new PrismaClient();
  try {
    const user = await prisma.user.findUnique({
      where: { username },
      select: { id: true, username: true, role: true, status: true },
    });
    if (!user)
      throw new Error(
        `User not found: ${username}. Register the account first.`,
      );
    if (user.status !== "ACTIVE")
      throw new Error(`User is not active: ${username}`);
    if (user.role === "ADMIN") {
      console.log(`User is already an administrator: ${username}`);
      return;
    }
    await prisma.$transaction([
      prisma.user.update({ where: { id: user.id }, data: { role: "ADMIN" } }),
      prisma.auditLog.create({
        data: {
          actorUserId: null,
          action: "ADMIN_PROMOTE_CLI",
          targetType: "USER",
          targetId: user.id,
          metadata: { username },
        },
      }),
    ]);
    console.log(`Administrator promoted: ${username}`);
  } finally {
    await prisma.$disconnect();
  }
}

void main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
