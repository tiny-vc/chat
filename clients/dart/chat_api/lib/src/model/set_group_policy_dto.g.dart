// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group_policy_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetGroupPolicyDto extends SetGroupPolicyDto {
  @override
  final bool? suspended;
  @override
  final bool? muteAll;

  factory _$SetGroupPolicyDto(
          [void Function(SetGroupPolicyDtoBuilder)? updates]) =>
      (SetGroupPolicyDtoBuilder()..update(updates))._build();

  _$SetGroupPolicyDto._({this.suspended, this.muteAll}) : super._();
  @override
  SetGroupPolicyDto rebuild(void Function(SetGroupPolicyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetGroupPolicyDtoBuilder toBuilder() =>
      SetGroupPolicyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetGroupPolicyDto &&
        suspended == other.suspended &&
        muteAll == other.muteAll;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, suspended.hashCode);
    _$hash = $jc(_$hash, muteAll.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetGroupPolicyDto')
          ..add('suspended', suspended)
          ..add('muteAll', muteAll))
        .toString();
  }
}

class SetGroupPolicyDtoBuilder
    implements Builder<SetGroupPolicyDto, SetGroupPolicyDtoBuilder> {
  _$SetGroupPolicyDto? _$v;

  bool? _suspended;
  bool? get suspended => _$this._suspended;
  set suspended(bool? suspended) => _$this._suspended = suspended;

  bool? _muteAll;
  bool? get muteAll => _$this._muteAll;
  set muteAll(bool? muteAll) => _$this._muteAll = muteAll;

  SetGroupPolicyDtoBuilder() {
    SetGroupPolicyDto._defaults(this);
  }

  SetGroupPolicyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _suspended = $v.suspended;
      _muteAll = $v.muteAll;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetGroupPolicyDto other) {
    _$v = other as _$SetGroupPolicyDto;
  }

  @override
  void update(void Function(SetGroupPolicyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetGroupPolicyDto build() => _build();

  _$SetGroupPolicyDto _build() {
    final _$result = _$v ??
        _$SetGroupPolicyDto._(
          suspended: suspended,
          muteAll: muteAll,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
