import { IsOptional, IsString, MaxLength } from 'class-validator';

export class GroupJoinMessageDto {
  @IsOptional()
  @IsString()
  @MaxLength(500)
  message?: string;
}
