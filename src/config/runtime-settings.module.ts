import { Global, Module } from "@nestjs/common";
import { RuntimeSettingsService } from "./runtime-settings.service";
import { RuntimeCapabilityGuard } from "./runtime-capability.guard";
import { WuKongImModule } from "../integrations/wukongim/wukongim.module";
import { ImPolicyReconcilerService } from "./im-policy-reconciler.service";

@Global()
@Module({
  imports: [WuKongImModule],
  providers: [RuntimeSettingsService, RuntimeCapabilityGuard, ImPolicyReconcilerService],
  exports: [RuntimeSettingsService, RuntimeCapabilityGuard],
})
export class RuntimeSettingsModule {}
