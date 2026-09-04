import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

export class SyncImConversationsDto {
  @ApiPropertyOptional({ type: String, default: '' })
  @IsOptional()
  @IsString()
  @MaxLength(20_000)
  lastMsgSeqs = '';

  @ApiPropertyOptional({ type: Number, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @Max(200)
  msgCount = 20;

  @ApiPropertyOptional({ type: Number, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  version = 0;
}

export class SyncImChannelMessagesDto {
  @IsString()
  @MaxLength(120)
  channelId: string;

  @Type(() => Number)
  @IsInt()
  @IsIn([1, 2])
  channelType: 1 | 2;

  @ApiPropertyOptional({ type: Number, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  startMessageSeq = 0;

  @ApiPropertyOptional({ type: Number, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  endMessageSeq = 0;

  @ApiPropertyOptional({ type: Number, default: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 50;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @IsIn([0, 1])
  pullMode: 0 | 1 = 0;
}

export class RevokeImMessageDto {
  @IsString()
  @MaxLength(120)
  channelId: string;

  @Type(() => Number)
  @IsInt()
  @IsIn([1, 2])
  channelType: 1 | 2;

  @IsString()
  @MaxLength(128)
  clientMsgNo: string;
}

export class MarkImReadDto {
  @IsString()
  @MaxLength(120)
  channelId: string;

  @Type(() => Number)
  @IsInt()
  @IsIn([1, 2])
  channelType: 1 | 2;

  @Type(() => Number)
  @IsInt()
  @Min(0)
  messageSeq: number;
}

export class ReceiptMessageDto {
  @IsString()
  @MaxLength(128)
  messageId: string;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  messageSeq: number;
}

export class SyncImReceiptsDto {
  @IsString()
  @MaxLength(120)
  channelId: string;

  @Type(() => Number)
  @IsInt()
  @IsIn([1, 2])
  channelType: 1 | 2;

  @IsArray()
  @ArrayMaxSize(100)
  @ValidateNested({ each: true })
  @Type(() => ReceiptMessageDto)
  messages: ReceiptMessageDto[];
}
