import { UserRole } from "@prisma/client";
import { ApiProperty } from "@nestjs/swagger";
import { IsEnum } from "class-validator";

export class SetUserRoleDto {
  @ApiProperty({ enum: UserRole })
  @IsEnum(UserRole)
  role!: UserRole;
}
