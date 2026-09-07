//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'im_sync_message_response.g.dart';

/// ImSyncMessageResponse
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [messageId] 
/// * [messageSeq] 
/// * [clientMsgNo] 
/// * [fromUid] 
/// * [timestamp] 
/// * [setting] 
/// * [payload] 
@BuiltValue()
abstract class ImSyncMessageResponse implements Built<ImSyncMessageResponse, ImSyncMessageResponseBuilder> {
  @BuiltValueField(wireName: r'channel_id')
  String get channelId;

  @BuiltValueField(wireName: r'channel_type')
  int get channelType;

  @BuiltValueField(wireName: r'message_id')
  String get messageId;

  @BuiltValueField(wireName: r'message_seq')
  int get messageSeq;

  @BuiltValueField(wireName: r'client_msg_no')
  String get clientMsgNo;

  @BuiltValueField(wireName: r'from_uid')
  String get fromUid;

  @BuiltValueField(wireName: r'timestamp')
  int get timestamp;

  @BuiltValueField(wireName: r'setting')
  int get setting;

  @BuiltValueField(wireName: r'payload')
  BuiltMap<String, JsonObject?> get payload;

  ImSyncMessageResponse._();

  factory ImSyncMessageResponse([void updates(ImSyncMessageResponseBuilder b)]) = _$ImSyncMessageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImSyncMessageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImSyncMessageResponse> get serializer => _$ImSyncMessageResponseSerializer();
}

class _$ImSyncMessageResponseSerializer implements PrimitiveSerializer<ImSyncMessageResponse> {
  @override
  final Iterable<Type> types = const [ImSyncMessageResponse, _$ImSyncMessageResponse];

  @override
  final String wireName = r'ImSyncMessageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImSyncMessageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channel_id';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channel_type';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(int),
    );
    yield r'message_id';
    yield serializers.serialize(
      object.messageId,
      specifiedType: const FullType(String),
    );
    yield r'message_seq';
    yield serializers.serialize(
      object.messageSeq,
      specifiedType: const FullType(int),
    );
    yield r'client_msg_no';
    yield serializers.serialize(
      object.clientMsgNo,
      specifiedType: const FullType(String),
    );
    yield r'from_uid';
    yield serializers.serialize(
      object.fromUid,
      specifiedType: const FullType(String),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(int),
    );
    yield r'setting';
    yield serializers.serialize(
      object.setting,
      specifiedType: const FullType(int),
    );
    yield r'payload';
    yield serializers.serialize(
      object.payload,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImSyncMessageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImSyncMessageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channel_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelId = valueDes;
          break;
        case r'channel_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.channelType = valueDes;
          break;
        case r'message_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messageId = valueDes;
          break;
        case r'message_seq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.messageSeq = valueDes;
          break;
        case r'client_msg_no':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientMsgNo = valueDes;
          break;
        case r'from_uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fromUid = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timestamp = valueDes;
          break;
        case r'setting':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.setting = valueDes;
          break;
        case r'payload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.payload.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImSyncMessageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImSyncMessageResponseBuilder();
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

