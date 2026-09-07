import { decodeJwt } from "jose";
import { TrackSource } from "livekit-server-sdk";
import { LiveKitService } from "../src/integrations/livekit/livekit.service";

describe("LiveKitService join tokens", () => {
  const values: Record<string, unknown> = {
    LIVEKIT_API_KEY: "test-key",
    LIVEKIT_API_SECRET: "a-test-secret-that-is-long-enough-to-sign",
    LIVEKIT_URL: "wss://livekit.example.com",
    LIVEKIT_HTTP_URL: "http://livekit:7880",
    LIVEKIT_JOIN_TOKEN_TTL_SECONDS: 600,
  };
  const config = {
    getOrThrow: jest.fn((key: string) => values[key]),
    get: jest.fn((key: string, fallback: unknown) => values[key] ?? fallback),
  };

  it.each([
    ["AUDIO", [TrackSource.MICROPHONE]],
    ["VIDEO", [TrackSource.MICROPHONE, TrackSource.CAMERA]],
  ] as const)(
    "limits %s tokens to required media tracks",
    async (callType, sources) => {
      const service = new LiveKitService(config as never);
      const result = await service.createJoinToken({
        roomName: "private-call-room",
        userId: "alice",
        sessionId: "device-session",
        displayName: "Alice",
        callType,
      });
      const claims = decodeJwt(result.token);
      const video = claims.video as Record<string, unknown>;

      expect(result.url).toBe("wss://livekit.example.com");
      expect(claims.sub).toBe("alice:device-session");
      expect(claims.attributes).toEqual({ userId: "alice" });
      expect(Number(claims.exp) - Number(claims.nbf)).toBe(600);
      expect(video).toMatchObject({
        roomJoin: true,
        room: "private-call-room",
        canPublish: true,
        canSubscribe: true,
        canPublishData: false,
        canUpdateOwnMetadata: false,
        canPublishSources: sources.map((source) =>
          source === TrackSource.MICROPHONE ? "microphone" : "camera",
        ),
      });
    },
  );

  it("gives two sessions of one account distinct participant identities", async () => {
    const service = new LiveKitService(config as never);
    const issue = async (sessionId: string) =>
      decodeJwt(
        (
          await service.createJoinToken({
            roomName: "private-call-room",
            userId: "alice",
            sessionId,
            displayName: "Alice",
            callType: "AUDIO",
          })
        ).token,
      ).sub;

    await expect(
      Promise.all([issue("phone"), issue("tablet")]),
    ).resolves.toEqual(["alice:phone", "alice:tablet"]);
  });
});
