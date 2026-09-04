import { isPayloadTooLargeError } from '../src/common/http-exception.filter';

describe('HTTP exception normalization', () => {
  it('recognizes body-parser oversized entity errors', () => {
    expect(isPayloadTooLargeError({ status: 413, type: 'entity.too.large' })).toBe(true);
  });

  it('does not reinterpret unrelated errors as payload errors', () => {
    expect(isPayloadTooLargeError(new Error('database unavailable'))).toBe(false);
    expect(isPayloadTooLargeError({ status: 413, type: 'other' })).toBe(false);
  });
});
