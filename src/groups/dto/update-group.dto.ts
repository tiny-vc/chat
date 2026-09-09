import { IsBoolean, IsOptional, IsString, Length, MaxLength } from 'class-validator';

export class UpdateGroupDto {
  @IsOptional()
  @IsString()
  @Length(1, 120)
  name?: string;

  @IsOptional()
  @IsString()
  @MaxLength(1000)
  announcement?: string;

  @IsOptional()
  @IsBoolean()
  muteAll?: boolean;
}
