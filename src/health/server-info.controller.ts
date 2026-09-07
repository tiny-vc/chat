import { Controller, Get } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { ApiOkResponse } from "@nestjs/swagger";
import { fileSizeLimits } from "../files/file-limits";
import { RuntimeSettingsService } from "../config/runtime-settings.service";

@Controller("server-info")
export class ServerInfoController {
  constructor(
    private readonly config: ConfigService,
    private readonly settings: RuntimeSettingsService,
  ) {}

  @Get()
  @ApiOkResponse({
    schema: {
      type: "object",
      required: [
        "product",
        "apiVersion",
        "name",
        "registrationEnabled",
        "capabilities",
        "uploadLimits",
      ],
      properties: {
        product: { type: "string", enum: ["chat"] },
        apiVersion: { type: "integer", enum: [1] },
        name: { type: "string" },
        registrationEnabled: { type: "boolean" },
        capabilities: {
          type: "object",
          required: [
            "messaging",
            "files",
            "groups",
            "audioCalls",
            "videoCalls",
          ],
          properties: {
            messaging: { type: "boolean" },
            files: { type: "boolean" },
            groups: { type: "boolean" },
            audioCalls: { type: "boolean" },
            videoCalls: { type: "boolean" },
          },
        },
        uploadLimits: {
          type: "object",
          additionalProperties: { type: "integer" },
        },
      },
    },
  })
  async getInfo() {
    const runtime = await this.settings.get();
    // Explicit allowlist: never expose environment variables or readiness details.
    return {
      product: "chat",
      apiVersion: 1,
      name: this.config.get<string>("SERVER_NAME") ?? "Chat",
      registrationEnabled: runtime.registrationEnabled,
      capabilities: runtime.capabilities,
      uploadLimits: { ...fileSizeLimits },
    };
  }
}
