import { IsBoolean, IsInt, IsOptional, Max, Min } from 'class-validator';

export class MuteMemberDto {
  @IsBoolean()
  muted!: boolean;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(43_200)
  durationMinutes?: number;
}
