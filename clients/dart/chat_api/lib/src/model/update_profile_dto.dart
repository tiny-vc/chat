//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_profile_dto.g.dart';

/// UpdateProfileDto
///
/// Properties:
/// * [nickname] 
@BuiltValue()
abstract class UpdateProfileDto implements Built<UpdateProfileDto, UpdateProfileDtoBuilder> {
  @BuiltValueField(wireName: r'nickname')
  String? get nickname;

  UpdateProfileDto._();

  factory UpdateProfileDto([void updates(UpdateProfileDtoBuilder b)]) = _$UpdateProfileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateProfileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateProfileDto> get serializer => _$UpdateProfileDtoSerializer();
}

class _$UpdateProfileDtoSerializer implements PrimitiveSerializer<UpdateProfileDto> {
  @override
  final Iterable<Type> types = const [UpdateProfileDto, _$UpdateProfileDto];

  @override
  final String wireName = r'UpdateProfileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nickname != null) {
      yield r'nickname';
      yield serializers.serialize(
        object.nickname,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateProfileDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nickname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nickname = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateProfileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateProfileDtoBuilder();
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

