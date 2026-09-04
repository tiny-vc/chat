import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { WuKongImModule } from '../integrations/wukongim/wukongim.module';
import { BlocksController } from './blocks.controller';
import { BlocksService } from './blocks.service';

@Module({ imports: [AuthModule, WuKongImModule], controllers: [BlocksController], providers: [BlocksService] })
export class BlocksModule {}
