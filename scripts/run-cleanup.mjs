import { NestFactory } from '@nestjs/core';
import { AppModule } from '../dist/app.module.js';
import { JobsService } from '../dist/jobs/jobs.service.js';

const app = await NestFactory.createApplicationContext(AppModule, { logger: ['error', 'warn'] });
try {
  const result = await app.get(JobsService).runCleanup('MANUAL');
  console.log(JSON.stringify(result));
} finally {
  await app.close();
}
