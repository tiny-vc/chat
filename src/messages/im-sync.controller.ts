import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import {
  RevokeImMessageDto,
  MarkImReadDto,
  SyncImReceiptsDto,
  SyncImChannelMessagesDto,
  SyncImConversationsDto,
} from './im-sync.dto';
import { MessagesService } from './messages.service';

@UseGuards(JwtAuthGuard)
@Controller('im')
export class ImSyncController {
  constructor(private readonly service: MessagesService) {}

  @Post('conversations/sync')
  syncConversations(
    @CurrentUser() user: JwtPayload,
    @Body() input: SyncImConversationsDto,
  ) {
    return this.service.syncConversations(user.sub, input);
  }

  @Post('messages/sync')
  syncMessages(
    @CurrentUser() user: JwtPayload,
    @Body() input: SyncImChannelMessagesDto,
  ) {
    return this.service.syncChannelMessages(user.sub, input);
  }

  @Post('conversations/read')
  markRead(
    @CurrentUser() user: JwtPayload,
    @Body() input: MarkImReadDto,
  ) {
    return this.service.markConversationRead(
      user.sub,
      input.channelId,
      input.channelType,
      input.messageSeq,
    );
  }

  @Post('messages/receipts')
  receipts(
    @CurrentUser() user: JwtPayload,
    @Body() input: SyncImReceiptsDto,
  ) {
    return this.service.messageReceipts(user.sub, input);
  }


  @Post('messages/revoke')
  revokeMessage(
    @CurrentUser() user: JwtPayload,
    @Body() input: RevokeImMessageDto,
  ) {
    return this.service.revokeMessage(user.sub, input);
  }
}
