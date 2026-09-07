import {
  ArgumentsHost,
  ServiceUnavailableException,
} from "@nestjs/common";
import { HttpExceptionFilter } from "../src/common/http-exception.filter";

describe("HttpExceptionFilter", () => {
  it("preserves stable application codes and structured details", () => {
    const json = jest.fn();
    const status = jest.fn().mockReturnValue({ json });
    const host = {
      switchToHttp: () => ({
        getRequest: () => ({
          requestId: "request-1",
          originalUrl: "/api/v1/auth/register",
        }),
        getResponse: () => ({ status }),
      }),
    } as unknown as ArgumentsHost;

    new HttpExceptionFilter().catch(
      new ServiceUnavailableException({
        error: "Service Unavailable",
        code: "CAPABILITY_DISABLED",
        capability: "registration",
        message: "registration is currently disabled",
      }),
      host,
    );

    expect(status).toHaveBeenCalledWith(503);
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({
        code: "CAPABILITY_DISABLED",
        details: { capability: "registration" },
      }),
    );
  });
});
