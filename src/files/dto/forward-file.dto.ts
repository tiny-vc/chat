import { FileScope } from '@prisma/client';
import { IsEnum, IsUUID } from 'class-validator';

export class ForwardFileDto {
  @IsEnum(FileScope)
  scope!: FileScope;

  @IsUUID()
  scopeId!: string;
}
