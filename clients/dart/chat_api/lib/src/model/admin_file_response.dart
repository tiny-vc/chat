//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_file_response.g.dart';

/// AdminFileResponse
///
/// Properties:
/// * [id] 
/// * [ownerUserId] 
/// * [originalName] 
/// * [mimeType] 
/// * [sizeBytes] 
/// * [sha256] 
/// * [purpose] 
/// * [scope] 
/// * [scopeId] 
/// * [status] 
/// * [thumbnailFileId] 
/// * [createdAt] 
/// * [uploadedAt] 
/// * [owner] 
@BuiltValue()
abstract class AdminFileResponse implements Built<AdminFileResponse, AdminFileResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'ownerUserId')
  String get ownerUserId;

  @BuiltValueField(wireName: r'originalName')
  String get originalName;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'sizeBytes')
  String get sizeBytes;

  @BuiltValueField(wireName: r'sha256')
  String? get sha256;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'scope')
  AdminFileResponseScopeEnum get scope;
  // enum scopeEnum {  PRIVATE,  DIRECT,  GROUP,  };

  @BuiltValueField(wireName: r'scopeId')
  String? get scopeId;

  @BuiltValueField(wireName: r'status')
  AdminFileResponseStatusEnum get status;
  // enum statusEnum {  PENDING,  UPLOADED,  READY,  REJECTED,  DELETE_PENDING,  DELETED,  };

  @BuiltValueField(wireName: r'thumbnailFileId')
  String? get thumbnailFileId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'owner')
  BuiltMap<String, JsonObject?> get owner;

  AdminFileResponse._();

  factory AdminFileResponse([void updates(AdminFileResponseBuilder b)]) = _$AdminFileResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFileResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFileResponse> get serializer => _$AdminFileResponseSerializer();
}

class _$AdminFileResponseSerializer implements PrimitiveSerializer<AdminFileResponse> {
  @override
  final Iterable<Type> types = const [AdminFileResponse, _$AdminFileResponse];

  @override
  final String wireName = r'AdminFileResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'ownerUserId';
    yield serializers.serialize(
      object.ownerUserId,
      specifiedType: const FullType(String),
    );
    yield r'originalName';
    yield serializers.serialize(
      object.originalName,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(String),
    );
    if (object.sha256 != null) {
      yield r'sha256';
      yield serializers.serialize(
        object.sha256,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(AdminFileResponseScopeEnum),
    );
    if (object.scopeId != null) {
      yield r'scopeId';
      yield serializers.serialize(
        object.scopeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminFileResponseStatusEnum),
    );
    if (object.thumbnailFileId != null) {
      yield r'thumbnailFileId';
      yield serializers.serialize(
        object.thumbnailFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.uploadedAt != null) {
      yield r'uploadedAt';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'owner';
    yield serializers.serialize(
      object.owner,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminFileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminFileResponseBuilder result,
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
        case r'ownerUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerUserId = valueDes;
          break;
        case r'originalName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalName = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sizeBytes = valueDes;
          break;
        case r'sha256':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sha256 = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminFileResponseScopeEnum),
          ) as AdminFileResponseScopeEnum;
          result.scope = valueDes;
          break;
        case r'scopeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scopeId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminFileResponseStatusEnum),
          ) as AdminFileResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'thumbnailFileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbnailFileId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'uploadedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.owner.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminFileResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFileResponseBuilder();
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

class AdminFileResponseScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRIVATE')
  static const AdminFileResponseScopeEnum PRIVATE = _$adminFileResponseScopeEnum_PRIVATE;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const AdminFileResponseScopeEnum DIRECT = _$adminFileResponseScopeEnum_DIRECT;
  @BuiltValueEnumConst(wireName: r'GROUP')
  static const AdminFileResponseScopeEnum GROUP = _$adminFileResponseScopeEnum_GROUP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminFileResponseScopeEnum unknownDefaultOpenApi = _$adminFileResponseScopeEnum_unknownDefaultOpenApi;

  static Serializer<AdminFileResponseScopeEnum> get serializer => _$adminFileResponseScopeEnumSerializer;

  const AdminFileResponseScopeEnum._(String name): super(name);

  static BuiltSet<AdminFileResponseScopeEnum> get values => _$adminFileResponseScopeEnumValues;
  static AdminFileResponseScopeEnum valueOf(String name) => _$adminFileResponseScopeEnumValueOf(name);
}

class AdminFileResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const AdminFileResponseStatusEnum PENDING = _$adminFileResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'UPLOADED')
  static const AdminFileResponseStatusEnum UPLOADED = _$adminFileResponseStatusEnum_UPLOADED;
  @BuiltValueEnumConst(wireName: r'READY')
  static const AdminFileResponseStatusEnum READY = _$adminFileResponseStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const AdminFileResponseStatusEnum REJECTED = _$adminFileResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'DELETE_PENDING')
  static const AdminFileResponseStatusEnum DELETE_PENDING = _$adminFileResponseStatusEnum_DELETE_PENDING;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const AdminFileResponseStatusEnum DELETED = _$adminFileResponseStatusEnum_DELETED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminFileResponseStatusEnum unknownDefaultOpenApi = _$adminFileResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminFileResponseStatusEnum> get serializer => _$adminFileResponseStatusEnumSerializer;

  const AdminFileResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminFileResponseStatusEnum> get values => _$adminFileResponseStatusEnumValues;
  static AdminFileResponseStatusEnum valueOf(String name) => _$adminFileResponseStatusEnumValueOf(name);
}

