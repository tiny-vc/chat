import { IsString, Length } from 'class-validator';

export class DeactivateAccountDto {
  @IsString()
  @Length(8, 72)
  currentPassword!: string;
}
