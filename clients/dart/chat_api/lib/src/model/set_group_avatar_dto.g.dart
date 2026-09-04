// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group_avatar_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetGroupAvatarDto extends SetGroupAvatarDto {
  @override
  final String fileId;

  factory _$SetGroupAvatarDto(
          [void Function(SetGroupAvatarDtoBuilder)? updates]) =>
      (SetGroupAvatarDtoBuilder()..update(updates))._build();

  _$SetGroupAvatarDto._({required this.fileId}) : super._();
  @override
  SetGroupAvatarDto rebuild(void Function(SetGroupAvatarDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetGroupAvatarDtoBuilder toBuilder() =>
      SetGroupAvatarDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetGroupAvatarDto && fileId == other.fileId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetGroupAvatarDto')
          ..add('fileId', fileId))
        .toString();
  }
}

class SetGroupAvatarDtoBuilder
    implements Builder<SetGroupAvatarDto, SetGroupAvatarDtoBuilder> {
  _$SetGroupAvatarDto? _$v;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  SetGroupAvatarDtoBuilder() {
    SetGroupAvatarDto._defaults(this);
  }

  SetGroupAvatarDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileId = $v.fileId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetGroupAvatarDto other) {
    _$v = other as _$SetGroupAvatarDto;
  }

  @override
  void update(void Function(SetGroupAvatarDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetGroupAvatarDto build() => _build();

  _$SetGroupAvatarDto _build() {
    final _$result = _$v ??
        _$SetGroupAvatarDto._(
          fileId: BuiltValueNullFieldError.checkNotNull(
              fileId, r'SetGroupAvatarDto', 'fileId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
