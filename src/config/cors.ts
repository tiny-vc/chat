export function parseCorsOrigins(value: string): true | string[] {
  if (value === '*') return true;
  return value
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
}
