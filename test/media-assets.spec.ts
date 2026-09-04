import { ConflictException, ForbiddenException } from '@nestjs/common';
import { FilesService } from '../src/files/files.service';
import { UsersService } from '../src/users/users.service';

describe('media asset rules', () => {
  it('rejects a non-avatar file as a profile avatar', async () => {
    const service = new UsersService({
      storedFile: {
        findFirst: jest.fn().mockResolvedValue({
          id: 'file-id', purpose: 'CHAT_FILE', scope: 'PRIVATE', mimeType: 'image/png',
        }),
      },
    } as never);
    await expect(service.setAvatar('user-id', 'file-id')).rejects.toBeInstanceOf(
      ForbiddenException,
    );
  });

  it('does not delete files referenced by an avatar or thumbnail', async () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    Object.assign(service, {
      prisma: {
        storedFile: {
          findFirst: jest.fn().mockResolvedValue({
            id: 'file-id', avatarFor: { id: 'user-id' }, thumbnailOf: [],
          }),
        },
      },
    });
    await expect(service.deleteFile('user-id', 'file-id')).rejects.toBeInstanceOf(
      ConflictException,
    );
  });

  it('rejects forwarding a file to private storage', async () => {
    const service = Object.create(FilesService.prototype) as FilesService;
    await expect(
      service.forward('user-id', 'file-id', {
        scope: 'PRIVATE',
        scopeId: '00000000-0000-4000-8000-000000000001',
      }),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });
});
