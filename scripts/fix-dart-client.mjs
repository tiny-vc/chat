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
const encodedLimits = [
  ...adminApi.matchAll(/r'limit': encodeQueryParameter\([^\n]+const FullType\(int\)\)/g),
].length;
if (typedLimits === 0 || typedLimits !== encodedLimits || /num\?? limit =/.test(adminApi)) {
  throw new Error(
    `Admin limit parameters are not consistently typed as int (${typedLimits} declarations, ${encodedLimits} encoders).`,
  );
}

// dart-dio emits a numeric argument for EnumClass.valueOf(String).
const syncPath = new URL('../clients/dart/chat_api/lib/src/model/sync_im_channel_messages_dto.dart', import.meta.url);
const sync = await readFile(syncPath, 'utf8');
const brokenDefault = 'SyncImChannelMessagesDtoPullModeEnum.valueOf(0)';
if (!sync.includes(brokenDefault)) throw new Error('Expected numeric enum default was not found');
await writeFile(syncPath, sync.replace(brokenDefault, 'SyncImChannelMessagesDtoPullModeEnum.n0'));

// dart-dio models numeric OpenAPI enums as EnumClass values whose wire names
// are strings. Request DTOs must still emit JSON numbers so the generated
// client matches the OpenAPI schema instead of relying on server coercion.
const numericRequestEnums = [
  ['sync_im_channel_messages_dto.dart', 'channelType', 'SyncImChannelMessagesDtoChannelTypeEnum', 'n1', 1, 'n2', 2],
  ['sync_im_channel_messages_dto.dart', 'pullMode', 'SyncImChannelMessagesDtoPullModeEnum', 'n0', 0, 'n1', 1],
  ['revoke_im_message_dto.dart', 'channelType', 'RevokeImMessageDtoChannelTypeEnum', 'n1', 1, 'n2', 2],
  ['mark_im_read_dto.dart', 'channelType', 'MarkImReadDtoChannelTypeEnum', 'n1', 1, 'n2', 2],
  ['sync_im_receipts_dto.dart', 'channelType', 'SyncImReceiptsDtoChannelTypeEnum', 'n1', 1, 'n2', 2],
  ['update_conversation_setting_dto.dart', 'channelType', 'UpdateConversationSettingDtoChannelTypeEnum', 'n1', 1, 'n2', 2],
];
const modelRoot = new URL('../clients/dart/chat_api/lib/src/model/', import.meta.url);
for (const [file, property, enumType, firstName, firstValue, secondName, secondValue] of numericRequestEnums) {
  const path = new URL(file, modelRoot);
  const source = await readFile(path, 'utf8');
  const generated = `yield r'${property}';\n    yield serializers.serialize(\n      object.${property},\n      specifiedType: const FullType(${enumType}),\n    );`;
  const fixed = `yield r'${property}';\n    yield object.${property} == ${enumType}.${firstName}\n        ? ${firstValue}\n        : object.${property} == ${enumType}.${secondName}\n        ? ${secondValue}\n        : throw StateError('Unsupported ${property} enum value');`;
  if (!source.includes(generated)) {
    throw new Error(`Expected numeric enum serializer was not found in ${file}:${property}`);
  }
  await writeFile(path, source.replace(generated, fixed));
}
