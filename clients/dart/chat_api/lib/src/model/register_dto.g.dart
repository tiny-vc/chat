// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterDtoDeviceTypeEnum _$registerDtoDeviceTypeEnum_APP =
    const RegisterDtoDeviceTypeEnum._('APP');
const RegisterDtoDeviceTypeEnum _$registerDtoDeviceTypeEnum_WEB =
    const RegisterDtoDeviceTypeEnum._('WEB');
const RegisterDtoDeviceTypeEnum _$registerDtoDeviceTypeEnum_DESKTOP =
    const RegisterDtoDeviceTypeEnum._('DESKTOP');
const RegisterDtoDeviceTypeEnum
    _$registerDtoDeviceTypeEnum_unknownDefaultOpenApi =
    const RegisterDtoDeviceTypeEnum._('unknownDefaultOpenApi');

RegisterDtoDeviceTypeEnum _$registerDtoDeviceTypeEnumValueOf(String name) {
  switch (name) {
    case 'APP':
      return _$registerDtoDeviceTypeEnum_APP;
    case 'WEB':
      return _$registerDtoDeviceTypeEnum_WEB;
    case 'DESKTOP':
      return _$registerDtoDeviceTypeEnum_DESKTOP;
    case 'unknownDefaultOpenApi':
      return _$registerDtoDeviceTypeEnum_unknownDefaultOpenApi;
    default:
      return _$registerDtoDeviceTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<RegisterDtoDeviceTypeEnum> _$registerDtoDeviceTypeEnumValues =
    BuiltSet<RegisterDtoDeviceTypeEnum>(const <RegisterDtoDeviceTypeEnum>[
  _$registerDtoDeviceTypeEnum_APP,
  _$registerDtoDeviceTypeEnum_WEB,
  _$registerDtoDeviceTypeEnum_DESKTOP,
  _$registerDtoDeviceTypeEnum_unknownDefaultOpenApi,
]);

Serializer<RegisterDtoDeviceTypeEnum> _$registerDtoDeviceTypeEnumSerializer =
    _$RegisterDtoDeviceTypeEnumSerializer();

class _$RegisterDtoDeviceTypeEnumSerializer
    implements PrimitiveSerializer<RegisterDtoDeviceTypeEnum> {
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
  final Iterable<Type> types = const <Type>[RegisterDtoDeviceTypeEnum];
  @override
  final String wireName = 'RegisterDtoDeviceTypeEnum';

  @override
  Object serialize(Serializers serializers, RegisterDtoDeviceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterDtoDeviceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterDtoDeviceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterDto extends RegisterDto {
  @override
  final String username;
  @override
  final String password;
  @override
  final String nickname;
  @override
  final String? deviceId;
  @override
  final RegisterDtoDeviceTypeEnum? deviceType;
  @override
  final String? deviceName;

  factory _$RegisterDto([void Function(RegisterDtoBuilder)? updates]) =>
      (RegisterDtoBuilder()..update(updates))._build();

  _$RegisterDto._(
      {required this.username,
      required this.password,
      required this.nickname,
      this.deviceId,
      this.deviceType,
      this.deviceName})
      : super._();
  @override
  RegisterDto rebuild(void Function(RegisterDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterDtoBuilder toBuilder() => RegisterDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterDto &&
        username == other.username &&
        password == other.password &&
        nickname == other.nickname &&
        deviceId == other.deviceId &&
        deviceType == other.deviceType &&
        deviceName == other.deviceName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, deviceType.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterDto')
          ..add('username', username)
          ..add('password', password)
          ..add('nickname', nickname)
          ..add('deviceId', deviceId)
          ..add('deviceType', deviceType)
          ..add('deviceName', deviceName))
        .toString();
  }
}

class RegisterDtoBuilder implements Builder<RegisterDto, RegisterDtoBuilder> {
  _$RegisterDto? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  RegisterDtoDeviceTypeEnum? _deviceType;
  RegisterDtoDeviceTypeEnum? get deviceType => _$this._deviceType;
  set deviceType(RegisterDtoDeviceTypeEnum? deviceType) =>
      _$this._deviceType = deviceType;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  RegisterDtoBuilder() {
    RegisterDto._defaults(this);
  }

  RegisterDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _password = $v.password;
      _nickname = $v.nickname;
      _deviceId = $v.deviceId;
      _deviceType = $v.deviceType;
      _deviceName = $v.deviceName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterDto other) {
    _$v = other as _$RegisterDto;
  }

  @override
  void update(void Function(RegisterDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterDto build() => _build();

  _$RegisterDto _build() {
    final _$result = _$v ??
        _$RegisterDto._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'RegisterDto', 'username'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'RegisterDto', 'password'),
          nickname: BuiltValueNullFieldError.checkNotNull(
              nickname, r'RegisterDto', 'nickname'),
          deviceId: deviceId,
          deviceType: deviceType,
          deviceName: deviceName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
