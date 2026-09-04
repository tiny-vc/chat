import { z } from "zod";

const environmentSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),
  PORT: z.coerce.number().int().positive().default(3000),
  SERVER_NAME: z.string().trim().min(1).max(80).default('Chat'),
  DATABASE_URL: z.string().min(1),
  JWT_ACCESS_SECRET: z.string().min(32),
  JWT_ACCESS_TTL: z.string().default("15m"),
  REFRESH_TOKEN_TTL_DAYS: z.coerce.number().int().min(1).max(365).default(30),
  LOGIN_MAX_ATTEMPTS: z.coerce.number().int().min(3).max(20).default(5),
  LOGIN_WINDOW_MINUTES: z.coerce.number().int().min(1).max(1440).default(15),
  JOBS_ENABLED: z.enum(["true", "false"]).default("true"),
  CLEANUP_INTERVAL_MINUTES: z.coerce
    .number()
    .int()
    .min(1)
    .max(1440)
    .default(60),
  PENDING_UPLOAD_TTL_HOURS: z.coerce.number().int().min(1).max(168).default(24),
  SESSION_RETENTION_DAYS: z.coerce.number().int().min(1).max(365).default(30),
  LOGIN_THROTTLE_RETENTION_DAYS: z.coerce
    .number()
    .int()
    .min(1)
    .max(90)
    .default(7),
  SLOW_REQUEST_MS: z.coerce.number().int().min(100).max(60000).default(1000),
  USER_STORAGE_QUOTA_MB: z.coerce
    .number()
    .int()
    .min(100)
    .max(102400)
    .default(1024),
  GROUP_JOIN_REQUEST_TTL_HOURS: z.coerce
    .number()
    .int()
    .min(1)
    .max(720)
    .default(168),
  SWAGGER_ENABLED: z.enum(["true", "false"]).default("true"),
  API_PUBLIC_URL: z.url().default("http://localhost:3000"),
  CORS_ALLOWED_ORIGINS: z.string().min(1).default("*"),
  JSON_BODY_LIMIT: z
    .string()
    .regex(/^\d+(kb|mb)$/i)
    .default("1mb"),
  WUKONGIM_API_URL: z.url(),
  WUKONGIM_WS_URL: z.string().min(1),
  WUKONGIM_TCP_ADDR: z.string().regex(/^[^:\s]+:\d+$/),
  WUKONGIM_MANAGER_TOKEN: z.string().optional(),
  WUKONGIM_WEBHOOK_SECRET: z.string().min(16),
  LIVEKIT_URL: z.string().min(1),
  LIVEKIT_HTTP_URL: z.url(),
  LIVEKIT_API_KEY: z.string().min(1),
  LIVEKIT_API_SECRET: z.string().min(1),
  S3_ENDPOINT: z.url().optional(),
  S3_PUBLIC_ENDPOINT: z.url().optional(),
  S3_REGION: z.string().default("us-east-1"),
  S3_BUCKET: z.string().min(3),
  S3_ACCESS_KEY: z.string().min(1),
  S3_SECRET_KEY: z.string().min(1),
  S3_FORCE_PATH_STYLE: z.enum(["true", "false"]).default("false"),
  S3_AUTO_CREATE_BUCKET: z.enum(["true", "false"]).default("false"),
});

export type Environment = z.infer<typeof environmentSchema>;

export function validateEnvironment(
  config: Record<string, unknown>,
): Environment {
  return environmentSchema.parse(config);
}
