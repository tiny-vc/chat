//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_call_response.g.dart';

/// AdminCallResponse
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
/// * [initiator] 
@BuiltValue()
abstract class AdminCallResponse implements Built<AdminCallResponse, AdminCallResponseBuilder> {
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
  AdminCallResponseTypeEnum get type;
  // enum typeEnum {  AUDIO,  VIDEO,  };

  @BuiltValueField(wireName: r'status')
  AdminCallResponseStatusEnum get status;
  // enum statusEnum {  INVITING,  RINGING,  ACCEPTED,  CONNECTED,  REJECTED,  CANCELLED,  MISSED,  ENDED,  FAILED,  };

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'answeredAt')
  DateTime? get answeredAt;

  @BuiltValueField(wireName: r'endedAt')
  DateTime? get endedAt;

  @BuiltValueField(wireName: r'endReason')
  String? get endReason;

  @BuiltValueField(wireName: r'initiator')
  BuiltMap<String, JsonObject?> get initiator;

  AdminCallResponse._();

  factory AdminCallResponse([void updates(AdminCallResponseBuilder b)]) = _$AdminCallResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCallResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCallResponse> get serializer => _$AdminCallResponseSerializer();
}

class _$AdminCallResponseSerializer implements PrimitiveSerializer<AdminCallResponse> {
  @override
  final Iterable<Type> types = const [AdminCallResponse, _$AdminCallResponse];

  @override
  final String wireName = r'AdminCallResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCallResponse object, {
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
      specifiedType: const FullType(AdminCallResponseTypeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminCallResponseStatusEnum),
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
    yield r'initiator';
    yield serializers.serialize(
      object.initiator,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCallResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCallResponseBuilder result,
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
            specifiedType: const FullType(AdminCallResponseTypeEnum),
          ) as AdminCallResponseTypeEnum;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminCallResponseStatusEnum),
          ) as AdminCallResponseStatusEnum;
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
        case r'initiator':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.initiator.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCallResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCallResponseBuilder();
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

class AdminCallResponseTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUDIO')
  static const AdminCallResponseTypeEnum AUDIO = _$adminCallResponseTypeEnum_AUDIO;
  @BuiltValueEnumConst(wireName: r'VIDEO')
  static const AdminCallResponseTypeEnum VIDEO = _$adminCallResponseTypeEnum_VIDEO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminCallResponseTypeEnum unknownDefaultOpenApi = _$adminCallResponseTypeEnum_unknownDefaultOpenApi;

  static Serializer<AdminCallResponseTypeEnum> get serializer => _$adminCallResponseTypeEnumSerializer;

  const AdminCallResponseTypeEnum._(String name): super(name);

  static BuiltSet<AdminCallResponseTypeEnum> get values => _$adminCallResponseTypeEnumValues;
  static AdminCallResponseTypeEnum valueOf(String name) => _$adminCallResponseTypeEnumValueOf(name);
}

class AdminCallResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INVITING')
  static const AdminCallResponseStatusEnum INVITING = _$adminCallResponseStatusEnum_INVITING;
  @BuiltValueEnumConst(wireName: r'RINGING')
  static const AdminCallResponseStatusEnum RINGING = _$adminCallResponseStatusEnum_RINGING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const AdminCallResponseStatusEnum ACCEPTED = _$adminCallResponseStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'CONNECTED')
  static const AdminCallResponseStatusEnum CONNECTED = _$adminCallResponseStatusEnum_CONNECTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminCallResponseStatusEnum REJECTED = _$adminCallResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const AdminCallResponseStatusEnum CANCELLED = _$adminCallResponseStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'MISSED')
  static const AdminCallResponseStatusEnum MISSED = _$adminCallResponseStatusEnum_MISSED;
  @BuiltValueEnumConst(wireName: r'ENDED')
  static const AdminCallResponseStatusEnum ENDED = _$adminCallResponseStatusEnum_ENDED;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const AdminCallResponseStatusEnum FAILED = _$adminCallResponseStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminCallResponseStatusEnum unknownDefaultOpenApi = _$adminCallResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminCallResponseStatusEnum> get serializer => _$adminCallResponseStatusEnumSerializer;

  const AdminCallResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminCallResponseStatusEnum> get values => _$adminCallResponseStatusEnumValues;
  static AdminCallResponseStatusEnum valueOf(String name) => _$adminCallResponseStatusEnumValueOf(name);
}

