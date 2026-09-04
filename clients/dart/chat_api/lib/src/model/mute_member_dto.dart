//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mute_member_dto.g.dart';

/// MuteMemberDto
///
/// Properties:
/// * [muted] 
/// * [durationMinutes] 
@BuiltValue()
abstract class MuteMemberDto implements Built<MuteMemberDto, MuteMemberDtoBuilder> {
  @BuiltValueField(wireName: r'muted')
  bool get muted;

  @BuiltValueField(wireName: r'durationMinutes')
  num? get durationMinutes;

  MuteMemberDto._();

  factory MuteMemberDto([void updates(MuteMemberDtoBuilder b)]) = _$MuteMemberDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MuteMemberDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MuteMemberDto> get serializer => _$MuteMemberDtoSerializer();
}

class _$MuteMemberDtoSerializer implements PrimitiveSerializer<MuteMemberDto> {
  @override
  final Iterable<Type> types = const [MuteMemberDto, _$MuteMemberDto];

  @override
  final String wireName = r'MuteMemberDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MuteMemberDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'muted';
    yield serializers.serialize(
      object.muted,
      specifiedType: const FullType(bool),
    );
    if (object.durationMinutes != null) {
      yield r'durationMinutes';
      yield serializers.serialize(
        object.durationMinutes,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MuteMemberDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MuteMemberDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'muted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muted = valueDes;
          break;
        case r'durationMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.durationMinutes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MuteMemberDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MuteMemberDtoBuilder();
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

