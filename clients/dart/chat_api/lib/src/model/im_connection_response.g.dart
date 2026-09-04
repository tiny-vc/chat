// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_connection_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImConnectionResponse extends ImConnectionResponse {
  @override
  final String uid;
  @override
  final String token;
  @override
  final String address;

  factory _$ImConnectionResponse(
          [void Function(ImConnectionResponseBuilder)? updates]) =>
      (ImConnectionResponseBuilder()..update(updates))._build();

  _$ImConnectionResponse._(
      {required this.uid, required this.token, required this.address})
      : super._();
  @override
  ImConnectionResponse rebuild(
          void Function(ImConnectionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImConnectionResponseBuilder toBuilder() =>
      ImConnectionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImConnectionResponse &&
        uid == other.uid &&
        token == other.token &&
        address == other.address;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImConnectionResponse')
          ..add('uid', uid)
          ..add('token', token)
          ..add('address', address))
        .toString();
  }
}

class ImConnectionResponseBuilder
    implements Builder<ImConnectionResponse, ImConnectionResponseBuilder> {
  _$ImConnectionResponse? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  ImConnectionResponseBuilder() {
    ImConnectionResponse._defaults(this);
  }

  ImConnectionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _token = $v.token;
      _address = $v.address;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImConnectionResponse other) {
    _$v = other as _$ImConnectionResponse;
  }

  @override
  void update(void Function(ImConnectionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImConnectionResponse build() => _build();

  _$ImConnectionResponse _build() {
    final _$result = _$v ??
        _$ImConnectionResponse._(
          uid: BuiltValueNullFieldError.checkNotNull(
              uid, r'ImConnectionResponse', 'uid'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'ImConnectionResponse', 'token'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'ImConnectionResponse', 'address'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
