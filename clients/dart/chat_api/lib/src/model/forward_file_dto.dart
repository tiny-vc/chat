//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'forward_file_dto.g.dart';

/// ForwardFileDto
///
/// Properties:
/// * [scope] 
/// * [scopeId] 
@BuiltValue()
abstract class ForwardFileDto implements Built<ForwardFileDto, ForwardFileDtoBuilder> {
  @BuiltValueField(wireName: r'scope')
  ForwardFileDtoScopeEnum get scope;
  // enum scopeEnum {  PRIVATE,  DIRECT,  GROUP,  };

  @BuiltValueField(wireName: r'scopeId')
  String get scopeId;

  ForwardFileDto._();

  factory ForwardFileDto([void updates(ForwardFileDtoBuilder b)]) = _$ForwardFileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ForwardFileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ForwardFileDto> get serializer => _$ForwardFileDtoSerializer();
}

class _$ForwardFileDtoSerializer implements PrimitiveSerializer<ForwardFileDto> {
  @override
  final Iterable<Type> types = const [ForwardFileDto, _$ForwardFileDto];

  @override
  final String wireName = r'ForwardFileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ForwardFileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(ForwardFileDtoScopeEnum),
    );
    yield r'scopeId';
    yield serializers.serialize(
      object.scopeId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ForwardFileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ForwardFileDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ForwardFileDtoScopeEnum),
          ) as ForwardFileDtoScopeEnum;
          result.scope = valueDes;
          break;
        case r'scopeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  ForwardFileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ForwardFileDtoBuilder();
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

class ForwardFileDtoScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRIVATE')
  static const ForwardFileDtoScopeEnum PRIVATE = _$forwardFileDtoScopeEnum_PRIVATE;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const ForwardFileDtoScopeEnum DIRECT = _$forwardFileDtoScopeEnum_DIRECT;
  @BuiltValueEnumConst(wireName: r'GROUP')
  static const ForwardFileDtoScopeEnum GROUP = _$forwardFileDtoScopeEnum_GROUP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ForwardFileDtoScopeEnum unknownDefaultOpenApi = _$forwardFileDtoScopeEnum_unknownDefaultOpenApi;

  static Serializer<ForwardFileDtoScopeEnum> get serializer => _$forwardFileDtoScopeEnumSerializer;

  const ForwardFileDtoScopeEnum._(String name): super(name);

  static BuiltSet<ForwardFileDtoScopeEnum> get values => _$forwardFileDtoScopeEnumValues;
  static ForwardFileDtoScopeEnum valueOf(String name) => _$forwardFileDtoScopeEnumValueOf(name);
}

