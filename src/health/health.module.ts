import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';
import { FilesModule } from '../files/files.module';
import { ServerInfoController } from './server-info.controller';

@Module({ imports: [FilesModule], controllers: [HealthController, ServerInfoController], providers: [HealthService] })
export class HealthModule {}
