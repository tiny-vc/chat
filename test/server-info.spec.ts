import { ServerInfoController } from "../src/health/server-info.controller";
import { fileSizeLimits } from "../src/files/file-limits";

describe("public server information", () => {
  it("returns only the explicit public allowlist and real upload limits", async () => {
    const get = jest.fn().mockReturnValue("Local Chat");
    const runtime = {
      registrationEnabled: false,
      capabilities: {
        messaging: true,
        files: false,
        groups: true,
        audioCalls: true,
        videoCalls: false,
      },
      updatedAt: new Date().toISOString(),
    };
    const settings = { get: jest.fn().mockResolvedValue(runtime) };
    const info = await new ServerInfoController(
      { get } as never,
      settings as never,
    ).getInfo();
    expect(info).toEqual({
      product: "chat",
      apiVersion: 1,
      name: "Local Chat",
      registrationEnabled: false,
      capabilities: {
        messaging: true,
        files: false,
        groups: true,
        audioCalls: true,
        videoCalls: false,
      },
      uploadLimits: fileSizeLimits,
    });
    expect(get).toHaveBeenCalledTimes(1);
    expect(get).toHaveBeenCalledWith("SERVER_NAME");
    expect(settings.get).toHaveBeenCalledTimes(1);
    expect(info.uploadLimits).not.toBe(fileSizeLimits);
  });
});
