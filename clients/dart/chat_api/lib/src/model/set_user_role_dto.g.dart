// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_user_role_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SetUserRoleDtoRoleEnum _$setUserRoleDtoRoleEnum_USER =
    const SetUserRoleDtoRoleEnum._('USER');
const SetUserRoleDtoRoleEnum _$setUserRoleDtoRoleEnum_ADMIN =
    const SetUserRoleDtoRoleEnum._('ADMIN');
const SetUserRoleDtoRoleEnum _$setUserRoleDtoRoleEnum_unknownDefaultOpenApi =
    const SetUserRoleDtoRoleEnum._('unknownDefaultOpenApi');

SetUserRoleDtoRoleEnum _$setUserRoleDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'USER':
      return _$setUserRoleDtoRoleEnum_USER;
    case 'ADMIN':
      return _$setUserRoleDtoRoleEnum_ADMIN;
    case 'unknownDefaultOpenApi':
      return _$setUserRoleDtoRoleEnum_unknownDefaultOpenApi;
    default:
      return _$setUserRoleDtoRoleEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<SetUserRoleDtoRoleEnum> _$setUserRoleDtoRoleEnumValues =
    BuiltSet<SetUserRoleDtoRoleEnum>(const <SetUserRoleDtoRoleEnum>[
  _$setUserRoleDtoRoleEnum_USER,
  _$setUserRoleDtoRoleEnum_ADMIN,
  _$setUserRoleDtoRoleEnum_unknownDefaultOpenApi,
]);

Serializer<SetUserRoleDtoRoleEnum> _$setUserRoleDtoRoleEnumSerializer =
    _$SetUserRoleDtoRoleEnumSerializer();

class _$SetUserRoleDtoRoleEnumSerializer
    implements PrimitiveSerializer<SetUserRoleDtoRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[SetUserRoleDtoRoleEnum];
  @override
  final String wireName = 'SetUserRoleDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, SetUserRoleDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SetUserRoleDtoRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SetUserRoleDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SetUserRoleDto extends SetUserRoleDto {
  @override
  final SetUserRoleDtoRoleEnum role;

  factory _$SetUserRoleDto([void Function(SetUserRoleDtoBuilder)? updates]) =>
      (SetUserRoleDtoBuilder()..update(updates))._build();

  _$SetUserRoleDto._({required this.role}) : super._();
  @override
  SetUserRoleDto rebuild(void Function(SetUserRoleDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetUserRoleDtoBuilder toBuilder() => SetUserRoleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetUserRoleDto && role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetUserRoleDto')..add('role', role))
        .toString();
  }
}

class SetUserRoleDtoBuilder
    implements Builder<SetUserRoleDto, SetUserRoleDtoBuilder> {
  _$SetUserRoleDto? _$v;

  SetUserRoleDtoRoleEnum? _role;
  SetUserRoleDtoRoleEnum? get role => _$this._role;
  set role(SetUserRoleDtoRoleEnum? role) => _$this._role = role;

  SetUserRoleDtoBuilder() {
    SetUserRoleDto._defaults(this);
  }

  SetUserRoleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetUserRoleDto other) {
    _$v = other as _$SetUserRoleDto;
  }

  @override
  void update(void Function(SetUserRoleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetUserRoleDto build() => _build();

  _$SetUserRoleDto _build() {
    final _$result = _$v ??
        _$SetUserRoleDto._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'SetUserRoleDto', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
