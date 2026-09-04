// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response_moderation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponseModeration
    extends AdminOverviewResponseModeration {
  @override
  final int pendingGroupJoinRequests;

  factory _$AdminOverviewResponseModeration(
          [void Function(AdminOverviewResponseModerationBuilder)? updates]) =>
      (AdminOverviewResponseModerationBuilder()..update(updates))._build();

  _$AdminOverviewResponseModeration._({required this.pendingGroupJoinRequests})
      : super._();
  @override
  AdminOverviewResponseModeration rebuild(
          void Function(AdminOverviewResponseModerationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseModerationBuilder toBuilder() =>
      AdminOverviewResponseModerationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponseModeration &&
        pendingGroupJoinRequests == other.pendingGroupJoinRequests;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pendingGroupJoinRequests.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponseModeration')
          ..add('pendingGroupJoinRequests', pendingGroupJoinRequests))
        .toString();
  }
}

class AdminOverviewResponseModerationBuilder
    implements
        Builder<AdminOverviewResponseModeration,
            AdminOverviewResponseModerationBuilder> {
  _$AdminOverviewResponseModeration? _$v;

  int? _pendingGroupJoinRequests;
  int? get pendingGroupJoinRequests => _$this._pendingGroupJoinRequests;
  set pendingGroupJoinRequests(int? pendingGroupJoinRequests) =>
      _$this._pendingGroupJoinRequests = pendingGroupJoinRequests;

  AdminOverviewResponseModerationBuilder() {
    AdminOverviewResponseModeration._defaults(this);
  }

  AdminOverviewResponseModerationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pendingGroupJoinRequests = $v.pendingGroupJoinRequests;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponseModeration other) {
    _$v = other as _$AdminOverviewResponseModeration;
  }

  @override
  void update(void Function(AdminOverviewResponseModerationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponseModeration build() => _build();

  _$AdminOverviewResponseModeration _build() {
    final _$result = _$v ??
        _$AdminOverviewResponseModeration._(
          pendingGroupJoinRequests: BuiltValueNullFieldError.checkNotNull(
              pendingGroupJoinRequests,
              r'AdminOverviewResponseModeration',
              'pendingGroupJoinRequests'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
