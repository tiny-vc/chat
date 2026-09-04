// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupResponseStatusEnum _$groupResponseStatusEnum_ACTIVE =
    const GroupResponseStatusEnum._('ACTIVE');
const GroupResponseStatusEnum _$groupResponseStatusEnum_DISBANDED =
    const GroupResponseStatusEnum._('DISBANDED');
const GroupResponseStatusEnum _$groupResponseStatusEnum_SUSPENDED =
    const GroupResponseStatusEnum._('SUSPENDED');
const GroupResponseStatusEnum _$groupResponseStatusEnum_unknownDefaultOpenApi =
    const GroupResponseStatusEnum._('unknownDefaultOpenApi');

GroupResponseStatusEnum _$groupResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'ACTIVE':
      return _$groupResponseStatusEnum_ACTIVE;
    case 'DISBANDED':
      return _$groupResponseStatusEnum_DISBANDED;
    case 'SUSPENDED':
      return _$groupResponseStatusEnum_SUSPENDED;
    case 'unknownDefaultOpenApi':
      return _$groupResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$groupResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<GroupResponseStatusEnum> _$groupResponseStatusEnumValues =
    BuiltSet<GroupResponseStatusEnum>(const <GroupResponseStatusEnum>[
  _$groupResponseStatusEnum_ACTIVE,
  _$groupResponseStatusEnum_DISBANDED,
  _$groupResponseStatusEnum_SUSPENDED,
  _$groupResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<GroupResponseStatusEnum> _$groupResponseStatusEnumSerializer =
    _$GroupResponseStatusEnumSerializer();

class _$GroupResponseStatusEnumSerializer
    implements PrimitiveSerializer<GroupResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACTIVE': 'ACTIVE',
    'DISBANDED': 'DISBANDED',
    'SUSPENDED': 'SUSPENDED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACTIVE': 'ACTIVE',
    'DISBANDED': 'DISBANDED',
    'SUSPENDED': 'SUSPENDED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[GroupResponseStatusEnum];
  @override
  final String wireName = 'GroupResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, GroupResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GroupResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GroupResponse extends GroupResponse {
  @override
  final String id;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  final String? avatarFileId;
  @override
  final int memberLimit;
  @override
  final bool muteAll;
  @override
  final GroupResponseStatusEnum status;
  @override
  final BuiltList<GroupMemberResponse>? members;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$GroupResponse([void Function(GroupResponseBuilder)? updates]) =>
      (GroupResponseBuilder()..update(updates))._build();

  _$GroupResponse._(
      {required this.id,
      required this.name,
      required this.ownerId,
      this.avatarFileId,
      required this.memberLimit,
      required this.muteAll,
      required this.status,
      this.members,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  GroupResponse rebuild(void Function(GroupResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupResponseBuilder toBuilder() => GroupResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupResponse &&
        id == other.id &&
        name == other.name &&
        ownerId == other.ownerId &&
        avatarFileId == other.avatarFileId &&
        memberLimit == other.memberLimit &&
        muteAll == other.muteAll &&
        status == other.status &&
        members == other.members &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, avatarFileId.hashCode);
    _$hash = $jc(_$hash, memberLimit.hashCode);
    _$hash = $jc(_$hash, muteAll.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupResponse')
          ..add('id', id)
          ..add('name', name)
          ..add('ownerId', ownerId)
          ..add('avatarFileId', avatarFileId)
          ..add('memberLimit', memberLimit)
          ..add('muteAll', muteAll)
          ..add('status', status)
          ..add('members', members)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class GroupResponseBuilder
    implements Builder<GroupResponse, GroupResponseBuilder> {
  _$GroupResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _ownerId;
  String? get ownerId => _$this._ownerId;
  set ownerId(String? ownerId) => _$this._ownerId = ownerId;

  String? _avatarFileId;
  String? get avatarFileId => _$this._avatarFileId;
  set avatarFileId(String? avatarFileId) => _$this._avatarFileId = avatarFileId;

  int? _memberLimit;
  int? get memberLimit => _$this._memberLimit;
  set memberLimit(int? memberLimit) => _$this._memberLimit = memberLimit;

  bool? _muteAll;
  bool? get muteAll => _$this._muteAll;
  set muteAll(bool? muteAll) => _$this._muteAll = muteAll;

  GroupResponseStatusEnum? _status;
  GroupResponseStatusEnum? get status => _$this._status;
  set status(GroupResponseStatusEnum? status) => _$this._status = status;

  ListBuilder<GroupMemberResponse>? _members;
  ListBuilder<GroupMemberResponse> get members =>
      _$this._members ??= ListBuilder<GroupMemberResponse>();
  set members(ListBuilder<GroupMemberResponse>? members) =>
      _$this._members = members;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  GroupResponseBuilder() {
    GroupResponse._defaults(this);
  }

  GroupResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _ownerId = $v.ownerId;
      _avatarFileId = $v.avatarFileId;
      _memberLimit = $v.memberLimit;
      _muteAll = $v.muteAll;
      _status = $v.status;
      _members = $v.members?.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupResponse other) {
    _$v = other as _$GroupResponse;
  }

  @override
  void update(void Function(GroupResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupResponse build() => _build();

  _$GroupResponse _build() {
    _$GroupResponse _$result;
    try {
      _$result = _$v ??
          _$GroupResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GroupResponse', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupResponse', 'name'),
            ownerId: BuiltValueNullFieldError.checkNotNull(
                ownerId, r'GroupResponse', 'ownerId'),
            avatarFileId: avatarFileId,
            memberLimit: BuiltValueNullFieldError.checkNotNull(
                memberLimit, r'GroupResponse', 'memberLimit'),
            muteAll: BuiltValueNullFieldError.checkNotNull(
                muteAll, r'GroupResponse', 'muteAll'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GroupResponse', 'status'),
            members: _members?.build(),
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'members';
        _members?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
