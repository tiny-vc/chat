import { IsISO8601, IsOptional, IsUUID } from 'class-validator';

export class GroupJoinPageDto {
  @IsOptional()
  @IsISO8601({ strict: true })
  before?: string;

  @IsOptional()
  @IsUUID()
  beforeId?: string;
}
