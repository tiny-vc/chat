//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_group_nickname_dto.g.dart';

/// UpdateGroupNicknameDto
///
/// Properties:
/// * [nickname] 
@BuiltValue()
abstract class UpdateGroupNicknameDto implements Built<UpdateGroupNicknameDto, UpdateGroupNicknameDtoBuilder> {
  @BuiltValueField(wireName: r'nickname')
  String get nickname;

  UpdateGroupNicknameDto._();

  factory UpdateGroupNicknameDto([void updates(UpdateGroupNicknameDtoBuilder b)]) = _$UpdateGroupNicknameDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateGroupNicknameDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateGroupNicknameDto> get serializer => _$UpdateGroupNicknameDtoSerializer();
}

class _$UpdateGroupNicknameDtoSerializer implements PrimitiveSerializer<UpdateGroupNicknameDto> {
  @override
  final Iterable<Type> types = const [UpdateGroupNicknameDto, _$UpdateGroupNicknameDto];

  @override
  final String wireName = r'UpdateGroupNicknameDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateGroupNicknameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nickname';
    yield serializers.serialize(
      object.nickname,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateGroupNicknameDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateGroupNicknameDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nickname':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  UpdateGroupNicknameDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateGroupNicknameDtoBuilder();
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

