// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminUserResponseStatusEnum _$adminUserResponseStatusEnum_ACTIVE =
    const AdminUserResponseStatusEnum._('ACTIVE');
const AdminUserResponseStatusEnum _$adminUserResponseStatusEnum_SUSPENDED =
    const AdminUserResponseStatusEnum._('SUSPENDED');
const AdminUserResponseStatusEnum _$adminUserResponseStatusEnum_DELETED =
    const AdminUserResponseStatusEnum._('DELETED');
const AdminUserResponseStatusEnum
    _$adminUserResponseStatusEnum_unknownDefaultOpenApi =
    const AdminUserResponseStatusEnum._('unknownDefaultOpenApi');

AdminUserResponseStatusEnum _$adminUserResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminUserResponseStatusEnum_ACTIVE;
    case 'SUSPENDED':
      return _$adminUserResponseStatusEnum_SUSPENDED;
    case 'DELETED':
      return _$adminUserResponseStatusEnum_DELETED;
    case 'unknownDefaultOpenApi':
      return _$adminUserResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminUserResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminUserResponseStatusEnum>
    _$adminUserResponseStatusEnumValues =
    BuiltSet<AdminUserResponseStatusEnum>(const <AdminUserResponseStatusEnum>[
  _$adminUserResponseStatusEnum_ACTIVE,
  _$adminUserResponseStatusEnum_SUSPENDED,
  _$adminUserResponseStatusEnum_DELETED,
  _$adminUserResponseStatusEnum_unknownDefaultOpenApi,
]);

const AdminUserResponseRoleEnum _$adminUserResponseRoleEnum_USER =
    const AdminUserResponseRoleEnum._('USER');
const AdminUserResponseRoleEnum _$adminUserResponseRoleEnum_ADMIN =
    const AdminUserResponseRoleEnum._('ADMIN');
const AdminUserResponseRoleEnum
    _$adminUserResponseRoleEnum_unknownDefaultOpenApi =
    const AdminUserResponseRoleEnum._('unknownDefaultOpenApi');

