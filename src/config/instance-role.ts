import { ConfigService } from "@nestjs/config";

export function backgroundJobsEnabled(config: ConfigService) {
  return (
    config.getOrThrow<string>("JOBS_ENABLED") === "true" &&
    config.getOrThrow<string>("INSTANCE_ROLE") !== "api"
  );
}
