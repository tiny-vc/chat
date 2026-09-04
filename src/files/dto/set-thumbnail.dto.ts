import { IsUUID } from 'class-validator';

export class SetThumbnailDto {
  @IsUUID()
  thumbnailFileId!: string;
}
