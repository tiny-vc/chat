// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_kit_token_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LiveKitTokenResponse extends LiveKitTokenResponse {
  @override
  final String url;
  @override
  final String token;

  factory _$LiveKitTokenResponse(
          [void Function(LiveKitTokenResponseBuilder)? updates]) =>
      (LiveKitTokenResponseBuilder()..update(updates))._build();

  _$LiveKitTokenResponse._({required this.url, required this.token})
      : super._();
  @override
  LiveKitTokenResponse rebuild(
          void Function(LiveKitTokenResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LiveKitTokenResponseBuilder toBuilder() =>
      LiveKitTokenResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LiveKitTokenResponse &&
        url == other.url &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LiveKitTokenResponse')
          ..add('url', url)
          ..add('token', token))
        .toString();
  }
}

class LiveKitTokenResponseBuilder
    implements Builder<LiveKitTokenResponse, LiveKitTokenResponseBuilder> {
  _$LiveKitTokenResponse? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  LiveKitTokenResponseBuilder() {
    LiveKitTokenResponse._defaults(this);
  }

  LiveKitTokenResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LiveKitTokenResponse other) {
    _$v = other as _$LiveKitTokenResponse;
  }

  @override
  void update(void Function(LiveKitTokenResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LiveKitTokenResponse build() => _build();

  _$LiveKitTokenResponse _build() {
    final _$result = _$v ??
        _$LiveKitTokenResponse._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'LiveKitTokenResponse', 'url'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'LiveKitTokenResponse', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
