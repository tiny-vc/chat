import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';
import { HealthService } from './health.service';

@Controller()
export class HealthController {
  constructor(private readonly health: HealthService) {}

  @Get('health')
  getHealth() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }

  @Get('ready')
  async getReadiness(@Res({ passthrough: true }) response: Response) {
    const result = await this.health.readiness();
    if (result.status !== 'ok') response.status(503);
    return result;
  }
}
