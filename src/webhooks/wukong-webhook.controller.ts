import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
} from "@nestjs/common";
import { WukongWebhookService } from "./wukong-webhook.service";

@Controller("webhooks/wukongim")
export class WukongWebhookController {
  constructor(private readonly service: WukongWebhookService) {}

  @Post()
  @HttpCode(HttpStatus.OK)
  receive(
    @Query("token") token: string | undefined,
    @Query("event") event: string | undefined,
    @Body() payload: unknown,
  ) {
    return this.service.receive(token, event, payload);
  }

  @Post(":token")
  @HttpCode(HttpStatus.OK)
  receiveWithPathToken(
    @Param("token") token: string,
    @Query("event") event: string | undefined,
    @Body() payload: unknown,
  ) {
    return this.service.receive(token, event, payload);
  }
}
