//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_group_avatar_dto.g.dart';

/// SetGroupAvatarDto
///
/// Properties:
/// * [fileId] 
@BuiltValue()
abstract class SetGroupAvatarDto implements Built<SetGroupAvatarDto, SetGroupAvatarDtoBuilder> {
  @BuiltValueField(wireName: r'fileId')
  String get fileId;

  SetGroupAvatarDto._();

  factory SetGroupAvatarDto([void updates(SetGroupAvatarDtoBuilder b)]) = _$SetGroupAvatarDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetGroupAvatarDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetGroupAvatarDto> get serializer => _$SetGroupAvatarDtoSerializer();
}

class _$SetGroupAvatarDtoSerializer implements PrimitiveSerializer<SetGroupAvatarDto> {
  @override
  final Iterable<Type> types = const [SetGroupAvatarDto, _$SetGroupAvatarDto];

  @override
  final String wireName = r'SetGroupAvatarDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetGroupAvatarDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileId';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetGroupAvatarDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetGroupAvatarDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetGroupAvatarDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetGroupAvatarDtoBuilder();
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

