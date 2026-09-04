import { Module } from '@nestjs/common';
import { WukongWebhookController } from './wukong-webhook.controller';
import { WukongWebhookService } from './wukong-webhook.service';

@Module({
  controllers: [WukongWebhookController],
  providers: [WukongWebhookService],
})
export class WebhooksModule {}
