import { IsString, MaxLength } from 'class-validator';

export class UpdateGroupNicknameDto {
  @IsString()
  @MaxLength(80)
  nickname!: string;
}
