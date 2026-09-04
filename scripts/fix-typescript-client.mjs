import { readFile, writeFile } from 'node:fs/promises';

const packagePath = new URL('../clients/typescript/admin_api/package.json', import.meta.url);
const source = await readFile(packagePath, 'utf8');
const updated = source.replace('"axios": "^1.16.0"', '"axios": "1.18.0"');

if (updated === source) {
  throw new Error('Generated Axios dependency was not found; check the generator output.');
}

await writeFile(packagePath, updated);
