//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'receipt_message_dto.g.dart';

/// ReceiptMessageDto
///
/// Properties:
/// * [messageId] 
/// * [messageSeq] 
@BuiltValue()
abstract class ReceiptMessageDto implements Built<ReceiptMessageDto, ReceiptMessageDtoBuilder> {
  @BuiltValueField(wireName: r'messageId')
  String get messageId;

  @BuiltValueField(wireName: r'messageSeq')
  num get messageSeq;

  ReceiptMessageDto._();

  factory ReceiptMessageDto([void updates(ReceiptMessageDtoBuilder b)]) = _$ReceiptMessageDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReceiptMessageDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReceiptMessageDto> get serializer => _$ReceiptMessageDtoSerializer();
}

class _$ReceiptMessageDtoSerializer implements PrimitiveSerializer<ReceiptMessageDto> {
  @override
  final Iterable<Type> types = const [ReceiptMessageDto, _$ReceiptMessageDto];

  @override
  final String wireName = r'ReceiptMessageDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReceiptMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageId';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
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
    ReceiptMessageDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReceiptMessageDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messageId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageId = valueDes;
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
  ReceiptMessageDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReceiptMessageDtoBuilder();
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

