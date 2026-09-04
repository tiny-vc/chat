import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiOkResponse } from '@nestjs/swagger';
import { fileSizeLimits } from '../files/file-limits';

@Controller('server-info')
export class ServerInfoController {
  constructor(private readonly config: ConfigService) {}

  @Get()
  @ApiOkResponse({ schema: {
    type: 'object', required: ['product', 'apiVersion', 'name', 'registrationEnabled', 'uploadLimits'],
    properties: {
      product: { type: 'string', enum: ['chat'] },
      apiVersion: { type: 'integer', enum: [1] },
      name: { type: 'string' },
      registrationEnabled: { type: 'boolean' },
      uploadLimits: { type: 'object', additionalProperties: { type: 'integer' } },
    },
  } })
  getInfo() {
    // Explicit allowlist: never expose environment variables or readiness details.
    return { product: 'chat', apiVersion: 1,
      name: this.config.get<string>('SERVER_NAME') ?? 'Chat',
      registrationEnabled: true, uploadLimits: { ...fileSizeLimits } };
  }
}
