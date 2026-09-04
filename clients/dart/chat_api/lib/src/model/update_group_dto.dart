//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_group_dto.g.dart';

/// UpdateGroupDto
///
/// Properties:
/// * [name] 
/// * [muteAll] 
@BuiltValue()
abstract class UpdateGroupDto implements Built<UpdateGroupDto, UpdateGroupDtoBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'muteAll')
  bool? get muteAll;

  UpdateGroupDto._();

  factory UpdateGroupDto([void updates(UpdateGroupDtoBuilder b)]) = _$UpdateGroupDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateGroupDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateGroupDto> get serializer => _$UpdateGroupDtoSerializer();
}

class _$UpdateGroupDtoSerializer implements PrimitiveSerializer<UpdateGroupDto> {
  @override
  final Iterable<Type> types = const [UpdateGroupDto, _$UpdateGroupDto];

  @override
  final String wireName = r'UpdateGroupDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.muteAll != null) {
      yield r'muteAll';
      yield serializers.serialize(
        object.muteAll,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateGroupDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateGroupDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'muteAll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.muteAll = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateGroupDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateGroupDtoBuilder();
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

