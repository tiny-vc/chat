import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { Response } from 'express';
import { RequestWithContext } from './request-context';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const context = host.switchToHttp();
    const request = context.getRequest<RequestWithContext>();
    const response = context.getResponse<Response>();
    const isHttp = exception instanceof HttpException;
    const isTooLarge = isPayloadTooLargeError(exception);
    const statusCode = isHttp
      ? exception.getStatus()
      : isTooLarge
        ? HttpStatus.PAYLOAD_TOO_LARGE
        : HttpStatus.INTERNAL_SERVER_ERROR;
    const detail = isHttp
      ? exception.getResponse()
      : isTooLarge
        ? { error: 'PAYLOAD_TOO_LARGE', message: 'Request body exceeds configured limit' }
        : undefined;
    const normalized = this.normalize(detail, statusCode);
    if (!isHttp || statusCode >= 500) {
      const error = exception instanceof Error ? exception : new Error(String(exception));
      this.logger.error(
        JSON.stringify({ event: 'http.error', requestId: request.requestId, path: request.originalUrl, statusCode, message: error.message }),
        error.stack,
      );
    }
    response.status(statusCode).json({
      statusCode,
      code: normalized.code,
      message: normalized.message,
      ...(normalized.details === undefined ? {} : { details: normalized.details }),
      requestId: request.requestId ?? null,
      timestamp: new Date().toISOString(),
      path: request.originalUrl.split('?')[0],
    });
  }

  private normalize(detail: string | object | undefined, statusCode: number) {
    if (typeof detail === 'string') return { code: this.defaultCode(statusCode), message: detail };
    if (detail && 'message' in detail) {
      const value = detail as { message: string | string[]; error?: string; [key: string]: unknown };
      const { message, error, ...rest } = value;
      return {
        code: (error ?? this.defaultCode(statusCode)).toUpperCase().replaceAll(' ', '_'),
        message: Array.isArray(message) ? 'Request validation failed' : message,
        details: Array.isArray(message) ? { issues: message } : Object.keys(rest).length ? rest : undefined,
      };
    }
    return {
      code: this.defaultCode(statusCode),
      message: statusCode >= 500 ? 'Internal server error' : 'Request failed',
    };
  }

  private defaultCode(statusCode: number) {
    return HttpStatus[statusCode] ?? `HTTP_${statusCode}`;
  }
}

export function isPayloadTooLargeError(exception: unknown): boolean {
  if (!exception || typeof exception !== 'object') return false;
  const value = exception as { status?: unknown; type?: unknown };
  return value.status === HttpStatus.PAYLOAD_TOO_LARGE && value.type === 'entity.too.large';
}
