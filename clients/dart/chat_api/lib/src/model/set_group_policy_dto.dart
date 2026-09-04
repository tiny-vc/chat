//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_group_policy_dto.g.dart';

/// SetGroupPolicyDto
///
/// Properties:
/// * [suspended] 
/// * [muteAll] 
@BuiltValue()
abstract class SetGroupPolicyDto implements Built<SetGroupPolicyDto, SetGroupPolicyDtoBuilder> {
  @BuiltValueField(wireName: r'suspended')
  bool? get suspended;

  @BuiltValueField(wireName: r'muteAll')
  bool? get muteAll;

  SetGroupPolicyDto._();

  factory SetGroupPolicyDto([void updates(SetGroupPolicyDtoBuilder b)]) = _$SetGroupPolicyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetGroupPolicyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetGroupPolicyDto> get serializer => _$SetGroupPolicyDtoSerializer();
}

class _$SetGroupPolicyDtoSerializer implements PrimitiveSerializer<SetGroupPolicyDto> {
  @override
  final Iterable<Type> types = const [SetGroupPolicyDto, _$SetGroupPolicyDto];

  @override
  final String wireName = r'SetGroupPolicyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetGroupPolicyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.suspended != null) {
      yield r'suspended';
      yield serializers.serialize(
        object.suspended,
        specifiedType: const FullType(bool),
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
    SetGroupPolicyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetGroupPolicyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'suspended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.suspended = valueDes;
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
  SetGroupPolicyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetGroupPolicyDtoBuilder();
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

