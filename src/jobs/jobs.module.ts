import { Module } from '@nestjs/common';
import { FilesModule } from '../files/files.module';
import { JobsService } from './jobs.service';

@Module({ imports: [FilesModule], providers: [JobsService], exports: [JobsService] })
export class JobsModule {}
