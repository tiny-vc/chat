// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupMemberResponseRoleEnum _$groupMemberResponseRoleEnum_OWNER =
    const GroupMemberResponseRoleEnum._('OWNER');
const GroupMemberResponseRoleEnum _$groupMemberResponseRoleEnum_ADMIN =
    const GroupMemberResponseRoleEnum._('ADMIN');
const GroupMemberResponseRoleEnum _$groupMemberResponseRoleEnum_MEMBER =
    const GroupMemberResponseRoleEnum._('MEMBER');
const GroupMemberResponseRoleEnum
    _$groupMemberResponseRoleEnum_unknownDefaultOpenApi =
    const GroupMemberResponseRoleEnum._('unknownDefaultOpenApi');

GroupMemberResponseRoleEnum _$groupMemberResponseRoleEnumValueOf(String name) {
  switch (name) {
    case 'OWNER':
      return _$groupMemberResponseRoleEnum_OWNER;
    case 'ADMIN':
      return _$groupMemberResponseRoleEnum_ADMIN;
    case 'MEMBER':
      return _$groupMemberResponseRoleEnum_MEMBER;
    case 'unknownDefaultOpenApi':
      return _$groupMemberResponseRoleEnum_unknownDefaultOpenApi;
    default:
      return _$groupMemberResponseRoleEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<GroupMemberResponseRoleEnum>
    _$groupMemberResponseRoleEnumValues =
    BuiltSet<GroupMemberResponseRoleEnum>(const <GroupMemberResponseRoleEnum>[
  _$groupMemberResponseRoleEnum_OWNER,
  _$groupMemberResponseRoleEnum_ADMIN,
  _$groupMemberResponseRoleEnum_MEMBER,
  _$groupMemberResponseRoleEnum_unknownDefaultOpenApi,
]);

const GroupMemberResponseStatusEnum _$groupMemberResponseStatusEnum_ACTIVE =
    const GroupMemberResponseStatusEnum._('ACTIVE');
const GroupMemberResponseStatusEnum _$groupMemberResponseStatusEnum_LEFT =
    const GroupMemberResponseStatusEnum._('LEFT');
const GroupMemberResponseStatusEnum _$groupMemberResponseStatusEnum_REMOVED =
    const GroupMemberResponseStatusEnum._('REMOVED');
const GroupMemberResponseStatusEnum
    _$groupMemberResponseStatusEnum_unknownDefaultOpenApi =
    const GroupMemberResponseStatusEnum._('unknownDefaultOpenApi');

GroupMemberResponseStatusEnum _$groupMemberResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$groupMemberResponseStatusEnum_ACTIVE;
    case 'LEFT':
      return _$groupMemberResponseStatusEnum_LEFT;
    case 'REMOVED':
      return _$groupMemberResponseStatusEnum_REMOVED;
    case 'unknownDefaultOpenApi':
      return _$groupMemberResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$groupMemberResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<GroupMemberResponseStatusEnum>
    _$groupMemberResponseStatusEnumValues = BuiltSet<
        GroupMemberResponseStatusEnum>(const <GroupMemberResponseStatusEnum>[
  _$groupMemberResponseStatusEnum_ACTIVE,
  _$groupMemberResponseStatusEnum_LEFT,
  _$groupMemberResponseStatusEnum_REMOVED,
  _$groupMemberResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<GroupMemberResponseRoleEnum>
    _$groupMemberResponseRoleEnumSerializer =
    _$GroupMemberResponseRoleEnumSerializer();
Serializer<GroupMemberResponseStatusEnum>
    _$groupMemberResponseStatusEnumSerializer =
    _$GroupMemberResponseStatusEnumSerializer();

class _$GroupMemberResponseRoleEnumSerializer
    implements PrimitiveSerializer<GroupMemberResponseRoleEnum> {
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
  final Iterable<Type> types = const <Type>[GroupMemberResponseRoleEnum];
  @override
  final String wireName = 'GroupMemberResponseRoleEnum';

  @override
  Object serialize(Serializers serializers, GroupMemberResponseRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupMemberResponseRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupMemberResponseRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GroupMemberResponseStatusEnumSerializer
    implements PrimitiveSerializer<GroupMemberResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[GroupMemberResponseStatusEnum];
  @override
  final String wireName = 'GroupMemberResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, GroupMemberResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupMemberResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupMemberResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GroupMemberResponse extends GroupMemberResponse {
  @override
  final String groupId;
  @override
  final String userId;
  @override
  final GroupMemberResponseRoleEnum role;
  @override
  final GroupMemberResponseStatusEnum status;
  @override
  final DateTime? mutedUntil;
  @override
  final DateTime joinedAt;
  @override
  final UserResponse? user;

  factory _$GroupMemberResponse(
          [void Function(GroupMemberResponseBuilder)? updates]) =>
      (GroupMemberResponseBuilder()..update(updates))._build();

  _$GroupMemberResponse._(
      {required this.groupId,
      required this.userId,
      required this.role,
      required this.status,
      this.mutedUntil,
      required this.joinedAt,
      this.user})
      : super._();
  @override
  GroupMemberResponse rebuild(
          void Function(GroupMemberResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupMemberResponseBuilder toBuilder() =>
      GroupMemberResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupMemberResponse &&
        groupId == other.groupId &&
        userId == other.userId &&
        role == other.role &&
        status == other.status &&
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
    _$hash = $jc(_$hash, mutedUntil.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupMemberResponse')
          ..add('groupId', groupId)
          ..add('userId', userId)
          ..add('role', role)
          ..add('status', status)
          ..add('mutedUntil', mutedUntil)
          ..add('joinedAt', joinedAt)
          ..add('user', user))
        .toString();
  }
}

class GroupMemberResponseBuilder
    implements Builder<GroupMemberResponse, GroupMemberResponseBuilder> {
  _$GroupMemberResponse? _$v;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  GroupMemberResponseRoleEnum? _role;
  GroupMemberResponseRoleEnum? get role => _$this._role;
  set role(GroupMemberResponseRoleEnum? role) => _$this._role = role;

  GroupMemberResponseStatusEnum? _status;
  GroupMemberResponseStatusEnum? get status => _$this._status;
  set status(GroupMemberResponseStatusEnum? status) => _$this._status = status;

  DateTime? _mutedUntil;
  DateTime? get mutedUntil => _$this._mutedUntil;
  set mutedUntil(DateTime? mutedUntil) => _$this._mutedUntil = mutedUntil;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  GroupMemberResponseBuilder() {
    GroupMemberResponse._defaults(this);
  }

  GroupMemberResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupId = $v.groupId;
      _userId = $v.userId;
      _role = $v.role;
      _status = $v.status;
      _mutedUntil = $v.mutedUntil;
      _joinedAt = $v.joinedAt;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupMemberResponse other) {
    _$v = other as _$GroupMemberResponse;
  }

  @override
  void update(void Function(GroupMemberResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupMemberResponse build() => _build();

  _$GroupMemberResponse _build() {
    _$GroupMemberResponse _$result;
    try {
      _$result = _$v ??
          _$GroupMemberResponse._(
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'GroupMemberResponse', 'groupId'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'GroupMemberResponse', 'userId'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'GroupMemberResponse', 'role'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GroupMemberResponse', 'status'),
            mutedUntil: mutedUntil,
            joinedAt: BuiltValueNullFieldError.checkNotNull(
                joinedAt, r'GroupMemberResponse', 'joinedAt'),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupMemberResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
