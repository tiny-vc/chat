// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_join_request_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupJoinRequestResponseTypeEnum
    _$groupJoinRequestResponseTypeEnum_APPLY =
    const GroupJoinRequestResponseTypeEnum._('APPLY');
const GroupJoinRequestResponseTypeEnum
    _$groupJoinRequestResponseTypeEnum_INVITE =
    const GroupJoinRequestResponseTypeEnum._('INVITE');
const GroupJoinRequestResponseTypeEnum
    _$groupJoinRequestResponseTypeEnum_unknownDefaultOpenApi =
    const GroupJoinRequestResponseTypeEnum._('unknownDefaultOpenApi');

GroupJoinRequestResponseTypeEnum _$groupJoinRequestResponseTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'APPLY':
      return _$groupJoinRequestResponseTypeEnum_APPLY;
    case 'INVITE':
      return _$groupJoinRequestResponseTypeEnum_INVITE;
    case 'unknownDefaultOpenApi':
      return _$groupJoinRequestResponseTypeEnum_unknownDefaultOpenApi;
    default:
      return _$groupJoinRequestResponseTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<GroupJoinRequestResponseTypeEnum>
    _$groupJoinRequestResponseTypeEnumValues = BuiltSet<
        GroupJoinRequestResponseTypeEnum>(const <GroupJoinRequestResponseTypeEnum>[
  _$groupJoinRequestResponseTypeEnum_APPLY,
  _$groupJoinRequestResponseTypeEnum_INVITE,
  _$groupJoinRequestResponseTypeEnum_unknownDefaultOpenApi,
]);

const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_PENDING =
    const GroupJoinRequestResponseStatusEnum._('PENDING');
const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_APPROVED =
    const GroupJoinRequestResponseStatusEnum._('APPROVED');
const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_REJECTED =
    const GroupJoinRequestResponseStatusEnum._('REJECTED');
const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_CANCELLED =
    const GroupJoinRequestResponseStatusEnum._('CANCELLED');
const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_EXPIRED =
    const GroupJoinRequestResponseStatusEnum._('EXPIRED');
const GroupJoinRequestResponseStatusEnum
    _$groupJoinRequestResponseStatusEnum_unknownDefaultOpenApi =
    const GroupJoinRequestResponseStatusEnum._('unknownDefaultOpenApi');

