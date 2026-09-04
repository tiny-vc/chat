import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

export class ReportUserDto {
  @IsIn(['SPAM', 'HARASSMENT', 'FRAUD', 'INAPPROPRIATE', 'OTHER'])
  reason!: 'SPAM' | 'HARASSMENT' | 'FRAUD' | 'INAPPROPRIATE' | 'OTHER';

  @IsOptional()
  @IsString()
  @MaxLength(500)
  details?: string;
}
