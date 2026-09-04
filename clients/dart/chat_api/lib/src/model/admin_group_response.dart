//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_group_response.g.dart';

/// AdminGroupResponse
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [avatarUrl] 
/// * [avatarFileId] 
/// * [ownerId] 
/// * [memberLimit] 
/// * [muteAll] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [owner] 
/// * [count] 
@BuiltValue()
abstract class AdminGroupResponse implements Built<AdminGroupResponse, AdminGroupResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'avatarFileId')
  String? get avatarFileId;

  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  @BuiltValueField(wireName: r'memberLimit')
  int get memberLimit;

  @BuiltValueField(wireName: r'muteAll')
  bool get muteAll;

  @BuiltValueField(wireName: r'status')
  AdminGroupResponseStatusEnum get status;
  // enum statusEnum {  ACTIVE,  DISBANDED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: r'owner')
  BuiltMap<String, JsonObject?>? get owner;

  @BuiltValueField(wireName: r'_count')
  BuiltMap<String, int>? get count;

  AdminGroupResponse._();

  factory AdminGroupResponse([void updates(AdminGroupResponseBuilder b)]) = _$AdminGroupResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGroupResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGroupResponse> get serializer => _$AdminGroupResponseSerializer();
}

class _$AdminGroupResponseSerializer implements PrimitiveSerializer<AdminGroupResponse> {
  @override
  final Iterable<Type> types = const [AdminGroupResponse, _$AdminGroupResponse];

  @override
  final String wireName = r'AdminGroupResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGroupResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
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
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    yield r'memberLimit';
    yield serializers.serialize(
      object.memberLimit,
      specifiedType: const FullType(int),
    );
    yield r'muteAll';
    yield serializers.serialize(
      object.muteAll,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminGroupResponseStatusEnum),
    );
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
    if (object.owner != null) {
      yield r'owner';
      yield serializers.serialize(
        object.owner,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
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
    AdminGroupResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminGroupResponseBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'memberLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberLimit = valueDes;
          break;
        case r'muteAll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muteAll = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminGroupResponseStatusEnum),
          ) as AdminGroupResponseStatusEnum;
          result.status = valueDes;
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
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.owner.replace(valueDes);
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
  AdminGroupResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGroupResponseBuilder();
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

class AdminGroupResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AdminGroupResponseStatusEnum ACTIVE = _$adminGroupResponseStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'DISBANDED')
  static const AdminGroupResponseStatusEnum DISBANDED = _$adminGroupResponseStatusEnum_DISBANDED;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AdminGroupResponseStatusEnum SUSPENDED = _$adminGroupResponseStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminGroupResponseStatusEnum unknownDefaultOpenApi = _$adminGroupResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminGroupResponseStatusEnum> get serializer => _$adminGroupResponseStatusEnumSerializer;

  const AdminGroupResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminGroupResponseStatusEnum> get values => _$adminGroupResponseStatusEnumValues;
  static AdminGroupResponseStatusEnum valueOf(String name) => _$adminGroupResponseStatusEnumValueOf(name);
}

