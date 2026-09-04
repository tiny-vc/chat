//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'call_session_response.g.dart';

/// CallSessionResponse
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
@BuiltValue()
abstract class CallSessionResponse implements Built<CallSessionResponse, CallSessionResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'initiatorUserId')
  String get initiatorUserId;

  @BuiltValueField(wireName: r'targetUserId')
  String? get targetUserId;

  @BuiltValueField(wireName: r'groupId')
  String? get groupId;

  @BuiltValueField(wireName: r'livekitRoomName')
  String get livekitRoomName;

  @BuiltValueField(wireName: r'type')
  CallSessionResponseTypeEnum get type;
  // enum typeEnum {  AUDIO,  VIDEO,  };

  @BuiltValueField(wireName: r'status')
  CallSessionResponseStatusEnum get status;
  // enum statusEnum {  INVITING,  RINGING,  ACCEPTED,  CONNECTED,  REJECTED,  CANCELLED,  MISSED,  ENDED,  FAILED,  };

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'answeredAt')
  DateTime? get answeredAt;

  @BuiltValueField(wireName: r'endedAt')
  DateTime? get endedAt;

  @BuiltValueField(wireName: r'endReason')
  String? get endReason;

  CallSessionResponse._();

  factory CallSessionResponse([void updates(CallSessionResponseBuilder b)]) = _$CallSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CallSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CallSessionResponse> get serializer => _$CallSessionResponseSerializer();
}

class _$CallSessionResponseSerializer implements PrimitiveSerializer<CallSessionResponse> {
  @override
  final Iterable<Type> types = const [CallSessionResponse, _$CallSessionResponse];

  @override
  final String wireName = r'CallSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CallSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'initiatorUserId';
    yield serializers.serialize(
      object.initiatorUserId,
      specifiedType: const FullType(String),
    );
    if (object.targetUserId != null) {
      yield r'targetUserId';
      yield serializers.serialize(
        object.targetUserId,
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
    yield r'livekitRoomName';
    yield serializers.serialize(
      object.livekitRoomName,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CallSessionResponseTypeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CallSessionResponseStatusEnum),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.answeredAt != null) {
      yield r'answeredAt';
      yield serializers.serialize(
        object.answeredAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.endedAt != null) {
      yield r'endedAt';
      yield serializers.serialize(
        object.endedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.endReason != null) {
      yield r'endReason';
      yield serializers.serialize(
        object.endReason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CallSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CallSessionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'initiatorUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.initiatorUserId = valueDes;
          break;
        case r'targetUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.targetUserId = valueDes;
          break;
        case r'groupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.groupId = valueDes;
          break;
        case r'livekitRoomName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.livekitRoomName = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSessionResponseTypeEnum),
          ) as CallSessionResponseTypeEnum;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CallSessionResponseStatusEnum),
          ) as CallSessionResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'answeredAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.answeredAt = valueDes;
          break;
        case r'endedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.endedAt = valueDes;
          break;
        case r'endReason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.endReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CallSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CallSessionResponseBuilder();
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

class CallSessionResponseTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUDIO')
  static const CallSessionResponseTypeEnum AUDIO = _$callSessionResponseTypeEnum_AUDIO;
  @BuiltValueEnumConst(wireName: r'VIDEO')
  static const CallSessionResponseTypeEnum VIDEO = _$callSessionResponseTypeEnum_VIDEO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CallSessionResponseTypeEnum unknownDefaultOpenApi = _$callSessionResponseTypeEnum_unknownDefaultOpenApi;

  static Serializer<CallSessionResponseTypeEnum> get serializer => _$callSessionResponseTypeEnumSerializer;

  const CallSessionResponseTypeEnum._(String name): super(name);

  static BuiltSet<CallSessionResponseTypeEnum> get values => _$callSessionResponseTypeEnumValues;
  static CallSessionResponseTypeEnum valueOf(String name) => _$callSessionResponseTypeEnumValueOf(name);
}

class CallSessionResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INVITING')
  static const CallSessionResponseStatusEnum INVITING = _$callSessionResponseStatusEnum_INVITING;
  @BuiltValueEnumConst(wireName: r'RINGING')
  static const CallSessionResponseStatusEnum RINGING = _$callSessionResponseStatusEnum_RINGING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const CallSessionResponseStatusEnum ACCEPTED = _$callSessionResponseStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'CONNECTED')
  static const CallSessionResponseStatusEnum CONNECTED = _$callSessionResponseStatusEnum_CONNECTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const CallSessionResponseStatusEnum REJECTED = _$callSessionResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const CallSessionResponseStatusEnum CANCELLED = _$callSessionResponseStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MISSED')
  static const CallSessionResponseStatusEnum MISSED = _$callSessionResponseStatusEnum_MISSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const CallSessionResponseStatusEnum ENDED = _$callSessionResponseStatusEnum_ENDED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const CallSessionResponseStatusEnum FAILED = _$callSessionResponseStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CallSessionResponseStatusEnum unknownDefaultOpenApi = _$callSessionResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<CallSessionResponseStatusEnum> get serializer => _$callSessionResponseStatusEnumSerializer;

  const CallSessionResponseStatusEnum._(String name): super(name);

  static BuiltSet<CallSessionResponseStatusEnum> get values => _$callSessionResponseStatusEnumValues;
  static CallSessionResponseStatusEnum valueOf(String name) => _$callSessionResponseStatusEnumValueOf(name);
}

