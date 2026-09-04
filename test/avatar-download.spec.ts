import { ForbiddenException } from '@nestjs/common';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { FilesService } from '../src/files/files.service';

jest.mock('@aws-sdk/s3-request-presigner', () => ({ getSignedUrl: jest.fn() }));

describe('avatar download authorization', () => {
  function setup() {
    const prisma = {
      storedFile: { findFirst: jest.fn().mockResolvedValue({
        id: 'avatar', ownerUserId: 'owner', purpose: 'AVATAR', scope: 'PRIVATE',
        objectKey: 'private/key', originalName: 'avatar.png', sizeBytes: 12n,
      }) },
      user: { findFirst: jest.fn().mockResolvedValue({ id: 'owner' }) },
      userBlock: { findFirst: jest.fn().mockResolvedValue(null) },
      friendship: { findFirst: jest.fn().mockResolvedValue({ id: 'friend' }) },
      groupMember: { findFirst: jest.fn().mockResolvedValue(null) },
    };
    const service = Object.create(FilesService.prototype) as FilesService;
    Object.assign(service, { prisma, bucket: 'test', signingClient: {} });
    jest.mocked(getSignedUrl).mockReset().mockResolvedValue('https://storage.test/signed');
    return { service, prisma };
  }

  it('allows an accepted friend to download the current profile avatar', async () => {
    const { service, prisma } = setup();
    await expect(service.createDownload('viewer', 'avatar')).resolves.toMatchObject({ expiresIn: 600 });
    expect(prisma.user.findFirst).toHaveBeenCalledWith({
      where: { avatarFileId: 'avatar', status: 'ACTIVE' }, select: { id: true },
    });
    expect(prisma.friendship.findFirst).toHaveBeenCalledWith({
      where: { pairKey: 'owner:viewer', status: 'ACCEPTED' }, select: { id: true },
    });
  });

  it.each(['stranger', 'blocked', 'unbound'])('denies %s without signing a URL', async (kind) => {
    const { service, prisma } = setup();
    if (kind === 'stranger') prisma.friendship.findFirst.mockResolvedValue(null);
    if (kind === 'blocked') prisma.userBlock.findFirst.mockResolvedValue({ blockerId: 'owner' });
    if (kind === 'unbound') prisma.user.findFirst.mockResolvedValue(null);
    await expect(service.createDownload('viewer', 'avatar')).rejects.toBeInstanceOf(ForbiddenException);
    expect(getSignedUrl).not.toHaveBeenCalled();
  });

  it('allows only active membership in a group with the current avatar binding', async () => {
    const { service, prisma } = setup();
    prisma.user.findFirst.mockResolvedValue(null);
    prisma.groupMember.findFirst.mockResolvedValue({ userId: 'viewer' });
    await service.createDownload('viewer', 'avatar');
    expect(prisma.groupMember.findFirst).toHaveBeenCalledWith({
      where: { userId: 'viewer', status: 'ACTIVE', group: { avatarFileId: 'avatar', status: 'ACTIVE' } },
      select: { userId: true },
    });
  });

  it('keeps ordinary private files owner-only', async () => {
    const { service, prisma } = setup();
    prisma.storedFile.findFirst.mockResolvedValue({
      id: 'file', ownerUserId: 'owner', purpose: 'CHAT_FILE', scope: 'PRIVATE',
      objectKey: 'private/key', originalName: 'file.txt', sizeBytes: 12n,
    });
    await expect(service.createDownload('viewer', 'file')).rejects.toBeInstanceOf(ForbiddenException);
    expect(prisma.user.findFirst).not.toHaveBeenCalled();
    expect(getSignedUrl).not.toHaveBeenCalled();
  });
});
