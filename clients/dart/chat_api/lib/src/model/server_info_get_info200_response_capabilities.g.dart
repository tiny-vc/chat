// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_info_get_info200_response_capabilities.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ServerInfoGetInfo200ResponseCapabilities
    extends ServerInfoGetInfo200ResponseCapabilities {
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

  factory _$ServerInfoGetInfo200ResponseCapabilities(
          [void Function(ServerInfoGetInfo200ResponseCapabilitiesBuilder)?
              updates]) =>
      (ServerInfoGetInfo200ResponseCapabilitiesBuilder()..update(updates))
          ._build();

  _$ServerInfoGetInfo200ResponseCapabilities._(
      {required this.messaging,
      required this.files,
      required this.groups,
      required this.audioCalls,
      required this.videoCalls})
      : super._();
  @override
  ServerInfoGetInfo200ResponseCapabilities rebuild(
          void Function(ServerInfoGetInfo200ResponseCapabilitiesBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ServerInfoGetInfo200ResponseCapabilitiesBuilder toBuilder() =>
      ServerInfoGetInfo200ResponseCapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServerInfoGetInfo200ResponseCapabilities &&
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
    return (newBuiltValueToStringHelper(
            r'ServerInfoGetInfo200ResponseCapabilities')
          ..add('messaging', messaging)
          ..add('files', files)
          ..add('groups', groups)
          ..add('audioCalls', audioCalls)
          ..add('videoCalls', videoCalls))
        .toString();
  }
}

class ServerInfoGetInfo200ResponseCapabilitiesBuilder
    implements
        Builder<ServerInfoGetInfo200ResponseCapabilities,
            ServerInfoGetInfo200ResponseCapabilitiesBuilder> {
  _$ServerInfoGetInfo200ResponseCapabilities? _$v;

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

  ServerInfoGetInfo200ResponseCapabilitiesBuilder() {
    ServerInfoGetInfo200ResponseCapabilities._defaults(this);
  }

  ServerInfoGetInfo200ResponseCapabilitiesBuilder get _$this {
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
  void replace(ServerInfoGetInfo200ResponseCapabilities other) {
    _$v = other as _$ServerInfoGetInfo200ResponseCapabilities;
  }

  @override
  void update(
      void Function(ServerInfoGetInfo200ResponseCapabilitiesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ServerInfoGetInfo200ResponseCapabilities build() => _build();

  _$ServerInfoGetInfo200ResponseCapabilities _build() {
    final _$result = _$v ??
        _$ServerInfoGetInfo200ResponseCapabilities._(
          messaging: BuiltValueNullFieldError.checkNotNull(messaging,
              r'ServerInfoGetInfo200ResponseCapabilities', 'messaging'),
          files: BuiltValueNullFieldError.checkNotNull(
              files, r'ServerInfoGetInfo200ResponseCapabilities', 'files'),
          groups: BuiltValueNullFieldError.checkNotNull(
              groups, r'ServerInfoGetInfo200ResponseCapabilities', 'groups'),
          audioCalls: BuiltValueNullFieldError.checkNotNull(audioCalls,
              r'ServerInfoGetInfo200ResponseCapabilities', 'audioCalls'),
          videoCalls: BuiltValueNullFieldError.checkNotNull(videoCalls,
              r'ServerInfoGetInfo200ResponseCapabilities', 'videoCalls'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
