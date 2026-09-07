import { UserReportStatus } from "@prisma/client";
import { Type } from "class-transformer";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsDate,
  IsEnum,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from "class-validator";

export class AdminReportQueryDto {
  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @ApiPropertyOptional({
    type: "integer",
    default: 50,
    minimum: 1,
    maximum: 100,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 50;
  @IsOptional() @IsEnum(UserReportStatus) status?: UserReportStatus;
  @IsOptional() @IsString() @MaxLength(80) search?: string;
  @IsOptional() @Type(() => Date) @IsDate() from?: Date;
  @IsOptional() @Type(() => Date) @IsDate() to?: Date;
}

export class DecideReportDto {
  @ApiProperty({
    enum: [UserReportStatus.RESOLVED, UserReportStatus.DISMISSED],
  })
  @IsIn([UserReportStatus.RESOLVED, UserReportStatus.DISMISSED])
  status!: "RESOLVED" | "DISMISSED";

  @IsOptional()
  @IsString()
  @MaxLength(500)
  note?: string;
}
