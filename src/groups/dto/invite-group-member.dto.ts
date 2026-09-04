import { IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';

export class InviteGroupMemberDto {
  @IsUUID()
  userId!: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  message?: string;
}
