//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/im_sync_message_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'im_sync_conversation_response.g.dart';

/// ImSyncConversationResponse
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [unread] 
/// * [timestamp] 
/// * [lastMsgSeq] 
/// * [lastClientMsgNo] 
/// * [version] 
/// * [recents] 
@BuiltValue()
abstract class ImSyncConversationResponse implements Built<ImSyncConversationResponse, ImSyncConversationResponseBuilder> {
  @BuiltValueField(wireName: r'channel_id')
  String get channelId;

  @BuiltValueField(wireName: r'channel_type')
  int get channelType;

  @BuiltValueField(wireName: r'unread')
  int get unread;

  @BuiltValueField(wireName: r'timestamp')
  int get timestamp;

  @BuiltValueField(wireName: r'last_msg_seq')
  int get lastMsgSeq;

  @BuiltValueField(wireName: r'last_client_msg_no')
  String get lastClientMsgNo;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'recents')
  BuiltList<ImSyncMessageResponse> get recents;

  ImSyncConversationResponse._();

  factory ImSyncConversationResponse([void updates(ImSyncConversationResponseBuilder b)]) = _$ImSyncConversationResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImSyncConversationResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImSyncConversationResponse> get serializer => _$ImSyncConversationResponseSerializer();
}

class _$ImSyncConversationResponseSerializer implements PrimitiveSerializer<ImSyncConversationResponse> {
  @override
  final Iterable<Type> types = const [ImSyncConversationResponse, _$ImSyncConversationResponse];

  @override
  final String wireName = r'ImSyncConversationResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImSyncConversationResponse object, {
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
    yield r'unread';
    yield serializers.serialize(
      object.unread,
      specifiedType: const FullType(int),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(int),
    );
    yield r'last_msg_seq';
    yield serializers.serialize(
      object.lastMsgSeq,
      specifiedType: const FullType(int),
    );
    yield r'last_client_msg_no';
    yield serializers.serialize(
      object.lastClientMsgNo,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'recents';
    yield serializers.serialize(
      object.recents,
      specifiedType: const FullType(BuiltList, [FullType(ImSyncMessageResponse)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImSyncConversationResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImSyncConversationResponseBuilder result,
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
        case r'unread':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unread = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.timestamp = valueDes;
          break;
        case r'last_msg_seq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastMsgSeq = valueDes;
          break;
        case r'last_client_msg_no':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lastClientMsgNo = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'recents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ImSyncMessageResponse)]),
          ) as BuiltList<ImSyncMessageResponse>;
          result.recents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImSyncConversationResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImSyncConversationResponseBuilder();
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

