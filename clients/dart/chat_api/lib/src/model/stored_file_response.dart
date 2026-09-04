//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'stored_file_response.g.dart';

/// StoredFileResponse
///
/// Properties:
/// * [id] 
/// * [originalName] 
/// * [mimeType] 
/// * [sizeBytes] 
/// * [purpose] 
/// * [scope] 
/// * [scopeId] 
/// * [thumbnailFileId] 
/// * [status] 
/// * [uploadedAt] 
/// * [createdAt] 
@BuiltValue()
abstract class StoredFileResponse implements Built<StoredFileResponse, StoredFileResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'originalName')
  String get originalName;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'sizeBytes')
  String get sizeBytes;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'scope')
  StoredFileResponseScopeEnum get scope;
  // enum scopeEnum {  PRIVATE,  DIRECT,  GROUP,  };

  @BuiltValueField(wireName: r'scopeId')
  String? get scopeId;

  @BuiltValueField(wireName: r'thumbnailFileId')
  String? get thumbnailFileId;

  @BuiltValueField(wireName: r'status')
  StoredFileResponseStatusEnum get status;
  // enum statusEnum {  PENDING,  UPLOADED,  READY,  REJECTED,  DELETED,  };

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime? get uploadedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  StoredFileResponse._();

  factory StoredFileResponse([void updates(StoredFileResponseBuilder b)]) = _$StoredFileResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StoredFileResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StoredFileResponse> get serializer => _$StoredFileResponseSerializer();
}

class _$StoredFileResponseSerializer implements PrimitiveSerializer<StoredFileResponse> {
  @override
  final Iterable<Type> types = const [StoredFileResponse, _$StoredFileResponse];

  @override
  final String wireName = r'StoredFileResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StoredFileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
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
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(StoredFileResponseScopeEnum),
    );
    if (object.scopeId != null) {
      yield r'scopeId';
      yield serializers.serialize(
        object.scopeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.thumbnailFileId != null) {
      yield r'thumbnailFileId';
      yield serializers.serialize(
        object.thumbnailFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(StoredFileResponseStatusEnum),
    );
    if (object.uploadedAt != null) {
      yield r'uploadedAt';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    StoredFileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StoredFileResponseBuilder result,
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
            specifiedType: const FullType(StoredFileResponseScopeEnum),
          ) as StoredFileResponseScopeEnum;
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
        case r'thumbnailFileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbnailFileId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoredFileResponseStatusEnum),
          ) as StoredFileResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'uploadedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StoredFileResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StoredFileResponseBuilder();
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

class StoredFileResponseScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRIVATE')
  static const StoredFileResponseScopeEnum PRIVATE = _$storedFileResponseScopeEnum_PRIVATE;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const StoredFileResponseScopeEnum DIRECT = _$storedFileResponseScopeEnum_DIRECT;
  @BuiltValueEnumConst(wireName: r'GROUP')
  static const StoredFileResponseScopeEnum GROUP = _$storedFileResponseScopeEnum_GROUP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const StoredFileResponseScopeEnum unknownDefaultOpenApi = _$storedFileResponseScopeEnum_unknownDefaultOpenApi;

  static Serializer<StoredFileResponseScopeEnum> get serializer => _$storedFileResponseScopeEnumSerializer;

  const StoredFileResponseScopeEnum._(String name): super(name);

  static BuiltSet<StoredFileResponseScopeEnum> get values => _$storedFileResponseScopeEnumValues;
  static StoredFileResponseScopeEnum valueOf(String name) => _$storedFileResponseScopeEnumValueOf(name);
}

class StoredFileResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const StoredFileResponseStatusEnum PENDING = _$storedFileResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'UPLOADED')
  static const StoredFileResponseStatusEnum UPLOADED = _$storedFileResponseStatusEnum_UPLOADED;
  @BuiltValueEnumConst(wireName: r'READY')
  static const StoredFileResponseStatusEnum READY = _$storedFileResponseStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const StoredFileResponseStatusEnum REJECTED = _$storedFileResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const StoredFileResponseStatusEnum DELETED = _$storedFileResponseStatusEnum_DELETED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const StoredFileResponseStatusEnum unknownDefaultOpenApi = _$storedFileResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<StoredFileResponseStatusEnum> get serializer => _$storedFileResponseStatusEnumSerializer;

  const StoredFileResponseStatusEnum._(String name): super(name);

  static BuiltSet<StoredFileResponseStatusEnum> get values => _$storedFileResponseStatusEnumValues;
  static StoredFileResponseStatusEnum valueOf(String name) => _$storedFileResponseStatusEnumValueOf(name);
}

