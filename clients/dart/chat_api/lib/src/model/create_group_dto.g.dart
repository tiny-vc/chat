// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_group_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateGroupDto extends CreateGroupDto {
  @override
  final String name;
  @override
  final BuiltSet<String> memberIds;

  factory _$CreateGroupDto([void Function(CreateGroupDtoBuilder)? updates]) =>
      (CreateGroupDtoBuilder()..update(updates))._build();

  _$CreateGroupDto._({required this.name, required this.memberIds}) : super._();
  @override
  CreateGroupDto rebuild(void Function(CreateGroupDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateGroupDtoBuilder toBuilder() => CreateGroupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateGroupDto &&
        name == other.name &&
        memberIds == other.memberIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, memberIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateGroupDto')
          ..add('name', name)
          ..add('memberIds', memberIds))
        .toString();
  }
}

class CreateGroupDtoBuilder
    implements Builder<CreateGroupDto, CreateGroupDtoBuilder> {
  _$CreateGroupDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SetBuilder<String>? _memberIds;
  SetBuilder<String> get memberIds =>
      _$this._memberIds ??= SetBuilder<String>();
  set memberIds(SetBuilder<String>? memberIds) => _$this._memberIds = memberIds;

  CreateGroupDtoBuilder() {
    CreateGroupDto._defaults(this);
  }

  CreateGroupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _memberIds = $v.memberIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateGroupDto other) {
    _$v = other as _$CreateGroupDto;
  }

  @override
  void update(void Function(CreateGroupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateGroupDto build() => _build();

  _$CreateGroupDto _build() {
    _$CreateGroupDto _$result;
    try {
      _$result = _$v ??
          _$CreateGroupDto._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateGroupDto', 'name'),
            memberIds: memberIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'memberIds';
        memberIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateGroupDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
