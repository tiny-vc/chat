import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { ConversationsService } from './conversations.service';
import { UpdateConversationSettingDto } from './dto/update-conversation-setting.dto';

@UseGuards(JwtAuthGuard)
@Controller('conversations/settings')
export class ConversationsController {
  constructor(private readonly service: ConversationsService) {}

  @Get()
  list(@CurrentUser() user: JwtPayload) {
    return this.service.list(user.sub);
  }

  @Patch()
  update(@CurrentUser() user: JwtPayload, @Body() input: UpdateConversationSettingDto) {
    return this.service.update(user.sub, input);
  }

  @Delete(':channelType/:channelId')
  remove(
    @CurrentUser() user: JwtPayload,
    @Param('channelType', ParseIntPipe) channelType: number,
    @Param('channelId') channelId: string,
  ) {
    return this.service.remove(user.sub, channelId, channelType);
  }
}
