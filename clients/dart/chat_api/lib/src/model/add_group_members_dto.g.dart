// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_group_members_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AddGroupMembersDto extends AddGroupMembersDto {
  @override
  final BuiltSet<String> userIds;

  factory _$AddGroupMembersDto(
          [void Function(AddGroupMembersDtoBuilder)? updates]) =>
      (AddGroupMembersDtoBuilder()..update(updates))._build();

  _$AddGroupMembersDto._({required this.userIds}) : super._();
  @override
  AddGroupMembersDto rebuild(
          void Function(AddGroupMembersDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddGroupMembersDtoBuilder toBuilder() =>
      AddGroupMembersDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddGroupMembersDto && userIds == other.userIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddGroupMembersDto')
          ..add('userIds', userIds))
        .toString();
  }
}

class AddGroupMembersDtoBuilder
    implements Builder<AddGroupMembersDto, AddGroupMembersDtoBuilder> {
  _$AddGroupMembersDto? _$v;

  SetBuilder<String>? _userIds;
  SetBuilder<String> get userIds => _$this._userIds ??= SetBuilder<String>();
  set userIds(SetBuilder<String>? userIds) => _$this._userIds = userIds;

  AddGroupMembersDtoBuilder() {
    AddGroupMembersDto._defaults(this);
  }

  AddGroupMembersDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userIds = $v.userIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddGroupMembersDto other) {
    _$v = other as _$AddGroupMembersDto;
  }

  @override
  void update(void Function(AddGroupMembersDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddGroupMembersDto build() => _build();

  _$AddGroupMembersDto _build() {
    _$AddGroupMembersDto _$result;
    try {
      _$result = _$v ??
          _$AddGroupMembersDto._(
            userIds: userIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'userIds';
        userIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AddGroupMembersDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
