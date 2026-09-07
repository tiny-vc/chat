import { SetMetadata } from "@nestjs/common";

export type RuntimeCapability =
  | "registration"
  | "messaging"
  | "files"
  | "groups"
  | "audioCalls"
  | "videoCalls";

export const RUNTIME_CAPABILITY_KEY = "runtimeCapability";

export const RequireRuntimeCapability = (capability: RuntimeCapability) =>
  SetMetadata(RUNTIME_CAPABILITY_KEY, capability);

export const RequireCallCapability = () =>
  SetMetadata(RUNTIME_CAPABILITY_KEY, "callType");
