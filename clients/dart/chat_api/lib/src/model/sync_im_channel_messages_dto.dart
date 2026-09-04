//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_im_channel_messages_dto.g.dart';

/// SyncImChannelMessagesDto
///
/// Properties:
/// * [startMessageSeq] 
/// * [endMessageSeq] 
/// * [limit] 
/// * [channelId] 
/// * [channelType] 
/// * [pullMode] 
@BuiltValue()
abstract class SyncImChannelMessagesDto implements Built<SyncImChannelMessagesDto, SyncImChannelMessagesDtoBuilder> {
  @BuiltValueField(wireName: r'startMessageSeq')
  num? get startMessageSeq;

  @BuiltValueField(wireName: r'endMessageSeq')
  num? get endMessageSeq;

  @BuiltValueField(wireName: r'limit')
  num? get limit;

  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  SyncImChannelMessagesDtoChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'pullMode')
  SyncImChannelMessagesDtoPullModeEnum get pullMode;
  // enum pullModeEnum {  0,  1,  };

  SyncImChannelMessagesDto._();

  factory SyncImChannelMessagesDto([void updates(SyncImChannelMessagesDtoBuilder b)]) = _$SyncImChannelMessagesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncImChannelMessagesDtoBuilder b) => b
      ..startMessageSeq = 0
      ..endMessageSeq = 0
      ..limit = 50
      ..pullMode = SyncImChannelMessagesDtoPullModeEnum.n0;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncImChannelMessagesDto> get serializer => _$SyncImChannelMessagesDtoSerializer();
}

class _$SyncImChannelMessagesDtoSerializer implements PrimitiveSerializer<SyncImChannelMessagesDto> {
  @override
  final Iterable<Type> types = const [SyncImChannelMessagesDto, _$SyncImChannelMessagesDto];

  @override
  final String wireName = r'SyncImChannelMessagesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncImChannelMessagesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.startMessageSeq != null) {
      yield r'startMessageSeq';
      yield serializers.serialize(
        object.startMessageSeq,
        specifiedType: const FullType(num),
      );
    }
    if (object.endMessageSeq != null) {
      yield r'endMessageSeq';
      yield serializers.serialize(
        object.endMessageSeq,
        specifiedType: const FullType(num),
      );
    }
    if (object.limit != null) {
      yield r'limit';
      yield serializers.serialize(
        object.limit,
        specifiedType: const FullType(num),
      );
    }
    yield r'channelId';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channelType';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(SyncImChannelMessagesDtoChannelTypeEnum),
    );
    yield r'pullMode';
    yield serializers.serialize(
      object.pullMode,
      specifiedType: const FullType(SyncImChannelMessagesDtoPullModeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncImChannelMessagesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncImChannelMessagesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startMessageSeq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.startMessageSeq = valueDes;
          break;
        case r'endMessageSeq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.endMessageSeq = valueDes;
          break;
        case r'limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.limit = valueDes;
          break;
        case r'channelId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelId = valueDes;
          break;
        case r'channelType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncImChannelMessagesDtoChannelTypeEnum),
          ) as SyncImChannelMessagesDtoChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'pullMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncImChannelMessagesDtoPullModeEnum),
          ) as SyncImChannelMessagesDtoPullModeEnum;
          result.pullMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncImChannelMessagesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncImChannelMessagesDtoBuilder();
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

class SyncImChannelMessagesDtoChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1')
  static const SyncImChannelMessagesDtoChannelTypeEnum n1 = _$syncImChannelMessagesDtoChannelTypeEnum_n1;
  @BuiltValueEnumConst(wireName: r'2')
  static const SyncImChannelMessagesDtoChannelTypeEnum n2 = _$syncImChannelMessagesDtoChannelTypeEnum_n2;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const SyncImChannelMessagesDtoChannelTypeEnum unknownDefaultOpenApi = _$syncImChannelMessagesDtoChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<SyncImChannelMessagesDtoChannelTypeEnum> get serializer => _$syncImChannelMessagesDtoChannelTypeEnumSerializer;

  const SyncImChannelMessagesDtoChannelTypeEnum._(String name): super(name);

  static BuiltSet<SyncImChannelMessagesDtoChannelTypeEnum> get values => _$syncImChannelMessagesDtoChannelTypeEnumValues;
  static SyncImChannelMessagesDtoChannelTypeEnum valueOf(String name) => _$syncImChannelMessagesDtoChannelTypeEnumValueOf(name);
}

class SyncImChannelMessagesDtoPullModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'0')
  static const SyncImChannelMessagesDtoPullModeEnum n0 = _$syncImChannelMessagesDtoPullModeEnum_n0;
  @BuiltValueEnumConst(wireName: r'1')
  static const SyncImChannelMessagesDtoPullModeEnum n1 = _$syncImChannelMessagesDtoPullModeEnum_n1;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const SyncImChannelMessagesDtoPullModeEnum unknownDefaultOpenApi = _$syncImChannelMessagesDtoPullModeEnum_unknownDefaultOpenApi;

  static Serializer<SyncImChannelMessagesDtoPullModeEnum> get serializer => _$syncImChannelMessagesDtoPullModeEnumSerializer;

  const SyncImChannelMessagesDtoPullModeEnum._(String name): super(name);

  static BuiltSet<SyncImChannelMessagesDtoPullModeEnum> get values => _$syncImChannelMessagesDtoPullModeEnumValues;
  static SyncImChannelMessagesDtoPullModeEnum valueOf(String name) => _$syncImChannelMessagesDtoPullModeEnumValueOf(name);
}
