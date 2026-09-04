import { ConflictException, ForbiddenException } from '@nestjs/common';
import { GroupsService } from '../src/groups/groups.service';
import { apiResponseSchemas } from '../src/openapi-schemas';

describe('group management rules', () => {
  it('notifies group subscribers only after avatar binding succeeds', async () => {
    const update = jest.fn().mockResolvedValue({ id: 'group', avatarFileId: 'file' });
    const sendGroupMessage = jest.fn().mockResolvedValue({});
    const service = new GroupsService({
      groupMember: { findFirst: jest.fn().mockResolvedValue({ role: 'ADMIN' }) },
      storedFile: { findFirst: jest.fn().mockResolvedValue({
        id: 'file', purpose: 'AVATAR', scope: 'PRIVATE', mimeType: 'image/png',
      }) },
      group: { update },
    } as never, { sendGroupMessage } as never, {} as never);
    await service.setAvatar('group', 'admin', 'file');
    expect(sendGroupMessage).toHaveBeenCalledWith(expect.objectContaining({
      groupId: 'group', fromUserId: 'admin',
      payload: expect.objectContaining({ type: 9002, event: 'group.avatar_changed', data: {} }),
    }));
    expect(update.mock.invocationCallOrder[0]).toBeLessThan(sendGroupMessage.mock.invocationCallOrder[0]);
    update.mockRejectedValueOnce(new Error('database unavailable'));
    await expect(service.setAvatar('group', 'admin', 'file')).rejects.toThrow('database unavailable');
    expect(sendGroupMessage).toHaveBeenCalledTimes(1);
  });

  it('keeps avatar removal successful when its best-effort notification fails', async () => {
    const sendGroupMessage = jest.fn().mockRejectedValue(new Error('IM unavailable'));
    const service = new GroupsService({
      groupMember: { findFirst: jest.fn().mockResolvedValue({ role: 'OWNER' }) },
      group: { update: jest.fn().mockResolvedValue({ avatarFileId: null }) },
    } as never, { sendGroupMessage } as never, {} as never);
    await expect(service.removeAvatar('group', 'owner')).resolves.toEqual({ avatarFileId: null });
    expect(sendGroupMessage).toHaveBeenCalledWith(expect.objectContaining({
      groupId: 'group', payload: expect.objectContaining({ event: 'group.avatar_changed' }),
    }));
  });

  it('does not notify or mutate for a member without avatar permission', async () => {
    const update = jest.fn();
    const sendGroupMessage = jest.fn();
    const service = new GroupsService({
      groupMember: { findFirst: jest.fn().mockResolvedValue({ role: 'MEMBER' }) },
      group: { update },
    } as never, { sendGroupMessage } as never, {} as never);
    await expect(service.removeAvatar('group', 'member')).rejects.toBeInstanceOf(ForbiddenException);
    expect(update).not.toHaveBeenCalled();
    expect(sendGroupMessage).not.toHaveBeenCalled();
  });
  it('uses scoped keyset pagination with an ID tie breaker for personal history', async () => {
    const findMany = jest.fn().mockResolvedValue([]);
    const service = new GroupsService({ groupJoinRequest: { findMany } } as never, {} as never, {} as never);
    const before = '2026-09-03T00:00:00.000Z';
    const beforeId = '00000000-0000-4000-8000-000000000001';
    await service.listMyJoinRequests('me', { before, beforeId });
    const query = findMany.mock.calls[0][0];
    expect(query.take).toBe(100);
    expect(query.orderBy).toEqual([{ createdAt: 'desc' }, { id: 'desc' }]);
    expect(query.where.AND).toEqual([
      { OR: [{ userId: 'me' }, { requestedById: 'me' }] },
      { OR: [{ createdAt: { lt: new Date(before) } }, { createdAt: new Date(before), id: { lt: beforeId } }] },
    ]);
    await expect(service.listMyJoinRequests('me', { before })).rejects.toThrow('supplied together');
    expect(findMany).toHaveBeenCalledTimes(1);
  });

  it('uses the same actionable scope for count and cross-group list', async () => {
    jest.useFakeTimers();
    try {
      const findMany = jest.fn().mockResolvedValue([]);
      const count = jest.fn().mockResolvedValue(0);
      const service = new GroupsService({ groupJoinRequest: { findMany, count } } as never, {} as never, {} as never);
      await service.listActionableJoinRequests('me');
      await service.pendingJoinRequestCount('me');
      expect(findMany.mock.calls[0][0].where.AND[0]).toEqual(count.mock.calls[0][0].where);
      expect(findMany.mock.calls[0][0].include.user.select.nickname).toBe(true);
    } finally {
      jest.useRealTimers();
    }
  });
  it('counts only actionable unexpired requests in active groups', async () => {
    const count = jest.fn().mockResolvedValue(3);
    const service = new GroupsService({ groupJoinRequest: { count } } as never, {} as never, {} as never);
    await expect(service.pendingJoinRequestCount('me')).resolves.toEqual({ count: 3 });
    const where = count.mock.calls[0][0].where;
    expect(where.status).toBe('PENDING');
    expect(where.group).toEqual({ status: 'ACTIVE' });
    expect(where.expiresAt.gt).toBeInstanceOf(Date);
    expect(where.OR).toEqual([
      { type: 'INVITE', userId: 'me' },
      { type: 'APPLY', group: { members: { some: {
        userId: 'me', status: 'ACTIVE', role: { in: ['OWNER', 'ADMIN'] },
      } } } },
    ]);
  });
  it('returns required group fields for typed join-request clients', async () => {
    const findMany = jest.fn().mockResolvedValue([]);
    const service = new GroupsService({ groupJoinRequest: { findMany } } as never, {} as never, {} as never);
    await service.listMyJoinRequests('user');
    const query = findMany.mock.calls[0][0];
    for (const field of apiResponseSchemas.GroupResponse.required ?? []) {
      expect(query.include.group.select[field]).toBe(true);
    }
    expect(query.where.AND[0]).toEqual({ OR: [{ userId: 'user' }, { requestedById: 'user' }] });
  });
  it('does not transfer ownership to the current owner', async () => {
    const service = new GroupsService({} as never, {} as never, {} as never);
    await expect(service.transferOwner('group', 'owner', 'owner')).rejects.toBeInstanceOf(
      ConflictException,
    );
  });

  it('does not mute the group owner', async () => {
    const prisma = {
      groupMember: {
        findFirst: jest
          .fn()
          .mockResolvedValueOnce({ role: 'OWNER' })
          .mockResolvedValueOnce({ role: 'OWNER' }),
      },
    };
    const service = new GroupsService(prisma as never, {} as never, {} as never);
    await expect(
      service.muteMember('group', 'owner', 'owner', { muted: true }),
    ).rejects.toBeInstanceOf(ForbiddenException);
  });
});
