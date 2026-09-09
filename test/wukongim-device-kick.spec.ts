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
        json: () =>
          Promise.resolve({
            total: 3,
            connections: [
              { id: 11, node_id: 1001, uid: "u1", device_id: "phone-a" },
              { id: 12, node_id: 1001, uid: "u1", device_id: "phone-b" },
              { id: 13, node_id: 1001, uid: "u2", device_id: "phone-a" },
            ],
          }),
      })
      .mockResolvedValueOnce({ ok: true, text: () => Promise.resolve("") });
    global.fetch = fetchMock;
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

  it("kicks a selected set of devices while preserving the current device", async () => {
    const fetchMock = jest
      .fn()
      .mockResolvedValueOnce({
        ok: true,
        json: () =>
          Promise.resolve({
            total: 3,
            connections: [
              { id: 21, node_id: 1001, uid: "u1", device_id: "current" },
              { id: 22, node_id: 1001, uid: "u1", device_id: "old-a" },
              { id: 23, node_id: 1002, uid: "u1", device_id: "old-b" },
            ],
          }),
      })
      .mockResolvedValue({ ok: true, text: () => Promise.resolve("") });
    global.fetch = fetchMock;
    const config = {
      getOrThrow: jest.fn().mockReturnValue("http://wukongim:5001"),
      get: jest.fn().mockReturnValue(undefined),
    } as unknown as ConfigService;
    const service = new WuKongImService(config);

    await expect(
      service.disconnectDevices("u1", ["old-a", "old-b"]),
    ).resolves.toBe(2);
    expect(fetchMock).toHaveBeenCalledTimes(3);
    expect(fetchMock).not.toHaveBeenCalledWith(
      "http://wukongim:5001/conn/kick",
      expect.objectContaining({
        body: expect.stringContaining('"conn_id":21'),
      }),
    );
  });

  it("delivers personal call signals without creating conversations or unread badges", async () => {
    const fetchMock = jest.fn().mockResolvedValue({
      ok: true,
      text: () => Promise.resolve(""),
    });
    global.fetch = fetchMock;
    const config = {
      getOrThrow: jest.fn().mockReturnValue("http://wukongim:5001"),
      get: jest.fn().mockReturnValue(undefined),
    } as unknown as ConfigService;
    const service = new WuKongImService(config);

    await service.sendPersonalMessage({
      fromUserId: "same-user",
      toUserId: "same-user",
      payload: { type: 2001, action: "answered_elsewhere" },
    });

    const request = fetchMock.mock.calls[0][1] as RequestInit;
    const body = JSON.parse(request.body as string) as {
      header: Record<string, number>;
    };
    expect(body.header).toEqual({
      no_persist: 1,
      red_dot: 0,
      sync_once: 0,
    });
  });
});
