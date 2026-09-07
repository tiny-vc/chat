import {
  BadRequestException,
  Body,
  Controller,
  Headers,
  Post,
} from "@nestjs/common";
import { LivekitWebhookService } from "./livekit-webhook.service";

@Controller("webhooks/livekit")
export class LivekitWebhookController {
  constructor(private readonly service: LivekitWebhookService) {}

  @Post()
  receive(
    @Headers("authorization") authorization: string | undefined,
    @Body() rawBody: unknown,
  ) {
    if (typeof rawBody !== "string") {
      throw new BadRequestException("LiveKit webhook body must be raw text");
    }
    return this.service.receive(rawBody, authorization);
  }
}
