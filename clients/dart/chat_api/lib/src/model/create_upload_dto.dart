//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_upload_dto.g.dart';

/// CreateUploadDto
///
/// Properties:
/// * [fileName] 
/// * [mimeType] 
/// * [size] 
/// * [purpose] 
/// * [scope] 
/// * [scopeId] 
@BuiltValue()
abstract class CreateUploadDto implements Built<CreateUploadDto, CreateUploadDtoBuilder> {
  @BuiltValueField(wireName: r'fileName')
  String get fileName;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'size')
  num get size;

  @BuiltValueField(wireName: r'purpose')
  CreateUploadDtoPurposeEnum get purpose;
  // enum purposeEnum {  AVATAR,  CHAT_IMAGE,  CHAT_VOICE,  CHAT_VIDEO,  CHAT_FILE,  };

  @BuiltValueField(wireName: r'scope')
  CreateUploadDtoScopeEnum get scope;
  // enum scopeEnum {  PRIVATE,  DIRECT,  GROUP,  };

  @BuiltValueField(wireName: r'scopeId')
  String? get scopeId;

  CreateUploadDto._();

  factory CreateUploadDto([void updates(CreateUploadDtoBuilder b)]) = _$CreateUploadDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateUploadDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateUploadDto> get serializer => _$CreateUploadDtoSerializer();
}

class _$CreateUploadDtoSerializer implements PrimitiveSerializer<CreateUploadDto> {
  @override
  final Iterable<Type> types = const [CreateUploadDto, _$CreateUploadDto];

  @override
  final String wireName = r'CreateUploadDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileName';
    yield serializers.serialize(
      object.fileName,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(num),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(CreateUploadDtoPurposeEnum),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(CreateUploadDtoScopeEnum),
    );
    if (object.scopeId != null) {
      yield r'scopeId';
      yield serializers.serialize(
        object.scopeId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateUploadDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateUploadDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileName = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.size = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateUploadDtoPurposeEnum),
          ) as CreateUploadDtoPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateUploadDtoScopeEnum),
          ) as CreateUploadDtoScopeEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateUploadDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateUploadDtoBuilder();
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

class CreateUploadDtoPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVATAR')
  static const CreateUploadDtoPurposeEnum AVATAR = _$createUploadDtoPurposeEnum_AVATAR;
  @BuiltValueEnumConst(wireName: r'CHAT_IMAGE')
  static const CreateUploadDtoPurposeEnum CHAT_IMAGE = _$createUploadDtoPurposeEnum_CHAT_IMAGE;
  @BuiltValueEnumConst(wireName: r'CHAT_VOICE')
  static const CreateUploadDtoPurposeEnum CHAT_VOICE = _$createUploadDtoPurposeEnum_CHAT_VOICE;
  @BuiltValueEnumConst(wireName: r'CHAT_VIDEO')
  static const CreateUploadDtoPurposeEnum CHAT_VIDEO = _$createUploadDtoPurposeEnum_CHAT_VIDEO;
  @BuiltValueEnumConst(wireName: r'CHAT_FILE')
  static const CreateUploadDtoPurposeEnum CHAT_FILE = _$createUploadDtoPurposeEnum_CHAT_FILE;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CreateUploadDtoPurposeEnum unknownDefaultOpenApi = _$createUploadDtoPurposeEnum_unknownDefaultOpenApi;

  static Serializer<CreateUploadDtoPurposeEnum> get serializer => _$createUploadDtoPurposeEnumSerializer;

  const CreateUploadDtoPurposeEnum._(String name): super(name);

  static BuiltSet<CreateUploadDtoPurposeEnum> get values => _$createUploadDtoPurposeEnumValues;
  static CreateUploadDtoPurposeEnum valueOf(String name) => _$createUploadDtoPurposeEnumValueOf(name);
}

class CreateUploadDtoScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRIVATE')
  static const CreateUploadDtoScopeEnum PRIVATE = _$createUploadDtoScopeEnum_PRIVATE;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const CreateUploadDtoScopeEnum DIRECT = _$createUploadDtoScopeEnum_DIRECT;
  @BuiltValueEnumConst(wireName: r'GROUP')
  static const CreateUploadDtoScopeEnum GROUP = _$createUploadDtoScopeEnum_GROUP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CreateUploadDtoScopeEnum unknownDefaultOpenApi = _$createUploadDtoScopeEnum_unknownDefaultOpenApi;

  static Serializer<CreateUploadDtoScopeEnum> get serializer => _$createUploadDtoScopeEnumSerializer;

  const CreateUploadDtoScopeEnum._(String name): super(name);

  static BuiltSet<CreateUploadDtoScopeEnum> get values => _$createUploadDtoScopeEnumValues;
  static CreateUploadDtoScopeEnum valueOf(String name) => _$createUploadDtoScopeEnumValueOf(name);
}

