// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_group_nickname_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateGroupNicknameDto extends UpdateGroupNicknameDto {
  @override
  final String nickname;

  factory _$UpdateGroupNicknameDto(
          [void Function(UpdateGroupNicknameDtoBuilder)? updates]) =>
      (UpdateGroupNicknameDtoBuilder()..update(updates))._build();

  _$UpdateGroupNicknameDto._({required this.nickname}) : super._();
  @override
  UpdateGroupNicknameDto rebuild(
          void Function(UpdateGroupNicknameDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateGroupNicknameDtoBuilder toBuilder() =>
      UpdateGroupNicknameDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateGroupNicknameDto && nickname == other.nickname;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateGroupNicknameDto')
          ..add('nickname', nickname))
        .toString();
  }
}

class UpdateGroupNicknameDtoBuilder
    implements Builder<UpdateGroupNicknameDto, UpdateGroupNicknameDtoBuilder> {
  _$UpdateGroupNicknameDto? _$v;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  UpdateGroupNicknameDtoBuilder() {
    UpdateGroupNicknameDto._defaults(this);
  }

  UpdateGroupNicknameDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nickname = $v.nickname;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateGroupNicknameDto other) {
    _$v = other as _$UpdateGroupNicknameDto;
  }

  @override
  void update(void Function(UpdateGroupNicknameDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateGroupNicknameDto build() => _build();

  _$UpdateGroupNicknameDto _build() {
    final _$result = _$v ??
        _$UpdateGroupNicknameDto._(
          nickname: BuiltValueNullFieldError.checkNotNull(
              nickname, r'UpdateGroupNicknameDto', 'nickname'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
