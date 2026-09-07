import { ExecutionContext } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { RuntimeCapabilityGuard } from "../src/config/runtime-capability.guard";
import { RuntimeSettingsService } from "../src/config/runtime-settings.service";

function context(body: unknown = {}) {
  return {
    getHandler: () => function handler() {},
    getClass: () => class Controller {},
    switchToHttp: () => ({ getRequest: () => ({ body }) }),
  } as unknown as ExecutionContext;
}

function settings(overrides: Record<string, boolean> = {}) {
  return {
    get: jest.fn().mockResolvedValue({
      registrationEnabled: overrides.registration ?? true,
      capabilities: {
        messaging: overrides.messaging ?? true,
        files: overrides.files ?? true,
        groups: overrides.groups ?? true,
        audioCalls: overrides.audioCalls ?? true,
        videoCalls: overrides.videoCalls ?? true,
      },
      updatedAt: new Date().toISOString(),
    }),
  } as unknown as RuntimeSettingsService;
}

describe("RuntimeCapabilityGuard", () => {
  it("allows an enabled static capability", async () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue("files"),
    } as unknown as Reflector;
    await expect(
      new RuntimeCapabilityGuard(reflector, settings()).canActivate(context()),
    ).resolves.toBe(true);
  });

  it("returns a stable disabled-capability error", async () => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue("registration"),
    } as unknown as Reflector;
    const guard = new RuntimeCapabilityGuard(
      reflector,
      settings({ registration: false }),
    );
    await expect(guard.canActivate(context())).rejects.toMatchObject({
      response: {
        statusCode: 503,
        code: "CAPABILITY_DISABLED",
        capability: "registration",
      },
    });
  });

  it.each([
    ["AUDIO", "audioCalls"],
    ["VIDEO", "videoCalls"],
  ])("checks the %s call switch", async (type, capability) => {
    const reflector = {
      getAllAndOverride: jest.fn().mockReturnValue("callType"),
    } as unknown as Reflector;
    const guard = new RuntimeCapabilityGuard(
      reflector,
      settings({ [capability]: false }),
    );
    await expect(guard.canActivate(context({ type }))).rejects.toMatchObject({
      response: { capability },
    });
  });
});
