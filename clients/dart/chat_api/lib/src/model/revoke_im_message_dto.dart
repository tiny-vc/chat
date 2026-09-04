//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'revoke_im_message_dto.g.dart';

/// RevokeImMessageDto
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [clientMsgNo] 
@BuiltValue()
abstract class RevokeImMessageDto implements Built<RevokeImMessageDto, RevokeImMessageDtoBuilder> {
  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  RevokeImMessageDtoChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'clientMsgNo')
  String get clientMsgNo;

  RevokeImMessageDto._();

  factory RevokeImMessageDto([void updates(RevokeImMessageDtoBuilder b)]) = _$RevokeImMessageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RevokeImMessageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RevokeImMessageDto> get serializer => _$RevokeImMessageDtoSerializer();
}

class _$RevokeImMessageDtoSerializer implements PrimitiveSerializer<RevokeImMessageDto> {
  @override
  final Iterable<Type> types = const [RevokeImMessageDto, _$RevokeImMessageDto];

  @override
  final String wireName = r'RevokeImMessageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RevokeImMessageDto object, {
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
      specifiedType: const FullType(RevokeImMessageDtoChannelTypeEnum),
    );
    yield r'clientMsgNo';
    yield serializers.serialize(
      object.clientMsgNo,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RevokeImMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RevokeImMessageDtoBuilder result,
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
            specifiedType: const FullType(RevokeImMessageDtoChannelTypeEnum),
          ) as RevokeImMessageDtoChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'clientMsgNo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMsgNo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RevokeImMessageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RevokeImMessageDtoBuilder();
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

class RevokeImMessageDtoChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1')
  static const RevokeImMessageDtoChannelTypeEnum n1 = _$revokeImMessageDtoChannelTypeEnum_n1;
  @BuiltValueEnumConst(wireName: r'2')
  static const RevokeImMessageDtoChannelTypeEnum n2 = _$revokeImMessageDtoChannelTypeEnum_n2;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const RevokeImMessageDtoChannelTypeEnum unknownDefaultOpenApi = _$revokeImMessageDtoChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<RevokeImMessageDtoChannelTypeEnum> get serializer => _$revokeImMessageDtoChannelTypeEnumSerializer;

  const RevokeImMessageDtoChannelTypeEnum._(String name): super(name);

  static BuiltSet<RevokeImMessageDtoChannelTypeEnum> get values => _$revokeImMessageDtoChannelTypeEnumValues;
  static RevokeImMessageDtoChannelTypeEnum valueOf(String name) => _$revokeImMessageDtoChannelTypeEnumValueOf(name);
}

