// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_thumbnail_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SetThumbnailDto extends SetThumbnailDto {
  @override
  final String thumbnailFileId;

  factory _$SetThumbnailDto([void Function(SetThumbnailDtoBuilder)? updates]) =>
      (SetThumbnailDtoBuilder()..update(updates))._build();

  _$SetThumbnailDto._({required this.thumbnailFileId}) : super._();
  @override
  SetThumbnailDto rebuild(void Function(SetThumbnailDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SetThumbnailDtoBuilder toBuilder() => SetThumbnailDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SetThumbnailDto && thumbnailFileId == other.thumbnailFileId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, thumbnailFileId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SetThumbnailDto')
          ..add('thumbnailFileId', thumbnailFileId))
        .toString();
  }
}

class SetThumbnailDtoBuilder
    implements Builder<SetThumbnailDto, SetThumbnailDtoBuilder> {
  _$SetThumbnailDto? _$v;

  String? _thumbnailFileId;
  String? get thumbnailFileId => _$this._thumbnailFileId;
  set thumbnailFileId(String? thumbnailFileId) =>
      _$this._thumbnailFileId = thumbnailFileId;

  SetThumbnailDtoBuilder() {
    SetThumbnailDto._defaults(this);
  }

  SetThumbnailDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _thumbnailFileId = $v.thumbnailFileId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SetThumbnailDto other) {
    _$v = other as _$SetThumbnailDto;
  }

  @override
  void update(void Function(SetThumbnailDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SetThumbnailDto build() => _build();

  _$SetThumbnailDto _build() {
    final _$result = _$v ??
        _$SetThumbnailDto._(
          thumbnailFileId: BuiltValueNullFieldError.checkNotNull(
              thumbnailFileId, r'SetThumbnailDto', 'thumbnailFileId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
