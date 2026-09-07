import { Module } from "@nestjs/common";
import { WukongWebhookController } from "./wukong-webhook.controller";
import { WukongWebhookService } from "./wukong-webhook.service";
import { LivekitWebhookController } from "./livekit-webhook.controller";
import { LivekitWebhookService } from "./livekit-webhook.service";
import { LiveKitModule } from "../integrations/livekit/livekit.module";
import { CallsModule } from "../calls/calls.module";

@Module({
  imports: [LiveKitModule, CallsModule],
  controllers: [WukongWebhookController, LivekitWebhookController],
  providers: [WukongWebhookService, LivekitWebhookService],
})
export class WebhooksModule {}
