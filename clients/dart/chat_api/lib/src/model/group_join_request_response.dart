//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:chat_api_client/src/model/group_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_join_request_response.g.dart';

/// GroupJoinRequestResponse
///
/// Properties:
/// * [id] 
/// * [groupId] 
/// * [userId] 
/// * [requestedById] 
/// * [decidedById] 
/// * [type] 
/// * [status] 
/// * [message] 
/// * [decisionNote] 
/// * [expiresAt] 
/// * [createdAt] 
/// * [decidedAt] 
/// * [group] 
/// * [user] 
@BuiltValue()
abstract class GroupJoinRequestResponse implements Built<GroupJoinRequestResponse, GroupJoinRequestResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'groupId')
  String get groupId;

  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'requestedById')
  String get requestedById;

  @BuiltValueField(wireName: r'decidedById')
  String? get decidedById;

  @BuiltValueField(wireName: r'type')
  GroupJoinRequestResponseTypeEnum get type;
  // enum typeEnum {  APPLY,  INVITE,  };

  @BuiltValueField(wireName: r'status')
  GroupJoinRequestResponseStatusEnum get status;
  // enum statusEnum {  PENDING,  APPROVED,  REJECTED,  CANCELLED,  EXPIRED,  };

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'decisionNote')
  String? get decisionNote;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'decidedAt')
  DateTime? get decidedAt;

  @BuiltValueField(wireName: r'group')
  GroupResponse? get group;

  @BuiltValueField(wireName: r'user')
  UserResponse? get user;

  GroupJoinRequestResponse._();

  factory GroupJoinRequestResponse([void updates(GroupJoinRequestResponseBuilder b)]) = _$GroupJoinRequestResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupJoinRequestResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupJoinRequestResponse> get serializer => _$GroupJoinRequestResponseSerializer();
}

class _$GroupJoinRequestResponseSerializer implements PrimitiveSerializer<GroupJoinRequestResponse> {
  @override
  final Iterable<Type> types = const [GroupJoinRequestResponse, _$GroupJoinRequestResponse];

  @override
  final String wireName = r'GroupJoinRequestResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupJoinRequestResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'groupId';
    yield serializers.serialize(
      object.groupId,
      specifiedType: const FullType(String),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'requestedById';
    yield serializers.serialize(
      object.requestedById,
      specifiedType: const FullType(String),
    );
    if (object.decidedById != null) {
      yield r'decidedById';
      yield serializers.serialize(
        object.decidedById,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(GroupJoinRequestResponseTypeEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GroupJoinRequestResponseStatusEnum),
    );
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.decisionNote != null) {
      yield r'decisionNote';
      yield serializers.serialize(
        object.decisionNote,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.decidedAt != null) {
      yield r'decidedAt';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.group != null) {
      yield r'group';
      yield serializers.serialize(
        object.group,
        specifiedType: const FullType(GroupResponse),
      );
    }
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(UserResponse),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupJoinRequestResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupJoinRequestResponseBuilder result,
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
        case r'groupId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.groupId = valueDes;
          break;
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'requestedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestedById = valueDes;
          break;
        case r'decidedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decidedById = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupJoinRequestResponseTypeEnum),
          ) as GroupJoinRequestResponseTypeEnum;
          result.type = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupJoinRequestResponseStatusEnum),
          ) as GroupJoinRequestResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'decisionNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decisionNote = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'decidedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'group':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GroupResponse),
          ) as GroupResponse?;
          if (valueDes == null) continue;
          result.group.replace(valueDes);
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserResponse),
          ) as UserResponse?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupJoinRequestResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupJoinRequestResponseBuilder();
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

class GroupJoinRequestResponseTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPLY')
  static const GroupJoinRequestResponseTypeEnum APPLY = _$groupJoinRequestResponseTypeEnum_APPLY;
  @BuiltValueEnumConst(wireName: r'INVITE')
  static const GroupJoinRequestResponseTypeEnum INVITE = _$groupJoinRequestResponseTypeEnum_INVITE;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const GroupJoinRequestResponseTypeEnum unknownDefaultOpenApi = _$groupJoinRequestResponseTypeEnum_unknownDefaultOpenApi;

  static Serializer<GroupJoinRequestResponseTypeEnum> get serializer => _$groupJoinRequestResponseTypeEnumSerializer;

  const GroupJoinRequestResponseTypeEnum._(String name): super(name);

  static BuiltSet<GroupJoinRequestResponseTypeEnum> get values => _$groupJoinRequestResponseTypeEnumValues;
  static GroupJoinRequestResponseTypeEnum valueOf(String name) => _$groupJoinRequestResponseTypeEnumValueOf(name);
}

class GroupJoinRequestResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const GroupJoinRequestResponseStatusEnum PENDING = _$groupJoinRequestResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const GroupJoinRequestResponseStatusEnum APPROVED = _$groupJoinRequestResponseStatusEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const GroupJoinRequestResponseStatusEnum REJECTED = _$groupJoinRequestResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const GroupJoinRequestResponseStatusEnum CANCELLED = _$groupJoinRequestResponseStatusEnum_CANCELLED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const GroupJoinRequestResponseStatusEnum EXPIRED = _$groupJoinRequestResponseStatusEnum_EXPIRED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const GroupJoinRequestResponseStatusEnum unknownDefaultOpenApi = _$groupJoinRequestResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<GroupJoinRequestResponseStatusEnum> get serializer => _$groupJoinRequestResponseStatusEnumSerializer;

  const GroupJoinRequestResponseStatusEnum._(String name): super(name);

  static BuiltSet<GroupJoinRequestResponseStatusEnum> get values => _$groupJoinRequestResponseStatusEnumValues;
  static GroupJoinRequestResponseStatusEnum valueOf(String name) => _$groupJoinRequestResponseStatusEnumValueOf(name);
}

