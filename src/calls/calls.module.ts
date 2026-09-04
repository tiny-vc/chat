import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { CallsController } from './calls.controller';
import { CallsService } from './calls.service';
import { FriendsModule } from '../friends/friends.module';

@Module({
  imports: [AuthModule, FriendsModule],
  controllers: [CallsController],
  providers: [CallsService],
})
export class CallsModule {}
