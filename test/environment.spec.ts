import { validateEnvironment } from "../src/config/environment";

const baseEnvironment = {
  NODE_ENV: "production",
  DATABASE_URL: "postgresql://chat:chat@postgres:5432/chat",
  JWT_ACCESS_SECRET: "a-secure-test-secret-with-32-characters",
  API_PUBLIC_URL: "https://api.example.com",
  WUKONGIM_API_URL: "http://wukongim:5001",
  WUKONGIM_WS_URL: "wss://im.example.com/ws",
  WUKONGIM_TCP_ADDR: "im.example.com:5100",
  WUKONGIM_WEBHOOK_SECRET: "a-secure-webhook-secret-value",
  LIVEKIT_URL: "wss://livekit.example.com",
  LIVEKIT_HTTP_URL: "http://livekit:7880",
  LIVEKIT_API_KEY: "livekit-key-1234",
  LIVEKIT_API_SECRET: "a-secure-livekit-secret-with-32-characters",
  S3_ENDPOINT: "http://minio:9000",
  S3_PUBLIC_ENDPOINT: "https://files.example.com",
  S3_BUCKET: "chat-files",
  S3_ACCESS_KEY: "storage-access-key",
  S3_SECRET_KEY: "a-secure-storage-secret-with-32-characters",
  CORS_ALLOWED_ORIGINS: "https://admin.example.com",
  SWAGGER_ENABLED: "false",
  S3_AUTO_CREATE_BUCKET: "false",
};

describe("environment transport security", () => {
  it("accepts TLS public endpoints with private HTTP service endpoints", () => {
    expect(validateEnvironment(baseEnvironment).LIVEKIT_URL).toBe(
      "wss://livekit.example.com",
    );
  });

  it.each([
    ["API_PUBLIC_URL", "http://api.example.com"],
    ["WUKONGIM_WS_URL", "ws://im.example.com/ws"],
    ["LIVEKIT_URL", "ws://livekit.example.com"],
    ["S3_PUBLIC_ENDPOINT", "http://files.example.com"],
  ])("rejects insecure production %s", (field, value) => {
    expect(() =>
      validateEnvironment({ ...baseEnvironment, [field]: value }),
    ).toThrow();
  });

  it("rejects a non-WebSocket LiveKit public URL", () => {
    expect(() =>
      validateEnvironment({
        ...baseEnvironment,
        LIVEKIT_URL: "https://livekit.example.com",
      }),
    ).toThrow();
  });

  it.each([59, 901, "not-a-number"])(
    "rejects unsafe LiveKit token TTL %s",
    (ttl) => {
      expect(() =>
        validateEnvironment({
          ...baseEnvironment,
          LIVEKIT_JOIN_TOKEN_TTL_SECONDS: ttl,
        }),
      ).toThrow();
    },
  );

  it.each([
    "https://im.example.com:5100",
    "im.example.com:5100/path",
    "user@im.example.com:5100",
    "im.example.com:0",
    "im.example.com:65536",
    "im.example.com",
  ])("rejects malformed WuKongIM TCP address %s", (address) => {
    expect(() =>
      validateEnvironment({
        ...baseEnvironment,
        WUKONGIM_TCP_ADDR: address,
      }),
    ).toThrow();
  });

  it.each([
    ["CORS_ALLOWED_ORIGINS", "*"],
    ["SWAGGER_ENABLED", "true"],
    ["S3_AUTO_CREATE_BUCKET", "true"],
    ["JWT_ACCESS_SECRET", "local-development-secret-at-least-32-chars"],
    ["WUKONGIM_WEBHOOK_SECRET", "replace-with-a-random-webhook-secret"],
    ["LIVEKIT_API_KEY", "devkey"],
    ["LIVEKIT_API_SECRET", "secret"],
    ["S3_ACCESS_KEY", "access"],
    ["S3_SECRET_KEY", "secret"],
  ])("rejects unsafe production setting %s", (field, value) => {
    expect(() =>
      validateEnvironment({ ...baseEnvironment, [field]: value }),
    ).toThrow();
  });
});
