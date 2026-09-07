// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_capabilities_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RuntimeCapabilitiesDto extends RuntimeCapabilitiesDto {
  @override
  final bool messaging;
  @override
  final bool files;
  @override
  final bool groups;
  @override
  final bool audioCalls;
  @override
  final bool videoCalls;

  factory _$RuntimeCapabilitiesDto(
          [void Function(RuntimeCapabilitiesDtoBuilder)? updates]) =>
      (RuntimeCapabilitiesDtoBuilder()..update(updates))._build();

  _$RuntimeCapabilitiesDto._(
      {required this.messaging,
      required this.files,
      required this.groups,
      required this.audioCalls,
      required this.videoCalls})
      : super._();
  @override
  RuntimeCapabilitiesDto rebuild(
          void Function(RuntimeCapabilitiesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RuntimeCapabilitiesDtoBuilder toBuilder() =>
      RuntimeCapabilitiesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RuntimeCapabilitiesDto &&
        messaging == other.messaging &&
        files == other.files &&
        groups == other.groups &&
        audioCalls == other.audioCalls &&
        videoCalls == other.videoCalls;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messaging.hashCode);
    _$hash = $jc(_$hash, files.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, audioCalls.hashCode);
    _$hash = $jc(_$hash, videoCalls.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RuntimeCapabilitiesDto')
          ..add('messaging', messaging)
          ..add('files', files)
          ..add('groups', groups)
          ..add('audioCalls', audioCalls)
          ..add('videoCalls', videoCalls))
        .toString();
  }
}

class RuntimeCapabilitiesDtoBuilder
    implements Builder<RuntimeCapabilitiesDto, RuntimeCapabilitiesDtoBuilder> {
  _$RuntimeCapabilitiesDto? _$v;

  bool? _messaging;
  bool? get messaging => _$this._messaging;
  set messaging(bool? messaging) => _$this._messaging = messaging;

  bool? _files;
  bool? get files => _$this._files;
  set files(bool? files) => _$this._files = files;

  bool? _groups;
  bool? get groups => _$this._groups;
  set groups(bool? groups) => _$this._groups = groups;

  bool? _audioCalls;
  bool? get audioCalls => _$this._audioCalls;
  set audioCalls(bool? audioCalls) => _$this._audioCalls = audioCalls;

  bool? _videoCalls;
  bool? get videoCalls => _$this._videoCalls;
  set videoCalls(bool? videoCalls) => _$this._videoCalls = videoCalls;

  RuntimeCapabilitiesDtoBuilder() {
    RuntimeCapabilitiesDto._defaults(this);
  }

  RuntimeCapabilitiesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messaging = $v.messaging;
      _files = $v.files;
      _groups = $v.groups;
      _audioCalls = $v.audioCalls;
      _videoCalls = $v.videoCalls;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RuntimeCapabilitiesDto other) {
    _$v = other as _$RuntimeCapabilitiesDto;
  }

  @override
  void update(void Function(RuntimeCapabilitiesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RuntimeCapabilitiesDto build() => _build();

  _$RuntimeCapabilitiesDto _build() {
    final _$result = _$v ??
        _$RuntimeCapabilitiesDto._(
          messaging: BuiltValueNullFieldError.checkNotNull(
              messaging, r'RuntimeCapabilitiesDto', 'messaging'),
          files: BuiltValueNullFieldError.checkNotNull(
              files, r'RuntimeCapabilitiesDto', 'files'),
          groups: BuiltValueNullFieldError.checkNotNull(
              groups, r'RuntimeCapabilitiesDto', 'groups'),
          audioCalls: BuiltValueNullFieldError.checkNotNull(
              audioCalls, r'RuntimeCapabilitiesDto', 'audioCalls'),
          videoCalls: BuiltValueNullFieldError.checkNotNull(
              videoCalls, r'RuntimeCapabilitiesDto', 'videoCalls'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
