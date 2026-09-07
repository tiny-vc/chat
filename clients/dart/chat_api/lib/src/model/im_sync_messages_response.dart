//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/im_sync_message_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'im_sync_messages_response.g.dart';

/// ImSyncMessagesResponse
///
/// Properties:
/// * [startMessageSeq] 
/// * [endMessageSeq] 
/// * [more] 
/// * [messages] 
@BuiltValue()
abstract class ImSyncMessagesResponse implements Built<ImSyncMessagesResponse, ImSyncMessagesResponseBuilder> {
  @BuiltValueField(wireName: r'start_message_seq')
  int get startMessageSeq;

  @BuiltValueField(wireName: r'end_message_seq')
  int get endMessageSeq;

  @BuiltValueField(wireName: r'more')
  int get more;

  @BuiltValueField(wireName: r'messages')
  BuiltList<ImSyncMessageResponse> get messages;

  ImSyncMessagesResponse._();

  factory ImSyncMessagesResponse([void updates(ImSyncMessagesResponseBuilder b)]) = _$ImSyncMessagesResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImSyncMessagesResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImSyncMessagesResponse> get serializer => _$ImSyncMessagesResponseSerializer();
}

class _$ImSyncMessagesResponseSerializer implements PrimitiveSerializer<ImSyncMessagesResponse> {
  @override
  final Iterable<Type> types = const [ImSyncMessagesResponse, _$ImSyncMessagesResponse];

  @override
  final String wireName = r'ImSyncMessagesResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImSyncMessagesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'start_message_seq';
    yield serializers.serialize(
      object.startMessageSeq,
      specifiedType: const FullType(int),
    );
    yield r'end_message_seq';
    yield serializers.serialize(
      object.endMessageSeq,
      specifiedType: const FullType(int),
    );
    yield r'more';
    yield serializers.serialize(
      object.more,
      specifiedType: const FullType(int),
    );
    yield r'messages';
    yield serializers.serialize(
      object.messages,
      specifiedType: const FullType(BuiltList, [FullType(ImSyncMessageResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImSyncMessagesResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImSyncMessagesResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'start_message_seq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.startMessageSeq = valueDes;
          break;
        case r'end_message_seq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.endMessageSeq = valueDes;
          break;
        case r'more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.more = valueDes;
          break;
        case r'messages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImSyncMessageResponse)]),
          ) as BuiltList<ImSyncMessageResponse>;
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
  ImSyncMessagesResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImSyncMessagesResponseBuilder();
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

