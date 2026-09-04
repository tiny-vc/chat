import { JobRunStatus } from "@prisma/client";
import { Type } from "class-transformer";
import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsEnum, IsInt, IsOptional, IsUUID, Max, Min } from "class-validator";

export class AdminJobRunsQueryDto {
  @IsOptional()
  @IsUUID()
  cursor?: string;

  @IsOptional()
  @ApiPropertyOptional({ type: "integer", default: 30, minimum: 1, maximum: 100 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 30;

  @IsOptional()
  @IsEnum(JobRunStatus)
  status?: JobRunStatus;
}
