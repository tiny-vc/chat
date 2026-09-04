import { ConfigService } from '@nestjs/config';
import { Prisma } from '@prisma/client';
import { WukongWebhookService } from '../src/webhooks/wukong-webhook.service';

describe('WukongWebhookService', () => {
  const secret = 'webhook-secret-for-tests';
  const config = { getOrThrow: jest.fn(() => secret) } as unknown as ConfigService;

  it('stores a new event', async () => {
    const create = jest.fn().mockResolvedValue({ id: 'event-id' });
    const service = new WukongWebhookService(config, {
      webhookEvent: { create },
    } as never);

    await expect(service.receive(secret, { event: 'message.notify', id: 'm1' })).resolves.toEqual({
      accepted: true,
      duplicate: false,
    });
    expect(create).toHaveBeenCalledWith({
      data: expect.objectContaining({ eventKey: 'message.notify:m1', eventType: 'message.notify' }),
    });
  });

  it('accepts duplicate delivery without inserting it twice', async () => {
    const duplicate = new Prisma.PrismaClientKnownRequestError('duplicate', {
      code: 'P2002',
      clientVersion: '6.19.3',
    });
    const service = new WukongWebhookService(config, {
      webhookEvent: { create: jest.fn().mockRejectedValue(duplicate) },
    } as never);

    await expect(service.receive(secret, { type: 'online', id: 'u1' })).resolves.toEqual({
      accepted: true,
      duplicate: true,
    });
  });

  it('rejects an invalid token', async () => {
    const service = new WukongWebhookService(config, {
      webhookEvent: { create: jest.fn() },
    } as never);
    await expect(service.receive('wrong-token-value-000', {})).rejects.toThrow(
      'Invalid webhook token',
    );
  });
});
