import 'reflect-metadata';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { json, urlencoded } from 'express';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/http-exception.filter';
import { RequestContextMiddleware } from './common/request-context.middleware';
import { setupOpenApi } from './openapi';
import { parseCorsOrigins } from './config/cors';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bodyParser: false });
  const express = app.getHttpAdapter().getInstance() as { disable(name: string): void };
  const config = app.get(ConfigService);
  const allowedOrigins = config.getOrThrow<string>('CORS_ALLOWED_ORIGINS');
  const bodyLimit = config.getOrThrow<string>('JSON_BODY_LIMIT');
  const isProduction = config.getOrThrow<string>('NODE_ENV') === 'production';
  express.disable('x-powered-by');
  const requestContext = new RequestContextMiddleware(config);
  app.use(requestContext.use.bind(requestContext));
  app.use(
    helmet({
      strictTransportSecurity: isProduction ? undefined : false,
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          imgSrc: ["'self'", 'data:'],
          scriptSrc: ["'self'", "'unsafe-inline'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          fontSrc: ["'self'", 'data:'],
        },
      },
    }),
  );
  app.use(json({ limit: bodyLimit }));
  app.use(urlencoded({ extended: true, limit: bodyLimit }));
  app.setGlobalPrefix('api/v1');
  app.enableCors({
    origin: parseCorsOrigins(allowedOrigins),
    credentials: true,
  });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new HttpExceptionFilter());
  setupOpenApi(app);
  app.enableShutdownHooks();
  await app.listen(process.env.PORT ?? 3000);
}

void bootstrap();
