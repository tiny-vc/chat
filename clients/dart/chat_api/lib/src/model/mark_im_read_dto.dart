//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mark_im_read_dto.g.dart';

/// MarkImReadDto
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [messageSeq] 
@BuiltValue()
abstract class MarkImReadDto implements Built<MarkImReadDto, MarkImReadDtoBuilder> {
  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  MarkImReadDtoChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'messageSeq')
  num get messageSeq;

  MarkImReadDto._();

  factory MarkImReadDto([void updates(MarkImReadDtoBuilder b)]) = _$MarkImReadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MarkImReadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MarkImReadDto> get serializer => _$MarkImReadDtoSerializer();
}

class _$MarkImReadDtoSerializer implements PrimitiveSerializer<MarkImReadDto> {
  @override
  final Iterable<Type> types = const [MarkImReadDto, _$MarkImReadDto];

  @override
  final String wireName = r'MarkImReadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MarkImReadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channelId';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channelType';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(MarkImReadDtoChannelTypeEnum),
    );
    yield r'messageSeq';
    yield serializers.serialize(
      object.messageSeq,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MarkImReadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MarkImReadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(MarkImReadDtoChannelTypeEnum),
          ) as MarkImReadDtoChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'messageSeq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.messageSeq = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MarkImReadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MarkImReadDtoBuilder();
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

class MarkImReadDtoChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1')
  static const MarkImReadDtoChannelTypeEnum n1 = _$markImReadDtoChannelTypeEnum_n1;
  @BuiltValueEnumConst(wireName: r'2')
  static const MarkImReadDtoChannelTypeEnum n2 = _$markImReadDtoChannelTypeEnum_n2;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const MarkImReadDtoChannelTypeEnum unknownDefaultOpenApi = _$markImReadDtoChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<MarkImReadDtoChannelTypeEnum> get serializer => _$markImReadDtoChannelTypeEnumSerializer;

  const MarkImReadDtoChannelTypeEnum._(String name): super(name);

  static BuiltSet<MarkImReadDtoChannelTypeEnum> get values => _$markImReadDtoChannelTypeEnumValues;
  static MarkImReadDtoChannelTypeEnum valueOf(String name) => _$markImReadDtoChannelTypeEnumValueOf(name);
}

