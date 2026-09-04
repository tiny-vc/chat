// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response_groups.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponseGroups extends AdminOverviewResponseGroups {
  @override
  final int total;
  @override
  final int active;
  @override
  final int suspended;

  factory _$AdminOverviewResponseGroups(
          [void Function(AdminOverviewResponseGroupsBuilder)? updates]) =>
      (AdminOverviewResponseGroupsBuilder()..update(updates))._build();

  _$AdminOverviewResponseGroups._(
      {required this.total, required this.active, required this.suspended})
      : super._();
  @override
  AdminOverviewResponseGroups rebuild(
          void Function(AdminOverviewResponseGroupsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseGroupsBuilder toBuilder() =>
      AdminOverviewResponseGroupsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponseGroups &&
        total == other.total &&
        active == other.active &&
        suspended == other.suspended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, suspended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponseGroups')
          ..add('total', total)
          ..add('active', active)
          ..add('suspended', suspended))
        .toString();
  }
}

class AdminOverviewResponseGroupsBuilder
    implements
        Builder<AdminOverviewResponseGroups,
            AdminOverviewResponseGroupsBuilder> {
  _$AdminOverviewResponseGroups? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _active;
  int? get active => _$this._active;
  set active(int? active) => _$this._active = active;

  int? _suspended;
  int? get suspended => _$this._suspended;
  set suspended(int? suspended) => _$this._suspended = suspended;

  AdminOverviewResponseGroupsBuilder() {
    AdminOverviewResponseGroups._defaults(this);
  }

  AdminOverviewResponseGroupsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _active = $v.active;
      _suspended = $v.suspended;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponseGroups other) {
    _$v = other as _$AdminOverviewResponseGroups;
  }

  @override
  void update(void Function(AdminOverviewResponseGroupsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponseGroups build() => _build();

  _$AdminOverviewResponseGroups _build() {
    final _$result = _$v ??
        _$AdminOverviewResponseGroups._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'AdminOverviewResponseGroups', 'total'),
          active: BuiltValueNullFieldError.checkNotNull(
              active, r'AdminOverviewResponseGroups', 'active'),
          suspended: BuiltValueNullFieldError.checkNotNull(
              suspended, r'AdminOverviewResponseGroups', 'suspended'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
