import { PrismaClient } from "@prisma/client";
import { hash } from "bcryptjs";
import { readFile } from "node:fs/promises";

type BootstrapInput = {
  username: string;
  nickname: string;
  password: string;
};

async function readInput(): Promise<BootstrapInput> {
  const source = await readFile("/dev/stdin", "utf8");
  if (Buffer.byteLength(source, "utf8") > 4096) {
    throw new Error("Bootstrap input is too large");
  }
  const [rawUsername = "", rawNickname = "", rawPassword = ""] =
    source.split(/\r?\n/, 3);
  return {
    username: rawUsername.trim().toLowerCase(),
    nickname: rawNickname.trim(),
    password: rawPassword,
  };
}

function validate(input: BootstrapInput) {
  if (!/^[a-zA-Z0-9_]{3,40}$/.test(input.username)) {
    throw new Error("Username must be 3-40 letters, numbers or underscores");
  }
  if (input.nickname.length < 1 || input.nickname.length > 80) {
    throw new Error("Nickname must be 1-80 characters");
  }
  if (input.password.length < 12 || input.password.length > 72) {
    throw new Error("Password must be 12-72 characters");
  }
}

async function main() {
  if (process.stdin.isTTY) {
    throw new Error(
      "Refusing to read a password from command arguments. Use the production bootstrap script.",
    );
  }
  const input = await readInput();
  validate(input);
  const passwordHash = await hash(input.password, 12);
  const prisma = new PrismaClient();
  try {
    const user = await prisma.$transaction(
      async (tx) => {
        const administratorCount = await tx.user.count({
          where: { role: "ADMIN", status: { not: "DELETED" } },
        });
        if (administratorCount > 0) {
          throw new Error(
            "An administrator already exists; use the management platform to grant additional roles.",
          );
        }
        const existing = await tx.user.findUnique({
          where: { username: input.username },
          select: { id: true },
        });
        if (existing)
          throw new Error(`Username already exists: ${input.username}`);
        const created = await tx.user.create({
          data: {
            username: input.username,
            nickname: input.nickname,
            passwordHash,
            role: "ADMIN",
            status: "ACTIVE",
          },
          select: { id: true, username: true },
        });
        await tx.auditLog.create({
          data: {
            actorUserId: null,
            action: "ADMIN_BOOTSTRAP_CLI",
            targetType: "USER",
            targetId: created.id,
            metadata: { username: created.username },
          },
        });
        return created;
      },
      { isolationLevel: "Serializable" },
    );
    console.log(`Initial administrator created: ${user.username}`);
  } finally {
    await prisma.$disconnect();
  }
}

void main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
