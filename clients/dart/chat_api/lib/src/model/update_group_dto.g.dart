// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateGroupDto extends UpdateGroupDto {
  @override
  final String? name;
  @override
  final bool? muteAll;

  factory _$UpdateGroupDto([void Function(UpdateGroupDtoBuilder)? updates]) =>
      (UpdateGroupDtoBuilder()..update(updates))._build();

  _$UpdateGroupDto._({this.name, this.muteAll}) : super._();
  @override
  UpdateGroupDto rebuild(void Function(UpdateGroupDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateGroupDtoBuilder toBuilder() => UpdateGroupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateGroupDto &&
        name == other.name &&
        muteAll == other.muteAll;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, muteAll.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateGroupDto')
          ..add('name', name)
          ..add('muteAll', muteAll))
        .toString();
  }
}

class UpdateGroupDtoBuilder
    implements Builder<UpdateGroupDto, UpdateGroupDtoBuilder> {
  _$UpdateGroupDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _muteAll;
  bool? get muteAll => _$this._muteAll;
  set muteAll(bool? muteAll) => _$this._muteAll = muteAll;

  UpdateGroupDtoBuilder() {
    UpdateGroupDto._defaults(this);
  }

  UpdateGroupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _muteAll = $v.muteAll;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateGroupDto other) {
    _$v = other as _$UpdateGroupDto;
  }

  @override
  void update(void Function(UpdateGroupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateGroupDto build() => _build();

  _$UpdateGroupDto _build() {
    final _$result = _$v ??
        _$UpdateGroupDto._(
          name: name,
          muteAll: muteAll,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
