import { readFile, writeFile } from 'node:fs/promises';

const pubspecPath = new URL('../clients/dart/chat_api/pubspec.yaml', import.meta.url);
const pubspec = await readFile(pubspecPath, 'utf8');
const updated = pubspec.replace("sdk: '>=2.18.0 <4.0.0'", "sdk: '>=3.0.0 <4.0.0'");

if (updated === pubspec) {
  throw new Error('Generated Dart SDK constraint was not found; check the generator output.');
}

await writeFile(pubspecPath, updated);

const adminApiPath = new URL('../clients/dart/chat_api/lib/src/api/admin_api.dart', import.meta.url);
const adminApi = await readFile(adminApiPath, 'utf8');
const typedLimits = [...adminApi.matchAll(/int\?? limit = \d+,/g)].length;
if (typedLimits !== 5) {
  throw new Error(`Expected five typed admin limit parameters, found ${typedLimits}.`);
}

// dart-dio emits a numeric argument for EnumClass.valueOf(String).
const syncPath = new URL('../clients/dart/chat_api/lib/src/model/sync_im_channel_messages_dto.dart', import.meta.url);
const sync = await readFile(syncPath, 'utf8');
const brokenDefault = 'SyncImChannelMessagesDtoPullModeEnum.valueOf(0)';
if (!sync.includes(brokenDefault)) throw new Error('Expected numeric enum default was not found');
await writeFile(syncPath, sync.replace(brokenDefault, 'SyncImChannelMessagesDtoPullModeEnum.n0'));
