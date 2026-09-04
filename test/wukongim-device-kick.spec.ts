import { ConfigService } from "@nestjs/config";
import { WuKongImService } from "../src/integrations/wukongim/wukongim.service";

describe("WuKongImService device disconnect", () => {
  const originalFetch = global.fetch;

  afterEach(() => {
    global.fetch = originalFetch;
    jest.restoreAllMocks();
  });

  it("kicks only connections matching both uid and device_id", async () => {
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce({
        ok: true,
        json: async () => ({
          total: 3,
          connections: [
            { id: 11, node_id: 1001, uid: "u1", device_id: "phone-a" },
            { id: 12, node_id: 1001, uid: "u1", device_id: "phone-b" },
            { id: 13, node_id: 1001, uid: "u2", device_id: "phone-a" },
          ],
        }),
      })
      .mockResolvedValueOnce({ ok: true, text: async () => "" });
    global.fetch = fetchMock as unknown as typeof fetch;
    const config = {
      getOrThrow: jest.fn().mockReturnValue("http://wukongim:5001"),
      get: jest.fn().mockReturnValue(undefined),
    } as unknown as ConfigService;
    const service = new WuKongImService(config);

    await expect(service.disconnectDevice("u1", "phone-a")).resolves.toBe(1);
    expect(fetchMock).toHaveBeenNthCalledWith(
      2,
      "http://wukongim:5001/conn/kick",
      expect.objectContaining({
        method: "POST",
        body: JSON.stringify({ uid: "u1", conn_id: 11, node_id: 1001 }),
      }),
    );
  });
});
