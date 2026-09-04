// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_group_member_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminGroupMemberResponseRoleEnum
    _$adminGroupMemberResponseRoleEnum_OWNER =
    const AdminGroupMemberResponseRoleEnum._('OWNER');
const AdminGroupMemberResponseRoleEnum
    _$adminGroupMemberResponseRoleEnum_ADMIN =
    const AdminGroupMemberResponseRoleEnum._('ADMIN');
const AdminGroupMemberResponseRoleEnum
    _$adminGroupMemberResponseRoleEnum_MEMBER =
    const AdminGroupMemberResponseRoleEnum._('MEMBER');
const AdminGroupMemberResponseRoleEnum
    _$adminGroupMemberResponseRoleEnum_unknownDefaultOpenApi =
    const AdminGroupMemberResponseRoleEnum._('unknownDefaultOpenApi');

AdminGroupMemberResponseRoleEnum _$adminGroupMemberResponseRoleEnumValueOf(
    String name) {
  switch (name) {
    case 'OWNER':
      return _$adminGroupMemberResponseRoleEnum_OWNER;
    case 'ADMIN':
      return _$adminGroupMemberResponseRoleEnum_ADMIN;
    case 'MEMBER':
      return _$adminGroupMemberResponseRoleEnum_MEMBER;
    case 'unknownDefaultOpenApi':
      return _$adminGroupMemberResponseRoleEnum_unknownDefaultOpenApi;
    default:
      return _$adminGroupMemberResponseRoleEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminGroupMemberResponseRoleEnum>
    _$adminGroupMemberResponseRoleEnumValues = BuiltSet<
        AdminGroupMemberResponseRoleEnum>(const <AdminGroupMemberResponseRoleEnum>[
  _$adminGroupMemberResponseRoleEnum_OWNER,
  _$adminGroupMemberResponseRoleEnum_ADMIN,
  _$adminGroupMemberResponseRoleEnum_MEMBER,
  _$adminGroupMemberResponseRoleEnum_unknownDefaultOpenApi,
]);

const AdminGroupMemberResponseStatusEnum
    _$adminGroupMemberResponseStatusEnum_ACTIVE =
    const AdminGroupMemberResponseStatusEnum._('ACTIVE');
const AdminGroupMemberResponseStatusEnum
    _$adminGroupMemberResponseStatusEnum_LEFT =
    const AdminGroupMemberResponseStatusEnum._('LEFT');
const AdminGroupMemberResponseStatusEnum
    _$adminGroupMemberResponseStatusEnum_REMOVED =
    const AdminGroupMemberResponseStatusEnum._('REMOVED');
const AdminGroupMemberResponseStatusEnum
    _$adminGroupMemberResponseStatusEnum_unknownDefaultOpenApi =
    const AdminGroupMemberResponseStatusEnum._('unknownDefaultOpenApi');

AdminGroupMemberResponseStatusEnum _$adminGroupMemberResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminGroupMemberResponseStatusEnum_ACTIVE;
    case 'LEFT':
      return _$adminGroupMemberResponseStatusEnum_LEFT;
    case 'REMOVED':
      return _$adminGroupMemberResponseStatusEnum_REMOVED;
    case 'unknownDefaultOpenApi':
      return _$adminGroupMemberResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminGroupMemberResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminGroupMemberResponseStatusEnum>
    _$adminGroupMemberResponseStatusEnumValues = BuiltSet<
        AdminGroupMemberResponseStatusEnum>(const <AdminGroupMemberResponseStatusEnum>[
  _$adminGroupMemberResponseStatusEnum_ACTIVE,
  _$adminGroupMemberResponseStatusEnum_LEFT,
  _$adminGroupMemberResponseStatusEnum_REMOVED,
  _$adminGroupMemberResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<AdminGroupMemberResponseRoleEnum>
    _$adminGroupMemberResponseRoleEnumSerializer =
    _$AdminGroupMemberResponseRoleEnumSerializer();
Serializer<AdminGroupMemberResponseStatusEnum>
    _$adminGroupMemberResponseStatusEnumSerializer =
    _$AdminGroupMemberResponseStatusEnumSerializer();

class _$AdminGroupMemberResponseRoleEnumSerializer
    implements PrimitiveSerializer<AdminGroupMemberResponseRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OWNER': 'OWNER',
    'ADMIN': 'ADMIN',
    'MEMBER': 'MEMBER',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OWNER': 'OWNER',
    'ADMIN': 'ADMIN',
    'MEMBER': 'MEMBER',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminGroupMemberResponseRoleEnum];
  @override
  final String wireName = 'AdminGroupMemberResponseRoleEnum';

  @override
  Object serialize(
          Serializers serializers, AdminGroupMemberResponseRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminGroupMemberResponseRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminGroupMemberResponseRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminGroupMemberResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminGroupMemberResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'LEFT': 'LEFT',
    'REMOVED': 'REMOVED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'LEFT': 'LEFT',
    'REMOVED': 'REMOVED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminGroupMemberResponseStatusEnum];
  @override
  final String wireName = 'AdminGroupMemberResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminGroupMemberResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminGroupMemberResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminGroupMemberResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminGroupMemberResponse extends AdminGroupMemberResponse {
  @override
  final String groupId;
  @override
  final String userId;
  @override
  final AdminGroupMemberResponseRoleEnum role;
  @override
  final AdminGroupMemberResponseStatusEnum status;
  @override
  final String? nickname;
  @override
  final DateTime? mutedUntil;
  @override
  final DateTime joinedAt;
  @override
  final BuiltMap<String, JsonObject?> user;

  factory _$AdminGroupMemberResponse(
          [void Function(AdminGroupMemberResponseBuilder)? updates]) =>
      (AdminGroupMemberResponseBuilder()..update(updates))._build();

  _$AdminGroupMemberResponse._(
      {required this.groupId,
      required this.userId,
      required this.role,
      required this.status,
      this.nickname,
      this.mutedUntil,
      required this.joinedAt,
      required this.user})
      : super._();
  @override
  AdminGroupMemberResponse rebuild(
          void Function(AdminGroupMemberResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGroupMemberResponseBuilder toBuilder() =>
      AdminGroupMemberResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGroupMemberResponse &&
        groupId == other.groupId &&
        userId == other.userId &&
        role == other.role &&
        status == other.status &&
        nickname == other.nickname &&
        mutedUntil == other.mutedUntil &&
        joinedAt == other.joinedAt &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, nickname.hashCode);
    _$hash = $jc(_$hash, mutedUntil.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminGroupMemberResponse')
          ..add('groupId', groupId)
          ..add('userId', userId)
          ..add('role', role)
          ..add('status', status)
          ..add('nickname', nickname)
          ..add('mutedUntil', mutedUntil)
          ..add('joinedAt', joinedAt)
          ..add('user', user))
        .toString();
  }
}

class AdminGroupMemberResponseBuilder
    implements
        Builder<AdminGroupMemberResponse, AdminGroupMemberResponseBuilder> {
  _$AdminGroupMemberResponse? _$v;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  AdminGroupMemberResponseRoleEnum? _role;
  AdminGroupMemberResponseRoleEnum? get role => _$this._role;
  set role(AdminGroupMemberResponseRoleEnum? role) => _$this._role = role;

  AdminGroupMemberResponseStatusEnum? _status;
  AdminGroupMemberResponseStatusEnum? get status => _$this._status;
  set status(AdminGroupMemberResponseStatusEnum? status) =>
      _$this._status = status;

  String? _nickname;
  String? get nickname => _$this._nickname;
  set nickname(String? nickname) => _$this._nickname = nickname;

  DateTime? _mutedUntil;
  DateTime? get mutedUntil => _$this._mutedUntil;
  set mutedUntil(DateTime? mutedUntil) => _$this._mutedUntil = mutedUntil;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  MapBuilder<String, JsonObject?>? _user;
  MapBuilder<String, JsonObject?> get user =>
      _$this._user ??= MapBuilder<String, JsonObject?>();
  set user(MapBuilder<String, JsonObject?>? user) => _$this._user = user;

  AdminGroupMemberResponseBuilder() {
    AdminGroupMemberResponse._defaults(this);
  }

  AdminGroupMemberResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupId = $v.groupId;
      _userId = $v.userId;
      _role = $v.role;
      _status = $v.status;
      _nickname = $v.nickname;
      _mutedUntil = $v.mutedUntil;
      _joinedAt = $v.joinedAt;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGroupMemberResponse other) {
    _$v = other as _$AdminGroupMemberResponse;
  }

  @override
  void update(void Function(AdminGroupMemberResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGroupMemberResponse build() => _build();

  _$AdminGroupMemberResponse _build() {
    _$AdminGroupMemberResponse _$result;
    try {
      _$result = _$v ??
          _$AdminGroupMemberResponse._(
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'AdminGroupMemberResponse', 'groupId'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'AdminGroupMemberResponse', 'userId'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'AdminGroupMemberResponse', 'role'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminGroupMemberResponse', 'status'),
            nickname: nickname,
            mutedUntil: mutedUntil,
            joinedAt: BuiltValueNullFieldError.checkNotNull(
                joinedAt, r'AdminGroupMemberResponse', 'joinedAt'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminGroupMemberResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
