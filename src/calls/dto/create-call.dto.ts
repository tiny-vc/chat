import { CallType } from '@prisma/client';
import { IsEnum, IsUUID } from 'class-validator';

export class CreateCallDto {
  @IsUUID()
  targetUserId!: string;

  @IsEnum(CallType)
  type!: CallType;
}
