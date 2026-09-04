import { IsBoolean, IsOptional } from "class-validator";

export class SetGroupPolicyDto {
  @IsOptional()
  @IsBoolean()
  suspended?: boolean;

  @IsOptional()
  @IsBoolean()
  muteAll?: boolean;
}
