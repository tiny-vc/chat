import { GroupStatus, UserRole, UserStatus } from "@prisma/client";
import { Type } from "class-transformer";
import { ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from "class-validator";

export class AdminListQueryDto {
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
  @IsString()
  @MaxLength(80)
  search?: string;
}

export class AdminUserListQueryDto extends AdminListQueryDto {
  @IsOptional()
  @IsEnum(UserStatus)
  status?: UserStatus;

  @IsOptional()
  @IsEnum(UserRole)
  role?: UserRole;
}

export class AdminGroupListQueryDto extends AdminListQueryDto {
  @IsOptional()
  @IsEnum(GroupStatus)
  status?: GroupStatus;
}

export class AdminGroupMemberListQueryDto extends AdminListQueryDto {}
