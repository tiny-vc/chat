import { FileScope } from '@prisma/client';
import { IsEnum, IsInt, IsMimeType, IsOptional, IsString, IsUUID, Max, MaxLength, Min } from 'class-validator';

export enum FilePurpose {
  AVATAR = 'AVATAR',
  CHAT_IMAGE = 'CHAT_IMAGE',
  CHAT_VOICE = 'CHAT_VOICE',
  CHAT_VIDEO = 'CHAT_VIDEO',
  CHAT_FILE = 'CHAT_FILE',
}

export class CreateUploadDto {
  @IsString()
  @MaxLength(255)
  fileName!: string;

  @IsMimeType()
  mimeType!: string;

  @IsInt()
  @Min(1)
  @Max(104_857_600)
  size!: number;

  @IsEnum(FilePurpose)
  purpose!: FilePurpose;

  @IsEnum(FileScope)
  scope!: FileScope;

  @IsOptional()
  @IsUUID()
  scopeId?: string;
}
