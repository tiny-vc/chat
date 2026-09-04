// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_group_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminGroupResponseStatusEnum _$adminGroupResponseStatusEnum_ACTIVE =
    const AdminGroupResponseStatusEnum._('ACTIVE');
const AdminGroupResponseStatusEnum _$adminGroupResponseStatusEnum_DISBANDED =
    const AdminGroupResponseStatusEnum._('DISBANDED');
const AdminGroupResponseStatusEnum _$adminGroupResponseStatusEnum_SUSPENDED =
    const AdminGroupResponseStatusEnum._('SUSPENDED');
const AdminGroupResponseStatusEnum
    _$adminGroupResponseStatusEnum_unknownDefaultOpenApi =
    const AdminGroupResponseStatusEnum._('unknownDefaultOpenApi');

AdminGroupResponseStatusEnum _$adminGroupResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ACTIVE':
      return _$adminGroupResponseStatusEnum_ACTIVE;
    case 'DISBANDED':
      return _$adminGroupResponseStatusEnum_DISBANDED;
    case 'SUSPENDED':
      return _$adminGroupResponseStatusEnum_SUSPENDED;
    case 'unknownDefaultOpenApi':
      return _$adminGroupResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminGroupResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminGroupResponseStatusEnum>
    _$adminGroupResponseStatusEnumValues =
    BuiltSet<AdminGroupResponseStatusEnum>(const <AdminGroupResponseStatusEnum>[
  _$adminGroupResponseStatusEnum_ACTIVE,
  _$adminGroupResponseStatusEnum_DISBANDED,
  _$adminGroupResponseStatusEnum_SUSPENDED,
  _$adminGroupResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<AdminGroupResponseStatusEnum>
    _$adminGroupResponseStatusEnumSerializer =
    _$AdminGroupResponseStatusEnumSerializer();

class _$AdminGroupResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminGroupResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminGroupResponseStatusEnum];
  @override
  final String wireName = 'AdminGroupResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, AdminGroupResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminGroupResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminGroupResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminGroupResponse extends AdminGroupResponse {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;
  @override
  final String? avatarFileId;
  @override
  final String ownerId;
  @override
  final int memberLimit;
  @override
  final bool muteAll;
  @override
  final AdminGroupResponseStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final BuiltMap<String, JsonObject?>? owner;
  @override
  final BuiltMap<String, int>? count;

  factory _$AdminGroupResponse(
          [void Function(AdminGroupResponseBuilder)? updates]) =>
      (AdminGroupResponseBuilder()..update(updates))._build();

  _$AdminGroupResponse._(
      {required this.id,
      required this.name,
      this.avatarUrl,
      this.avatarFileId,
      required this.ownerId,
      required this.memberLimit,
      required this.muteAll,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.owner,
      this.count})
      : super._();
  @override
  AdminGroupResponse rebuild(
          void Function(AdminGroupResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGroupResponseBuilder toBuilder() =>
      AdminGroupResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGroupResponse &&
        id == other.id &&
        name == other.name &&
        avatarUrl == other.avatarUrl &&
        avatarFileId == other.avatarFileId &&
        ownerId == other.ownerId &&
        memberLimit == other.memberLimit &&
        muteAll == other.muteAll &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        owner == other.owner &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, avatarFileId.hashCode);
    _$hash = $jc(_$hash, ownerId.hashCode);
    _$hash = $jc(_$hash, memberLimit.hashCode);
    _$hash = $jc(_$hash, muteAll.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminGroupResponse')
          ..add('id', id)
          ..add('name', name)
          ..add('avatarUrl', avatarUrl)
          ..add('avatarFileId', avatarFileId)
          ..add('ownerId', ownerId)
          ..add('memberLimit', memberLimit)
          ..add('muteAll', muteAll)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('owner', owner)
          ..add('count', count))
        .toString();
  }
}

class AdminGroupResponseBuilder
    implements Builder<AdminGroupResponse, AdminGroupResponseBuilder> {
  _$AdminGroupResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _avatarFileId;
  String? get avatarFileId => _$this._avatarFileId;
  set avatarFileId(String? avatarFileId) => _$this._avatarFileId = avatarFileId;

  String? _ownerId;
  String? get ownerId => _$this._ownerId;
  set ownerId(String? ownerId) => _$this._ownerId = ownerId;

  int? _memberLimit;
  int? get memberLimit => _$this._memberLimit;
  set memberLimit(int? memberLimit) => _$this._memberLimit = memberLimit;

  bool? _muteAll;
  bool? get muteAll => _$this._muteAll;
  set muteAll(bool? muteAll) => _$this._muteAll = muteAll;

  AdminGroupResponseStatusEnum? _status;
  AdminGroupResponseStatusEnum? get status => _$this._status;
  set status(AdminGroupResponseStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  MapBuilder<String, JsonObject?>? _owner;
  MapBuilder<String, JsonObject?> get owner =>
      _$this._owner ??= MapBuilder<String, JsonObject?>();
  set owner(MapBuilder<String, JsonObject?>? owner) => _$this._owner = owner;

  MapBuilder<String, int>? _count;
  MapBuilder<String, int> get count =>
      _$this._count ??= MapBuilder<String, int>();
  set count(MapBuilder<String, int>? count) => _$this._count = count;

  AdminGroupResponseBuilder() {
    AdminGroupResponse._defaults(this);
  }

  AdminGroupResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _avatarUrl = $v.avatarUrl;
      _avatarFileId = $v.avatarFileId;
      _ownerId = $v.ownerId;
      _memberLimit = $v.memberLimit;
      _muteAll = $v.muteAll;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _owner = $v.owner?.toBuilder();
      _count = $v.count?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGroupResponse other) {
    _$v = other as _$AdminGroupResponse;
  }

  @override
  void update(void Function(AdminGroupResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGroupResponse build() => _build();

  _$AdminGroupResponse _build() {
    _$AdminGroupResponse _$result;
    try {
      _$result = _$v ??
          _$AdminGroupResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminGroupResponse', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'AdminGroupResponse', 'name'),
            avatarUrl: avatarUrl,
            avatarFileId: avatarFileId,
            ownerId: BuiltValueNullFieldError.checkNotNull(
                ownerId, r'AdminGroupResponse', 'ownerId'),
            memberLimit: BuiltValueNullFieldError.checkNotNull(
                memberLimit, r'AdminGroupResponse', 'memberLimit'),
            muteAll: BuiltValueNullFieldError.checkNotNull(
                muteAll, r'AdminGroupResponse', 'muteAll'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminGroupResponse', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminGroupResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'AdminGroupResponse', 'updatedAt'),
            owner: _owner?.build(),
            count: _count?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        _owner?.build();
        _$failedField = 'count';
        _count?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminGroupResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
