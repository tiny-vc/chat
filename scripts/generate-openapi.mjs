import { mkdir, writeFile } from 'node:fs/promises';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../dist/app.module.js';
import { createOpenApiDocument } from '../dist/openapi.js';

const app = await NestFactory.create(AppModule, { logger: false });
try {
  app.setGlobalPrefix('api/v1');
  const document = createOpenApiDocument(app);
  await mkdir('openapi', { recursive: true });
  await writeFile('openapi/chat-api.json', `${JSON.stringify(document, null, 2)}\n`);
  console.log(`Generated openapi/chat-api.json with ${Object.keys(document.paths).length} paths`);
} finally {
  await app.close();
}