AdminUserResponseRoleEnum _$adminUserResponseRoleEnumValueOf(String name) {
  switch (name) {
    case 'USER':
      return _$adminUserResponseRoleEnum_USER;
    case 'ADMIN':
      return _$adminUserResponseRoleEnum_ADMIN;
    case 'unknownDefaultOpenApi':
      return _$adminUserResponseRoleEnum_unknownDefaultOpenApi;
    default:
      return _$adminUserResponseRoleEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminUserResponseRoleEnum> _$adminUserResponseRoleEnumValues =
    BuiltSet<AdminUserResponseRoleEnum>(const <AdminUserResponseRoleEnum>[
  _$adminUserResponseRoleEnum_USER,
  _$adminUserResponseRoleEnum_ADMIN,
  _$adminUserResponseRoleEnum_unknownDefaultOpenApi,
]);

Serializer<AdminUserResponseStatusEnum>
    _$adminUserResponseStatusEnumSerializer =
    _$AdminUserResponseStatusEnumSerializer();
Serializer<AdminUserResponseRoleEnum> _$adminUserResponseRoleEnumSerializer =
    _$AdminUserResponseRoleEnumSerializer();

class _$AdminUserResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminUserResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DELETED': 'DELETED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'SUSPENDED': 'SUSPENDED',
    'DELETED': 'DELETED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminUserResponseStatusEnum];
  @override
  final String wireName = 'AdminUserResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, AdminUserResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminUserResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminUserResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminUserResponseRoleEnumSerializer
    implements PrimitiveSerializer<AdminUserResponseRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminUserResponseRoleEnum];
  @override
  final String wireName = 'AdminUserResponseRoleEnum';

  @override
  Object serialize(Serializers serializers, AdminUserResponseRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminUserResponseRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminUserResponseRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminUserResponse extends AdminUserResponse {
  @override
  final String id;
  @override
  final String username;
  @override
  final String nickname;
  @override
  final String? avatarUrl;
  @override
  final String? avatarFileId;
  @override
  final AdminUserResponseStatusEnum status;
  @override
  final AdminUserResponseRoleEnum role;
  @override
  final int? revokedSessions;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>>? deviceSessions;
  @override
  final BuiltMap<String, int>? count;

  factory _$AdminUserResponse(
          [void Function(AdminUserResponseBuilder)? updates]) =>
      (AdminUserResponseBuilder()..update(updates))._build();

  _$AdminUserResponse._(
      {required this.id,
      required this.username,
      required this.nickname,
      this.avatarUrl,
      this.avatarFileId,
      required this.status,
      required this.role,
      this.revokedSessions,
      required this.createdAt,
      required this.updatedAt,
      this.deviceSessions,
      this.count})
      : super._();
  @override
  AdminUserResponse rebuild(void Function(AdminUserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserResponseBuilder toBuilder() =>
      AdminUserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserResponse &&
        id == other.id &&
        username == other.username &&
        nickname == other.nickname &&
        avatarUrl == other.avatarUrl &&
        avatarFileId == other.avatarFileId &&
        status == other.status &&
        role == other.role &&
        revokedSessions == other.revokedSessions &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deviceSessions == other.deviceSessions &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, avatarFileId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, revokedSessions.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, deviceSessions.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUserResponse')
          ..add('id', id)
          ..add('username', username)
          ..add('nickname', nickname)
          ..add('avatarUrl', avatarUrl)
          ..add('avatarFileId', avatarFileId)
          ..add('status', status)
          ..add('role', role)
          ..add('revokedSessions', revokedSessions)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('deviceSessions', deviceSessions)
          ..add('count', count))
        .toString();
  }
}

class AdminUserResponseBuilder
    implements Builder<AdminUserResponse, AdminUserResponseBuilder> {
  _$AdminUserResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _avatarFileId;
  String? get avatarFileId => _$this._avatarFileId;
  set avatarFileId(String? avatarFileId) => _$this._avatarFileId = avatarFileId;

  AdminUserResponseStatusEnum? _status;
  AdminUserResponseStatusEnum? get status => _$this._status;
  set status(AdminUserResponseStatusEnum? status) => _$this._status = status;

  AdminUserResponseRoleEnum? _role;
  AdminUserResponseRoleEnum? get role => _$this._role;
  set role(AdminUserResponseRoleEnum? role) => _$this._role = role;

  int? _revokedSessions;
  int? get revokedSessions => _$this._revokedSessions;
  set revokedSessions(int? revokedSessions) =>
      _$this._revokedSessions = revokedSessions;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<BuiltMap<String, JsonObject?>>? _deviceSessions;
  ListBuilder<BuiltMap<String, JsonObject?>> get deviceSessions =>
      _$this._deviceSessions ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set deviceSessions(
          ListBuilder<BuiltMap<String, JsonObject?>>? deviceSessions) =>
      _$this._deviceSessions = deviceSessions;

  MapBuilder<String, int>? _count;
  MapBuilder<String, int> get count =>
      _$this._count ??= MapBuilder<String, int>();
  set count(MapBuilder<String, int>? count) => _$this._count = count;

  AdminUserResponseBuilder() {
    AdminUserResponse._defaults(this);
  }

  AdminUserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _nickname = $v.nickname;
      _avatarUrl = $v.avatarUrl;
      _avatarFileId = $v.avatarFileId;
      _status = $v.status;
      _role = $v.role;
      _revokedSessions = $v.revokedSessions;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _deviceSessions = $v.deviceSessions?.toBuilder();
      _count = $v.count?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserResponse other) {
    _$v = other as _$AdminUserResponse;
  }

  @override
  void update(void Function(AdminUserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserResponse build() => _build();

  _$AdminUserResponse _build() {
    _$AdminUserResponse _$result;
    try {
      _$result = _$v ??
          _$AdminUserResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminUserResponse', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'AdminUserResponse', 'username'),
            nickname: BuiltValueNullFieldError.checkNotNull(
                nickname, r'AdminUserResponse', 'nickname'),
            avatarUrl: avatarUrl,
            avatarFileId: avatarFileId,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminUserResponse', 'status'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'AdminUserResponse', 'role'),
            revokedSessions: revokedSessions,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminUserResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'AdminUserResponse', 'updatedAt'),
            deviceSessions: _deviceSessions?.build(),
            count: _count?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'deviceSessions';
        _deviceSessions?.build();
        _$failedField = 'count';
        _count?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminUserResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
