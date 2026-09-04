//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_dto.g.dart';

/// LoginDto
///
/// Properties:
/// * [username] 
/// * [password] 
/// * [deviceId] 
/// * [deviceType] 
/// * [deviceName] 
@BuiltValue()
abstract class LoginDto implements Built<LoginDto, LoginDtoBuilder> {
  @BuiltValueField(wireName: r'username')
  String get username;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'deviceId')
  String? get deviceId;

  @BuiltValueField(wireName: r'deviceType')
  LoginDtoDeviceTypeEnum? get deviceType;
  // enum deviceTypeEnum {  APP,  WEB,  DESKTOP,  };

  @BuiltValueField(wireName: r'deviceName')
  String? get deviceName;

  LoginDto._();

  factory LoginDto([void updates(LoginDtoBuilder b)]) = _$LoginDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginDto> get serializer => _$LoginDtoSerializer();
}

class _$LoginDtoSerializer implements PrimitiveSerializer<LoginDto> {
  @override
  final Iterable<Type> types = const [LoginDto, _$LoginDto];

  @override
  final String wireName = r'LoginDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'username';
    yield serializers.serialize(
      object.username,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    if (object.deviceId != null) {
      yield r'deviceId';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType(String),
      );
    }
    if (object.deviceType != null) {
      yield r'deviceType';
      yield serializers.serialize(
        object.deviceType,
        specifiedType: const FullType(LoginDtoDeviceTypeEnum),
      );
    }
    if (object.deviceName != null) {
      yield r'deviceName';
      yield serializers.serialize(
        object.deviceName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'username':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.username = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        case r'deviceType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(LoginDtoDeviceTypeEnum),
          ) as LoginDtoDeviceTypeEnum?;
          if (valueDes == null) continue;
          result.deviceType = valueDes;
          break;
        case r'deviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoginDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginDtoBuilder();
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

class LoginDtoDeviceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APP')
  static const LoginDtoDeviceTypeEnum APP = _$loginDtoDeviceTypeEnum_APP;
  @BuiltValueEnumConst(wireName: r'WEB')
  static const LoginDtoDeviceTypeEnum WEB = _$loginDtoDeviceTypeEnum_WEB;
  @BuiltValueEnumConst(wireName: r'DESKTOP')
  static const LoginDtoDeviceTypeEnum DESKTOP = _$loginDtoDeviceTypeEnum_DESKTOP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const LoginDtoDeviceTypeEnum unknownDefaultOpenApi = _$loginDtoDeviceTypeEnum_unknownDefaultOpenApi;

  static Serializer<LoginDtoDeviceTypeEnum> get serializer => _$loginDtoDeviceTypeEnumSerializer;

  const LoginDtoDeviceTypeEnum._(String name): super(name);

  static BuiltSet<LoginDtoDeviceTypeEnum> get values => _$loginDtoDeviceTypeEnumValues;
  static LoginDtoDeviceTypeEnum valueOf(String name) => _$loginDtoDeviceTypeEnumValueOf(name);
}

