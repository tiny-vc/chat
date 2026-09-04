//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_group_member_response.g.dart';

/// AdminGroupMemberResponse
///
/// Properties:
/// * [groupId] 
/// * [userId] 
/// * [role] 
/// * [status] 
/// * [nickname] 
/// * [mutedUntil] 
/// * [joinedAt] 
/// * [user] 
@BuiltValue()
abstract class AdminGroupMemberResponse implements Built<AdminGroupMemberResponse, AdminGroupMemberResponseBuilder> {
  @BuiltValueField(wireName: r'groupId')
  String get groupId;

  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'role')
  AdminGroupMemberResponseRoleEnum get role;
  // enum roleEnum {  OWNER,  ADMIN,  MEMBER,  };

  @BuiltValueField(wireName: r'status')
  AdminGroupMemberResponseStatusEnum get status;
  // enum statusEnum {  ACTIVE,  LEFT,  REMOVED,  };

  @BuiltValueField(wireName: r'nickname')
  String? get nickname;

  @BuiltValueField(wireName: r'mutedUntil')
  DateTime? get mutedUntil;

  @BuiltValueField(wireName: r'joinedAt')
  DateTime get joinedAt;

  @BuiltValueField(wireName: r'user')
  BuiltMap<String, JsonObject?> get user;

  AdminGroupMemberResponse._();

  factory AdminGroupMemberResponse([void updates(AdminGroupMemberResponseBuilder b)]) = _$AdminGroupMemberResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGroupMemberResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGroupMemberResponse> get serializer => _$AdminGroupMemberResponseSerializer();
}

class _$AdminGroupMemberResponseSerializer implements PrimitiveSerializer<AdminGroupMemberResponse> {
  @override
  final Iterable<Type> types = const [AdminGroupMemberResponse, _$AdminGroupMemberResponse];

  @override
  final String wireName = r'AdminGroupMemberResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGroupMemberResponse object, {
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
      specifiedType: const FullType(AdminGroupMemberResponseRoleEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminGroupMemberResponseStatusEnum),
    );
    if (object.nickname != null) {
      yield r'nickname';
      yield serializers.serialize(
        object.nickname,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminGroupMemberResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminGroupMemberResponseBuilder result,
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
            specifiedType: const FullType(AdminGroupMemberResponseRoleEnum),
          ) as AdminGroupMemberResponseRoleEnum;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminGroupMemberResponseStatusEnum),
          ) as AdminGroupMemberResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'nickname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nickname = valueDes;
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
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
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
  AdminGroupMemberResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGroupMemberResponseBuilder();
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

class AdminGroupMemberResponseRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OWNER')
  static const AdminGroupMemberResponseRoleEnum OWNER = _$adminGroupMemberResponseRoleEnum_OWNER;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const AdminGroupMemberResponseRoleEnum ADMIN = _$adminGroupMemberResponseRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'MEMBER')
  static const AdminGroupMemberResponseRoleEnum MEMBER = _$adminGroupMemberResponseRoleEnum_MEMBER;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminGroupMemberResponseRoleEnum unknownDefaultOpenApi = _$adminGroupMemberResponseRoleEnum_unknownDefaultOpenApi;

  static Serializer<AdminGroupMemberResponseRoleEnum> get serializer => _$adminGroupMemberResponseRoleEnumSerializer;

  const AdminGroupMemberResponseRoleEnum._(String name): super(name);

  static BuiltSet<AdminGroupMemberResponseRoleEnum> get values => _$adminGroupMemberResponseRoleEnumValues;
  static AdminGroupMemberResponseRoleEnum valueOf(String name) => _$adminGroupMemberResponseRoleEnumValueOf(name);
}

class AdminGroupMemberResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminGroupMemberResponseStatusEnum ACTIVE = _$adminGroupMemberResponseStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'LEFT')
  static const AdminGroupMemberResponseStatusEnum LEFT = _$adminGroupMemberResponseStatusEnum_LEFT;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const AdminGroupMemberResponseStatusEnum REMOVED = _$adminGroupMemberResponseStatusEnum_REMOVED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminGroupMemberResponseStatusEnum unknownDefaultOpenApi = _$adminGroupMemberResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminGroupMemberResponseStatusEnum> get serializer => _$adminGroupMemberResponseStatusEnumSerializer;

  const AdminGroupMemberResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminGroupMemberResponseStatusEnum> get values => _$adminGroupMemberResponseStatusEnumValues;
  static AdminGroupMemberResponseStatusEnum valueOf(String name) => _$adminGroupMemberResponseStatusEnumValueOf(name);
}

