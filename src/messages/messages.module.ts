import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { MessagesController } from './messages.controller';
import { ImSyncController } from './im-sync.controller';
import { MessagesService } from './messages.service';

@Module({
  imports: [AuthModule],
  controllers: [MessagesController, ImSyncController],
  providers: [MessagesService],
  exports: [MessagesService],
})
export class MessagesModule {}
