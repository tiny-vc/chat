import { Injectable, Logger, NestMiddleware } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NextFunction, Response } from 'express';
import { randomUUID } from 'node:crypto';
import { RequestWithContext } from './request-context';

@Injectable()
export class RequestContextMiddleware implements NestMiddleware {
  private readonly logger = new Logger('HTTP');
  private readonly slowRequestMs: number;

  constructor(config: ConfigService) {
    this.slowRequestMs = config.getOrThrow<number>('SLOW_REQUEST_MS');
  }

  use(request: RequestWithContext, response: Response, next: NextFunction) {
    const supplied = request.headers['x-request-id'];
    const requestId =
      typeof supplied === 'string' && /^[a-zA-Z0-9_.:-]{1,100}$/.test(supplied)
        ? supplied
        : randomUUID();
    request.requestId = requestId;
    request.requestStartedAt = Date.now();
    response.setHeader('x-request-id', requestId);
    response.on('finish', () => {
      const durationMs = Date.now() - (request.requestStartedAt ?? Date.now());
      const entry = JSON.stringify({
        event: durationMs >= this.slowRequestMs ? 'http.slow_request' : 'http.request',
        requestId,
        method: request.method,
        path: request.originalUrl.split('?')[0],
        statusCode: response.statusCode,
        durationMs,
        ip: request.ip,
      });
      if (durationMs >= this.slowRequestMs) this.logger.warn(entry);
      else this.logger.log(entry);
    });
    next();
  }
}
