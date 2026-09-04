import { GroupRole } from '@prisma/client';
import { IsIn } from 'class-validator';

export class SetMemberRoleDto {
  @IsIn([GroupRole.ADMIN, GroupRole.MEMBER])
  role!: 'ADMIN' | 'MEMBER';
}
