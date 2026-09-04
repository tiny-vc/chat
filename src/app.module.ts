import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { validateEnvironment } from './config/environment';
import { HealthModule } from './health/health.module';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { WuKongImModule } from './integrations/wukongim/wukongim.module';
import { LiveKitModule } from './integrations/livekit/livekit.module';
import { CallsModule } from './calls/calls.module';
import { UsersModule } from './users/users.module';
import { FriendsModule } from './friends/friends.module';
import { GroupsModule } from './groups/groups.module';
import { FilesModule } from './files/files.module';
import { WebhooksModule } from './webhooks/webhooks.module';
import { AdminModule } from './admin/admin.module';
import { MessagesModule } from './messages/messages.module';
import { ConversationsModule } from './conversations/conversations.module';
import { BlocksModule } from './blocks/blocks.module';
import { JobsModule } from './jobs/jobs.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      validate: validateEnvironment,
    }),
    PrismaModule,
    WuKongImModule,
    LiveKitModule,
    HealthModule,
    AuthModule,
    CallsModule,
    UsersModule,
    FriendsModule,
    GroupsModule,
    FilesModule,
    WebhooksModule,
    AdminModule,
    MessagesModule,
    ConversationsModule,
    BlocksModule,
    JobsModule,
  ],
})
export class AppModule {}
