import { IsBoolean, IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

export class UpdateConversationSettingDto {
  @IsString()
  @MaxLength(120)
  channelId!: string;

  @IsIn([1, 2])
  channelType!: 1 | 2;

  @IsOptional()
  @IsBoolean()
  pinned?: boolean;

  @IsOptional()
  @IsBoolean()
  muted?: boolean;

  @IsOptional()
  @IsBoolean()
  archived?: boolean;
}
