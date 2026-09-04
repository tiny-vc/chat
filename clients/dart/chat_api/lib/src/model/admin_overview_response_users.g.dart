// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response_users.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponseUsers extends AdminOverviewResponseUsers {
  @override
  final int total;
  @override
  final int active;
  @override
  final int suspended;
  @override
  final int new24h;

  factory _$AdminOverviewResponseUsers(
          [void Function(AdminOverviewResponseUsersBuilder)? updates]) =>
      (AdminOverviewResponseUsersBuilder()..update(updates))._build();

  _$AdminOverviewResponseUsers._(
      {required this.total,
      required this.active,
      required this.suspended,
      required this.new24h})
      : super._();
  @override
  AdminOverviewResponseUsers rebuild(
          void Function(AdminOverviewResponseUsersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseUsersBuilder toBuilder() =>
      AdminOverviewResponseUsersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponseUsers &&
        total == other.total &&
        active == other.active &&
        suspended == other.suspended &&
        new24h == other.new24h;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, suspended.hashCode);
    _$hash = $jc(_$hash, new24h.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponseUsers')
          ..add('total', total)
          ..add('active', active)
          ..add('suspended', suspended)
          ..add('new24h', new24h))
        .toString();
  }
}

class AdminOverviewResponseUsersBuilder
    implements
        Builder<AdminOverviewResponseUsers, AdminOverviewResponseUsersBuilder> {
  _$AdminOverviewResponseUsers? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  int? _suspended;
  int? get suspended => _$this._suspended;
  set suspended(int? suspended) => _$this._suspended = suspended;

  int? _new24h;
  int? get new24h => _$this._new24h;
  set new24h(int? new24h) => _$this._new24h = new24h;

  AdminOverviewResponseUsersBuilder() {
    AdminOverviewResponseUsers._defaults(this);
  }

  AdminOverviewResponseUsersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _active = $v.active;
      _suspended = $v.suspended;
      _new24h = $v.new24h;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponseUsers other) {
    _$v = other as _$AdminOverviewResponseUsers;
  }

  @override
  void update(void Function(AdminOverviewResponseUsersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponseUsers build() => _build();

  _$AdminOverviewResponseUsers _build() {
    final _$result = _$v ??
        _$AdminOverviewResponseUsers._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'AdminOverviewResponseUsers', 'total'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'AdminOverviewResponseUsers', 'active'),
          suspended: BuiltValueNullFieldError.checkNotNull(
              suspended, r'AdminOverviewResponseUsers', 'suspended'),
          new24h: BuiltValueNullFieldError.checkNotNull(
              new24h, r'AdminOverviewResponseUsers', 'new24h'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
