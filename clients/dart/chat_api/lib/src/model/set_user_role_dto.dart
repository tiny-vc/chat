//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_user_role_dto.g.dart';

/// SetUserRoleDto
///
/// Properties:
/// * [role] 
@BuiltValue()
abstract class SetUserRoleDto implements Built<SetUserRoleDto, SetUserRoleDtoBuilder> {
  @BuiltValueField(wireName: r'role')
  SetUserRoleDtoRoleEnum get role;
  // enum roleEnum {  USER,  ADMIN,  };

  SetUserRoleDto._();

  factory SetUserRoleDto([void updates(SetUserRoleDtoBuilder b)]) = _$SetUserRoleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetUserRoleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetUserRoleDto> get serializer => _$SetUserRoleDtoSerializer();
}

class _$SetUserRoleDtoSerializer implements PrimitiveSerializer<SetUserRoleDto> {
  @override
  final Iterable<Type> types = const [SetUserRoleDto, _$SetUserRoleDto];

  @override
  final String wireName = r'SetUserRoleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetUserRoleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(SetUserRoleDtoRoleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetUserRoleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetUserRoleDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SetUserRoleDtoRoleEnum),
          ) as SetUserRoleDtoRoleEnum;
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
  SetUserRoleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetUserRoleDtoBuilder();
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

class SetUserRoleDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'USER')
  static const SetUserRoleDtoRoleEnum USER = _$setUserRoleDtoRoleEnum_USER;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const SetUserRoleDtoRoleEnum ADMIN = _$setUserRoleDtoRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const SetUserRoleDtoRoleEnum unknownDefaultOpenApi = _$setUserRoleDtoRoleEnum_unknownDefaultOpenApi;

  static Serializer<SetUserRoleDtoRoleEnum> get serializer => _$setUserRoleDtoRoleEnumSerializer;

  const SetUserRoleDtoRoleEnum._(String name): super(name);

  static BuiltSet<SetUserRoleDtoRoleEnum> get values => _$setUserRoleDtoRoleEnumValues;
  static SetUserRoleDtoRoleEnum valueOf(String name) => _$setUserRoleDtoRoleEnumValueOf(name);
}

