import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MessagesService } from './messages.service';
import { RequireRuntimeCapability } from '../config/runtime-capability.decorator';
import { RuntimeCapabilityGuard } from '../config/runtime-capability.guard';

@Controller('messages/protocol')
export class MessagesController {
  constructor(private readonly service: MessagesService) {}

  @Get()
  describe() {
    return this.service.describeProtocol();
  }

  @UseGuards(JwtAuthGuard)
  @Post('validate')
  @RequireRuntimeCapability('messaging')
  @UseGuards(RuntimeCapabilityGuard)
  validate(@Body() payload: unknown) {
    return this.service.validate(payload);
  }
}
