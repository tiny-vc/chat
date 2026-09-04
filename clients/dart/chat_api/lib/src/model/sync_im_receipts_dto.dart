//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/receipt_message_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_im_receipts_dto.g.dart';

/// SyncImReceiptsDto
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [messages] 
@BuiltValue()
abstract class SyncImReceiptsDto implements Built<SyncImReceiptsDto, SyncImReceiptsDtoBuilder> {
  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  SyncImReceiptsDtoChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'messages')
  BuiltList<ReceiptMessageDto> get messages;

  SyncImReceiptsDto._();

  factory SyncImReceiptsDto([void updates(SyncImReceiptsDtoBuilder b)]) = _$SyncImReceiptsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncImReceiptsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncImReceiptsDto> get serializer => _$SyncImReceiptsDtoSerializer();
}

class _$SyncImReceiptsDtoSerializer implements PrimitiveSerializer<SyncImReceiptsDto> {
  @override
  final Iterable<Type> types = const [SyncImReceiptsDto, _$SyncImReceiptsDto];

  @override
  final String wireName = r'SyncImReceiptsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncImReceiptsDto object, {
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
      specifiedType: const FullType(SyncImReceiptsDtoChannelTypeEnum),
    );
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(BuiltList, [FullType(ReceiptMessageDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncImReceiptsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncImReceiptsDtoBuilder result,
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
            specifiedType: const FullType(SyncImReceiptsDtoChannelTypeEnum),
          ) as SyncImReceiptsDtoChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReceiptMessageDto)]),
          ) as BuiltList<ReceiptMessageDto>;
          result.messages.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncImReceiptsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncImReceiptsDtoBuilder();
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

class SyncImReceiptsDtoChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1')
  static const SyncImReceiptsDtoChannelTypeEnum n1 = _$syncImReceiptsDtoChannelTypeEnum_n1;
  @BuiltValueEnumConst(wireName: r'2')
  static const SyncImReceiptsDtoChannelTypeEnum n2 = _$syncImReceiptsDtoChannelTypeEnum_n2;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const SyncImReceiptsDtoChannelTypeEnum unknownDefaultOpenApi = _$syncImReceiptsDtoChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<SyncImReceiptsDtoChannelTypeEnum> get serializer => _$syncImReceiptsDtoChannelTypeEnumSerializer;

  const SyncImReceiptsDtoChannelTypeEnum._(String name): super(name);

  static BuiltSet<SyncImReceiptsDtoChannelTypeEnum> get values => _$syncImReceiptsDtoChannelTypeEnumValues;
  static SyncImReceiptsDtoChannelTypeEnum valueOf(String name) => _$syncImReceiptsDtoChannelTypeEnumValueOf(name);
}

