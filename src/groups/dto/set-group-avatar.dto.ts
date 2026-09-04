import { IsUUID } from 'class-validator';

export class SetGroupAvatarDto {
  @IsUUID()
  fileId!: string;
}
