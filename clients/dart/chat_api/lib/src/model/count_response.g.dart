// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CountResponse extends CountResponse {
  @override
  final int count;

  factory _$CountResponse([void Function(CountResponseBuilder)? updates]) =>
      (CountResponseBuilder()..update(updates))._build();

  _$CountResponse._({required this.count}) : super._();
  @override
  CountResponse rebuild(void Function(CountResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CountResponseBuilder toBuilder() => CountResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CountResponse && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CountResponse')..add('count', count))
        .toString();
  }
}

class CountResponseBuilder
    implements Builder<CountResponse, CountResponseBuilder> {
  _$CountResponse? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  CountResponseBuilder() {
    CountResponse._defaults(this);
  }

  CountResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CountResponse other) {
    _$v = other as _$CountResponse;
  }

  @override
  void update(void Function(CountResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CountResponse build() => _build();

  _$CountResponse _build() {
    final _$result = _$v ??
        _$CountResponse._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'CountResponse', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
