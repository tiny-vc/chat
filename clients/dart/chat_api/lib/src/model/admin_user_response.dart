//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_user_response.g.dart';

/// AdminUserResponse
///
/// Properties:
/// * [id] 
/// * [username] 
/// * [nickname] 
/// * [avatarUrl] 
/// * [avatarFileId] 
/// * [status] 
/// * [role] 
/// * [revokedSessions] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [deviceSessions] 
/// * [count] 
@BuiltValue()
abstract class AdminUserResponse implements Built<AdminUserResponse, AdminUserResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'nickname')
  String get nickname;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'avatarFileId')
  String? get avatarFileId;

  @BuiltValueField(wireName: r'status')
  AdminUserResponseStatusEnum get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  DELETED,  };

  @BuiltValueField(wireName: r'role')
  AdminUserResponseRoleEnum get role;
  // enum roleEnum {  USER,  ADMIN,  };

  @BuiltValueField(wireName: r'revokedSessions')
  int? get revokedSessions;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'deviceSessions')
  BuiltList<BuiltMap<String, JsonObject?>>? get deviceSessions;

  @BuiltValueField(wireName: r'_count')
  BuiltMap<String, int>? get count;

  AdminUserResponse._();

  factory AdminUserResponse([void updates(AdminUserResponseBuilder b)]) = _$AdminUserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminUserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminUserResponse> get serializer => _$AdminUserResponseSerializer();
}

class _$AdminUserResponseSerializer implements PrimitiveSerializer<AdminUserResponse> {
  @override
  final Iterable<Type> types = const [AdminUserResponse, _$AdminUserResponse];

  @override
  final String wireName = r'AdminUserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminUserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'nickname';
    yield serializers.serialize(
      object.nickname,
      specifiedType: const FullType(String),
    );
    if (object.avatarUrl != null) {
      yield r'avatarUrl';
      yield serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.avatarFileId != null) {
      yield r'avatarFileId';
      yield serializers.serialize(
        object.avatarFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminUserResponseStatusEnum),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(AdminUserResponseRoleEnum),
    );
    if (object.revokedSessions != null) {
      yield r'revokedSessions';
      yield serializers.serialize(
        object.revokedSessions,
        specifiedType: const FullType(int),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.deviceSessions != null) {
      yield r'deviceSessions';
      yield serializers.serialize(
        object.deviceSessions,
        specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
      );
    }
    if (object.count != null) {
      yield r'_count';
      yield serializers.serialize(
        object.count,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminUserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminUserResponseBuilder result,
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
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'nickname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nickname = valueDes;
          break;
        case r'avatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        case r'avatarFileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarFileId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminUserResponseStatusEnum),
          ) as AdminUserResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminUserResponseRoleEnum),
          ) as AdminUserResponseRoleEnum;
          result.role = valueDes;
          break;
        case r'revokedSessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.revokedSessions = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'deviceSessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>?;
          if (valueDes == null) continue;
          result.deviceSessions.replace(valueDes);
          break;
        case r'_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.count.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminUserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminUserResponseBuilder();
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

class AdminUserResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminUserResponseStatusEnum ACTIVE = _$adminUserResponseStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminUserResponseStatusEnum SUSPENDED = _$adminUserResponseStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const AdminUserResponseStatusEnum DELETED = _$adminUserResponseStatusEnum_DELETED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminUserResponseStatusEnum unknownDefaultOpenApi = _$adminUserResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminUserResponseStatusEnum> get serializer => _$adminUserResponseStatusEnumSerializer;

  const AdminUserResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminUserResponseStatusEnum> get values => _$adminUserResponseStatusEnumValues;
  static AdminUserResponseStatusEnum valueOf(String name) => _$adminUserResponseStatusEnumValueOf(name);
}

class AdminUserResponseRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'USER')
  static const AdminUserResponseRoleEnum USER = _$adminUserResponseRoleEnum_USER;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const AdminUserResponseRoleEnum ADMIN = _$adminUserResponseRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminUserResponseRoleEnum unknownDefaultOpenApi = _$adminUserResponseRoleEnum_unknownDefaultOpenApi;

  static Serializer<AdminUserResponseRoleEnum> get serializer => _$adminUserResponseRoleEnumSerializer;

  const AdminUserResponseRoleEnum._(String name): super(name);

  static BuiltSet<AdminUserResponseRoleEnum> get values => _$adminUserResponseRoleEnumValues;
  static AdminUserResponseRoleEnum valueOf(String name) => _$adminUserResponseRoleEnumValueOf(name);
}

