//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'messaging_policy_sync_dto.g.dart';

/// MessagingPolicySyncDto
///
/// Properties:
/// * [status] 
/// * [attempts] 
/// * [lastError] 
/// * [syncedAt] 
@BuiltValue()
abstract class MessagingPolicySyncDto implements Built<MessagingPolicySyncDto, MessagingPolicySyncDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  MessagingPolicySyncDtoStatusEnum get status;
  // enum statusEnum {  PENDING,  SYNCING,  SYNCED,  FAILED,  };

  @BuiltValueField(wireName: r'attempts')
  num get attempts;

  @BuiltValueField(wireName: r'lastError')
  String? get lastError;

  @BuiltValueField(wireName: r'syncedAt')
  DateTime? get syncedAt;

  MessagingPolicySyncDto._();

  factory MessagingPolicySyncDto([void updates(MessagingPolicySyncDtoBuilder b)]) = _$MessagingPolicySyncDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MessagingPolicySyncDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MessagingPolicySyncDto> get serializer => _$MessagingPolicySyncDtoSerializer();
}

class _$MessagingPolicySyncDtoSerializer implements PrimitiveSerializer<MessagingPolicySyncDto> {
  @override
  final Iterable<Type> types = const [MessagingPolicySyncDto, _$MessagingPolicySyncDto];

  @override
  final String wireName = r'MessagingPolicySyncDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MessagingPolicySyncDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(MessagingPolicySyncDtoStatusEnum),
    );
    yield r'attempts';
    yield serializers.serialize(
      object.attempts,
      specifiedType: const FullType(num),
    );
    yield r'lastError';
    yield object.lastError == null ? null : serializers.serialize(
      object.lastError,
      specifiedType: const FullType.nullable(String),
    );
    yield r'syncedAt';
    yield object.syncedAt == null ? null : serializers.serialize(
      object.syncedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MessagingPolicySyncDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MessagingPolicySyncDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MessagingPolicySyncDtoStatusEnum),
          ) as MessagingPolicySyncDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'attempts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.attempts = valueDes;
          break;
        case r'lastError':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastError = valueDes;
          break;
        case r'syncedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.syncedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MessagingPolicySyncDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessagingPolicySyncDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class MessagingPolicySyncDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const MessagingPolicySyncDtoStatusEnum PENDING = _$messagingPolicySyncDtoStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'SYNCING')
  static const MessagingPolicySyncDtoStatusEnum SYNCING = _$messagingPolicySyncDtoStatusEnum_SYNCING;
  @BuiltValueEnumConst(wireName: r'SYNCED')
  static const MessagingPolicySyncDtoStatusEnum SYNCED = _$messagingPolicySyncDtoStatusEnum_SYNCED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const MessagingPolicySyncDtoStatusEnum FAILED = _$messagingPolicySyncDtoStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const MessagingPolicySyncDtoStatusEnum unknownDefaultOpenApi = _$messagingPolicySyncDtoStatusEnum_unknownDefaultOpenApi;

  static Serializer<MessagingPolicySyncDtoStatusEnum> get serializer => _$messagingPolicySyncDtoStatusEnumSerializer;

  const MessagingPolicySyncDtoStatusEnum._(String name): super(name);

  static BuiltSet<MessagingPolicySyncDtoStatusEnum> get values => _$messagingPolicySyncDtoStatusEnumValues;
  static MessagingPolicySyncDtoStatusEnum valueOf(String name) => _$messagingPolicySyncDtoStatusEnumValueOf(name);
}

