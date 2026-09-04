// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoginDtoDeviceTypeEnum _$loginDtoDeviceTypeEnum_APP =
    const LoginDtoDeviceTypeEnum._('APP');
const LoginDtoDeviceTypeEnum _$loginDtoDeviceTypeEnum_WEB =
    const LoginDtoDeviceTypeEnum._('WEB');
const LoginDtoDeviceTypeEnum _$loginDtoDeviceTypeEnum_DESKTOP =
    const LoginDtoDeviceTypeEnum._('DESKTOP');
const LoginDtoDeviceTypeEnum _$loginDtoDeviceTypeEnum_unknownDefaultOpenApi =
    const LoginDtoDeviceTypeEnum._('unknownDefaultOpenApi');

LoginDtoDeviceTypeEnum _$loginDtoDeviceTypeEnumValueOf(String name) {
  switch (name) {
    case 'APP':
      return _$loginDtoDeviceTypeEnum_APP;
    case 'WEB':
      return _$loginDtoDeviceTypeEnum_WEB;
    case 'DESKTOP':
      return _$loginDtoDeviceTypeEnum_DESKTOP;
    case 'unknownDefaultOpenApi':
      return _$loginDtoDeviceTypeEnum_unknownDefaultOpenApi;
    default:
      return _$loginDtoDeviceTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<LoginDtoDeviceTypeEnum> _$loginDtoDeviceTypeEnumValues =
    BuiltSet<LoginDtoDeviceTypeEnum>(const <LoginDtoDeviceTypeEnum>[
  _$loginDtoDeviceTypeEnum_APP,
  _$loginDtoDeviceTypeEnum_WEB,
  _$loginDtoDeviceTypeEnum_DESKTOP,
  _$loginDtoDeviceTypeEnum_unknownDefaultOpenApi,
]);

Serializer<LoginDtoDeviceTypeEnum> _$loginDtoDeviceTypeEnumSerializer =
    _$LoginDtoDeviceTypeEnumSerializer();

class _$LoginDtoDeviceTypeEnumSerializer
    implements PrimitiveSerializer<LoginDtoDeviceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APP': 'APP',
    'WEB': 'WEB',
    'DESKTOP': 'DESKTOP',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APP': 'APP',
    'WEB': 'WEB',
    'DESKTOP': 'DESKTOP',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[LoginDtoDeviceTypeEnum];
  @override
  final String wireName = 'LoginDtoDeviceTypeEnum';

  @override
  Object serialize(Serializers serializers, LoginDtoDeviceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoginDtoDeviceTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoginDtoDeviceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoginDto extends LoginDto {
  @override
  final String username;
  @override
  final String password;
  @override
  final String? deviceId;
  @override
  final LoginDtoDeviceTypeEnum? deviceType;
  @override
  final String? deviceName;

  factory _$LoginDto([void Function(LoginDtoBuilder)? updates]) =>
      (LoginDtoBuilder()..update(updates))._build();

  _$LoginDto._(
      {required this.username,
      required this.password,
      this.deviceId,
      this.deviceType,
      this.deviceName})
      : super._();
  @override
  LoginDto rebuild(void Function(LoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginDtoBuilder toBuilder() => LoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginDto &&
        username == other.username &&
        password == other.password &&
        deviceId == other.deviceId &&
        deviceType == other.deviceType &&
        deviceName == other.deviceName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, deviceType.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginDto')
          ..add('username', username)
          ..add('password', password)
          ..add('deviceId', deviceId)
          ..add('deviceType', deviceType)
          ..add('deviceName', deviceName))
        .toString();
  }
}

class LoginDtoBuilder implements Builder<LoginDto, LoginDtoBuilder> {
  _$LoginDto? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  LoginDtoDeviceTypeEnum? _deviceType;
  LoginDtoDeviceTypeEnum? get deviceType => _$this._deviceType;
  set deviceType(LoginDtoDeviceTypeEnum? deviceType) =>
      _$this._deviceType = deviceType;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  LoginDtoBuilder() {
    LoginDto._defaults(this);
  }

  LoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _password = $v.password;
      _deviceId = $v.deviceId;
      _deviceType = $v.deviceType;
      _deviceName = $v.deviceName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginDto other) {
    _$v = other as _$LoginDto;
  }

  @override
  void update(void Function(LoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginDto build() => _build();

  _$LoginDto _build() {
    final _$result = _$v ??
        _$LoginDto._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'LoginDto', 'username'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'LoginDto', 'password'),
          deviceId: deviceId,
          deviceType: deviceType,
          deviceName: deviceName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
