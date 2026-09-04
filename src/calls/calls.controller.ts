import { Body, Controller, Get, Param, Post, UseGuards } from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { JwtPayload } from '../auth/jwt-payload';
import { CallsService } from './calls.service';
import { CreateCallDto } from './dto/create-call.dto';

@UseGuards(JwtAuthGuard)
@Controller('calls')
export class CallsController {
  constructor(private readonly callsService: CallsService) {}

  @Post()
  create(@CurrentUser() user: JwtPayload, @Body() input: CreateCallDto) {
    return this.callsService.create(user.sub, input);
  }

  @Get()
  list(@CurrentUser() user: JwtPayload) {
    return this.callsService.list(user.sub);
  }

  @Post(':callId/token')
  createToken(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.createToken(callId, user.sub);
  }

  @Post(':callId/accept')
  accept(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.accept(callId, user.sub);
  }

  @Post(':callId/reject')
  reject(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.reject(callId, user.sub);
  }

  @Post(':callId/busy')
  busy(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.busy(callId, user.sub);
  }

  @Post(':callId/cancel')
  cancel(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.cancel(callId, user.sub);
  }

  @Post(':callId/miss')
  miss(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.miss(callId, user.sub);
  }

  @Post(':callId/end')
  end(@CurrentUser() user: JwtPayload, @Param('callId') callId: string) {
    return this.callsService.end(callId, user.sub);
  }
}
