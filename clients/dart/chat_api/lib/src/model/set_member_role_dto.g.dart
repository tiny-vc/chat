// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_member_role_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SetMemberRoleDtoRoleEnum _$setMemberRoleDtoRoleEnum_ADMIN =
    const SetMemberRoleDtoRoleEnum._('ADMIN');
const SetMemberRoleDtoRoleEnum _$setMemberRoleDtoRoleEnum_MEMBER =
    const SetMemberRoleDtoRoleEnum._('MEMBER');
const SetMemberRoleDtoRoleEnum
    _$setMemberRoleDtoRoleEnum_unknownDefaultOpenApi =
    const SetMemberRoleDtoRoleEnum._('unknownDefaultOpenApi');

SetMemberRoleDtoRoleEnum _$setMemberRoleDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$setMemberRoleDtoRoleEnum_ADMIN;
    case 'MEMBER':
      return _$setMemberRoleDtoRoleEnum_MEMBER;
    case 'unknownDefaultOpenApi':
      return _$setMemberRoleDtoRoleEnum_unknownDefaultOpenApi;
    default:
      return _$setMemberRoleDtoRoleEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<SetMemberRoleDtoRoleEnum> _$setMemberRoleDtoRoleEnumValues =
    BuiltSet<SetMemberRoleDtoRoleEnum>(const <SetMemberRoleDtoRoleEnum>[
  _$setMemberRoleDtoRoleEnum_ADMIN,
  _$setMemberRoleDtoRoleEnum_MEMBER,
  _$setMemberRoleDtoRoleEnum_unknownDefaultOpenApi,
]);

Serializer<SetMemberRoleDtoRoleEnum> _$setMemberRoleDtoRoleEnumSerializer =
    _$SetMemberRoleDtoRoleEnumSerializer();

class _$SetMemberRoleDtoRoleEnumSerializer
    implements PrimitiveSerializer<SetMemberRoleDtoRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'MEMBER': 'MEMBER',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'MEMBER': 'MEMBER',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[SetMemberRoleDtoRoleEnum];
  @override
  final String wireName = 'SetMemberRoleDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, SetMemberRoleDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SetMemberRoleDtoRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SetMemberRoleDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SetMemberRoleDto extends SetMemberRoleDto {
  @override
  final SetMemberRoleDtoRoleEnum role;

  factory _$SetMemberRoleDto(
          [void Function(SetMemberRoleDtoBuilder)? updates]) =>
      (SetMemberRoleDtoBuilder()..update(updates))._build();

  _$SetMemberRoleDto._({required this.role}) : super._();
  @override
  SetMemberRoleDto rebuild(void Function(SetMemberRoleDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetMemberRoleDtoBuilder toBuilder() =>
      SetMemberRoleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetMemberRoleDto && role == other.role;
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
    return (newBuiltValueToStringHelper(r'SetMemberRoleDto')..add('role', role))
        .toString();
  }
}

class SetMemberRoleDtoBuilder
    implements Builder<SetMemberRoleDto, SetMemberRoleDtoBuilder> {
  _$SetMemberRoleDto? _$v;

  SetMemberRoleDtoRoleEnum? _role;
  SetMemberRoleDtoRoleEnum? get role => _$this._role;
  set role(SetMemberRoleDtoRoleEnum? role) => _$this._role = role;

  SetMemberRoleDtoBuilder() {
    SetMemberRoleDto._defaults(this);
  }

  SetMemberRoleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetMemberRoleDto other) {
    _$v = other as _$SetMemberRoleDto;
  }

  @override
  void update(void Function(SetMemberRoleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetMemberRoleDto build() => _build();

  _$SetMemberRoleDto _build() {
    final _$result = _$v ??
        _$SetMemberRoleDto._(
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'SetMemberRoleDto', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
