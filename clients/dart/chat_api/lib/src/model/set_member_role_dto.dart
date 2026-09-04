//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_member_role_dto.g.dart';

/// SetMemberRoleDto
///
/// Properties:
/// * [role] 
@BuiltValue()
abstract class SetMemberRoleDto implements Built<SetMemberRoleDto, SetMemberRoleDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  SetMemberRoleDtoRoleEnum get role;
  // enum roleEnum {  ADMIN,  MEMBER,  };

  SetMemberRoleDto._();

  factory SetMemberRoleDto([void updates(SetMemberRoleDtoBuilder b)]) = _$SetMemberRoleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetMemberRoleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetMemberRoleDto> get serializer => _$SetMemberRoleDtoSerializer();
}

class _$SetMemberRoleDtoSerializer implements PrimitiveSerializer<SetMemberRoleDto> {
  @override
  final Iterable<Type> types = const [SetMemberRoleDto, _$SetMemberRoleDto];

  @override
  final String wireName = r'SetMemberRoleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetMemberRoleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(SetMemberRoleDtoRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetMemberRoleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetMemberRoleDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SetMemberRoleDtoRoleEnum),
          ) as SetMemberRoleDtoRoleEnum;
          result.role = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetMemberRoleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetMemberRoleDtoBuilder();
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

class SetMemberRoleDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const SetMemberRoleDtoRoleEnum ADMIN = _$setMemberRoleDtoRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'MEMBER')
  static const SetMemberRoleDtoRoleEnum MEMBER = _$setMemberRoleDtoRoleEnum_MEMBER;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const SetMemberRoleDtoRoleEnum unknownDefaultOpenApi = _$setMemberRoleDtoRoleEnum_unknownDefaultOpenApi;

  static Serializer<SetMemberRoleDtoRoleEnum> get serializer => _$setMemberRoleDtoRoleEnumSerializer;

  const SetMemberRoleDtoRoleEnum._(String name): super(name);

  static BuiltSet<SetMemberRoleDtoRoleEnum> get values => _$setMemberRoleDtoRoleEnumValues;
  static SetMemberRoleDtoRoleEnum valueOf(String name) => _$setMemberRoleDtoRoleEnumValueOf(name);
}

