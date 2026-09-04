//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_member_response.g.dart';

/// GroupMemberResponse
///
/// Properties:
/// * [groupId] 
/// * [userId] 
/// * [role] 
/// * [status] 
/// * [mutedUntil] 
/// * [joinedAt] 
/// * [user] 
@BuiltValue()
abstract class GroupMemberResponse implements Built<GroupMemberResponse, GroupMemberResponseBuilder> {
  @BuiltValueField(wireName: r'groupId')
  String get groupId;

  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'role')
  GroupMemberResponseRoleEnum get role;
  // enum roleEnum {  OWNER,  ADMIN,  MEMBER,  };

  @BuiltValueField(wireName: r'status')
  GroupMemberResponseStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LEFT,  REMOVED,  };

  @BuiltValueField(wireName: r'mutedUntil')
  DateTime? get mutedUntil;

  @BuiltValueField(wireName: r'joinedAt')
  DateTime get joinedAt;

  @BuiltValueField(wireName: r'user')
  UserResponse? get user;

  GroupMemberResponse._();

  factory GroupMemberResponse([void updates(GroupMemberResponseBuilder b)]) = _$GroupMemberResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupMemberResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupMemberResponse> get serializer => _$GroupMemberResponseSerializer();
}

class _$GroupMemberResponseSerializer implements PrimitiveSerializer<GroupMemberResponse> {
  @override
  final Iterable<Type> types = const [GroupMemberResponse, _$GroupMemberResponse];

  @override
  final String wireName = r'GroupMemberResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupMemberResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(GroupMemberResponseRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GroupMemberResponseStatusEnum),
    );
    if (object.mutedUntil != null) {
      yield r'mutedUntil';
      yield serializers.serialize(
        object.mutedUntil,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'joinedAt';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(DateTime),
    );
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
    GroupMemberResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupMemberResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupMemberResponseRoleEnum),
          ) as GroupMemberResponseRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupMemberResponseStatusEnum),
          ) as GroupMemberResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'mutedUntil':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.mutedUntil = valueDes;
          break;
        case r'joinedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.joinedAt = valueDes;
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
  GroupMemberResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupMemberResponseBuilder();
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

class GroupMemberResponseRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWNER')
  static const GroupMemberResponseRoleEnum OWNER = _$groupMemberResponseRoleEnum_OWNER;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const GroupMemberResponseRoleEnum ADMIN = _$groupMemberResponseRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'MEMBER')
  static const GroupMemberResponseRoleEnum MEMBER = _$groupMemberResponseRoleEnum_MEMBER;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const GroupMemberResponseRoleEnum unknownDefaultOpenApi = _$groupMemberResponseRoleEnum_unknownDefaultOpenApi;

  static Serializer<GroupMemberResponseRoleEnum> get serializer => _$groupMemberResponseRoleEnumSerializer;

  const GroupMemberResponseRoleEnum._(String name): super(name);

  static BuiltSet<GroupMemberResponseRoleEnum> get values => _$groupMemberResponseRoleEnumValues;
  static GroupMemberResponseRoleEnum valueOf(String name) => _$groupMemberResponseRoleEnumValueOf(name);
}

class GroupMemberResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const GroupMemberResponseStatusEnum ACTIVE = _$groupMemberResponseStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LEFT')
  static const GroupMemberResponseStatusEnum LEFT = _$groupMemberResponseStatusEnum_LEFT;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const GroupMemberResponseStatusEnum REMOVED = _$groupMemberResponseStatusEnum_REMOVED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const GroupMemberResponseStatusEnum unknownDefaultOpenApi = _$groupMemberResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<GroupMemberResponseStatusEnum> get serializer => _$groupMemberResponseStatusEnumSerializer;

  const GroupMemberResponseStatusEnum._(String name): super(name);

  static BuiltSet<GroupMemberResponseStatusEnum> get values => _$groupMemberResponseStatusEnumValues;
  static GroupMemberResponseStatusEnum valueOf(String name) => _$groupMemberResponseStatusEnumValueOf(name);
}

