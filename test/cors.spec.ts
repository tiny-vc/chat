import { parseCorsOrigins } from '../src/config/cors';

describe('CORS origin configuration', () => {
  it('allows reflected origins only when explicitly configured with a wildcard', () => {
    expect(parseCorsOrigins('*')).toBe(true);
  });

  it('parses and trims an explicit production allowlist', () => {
    expect(
      parseCorsOrigins('https://app.example.com, https://admin.example.com'),
    ).toEqual(['https://app.example.com', 'https://admin.example.com']);
  });

  it('drops empty entries', () => {
    expect(parseCorsOrigins('https://app.example.com, ,')).toEqual([
      'https://app.example.com',
    ]);
  });
});
