// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SuccessResponse extends SuccessResponse {
  @override
  final bool success;
  @override
  final int? revokedSessions;

  factory _$SuccessResponse([void Function(SuccessResponseBuilder)? updates]) =>
      (SuccessResponseBuilder()..update(updates))._build();

  _$SuccessResponse._({required this.success, this.revokedSessions})
      : super._();
  @override
  SuccessResponse rebuild(void Function(SuccessResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SuccessResponseBuilder toBuilder() => SuccessResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SuccessResponse &&
        success == other.success &&
        revokedSessions == other.revokedSessions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, revokedSessions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SuccessResponse')
          ..add('success', success)
          ..add('revokedSessions', revokedSessions))
        .toString();
  }
}

class SuccessResponseBuilder
    implements Builder<SuccessResponse, SuccessResponseBuilder> {
  _$SuccessResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  int? _revokedSessions;
  int? get revokedSessions => _$this._revokedSessions;
  set revokedSessions(int? revokedSessions) =>
      _$this._revokedSessions = revokedSessions;

  SuccessResponseBuilder() {
    SuccessResponse._defaults(this);
  }

  SuccessResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _revokedSessions = $v.revokedSessions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SuccessResponse other) {
    _$v = other as _$SuccessResponse;
  }

  @override
  void update(void Function(SuccessResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SuccessResponse build() => _build();

  _$SuccessResponse _build() {
    final _$result = _$v ??
        _$SuccessResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
              success, r'SuccessResponse', 'success'),
          revokedSessions: revokedSessions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
