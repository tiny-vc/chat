// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response_calls.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponseCalls extends AdminOverviewResponseCalls {
  @override
  final int active;
  @override
  final int failed24h;

  factory _$AdminOverviewResponseCalls(
          [void Function(AdminOverviewResponseCallsBuilder)? updates]) =>
      (AdminOverviewResponseCallsBuilder()..update(updates))._build();

  _$AdminOverviewResponseCalls._(
      {required this.active, required this.failed24h})
      : super._();
  @override
  AdminOverviewResponseCalls rebuild(
          void Function(AdminOverviewResponseCallsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseCallsBuilder toBuilder() =>
      AdminOverviewResponseCallsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponseCalls &&
        active == other.active &&
        failed24h == other.failed24h;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, failed24h.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponseCalls')
          ..add('active', active)
          ..add('failed24h', failed24h))
        .toString();
  }
}

class AdminOverviewResponseCallsBuilder
    implements
        Builder<AdminOverviewResponseCalls, AdminOverviewResponseCallsBuilder> {
  _$AdminOverviewResponseCalls? _$v;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  int? _failed24h;
  int? get failed24h => _$this._failed24h;
  set failed24h(int? failed24h) => _$this._failed24h = failed24h;

  AdminOverviewResponseCallsBuilder() {
    AdminOverviewResponseCalls._defaults(this);
  }

  AdminOverviewResponseCallsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _failed24h = $v.failed24h;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponseCalls other) {
    _$v = other as _$AdminOverviewResponseCalls;
  }

  @override
  void update(void Function(AdminOverviewResponseCallsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponseCalls build() => _build();

  _$AdminOverviewResponseCalls _build() {
    final _$result = _$v ??
        _$AdminOverviewResponseCalls._(
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'AdminOverviewResponseCalls', 'active'),
          failed24h: BuiltValueNullFieldError.checkNotNull(
              failed24h, r'AdminOverviewResponseCalls', 'failed24h'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
