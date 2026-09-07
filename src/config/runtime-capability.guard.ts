import {
  CanActivate,
  ExecutionContext,
  Injectable,
  ServiceUnavailableException,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { Request } from "express";
import {
  RUNTIME_CAPABILITY_KEY,
  RuntimeCapability,
} from "./runtime-capability.decorator";
import { RuntimeSettingsService } from "./runtime-settings.service";

type CapabilityRequirement = RuntimeCapability | "callType";

@Injectable()
export class RuntimeCapabilityGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly settings: RuntimeSettingsService,
  ) {}

  async canActivate(context: ExecutionContext) {
    const requirement = this.reflector.getAllAndOverride<CapabilityRequirement>(
      RUNTIME_CAPABILITY_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (!requirement) return true;

    const current = await this.settings.get();
    const capability =
      requirement === "callType"
        ? this.callCapability(context.switchToHttp().getRequest<Request>())
        : requirement;
    const enabled =
      capability === "registration"
        ? current.registrationEnabled
        : current.capabilities[capability];
    if (enabled) return true;

    throw new ServiceUnavailableException({
      statusCode: 503,
      error: "Service Unavailable",
      code: "CAPABILITY_DISABLED",
      capability,
      message: `${capability} is currently disabled`,
    });
  }

  private callCapability(request: Request): "audioCalls" | "videoCalls" {
    const body = request.body as { type?: unknown } | undefined;
    return body?.type === "VIDEO" ? "videoCalls" : "audioCalls";
  }
}
