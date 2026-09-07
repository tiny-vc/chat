//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'message_receipt_response.g.dart';

/// MessageReceiptResponse
///
/// Properties:
/// * [messageId] 
/// * [readCount] 
/// * [unreadCount] 
@BuiltValue()
abstract class MessageReceiptResponse implements Built<MessageReceiptResponse, MessageReceiptResponseBuilder> {
  @BuiltValueField(wireName: r'messageId')
  String get messageId;

  @BuiltValueField(wireName: r'readCount')
  int get readCount;

  @BuiltValueField(wireName: r'unreadCount')
  int get unreadCount;

  MessageReceiptResponse._();

  factory MessageReceiptResponse([void updates(MessageReceiptResponseBuilder b)]) = _$MessageReceiptResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MessageReceiptResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MessageReceiptResponse> get serializer => _$MessageReceiptResponseSerializer();
}

class _$MessageReceiptResponseSerializer implements PrimitiveSerializer<MessageReceiptResponse> {
  @override
  final Iterable<Type> types = const [MessageReceiptResponse, _$MessageReceiptResponse];

  @override
  final String wireName = r'MessageReceiptResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MessageReceiptResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messageId';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
    );
    yield r'readCount';
    yield serializers.serialize(
      object.readCount,
      specifiedType: const FullType(int),
    );
    yield r'unreadCount';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MessageReceiptResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MessageReceiptResponseBuilder result,
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
        case r'readCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.readCount = valueDes;
          break;
        case r'unreadCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MessageReceiptResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageReceiptResponseBuilder();
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

