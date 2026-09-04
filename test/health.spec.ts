import { HealthController } from '../src/health/health.controller';

describe('HealthController', () => {
  it('returns an ok status', () => {
    const response = new HealthController({} as never).getHealth();
    expect(response.status).toBe('ok');
    expect(Number.isNaN(Date.parse(response.timestamp))).toBe(false);
  });
});

describe('HealthService readiness', () => {
  it('reports healthy dependencies with latency', async () => {
    const { HealthService } = await import('../src/health/health.service');
    const service = new HealthService(
      { $queryRaw: jest.fn().mockResolvedValue([{ value: 1 }]) } as never,
      { healthCheck: jest.fn().mockResolvedValue(undefined) } as never,
      { healthCheck: jest.fn().mockResolvedValue(undefined) } as never,
      { healthCheck: jest.fn().mockResolvedValue(undefined) } as never,
    );
    const result = await service.readiness();
    expect(result.status).toBe('ok');
    expect(result.dependencies).toMatchObject({
      postgresql: { status: 'ok' },
      wukongim: { status: 'ok' },
      livekit: { status: 'ok' },
      objectStorage: { status: 'ok' },
    });
  });
});
