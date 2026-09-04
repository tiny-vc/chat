import { Global, Module } from '@nestjs/common';
import { WuKongImService } from './wukongim.service';

@Global()
@Module({
  providers: [WuKongImService],
  exports: [WuKongImService],
})
export class WuKongImModule {}
