import { ServerInfoController } from '../src/health/server-info.controller';
import { fileSizeLimits } from '../src/files/file-limits';

describe('public server information', () => {
  it('returns only the explicit public allowlist and real upload limits', () => {
    const get = jest.fn().mockReturnValue('Local Chat');
    const info = new ServerInfoController({ get } as never).getInfo();
    expect(info).toEqual({ product: 'chat', apiVersion: 1, name: 'Local Chat',
      registrationEnabled: true, uploadLimits: fileSizeLimits });
    expect(get).toHaveBeenCalledTimes(1);
    expect(get).toHaveBeenCalledWith('SERVER_NAME');
    expect(info.uploadLimits).not.toBe(fileSizeLimits);
  });
});
