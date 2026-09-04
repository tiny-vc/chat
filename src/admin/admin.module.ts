import { Module } from "@nestjs/common";
import { AuthModule } from "../auth/auth.module";
import { WuKongImModule } from "../integrations/wukongim/wukongim.module";
import { AdminController } from "./admin.controller";
import { AdminService } from "./admin.service";
import { JobsModule } from "../jobs/jobs.module";

@Module({
  imports: [AuthModule, WuKongImModule, JobsModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
