import { Body, Controller, Post, Query } from '@nestjs/common';
import { WukongWebhookService } from './wukong-webhook.service';

@Controller('webhooks/wukongim')
export class WukongWebhookController {
  constructor(private readonly service: WukongWebhookService) {}

  @Post()
  receive(@Query('token') token: string | undefined, @Body() payload: unknown) {
    return this.service.receive(token, payload);
  }
}
