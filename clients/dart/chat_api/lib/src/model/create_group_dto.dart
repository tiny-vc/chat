//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_group_dto.g.dart';

/// CreateGroupDto
///
/// Properties:
/// * [name] 
/// * [memberIds] 
@BuiltValue()
abstract class CreateGroupDto implements Built<CreateGroupDto, CreateGroupDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'memberIds')
  BuiltSet<String> get memberIds;

  CreateGroupDto._();

  factory CreateGroupDto([void updates(CreateGroupDtoBuilder b)]) = _$CreateGroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateGroupDtoBuilder b) => b
      ..memberIds = SetBuilder();

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateGroupDto> get serializer => _$CreateGroupDtoSerializer();
}

class _$CreateGroupDtoSerializer implements PrimitiveSerializer<CreateGroupDto> {
  @override
  final Iterable<Type> types = const [CreateGroupDto, _$CreateGroupDto];

  @override
  final String wireName = r'CreateGroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'memberIds';
    yield serializers.serialize(
      object.memberIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateGroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'memberIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.memberIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateGroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateGroupDtoBuilder();
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

