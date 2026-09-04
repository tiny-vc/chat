// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponse extends AdminOverviewResponse {
  @override
  final DateTime generatedAt;
  @override
  final AdminOverviewResponseUsers users;
  @override
  final AdminOverviewResponseGroups groups;
  @override
  final AdminOverviewResponseFiles files;
  @override
  final AdminOverviewResponseCalls calls;
  @override
  final AdminOverviewResponseModeration moderation;

  factory _$AdminOverviewResponse(
          [void Function(AdminOverviewResponseBuilder)? updates]) =>
      (AdminOverviewResponseBuilder()..update(updates))._build();

  _$AdminOverviewResponse._(
      {required this.generatedAt,
      required this.users,
      required this.groups,
      required this.files,
      required this.calls,
      required this.moderation})
      : super._();
  @override
  AdminOverviewResponse rebuild(
          void Function(AdminOverviewResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseBuilder toBuilder() =>
      AdminOverviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponse &&
        generatedAt == other.generatedAt &&
        users == other.users &&
        groups == other.groups &&
        files == other.files &&
        calls == other.calls &&
        moderation == other.moderation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, files.hashCode);
    _$hash = $jc(_$hash, calls.hashCode);
    _$hash = $jc(_$hash, moderation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponse')
          ..add('generatedAt', generatedAt)
          ..add('users', users)
          ..add('groups', groups)
          ..add('files', files)
          ..add('calls', calls)
          ..add('moderation', moderation))
        .toString();
  }
}

class AdminOverviewResponseBuilder
    implements Builder<AdminOverviewResponse, AdminOverviewResponseBuilder> {
  _$AdminOverviewResponse? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  AdminOverviewResponseUsersBuilder? _users;
  AdminOverviewResponseUsersBuilder get users =>
      _$this._users ??= AdminOverviewResponseUsersBuilder();
  set users(AdminOverviewResponseUsersBuilder? users) => _$this._users = users;

  AdminOverviewResponseGroupsBuilder? _groups;
  AdminOverviewResponseGroupsBuilder get groups =>
      _$this._groups ??= AdminOverviewResponseGroupsBuilder();
  set groups(AdminOverviewResponseGroupsBuilder? groups) =>
      _$this._groups = groups;

  AdminOverviewResponseFilesBuilder? _files;
  AdminOverviewResponseFilesBuilder get files =>
      _$this._files ??= AdminOverviewResponseFilesBuilder();
  set files(AdminOverviewResponseFilesBuilder? files) => _$this._files = files;

  AdminOverviewResponseCallsBuilder? _calls;
  AdminOverviewResponseCallsBuilder get calls =>
      _$this._calls ??= AdminOverviewResponseCallsBuilder();
  set calls(AdminOverviewResponseCallsBuilder? calls) => _$this._calls = calls;

  AdminOverviewResponseModerationBuilder? _moderation;
  AdminOverviewResponseModerationBuilder get moderation =>
      _$this._moderation ??= AdminOverviewResponseModerationBuilder();
  set moderation(AdminOverviewResponseModerationBuilder? moderation) =>
      _$this._moderation = moderation;

  AdminOverviewResponseBuilder() {
    AdminOverviewResponse._defaults(this);
  }

  AdminOverviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _users = $v.users.toBuilder();
      _groups = $v.groups.toBuilder();
      _files = $v.files.toBuilder();
      _calls = $v.calls.toBuilder();
      _moderation = $v.moderation.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponse other) {
    _$v = other as _$AdminOverviewResponse;
  }

  @override
  void update(void Function(AdminOverviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponse build() => _build();

  _$AdminOverviewResponse _build() {
    _$AdminOverviewResponse _$result;
    try {
      _$result = _$v ??
          _$AdminOverviewResponse._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'AdminOverviewResponse', 'generatedAt'),
            users: users.build(),
            groups: groups.build(),
            files: files.build(),
            calls: calls.build(),
            moderation: moderation.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'users';
        users.build();
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'files';
        files.build();
        _$failedField = 'calls';
        calls.build();
        _$failedField = 'moderation';
        moderation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminOverviewResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
