// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_member_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MuteMemberDto extends MuteMemberDto {
  @override
  final bool muted;
  @override
  final num? durationMinutes;

  factory _$MuteMemberDto([void Function(MuteMemberDtoBuilder)? updates]) =>
      (MuteMemberDtoBuilder()..update(updates))._build();

  _$MuteMemberDto._({required this.muted, this.durationMinutes}) : super._();
  @override
  MuteMemberDto rebuild(void Function(MuteMemberDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MuteMemberDtoBuilder toBuilder() => MuteMemberDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MuteMemberDto &&
        muted == other.muted &&
        durationMinutes == other.durationMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, durationMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MuteMemberDto')
          ..add('muted', muted)
          ..add('durationMinutes', durationMinutes))
        .toString();
  }
}

class MuteMemberDtoBuilder
    implements Builder<MuteMemberDto, MuteMemberDtoBuilder> {
  _$MuteMemberDto? _$v;

  bool? _muted;
  bool? get muted => _$this._muted;
  set muted(bool? muted) => _$this._muted = muted;

  num? _durationMinutes;
  num? get durationMinutes => _$this._durationMinutes;
  set durationMinutes(num? durationMinutes) =>
      _$this._durationMinutes = durationMinutes;

  MuteMemberDtoBuilder() {
    MuteMemberDto._defaults(this);
  }

  MuteMemberDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _muted = $v.muted;
      _durationMinutes = $v.durationMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MuteMemberDto other) {
    _$v = other as _$MuteMemberDto;
  }

  @override
  void update(void Function(MuteMemberDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MuteMemberDto build() => _build();

  _$MuteMemberDto _build() {
    final _$result = _$v ??
        _$MuteMemberDto._(
          muted: BuiltValueNullFieldError.checkNotNull(
              muted, r'MuteMemberDto', 'muted'),
          durationMinutes: durationMinutes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