GroupJoinRequestResponseStatusEnum _$groupJoinRequestResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$groupJoinRequestResponseStatusEnum_PENDING;
    case 'APPROVED':
      return _$groupJoinRequestResponseStatusEnum_APPROVED;
    case 'REJECTED':
      return _$groupJoinRequestResponseStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$groupJoinRequestResponseStatusEnum_CANCELLED;
    case 'EXPIRED':
      return _$groupJoinRequestResponseStatusEnum_EXPIRED;
    case 'unknownDefaultOpenApi':
      return _$groupJoinRequestResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$groupJoinRequestResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<GroupJoinRequestResponseStatusEnum>
    _$groupJoinRequestResponseStatusEnumValues = BuiltSet<
        GroupJoinRequestResponseStatusEnum>(const <GroupJoinRequestResponseStatusEnum>[
  _$groupJoinRequestResponseStatusEnum_PENDING,
  _$groupJoinRequestResponseStatusEnum_APPROVED,
  _$groupJoinRequestResponseStatusEnum_REJECTED,
  _$groupJoinRequestResponseStatusEnum_CANCELLED,
  _$groupJoinRequestResponseStatusEnum_EXPIRED,
  _$groupJoinRequestResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<GroupJoinRequestResponseTypeEnum>
    _$groupJoinRequestResponseTypeEnumSerializer =
    _$GroupJoinRequestResponseTypeEnumSerializer();
Serializer<GroupJoinRequestResponseStatusEnum>
    _$groupJoinRequestResponseStatusEnumSerializer =
    _$GroupJoinRequestResponseStatusEnumSerializer();

class _$GroupJoinRequestResponseTypeEnumSerializer
    implements PrimitiveSerializer<GroupJoinRequestResponseTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPLY': 'APPLY',
    'INVITE': 'INVITE',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPLY': 'APPLY',
    'INVITE': 'INVITE',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupJoinRequestResponseTypeEnum];
  @override
  final String wireName = 'GroupJoinRequestResponseTypeEnum';

  @override
  Object serialize(
          Serializers serializers, GroupJoinRequestResponseTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupJoinRequestResponseTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupJoinRequestResponseTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GroupJoinRequestResponseStatusEnumSerializer
    implements PrimitiveSerializer<GroupJoinRequestResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
    'EXPIRED': 'EXPIRED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
    'EXPIRED': 'EXPIRED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupJoinRequestResponseStatusEnum];
  @override
  final String wireName = 'GroupJoinRequestResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, GroupJoinRequestResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupJoinRequestResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupJoinRequestResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GroupJoinRequestResponse extends GroupJoinRequestResponse {
  @override
  final String id;
  @override
  final String groupId;
  @override
  final String userId;
  @override
  final String requestedById;
  @override
  final String? decidedById;
  @override
  final GroupJoinRequestResponseTypeEnum type;
  @override
  final GroupJoinRequestResponseStatusEnum status;
  @override
  final String? message;
  @override
  final String? decisionNote;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? decidedAt;
  @override
  final GroupResponse? group;
  @override
  final UserResponse? user;

  factory _$GroupJoinRequestResponse(
          [void Function(GroupJoinRequestResponseBuilder)? updates]) =>
      (GroupJoinRequestResponseBuilder()..update(updates))._build();

  _$GroupJoinRequestResponse._(
      {required this.id,
      required this.groupId,
      required this.userId,
      required this.requestedById,
      this.decidedById,
      required this.type,
      required this.status,
      this.message,
      this.decisionNote,
      required this.expiresAt,
      required this.createdAt,
      this.decidedAt,
      this.group,
      this.user})
      : super._();
  @override
  GroupJoinRequestResponse rebuild(
          void Function(GroupJoinRequestResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupJoinRequestResponseBuilder toBuilder() =>
      GroupJoinRequestResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupJoinRequestResponse &&
        id == other.id &&
        groupId == other.groupId &&
        userId == other.userId &&
        requestedById == other.requestedById &&
        decidedById == other.decidedById &&
        type == other.type &&
        status == other.status &&
        message == other.message &&
        decisionNote == other.decisionNote &&
        expiresAt == other.expiresAt &&
        createdAt == other.createdAt &&
        decidedAt == other.decidedAt &&
        group == other.group &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, requestedById.hashCode);
    _$hash = $jc(_$hash, decidedById.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, decisionNote.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupJoinRequestResponse')
          ..add('id', id)
          ..add('groupId', groupId)
          ..add('userId', userId)
          ..add('requestedById', requestedById)
          ..add('decidedById', decidedById)
          ..add('type', type)
          ..add('status', status)
          ..add('message', message)
          ..add('decisionNote', decisionNote)
          ..add('expiresAt', expiresAt)
          ..add('createdAt', createdAt)
          ..add('decidedAt', decidedAt)
          ..add('group', group)
          ..add('user', user))
        .toString();
  }
}

class GroupJoinRequestResponseBuilder
    implements
        Builder<GroupJoinRequestResponse, GroupJoinRequestResponseBuilder> {
  _$GroupJoinRequestResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _requestedById;
  String? get requestedById => _$this._requestedById;
  set requestedById(String? requestedById) =>
      _$this._requestedById = requestedById;

  String? _decidedById;
  String? get decidedById => _$this._decidedById;
  set decidedById(String? decidedById) => _$this._decidedById = decidedById;

  GroupJoinRequestResponseTypeEnum? _type;
  GroupJoinRequestResponseTypeEnum? get type => _$this._type;
  set type(GroupJoinRequestResponseTypeEnum? type) => _$this._type = type;

  GroupJoinRequestResponseStatusEnum? _status;
  GroupJoinRequestResponseStatusEnum? get status => _$this._status;
  set status(GroupJoinRequestResponseStatusEnum? status) =>
      _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _decisionNote;
  String? get decisionNote => _$this._decisionNote;
  set decisionNote(String? decisionNote) => _$this._decisionNote = decisionNote;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  GroupResponseBuilder? _group;
  GroupResponseBuilder get group => _$this._group ??= GroupResponseBuilder();
  set group(GroupResponseBuilder? group) => _$this._group = group;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  GroupJoinRequestResponseBuilder() {
    GroupJoinRequestResponse._defaults(this);
  }

  GroupJoinRequestResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _groupId = $v.groupId;
      _userId = $v.userId;
      _requestedById = $v.requestedById;
      _decidedById = $v.decidedById;
      _type = $v.type;
      _status = $v.status;
      _message = $v.message;
      _decisionNote = $v.decisionNote;
      _expiresAt = $v.expiresAt;
      _createdAt = $v.createdAt;
      _decidedAt = $v.decidedAt;
      _group = $v.group?.toBuilder();
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupJoinRequestResponse other) {
    _$v = other as _$GroupJoinRequestResponse;
  }

  @override
  void update(void Function(GroupJoinRequestResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupJoinRequestResponse build() => _build();

  _$GroupJoinRequestResponse _build() {
    _$GroupJoinRequestResponse _$result;
    try {
      _$result = _$v ??
          _$GroupJoinRequestResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GroupJoinRequestResponse', 'id'),
            groupId: BuiltValueNullFieldError.checkNotNull(
                groupId, r'GroupJoinRequestResponse', 'groupId'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'GroupJoinRequestResponse', 'userId'),
            requestedById: BuiltValueNullFieldError.checkNotNull(
                requestedById, r'GroupJoinRequestResponse', 'requestedById'),
            decidedById: decidedById,
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'GroupJoinRequestResponse', 'type'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GroupJoinRequestResponse', 'status'),
            message: message,
            decisionNote: decisionNote,
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'GroupJoinRequestResponse', 'expiresAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'GroupJoinRequestResponse', 'createdAt'),
            decidedAt: decidedAt,
            group: _group?.build(),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'group';
        _group?.build();
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupJoinRequestResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
