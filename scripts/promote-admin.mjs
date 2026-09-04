import { NestFactory } from "@nestjs/core";
import { AppModule } from "../dist/app.module.js";
import { PrismaService } from "../dist/prisma/prisma.service.js";

const username = process.argv[2]?.trim().toLowerCase();
if (!username) {
  console.error("Usage: npm run admin:promote -- <username>");
  process.exitCode = 2;
} else {
  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ["error", "warn"],
  });
  try {
    const prisma = app.get(PrismaService);
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
    } else {
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
    }
  } finally {
    await app.close();
  }
}
