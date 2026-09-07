// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_runtime_settings_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateRuntimeSettingsDto extends UpdateRuntimeSettingsDto {
  @override
  final bool registrationEnabled;
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

  factory _$UpdateRuntimeSettingsDto(
          [void Function(UpdateRuntimeSettingsDtoBuilder)? updates]) =>
      (UpdateRuntimeSettingsDtoBuilder()..update(updates))._build();

  _$UpdateRuntimeSettingsDto._(
      {required this.registrationEnabled,
      required this.messaging,
      required this.files,
      required this.groups,
      required this.audioCalls,
      required this.videoCalls})
      : super._();
  @override
  UpdateRuntimeSettingsDto rebuild(
          void Function(UpdateRuntimeSettingsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateRuntimeSettingsDtoBuilder toBuilder() =>
      UpdateRuntimeSettingsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateRuntimeSettingsDto &&
        registrationEnabled == other.registrationEnabled &&
        messaging == other.messaging &&
        files == other.files &&
        groups == other.groups &&
        audioCalls == other.audioCalls &&
        videoCalls == other.videoCalls;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registrationEnabled.hashCode);
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
    return (newBuiltValueToStringHelper(r'UpdateRuntimeSettingsDto')
          ..add('registrationEnabled', registrationEnabled)
          ..add('messaging', messaging)
          ..add('files', files)
          ..add('groups', groups)
          ..add('audioCalls', audioCalls)
          ..add('videoCalls', videoCalls))
        .toString();
  }
}

class UpdateRuntimeSettingsDtoBuilder
    implements
        Builder<UpdateRuntimeSettingsDto, UpdateRuntimeSettingsDtoBuilder> {
  _$UpdateRuntimeSettingsDto? _$v;

  bool? _registrationEnabled;
  bool? get registrationEnabled => _$this._registrationEnabled;
  set registrationEnabled(bool? registrationEnabled) =>
      _$this._registrationEnabled = registrationEnabled;

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

  UpdateRuntimeSettingsDtoBuilder() {
    UpdateRuntimeSettingsDto._defaults(this);
  }

  UpdateRuntimeSettingsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registrationEnabled = $v.registrationEnabled;
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
  void replace(UpdateRuntimeSettingsDto other) {
    _$v = other as _$UpdateRuntimeSettingsDto;
  }

  @override
  void update(void Function(UpdateRuntimeSettingsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateRuntimeSettingsDto build() => _build();

  _$UpdateRuntimeSettingsDto _build() {
    final _$result = _$v ??
        _$UpdateRuntimeSettingsDto._(
          registrationEnabled: BuiltValueNullFieldError.checkNotNull(
              registrationEnabled,
              r'UpdateRuntimeSettingsDto',
              'registrationEnabled'),
          messaging: BuiltValueNullFieldError.checkNotNull(
              messaging, r'UpdateRuntimeSettingsDto', 'messaging'),
          files: BuiltValueNullFieldError.checkNotNull(
              files, r'UpdateRuntimeSettingsDto', 'files'),
          groups: BuiltValueNullFieldError.checkNotNull(
              groups, r'UpdateRuntimeSettingsDto', 'groups'),
          audioCalls: BuiltValueNullFieldError.checkNotNull(
              audioCalls, r'UpdateRuntimeSettingsDto', 'audioCalls'),
          videoCalls: BuiltValueNullFieldError.checkNotNull(
              videoCalls, r'UpdateRuntimeSettingsDto', 'videoCalls'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
