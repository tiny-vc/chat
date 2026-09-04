import { ArrayMaxSize, ArrayUnique, IsArray, IsOptional, IsString, IsUUID, Length } from 'class-validator';

export class CreateGroupDto {
  @IsString()
  @Length(1, 120)
  name!: string;

  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(499)
  @IsUUID('4', { each: true })
  memberIds: string[] = [];
}
