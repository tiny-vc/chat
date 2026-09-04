import { CallsService } from '../src/calls/calls.service';

describe('call media recovery and hangup', () => {
  const call = { id: '11111111-1111-4111-8111-111111111111', initiatorUserId: 'a', targetUserId: 'b',
    status: 'ACCEPTED', livekitRoomName: 'room', type: 'AUDIO' };
  function setup() {
    const prisma = { callSession: {
      findMany: jest.fn().mockResolvedValue([call]),
      findUnique: jest.fn().mockResolvedValue(call),
      updateMany: jest.fn().mockResolvedValue({ count: 1 }),
    } };
    const livekit = {
      participantIdentities: jest.fn().mockResolvedValue(['a']),
      deleteRoom: jest.fn().mockResolvedValue(undefined),
    };
    const im = { sendPersonalMessage: jest.fn().mockResolvedValue(undefined) };
    return { prisma, livekit, im,
      service: new CallsService(prisma as never, livekit as never, im as never, {} as never) };
  }
  beforeEach(() => { jest.useFakeTimers(); jest.setSystemTime(new Date('2026-09-03T00:00:00Z')); });
  afterEach(() => jest.useRealTimers());

  it('allows brief absence and ends only after a full 90-second grace window', async () => {
    const { service, prisma, livekit, im } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(89_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalled();
    jest.advanceTimersByTime(1_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: call.id, status: { in: ['ACCEPTED', 'CONNECTED'] } },
      data: { status: 'ENDED', endedAt: expect.any(Date), endReason: 'MEDIA_DISCONNECTED' },
    });
    expect(livekit.deleteRoom).toHaveBeenCalledWith('room');
    expect(im.sendPersonalMessage).toHaveBeenCalledTimes(2);
  });

  it('resets grace when both participants return', async () => {
    const { service, prisma, livekit } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(80_000);
    livekit.participantIdentities.mockResolvedValueOnce(['a', 'b']);
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(20_000);
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalled();
  });

  it('does not interpret a LiveKit API outage as participant absence', async () => {
    const { service, prisma, livekit } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(100_000);
    livekit.participantIdentities.mockRejectedValueOnce(new Error('timeout'));
    await service.reconcileMediaSessions();
    await service.reconcileMediaSessions();
    expect(prisma.callSession.updateMany).not.toHaveBeenCalled();
  });

  it('does not delete a room if a concurrent terminal transition already won', async () => {
    const { service, prisma, livekit, im } = setup();
    await service.reconcileMediaSessions();
    jest.advanceTimersByTime(100_000);
    prisma.callSession.updateMany.mockResolvedValue({ count: 0 });
    await service.reconcileMediaSessions();
    expect(livekit.deleteRoom).not.toHaveBeenCalled();
    expect(im.sendPersonalMessage).not.toHaveBeenCalled();
  });

  it('permits an authorized retry after acceptance without transitioning twice', async () => {
    const { service, prisma, im } = setup();
    await expect(service.accept('call', 'b')).resolves.toEqual(call);
    expect(im.sendPersonalMessage).toHaveBeenCalledTimes(1);
    // requireCall only runs expiry of unanswered invitations.
    expect(prisma.callSession.updateMany).not.toHaveBeenCalledWith(expect.objectContaining({
      data: expect.objectContaining({ status: 'ACCEPTED' }),
    }));
    await expect(service.accept('call', 'a')).rejects.toThrow('Only the recipient');
  });

  it('repeated hangup is harmless but still enforces participant permissions', async () => {
    const { service, prisma, livekit } = setup();
    prisma.callSession.findUnique.mockResolvedValue({ ...call, status: 'ENDED' });
    await expect(service.end('call', 'a')).resolves.toMatchObject({ status: 'ENDED' });
    expect(livekit.deleteRoom).not.toHaveBeenCalled();
    await expect(service.end('call', 'stranger')).rejects.toThrow('not a participant');
  });

  it('caller hangup accepts the invitation/accept race but recipient cannot end an invitation', async () => {
    const { service, prisma } = setup();
    prisma.callSession.findUnique.mockResolvedValue({ ...call, status: 'RINGING' });
    await expect(service.end('call', 'b')).rejects.toThrow('not active');
    await service.end('call', 'a');
    expect(prisma.callSession.updateMany).toHaveBeenCalledWith({
      where: { id: call.id, status: { in: ['INVITING', 'RINGING', 'ACCEPTED', 'CONNECTED'] } },
      data: { status: 'ENDED', endedAt: expect.any(Date), endReason: 'HANGUP' },
    });
  });
});
