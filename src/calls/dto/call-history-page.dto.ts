import { IsISO8601, IsOptional, IsUUID } from "class-validator";

export class CallHistoryPageDto {
  @IsOptional()
  @IsISO8601({ strict: true })
  before?: string;

  @IsOptional()
  @IsUUID()
  beforeId?: string;
}
