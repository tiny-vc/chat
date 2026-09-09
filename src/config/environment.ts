import { z } from "zod";

const httpUrl = z
  .url()
  .refine((value) => ["http:", "https:"].includes(new URL(value).protocol), {
    message: "URL must use http:// or https://",
  });

const hostPort = z.string().refine((value) => {
  if (
    value !== value.trim() ||
    value.length > 512 ||
    /[\s/@?#]/.test(value) ||
    value.includes("://")
  ) {
    return false;
  }
  try {
    const parsed = new URL(`tcp://${value}`);
    const port = Number(parsed.port);
    return (
      parsed.hostname.length > 0 &&
      parsed.port.length > 0 &&
      Number.isInteger(port) &&
      port >= 1 &&
      port <= 65535 &&
      (parsed.pathname === "" || parsed.pathname === "/")
    );
  } catch {
    return false;
  }
}, "WUKONGIM_TCP_ADDR must be a valid host:port");

const environmentSchema = z
  .object({
    NODE_ENV: z
      .enum(["development", "test", "production"])
      .default("development"),
    PORT: z.coerce.number().int().positive().default(3000),
    INSTANCE_ROLE: z.enum(["api", "worker", "all"]).default("all"),
    SERVER_NAME: z.string().trim().min(1).max(80).default("Chat"),
    DATABASE_URL: z.string().min(1),
    JWT_ACCESS_SECRET: z.string().min(32),
    JWT_ACCESS_TTL: z.string().default("15m"),
    REFRESH_TOKEN_TTL_DAYS: z.coerce.number().int().min(1).max(365).default(30),
    ADMIN_REFRESH_TOKEN_TTL_HOURS: z.coerce
      .number()
      .int()
      .min(1)
      .max(168)
      .default(12),
    LOGIN_MAX_ATTEMPTS: z.coerce.number().int().min(3).max(20).default(5),
    LOGIN_WINDOW_MINUTES: z.coerce.number().int().min(1).max(1440).default(15),
    JOBS_ENABLED: z.enum(["true", "false"]).default("true"),
    CLEANUP_INTERVAL_MINUTES: z.coerce
      .number()
      .int()
      .min(1)
      .max(1440)
      .default(60),
    PENDING_UPLOAD_TTL_HOURS: z.coerce
      .number()
      .int()
      .min(1)
      .max(168)
      .default(24),
    UNREFERENCED_FILE_TTL_HOURS: z.coerce
      .number()
      .int()
      .min(1)
      .max(168)
      .default(24),
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
    API_PUBLIC_URL: httpUrl.default("http://localhost:3000"),
    CORS_ALLOWED_ORIGINS: z.string().min(1).default("*"),
    JSON_BODY_LIMIT: z
      .string()
      .regex(/^\d+(kb|mb)$/i)
      .default("1mb"),
    WUKONGIM_API_URL: httpUrl,
    WUKONGIM_WS_URL: z
      .url()
      .refine((value) => ["ws:", "wss:"].includes(new URL(value).protocol), {
        message: "WUKONGIM_WS_URL must use ws:// or wss://",
      }),
    WUKONGIM_TCP_ADDR: hostPort,
    WUKONGIM_MANAGER_TOKEN: z.string().optional(),
    WUKONGIM_WEBHOOK_SECRET: z.string().min(16),
    LIVEKIT_URL: z
      .url()
      .refine((value) => ["ws:", "wss:"].includes(new URL(value).protocol), {
        message: "LIVEKIT_URL must use ws:// or wss://",
      }),
    LIVEKIT_HTTP_URL: httpUrl,
    LIVEKIT_API_KEY: z.string().min(1),
    LIVEKIT_API_SECRET: z.string().min(1),
    LIVEKIT_JOIN_TOKEN_TTL_SECONDS: z.coerce
      .number()
      .int()
      .min(60)
      .max(900)
      .default(600),
    S3_ENDPOINT: httpUrl.optional(),
    S3_PUBLIC_ENDPOINT: httpUrl.optional(),
    S3_REGION: z.string().default("us-east-1"),
    S3_BUCKET: z.string().min(3),
    S3_ACCESS_KEY: z.string().min(1),
    S3_SECRET_KEY: z.string().min(1),
    S3_FORCE_PATH_STYLE: z.enum(["true", "false"]).default("false"),
    S3_AUTO_CREATE_BUCKET: z.enum(["true", "false"]).default("false"),
  })
  .superRefine((config, context) => {
    if (config.NODE_ENV !== "production") return;
    const reject = (field: string, message: string) =>
      context.addIssue({ code: "custom", path: [field], message });
    const requireTls = (field: string, value: string, protocol: string) => {
      if (new URL(value).protocol !== protocol) {
        context.addIssue({
          code: "custom",
          path: [field],
          message: `${field} must use ${protocol}// in production`,
        });
      }
    };
    requireTls("API_PUBLIC_URL", config.API_PUBLIC_URL, "https:");
    requireTls("WUKONGIM_WS_URL", config.WUKONGIM_WS_URL, "wss:");
    requireTls("LIVEKIT_URL", config.LIVEKIT_URL, "wss:");
    if (config.S3_PUBLIC_ENDPOINT) {
      requireTls("S3_PUBLIC_ENDPOINT", config.S3_PUBLIC_ENDPOINT, "https:");
    }
    if (config.CORS_ALLOWED_ORIGINS.trim() === "*") {
      reject(
        "CORS_ALLOWED_ORIGINS",
        "Wildcard CORS is forbidden in production",
      );
    }
    if (config.SWAGGER_ENABLED === "true") {
      reject("SWAGGER_ENABLED", "Swagger must be disabled in production");
    }
    if (config.S3_AUTO_CREATE_BUCKET === "true") {
      reject(
        "S3_AUTO_CREATE_BUCKET",
        "Automatic bucket creation must be disabled in production",
      );
    }
    const requireSecret = (field: string, value: string, minimum: number) => {
      const normalized = value.toLowerCase();
      if (
        value.length < minimum ||
        ["secret", "devkey", "change-me", "password"].includes(normalized) ||
        normalized.startsWith("replace-with") ||
        normalized.includes("local-development")
      ) {
        reject(
          field,
          `${field} must be a non-placeholder secret in production`,
        );
      }
    };
    requireSecret("JWT_ACCESS_SECRET", config.JWT_ACCESS_SECRET, 32);
    requireSecret(
      "WUKONGIM_WEBHOOK_SECRET",
      config.WUKONGIM_WEBHOOK_SECRET,
      24,
    );
    requireSecret("LIVEKIT_API_KEY", config.LIVEKIT_API_KEY, 12);
    requireSecret("LIVEKIT_API_SECRET", config.LIVEKIT_API_SECRET, 32);
    requireSecret("S3_ACCESS_KEY", config.S3_ACCESS_KEY, 12);
    requireSecret("S3_SECRET_KEY", config.S3_SECRET_KEY, 32);
  });

export type Environment = z.infer<typeof environmentSchema>;

export function validateEnvironment(
  config: Record<string, unknown>,
): Environment {
  return environmentSchema.parse(config);
}
