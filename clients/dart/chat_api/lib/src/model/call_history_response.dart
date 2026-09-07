//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/call_session_response.dart';
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_history_response.g.dart';

/// CallHistoryResponse
///
/// Properties:
/// * [id] 
/// * [initiatorUserId] 
/// * [targetUserId] 
/// * [groupId] 
/// * [livekitRoomName] 
/// * [type] 
/// * [status] 
/// * [startedAt] 
/// * [answeredAt] 
/// * [endedAt] 
/// * [endReason] 
/// * [outgoing] 
/// * [peer] 
@BuiltValue()
abstract class CallHistoryResponse implements CallSessionResponse, Built<CallHistoryResponse, CallHistoryResponseBuilder> {
  @BuiltValueField(wireName: r'outgoing')
  bool get outgoing;

  @BuiltValueField(wireName: r'peer')
  UserResponse? get peer;

  CallHistoryResponse._();

  factory CallHistoryResponse([void updates(CallHistoryResponseBuilder b)]) = _$CallHistoryResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallHistoryResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallHistoryResponse> get serializer => _$CallHistoryResponseSerializer();
}

class _$CallHistoryResponseSerializer implements PrimitiveSerializer<CallHistoryResponse> {
  @override
  final Iterable<Type> types = const [CallHistoryResponse, _$CallHistoryResponse];

  @override
  final String wireName = r'CallHistoryResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallHistoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outgoing';
    yield serializers.serialize(
      object.outgoing,
      specifiedType: const FullType(bool),
    );
    if (object.endReason != null) {
      yield r'endReason';
      yield serializers.serialize(
        object.endReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.groupId != null) {
      yield r'groupId';
      yield serializers.serialize(
        object.groupId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.answeredAt != null) {
      yield r'answeredAt';
      yield serializers.serialize(
        object.answeredAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.targetUserId != null) {
      yield r'targetUserId';
      yield serializers.serialize(
        object.targetUserId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CallSessionResponseTypeEnum),
    );
    yield r'livekitRoomName';
    yield serializers.serialize(
      object.livekitRoomName,
      specifiedType: const FullType(String),
    );
    yield r'initiatorUserId';
    yield serializers.serialize(
      object.initiatorUserId,
      specifiedType: const FullType(String),
    );
    yield r'peer';
    yield object.peer == null ? null : serializers.serialize(
      object.peer,
      specifiedType: const FullType.nullable(UserResponse),
    );
    if (object.endedAt != null) {
      yield r'endedAt';
      yield serializers.serialize(
        object.endedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CallSessionResponseStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CallHistoryResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CallHistoryResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outgoing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.outgoing = valueDes;
          break;
        case r'endReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endReason = valueDes;
          break;
        case r'groupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.groupId = valueDes;
          break;
        case r'answeredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'targetUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.targetUserId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSessionResponseTypeEnum),
          ) as CallSessionResponseTypeEnum;
          result.type = valueDes;
          break;
        case r'livekitRoomName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.livekitRoomName = valueDes;
          break;
        case r'initiatorUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.initiatorUserId = valueDes;
          break;
        case r'peer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserResponse),
          ) as UserResponse?;
          if (valueDes == null) continue;
          result.peer.replace(valueDes);
          break;
        case r'endedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.endedAt = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSessionResponseStatusEnum),
          ) as CallSessionResponseStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallHistoryResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallHistoryResponseBuilder();
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

class CallHistoryResponseTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUDIO')
  static const CallHistoryResponseTypeEnum AUDIO = _$callHistoryResponseTypeEnum_AUDIO;
  @BuiltValueEnumConst(wireName: r'VIDEO')
  static const CallHistoryResponseTypeEnum VIDEO = _$callHistoryResponseTypeEnum_VIDEO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CallHistoryResponseTypeEnum unknownDefaultOpenApi = _$callHistoryResponseTypeEnum_unknownDefaultOpenApi;

  static Serializer<CallHistoryResponseTypeEnum> get serializer => _$callHistoryResponseTypeEnumSerializer;

  const CallHistoryResponseTypeEnum._(String name): super(name);

  static BuiltSet<CallHistoryResponseTypeEnum> get values => _$callHistoryResponseTypeEnumValues;
  static CallHistoryResponseTypeEnum valueOf(String name) => _$callHistoryResponseTypeEnumValueOf(name);
}

class CallHistoryResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INVITING')
  static const CallHistoryResponseStatusEnum INVITING = _$callHistoryResponseStatusEnum_INVITING;
  @BuiltValueEnumConst(wireName: r'RINGING')
  static const CallHistoryResponseStatusEnum RINGING = _$callHistoryResponseStatusEnum_RINGING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const CallHistoryResponseStatusEnum ACCEPTED = _$callHistoryResponseStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'CONNECTED')
  static const CallHistoryResponseStatusEnum CONNECTED = _$callHistoryResponseStatusEnum_CONNECTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const CallHistoryResponseStatusEnum REJECTED = _$callHistoryResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CallHistoryResponseStatusEnum CANCELLED = _$callHistoryResponseStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MISSED')
  static const CallHistoryResponseStatusEnum MISSED = _$callHistoryResponseStatusEnum_MISSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const CallHistoryResponseStatusEnum ENDED = _$callHistoryResponseStatusEnum_ENDED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CallHistoryResponseStatusEnum FAILED = _$callHistoryResponseStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CallHistoryResponseStatusEnum unknownDefaultOpenApi = _$callHistoryResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<CallHistoryResponseStatusEnum> get serializer => _$callHistoryResponseStatusEnumSerializer;

  const CallHistoryResponseStatusEnum._(String name): super(name);

  static BuiltSet<CallHistoryResponseStatusEnum> get values => _$callHistoryResponseStatusEnumValues;
  static CallHistoryResponseStatusEnum valueOf(String name) => _$callHistoryResponseStatusEnumValueOf(name);
}

