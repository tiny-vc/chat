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
      {
        required?: string[];
        properties?: Record<string, unknown>;
        allOf?: Array<{
          required?: string[];
          properties?: Record<string, unknown>;
        }>;
      }
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
    const adminLogin = document.paths["/api/v1/auth/admin-login"].post;
    const loginDto = document.components.schemas.LoginDto;

    expect(login.security).toBeUndefined();
    expect(adminLogin.security).toBeUndefined();
    expect(
      adminLogin.responses?.["201"]?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/AuthSessionResponse" });
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

  it("types call history direction and peer without exposing device bindings", () => {
    const listSchema = document.paths["/api/v1/calls"].get.responses?.["200"]
      ?.content?.["application/json"]?.schema as {
      type?: string;
      items?: { $ref?: string };
    };
    expect(listSchema).toEqual({
      type: "array",
      items: { $ref: "#/components/schemas/CallHistoryResponse" },
    });

    const extension =
      document.components.schemas.CallHistoryResponse.allOf?.[1];
    expect(extension?.required).toEqual(["outgoing", "peer"]);
    expect(extension?.properties).toHaveProperty("outgoing");
    expect(extension?.properties).toHaveProperty("peer");
    expect(
      document.components.schemas.CallSessionResponse.properties,
    ).not.toHaveProperty("initiatorSessionId");
    expect(
      document.components.schemas.CallSessionResponse.properties,
    ).not.toHaveProperty("targetSessionId");
  });

  it("types every call state transition as a call session", () => {
    for (const action of [
      "accept",
      "reject",
      "busy",
      "cancel",
      "miss",
      "end",
    ]) {
      const schema =
        document.paths[`/api/v1/calls/{callId}/${action}`].post.responses?.[
          "201"
        ]?.content?.["application/json"]?.schema;
      expect(schema).toEqual({
        $ref: "#/components/schemas/CallSessionResponse",
      });
    }
  });

  it("types blacklist reads and writes without internal relation fields", () => {
    expect(
      document.paths["/api/v1/blocks"].get.responses?.["200"]?.content?.[
        "application/json"
      ]?.schema,
    ).toEqual({
      type: "array",
      items: { $ref: "#/components/schemas/BlockedUserResponse" },
    });
    expect(
      document.paths["/api/v1/blocks/{userId}"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/BlockedUserResponse" });
    expect(document.components.schemas.BlockedUserResponse.required).toEqual([
      "user",
      "createdAt",
    ]);
  });

  it("includes requester details in the typed friend request list", () => {
    expect(
      document.paths["/api/v1/friends/requests"].get.responses?.["200"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({
      type: "array",
      items: { $ref: "#/components/schemas/FriendRequestResponse" },
    });
    const extension =
      document.components.schemas.FriendRequestResponse.allOf?.[1];
    expect(extension?.required).toEqual(["requester"]);
    expect(extension?.properties).toHaveProperty("requester");
  });

  it("describes the user search query as an optional string", () => {
    const query = document.paths["/api/v1/users/search"].get.parameters?.find(
      (parameter) => parameter.name === "q",
    );
    expect(query).toMatchObject({
      name: "q",
      required: false,
      schema: { type: "string" },
    });
  });

  it("types user reports as an acknowledged operation", () => {
    expect(
      document.paths["/api/v1/users/{userId}/report"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/SuccessResponse" });
  });

  it("types account deactivation as an acknowledged operation", () => {
    expect(
      document.paths["/api/v1/auth/account"].delete.responses?.["200"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/SuccessResponse" });
  });

  it("types forwarded files as stored files", () => {
    expect(
      document.paths["/api/v1/files/{fileId}/forward"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/StoredFileResponse" });
  });

  it("types IM acknowledgements and message receipts", () => {
    expect(
      document.paths["/api/v1/im/conversations/read"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/SuccessResponse" });
    expect(
      document.paths["/api/v1/im/messages/revoke"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/SuccessResponse" });
    expect(
      document.paths["/api/v1/im/messages/receipts"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({
      type: "array",
      items: { $ref: "#/components/schemas/MessageReceiptResponse" },
    });
  });

  it("types IM conversation and message history envelopes", () => {
    expect(
      document.paths["/api/v1/im/conversations/sync"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({
      type: "array",
      items: { $ref: "#/components/schemas/ImSyncConversationResponse" },
    });
    expect(
      document.paths["/api/v1/im/messages/sync"].post.responses?.["201"]
        ?.content?.["application/json"]?.schema,
    ).toEqual({ $ref: "#/components/schemas/ImSyncMessagesResponse" });
  });
});
