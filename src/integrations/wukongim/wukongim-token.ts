import { createHmac, randomBytes } from "node:crypto";

export function createWuKongImToken(
  secret: string,
  userId: string,
  deviceFlag: number,
) {
  return createHmac("sha256", secret)
    .update(`wukong-im\0${userId}\0${deviceFlag}`)
    .digest("base64url");
}

export function createDisabledWuKongImToken() {
  return randomBytes(32).toString("base64url");
}
