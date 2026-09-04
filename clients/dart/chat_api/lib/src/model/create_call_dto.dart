//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_call_dto.g.dart';

/// CreateCallDto
///
/// Properties:
/// * [targetUserId] 
/// * [type] 
@BuiltValue()
abstract class CreateCallDto implements Built<CreateCallDto, CreateCallDtoBuilder> {
  @BuiltValueField(wireName: r'targetUserId')
  String get targetUserId;

  @BuiltValueField(wireName: r'type')
  CreateCallDtoTypeEnum get type;
  // enum typeEnum {  AUDIO,  VIDEO,  };

  CreateCallDto._();

  factory CreateCallDto([void updates(CreateCallDtoBuilder b)]) = _$CreateCallDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCallDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCallDto> get serializer => _$CreateCallDtoSerializer();
}

class _$CreateCallDtoSerializer implements PrimitiveSerializer<CreateCallDto> {
  @override
  final Iterable<Type> types = const [CreateCallDto, _$CreateCallDto];

  @override
  final String wireName = r'CreateCallDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCallDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'targetUserId';
    yield serializers.serialize(
      object.targetUserId,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CreateCallDtoTypeEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateCallDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateCallDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'targetUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetUserId = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreateCallDtoTypeEnum),
          ) as CreateCallDtoTypeEnum;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateCallDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCallDtoBuilder();
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

class CreateCallDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AUDIO')
  static const CreateCallDtoTypeEnum AUDIO = _$createCallDtoTypeEnum_AUDIO;
  @BuiltValueEnumConst(wireName: r'VIDEO')
  static const CreateCallDtoTypeEnum VIDEO = _$createCallDtoTypeEnum_VIDEO;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const CreateCallDtoTypeEnum unknownDefaultOpenApi = _$createCallDtoTypeEnum_unknownDefaultOpenApi;

  static Serializer<CreateCallDtoTypeEnum> get serializer => _$createCallDtoTypeEnumSerializer;

  const CreateCallDtoTypeEnum._(String name): super(name);

  static BuiltSet<CreateCallDtoTypeEnum> get values => _$createCallDtoTypeEnumValues;
  static CreateCallDtoTypeEnum valueOf(String name) => _$createCallDtoTypeEnumValueOf(name);
}

