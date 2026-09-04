import { readFileSync } from "node:fs";
import { join } from "node:path";

type Operation = {
  operationId?: string;
  security?: Array<Record<string, string[]>>;
  responses?: Record<
    string,
    { content?: Record<string, { schema?: unknown }> }
  >;
  parameters?: Array<{
    name: string;
    required?: boolean;
    schema?: { type?: string };
  }>;
};

type OpenApiDocument = {
  openapi: string;
  paths: Record<string, Record<string, Operation>>;
  components: {
    schemas: Record<
      string,
      { required?: string[]; properties?: Record<string, unknown> }
    >;
    securitySchemes: Record<string, unknown>;
  };
};

const root = join(__dirname, "..");
const document = JSON.parse(
  readFileSync(join(root, "openapi", "chat-api.json"), "utf8"),
) as OpenApiDocument;
const httpMethods = new Set(["get", "post", "put", "patch", "delete"]);
const operations = Object.entries(document.paths).flatMap(([path, pathItem]) =>
  Object.entries(pathItem)
    .filter(([method]) => httpMethods.has(method))
    .map(([method, operation]) => ({ path, method, operation })),
);

describe("OpenAPI contract", () => {
  it("contains unique, stable operation IDs and typed success responses", () => {
    const operationIds = operations.map(
      ({ operation }) => operation.operationId,
    );

    expect(operationIds).not.toContain(undefined);
    expect(new Set(operationIds).size).toBe(operationIds.length);
    for (const { method, operation } of operations) {
      const successStatus = method === "post" ? "201" : "200";
      expect(
        operation.responses?.[successStatus]?.content?.["application/json"]
          ?.schema,
      ).toBeDefined();
    }
  });

  it("describes login as a strongly typed public operation", () => {
    const login = document.paths["/api/v1/auth/login"].post;
    const loginDto = document.components.schemas.LoginDto;

    expect(login.security).toBeUndefined();
    expect(loginDto.required).toEqual(
      expect.arrayContaining(["username", "password"]),
    );
    expect(Object.keys(loginDto.properties ?? {})).toEqual(
      expect.arrayContaining([
        "username",
        "password",
        "deviceId",
        "deviceType",
        "deviceName",
      ]),
    );
  });

  it("requires bearer auth for protected operations only", () => {
    expect(document.components.securitySchemes["access-token"]).toBeDefined();
    expect(document.paths["/api/v1/groups"].post.security).toEqual([
      { "access-token": [] },
    ]);
    expect(document.paths["/api/v1/health"].get.security).toBeUndefined();
    expect(
      document.paths["/api/v1/auth/refresh"].post.security,
    ).toBeUndefined();
  });

  it("keeps the generated Dart auth API strongly typed", () => {
    const authApi = readFileSync(
      join(
        root,
        "clients",
        "dart",
        "chat_api",
        "lib",
        "src",
        "api",
        "auth_api.dart",
      ),
      "utf8",
    );

    expect(authApi).toContain("required LoginDto loginDto");
    expect(authApi).toContain(
      "Future<Response<AuthSessionResponse>> authLogin",
    );
    expect(authApi).toContain("required RefreshTokenDto refreshTokenDto");
  });

  it("describes admin pagination limits as optional integers", () => {
    for (const path of [
      "/api/v1/admin/users",
      "/api/v1/admin/groups",
      "/api/v1/admin/audit-logs",
      "/api/v1/admin/jobs/runs",
    ]) {
      const parameters = document.paths[path].get.parameters ?? [];
      const limit = parameters.find((parameter) => parameter.name === "limit");
      expect(limit).toMatchObject({
        required: false,
        schema: { type: "integer" },
      });
    }
  });
});
