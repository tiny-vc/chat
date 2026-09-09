// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_file_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminFileResponseScopeEnum _$adminFileResponseScopeEnum_PRIVATE =
    const AdminFileResponseScopeEnum._('PRIVATE');
const AdminFileResponseScopeEnum _$adminFileResponseScopeEnum_DIRECT =
    const AdminFileResponseScopeEnum._('DIRECT');
const AdminFileResponseScopeEnum _$adminFileResponseScopeEnum_GROUP =
    const AdminFileResponseScopeEnum._('GROUP');
const AdminFileResponseScopeEnum
    _$adminFileResponseScopeEnum_unknownDefaultOpenApi =
    const AdminFileResponseScopeEnum._('unknownDefaultOpenApi');

AdminFileResponseScopeEnum _$adminFileResponseScopeEnumValueOf(String name) {
  switch (name) {
    case 'PRIVATE':
      return _$adminFileResponseScopeEnum_PRIVATE;
    case 'DIRECT':
      return _$adminFileResponseScopeEnum_DIRECT;
    case 'GROUP':
      return _$adminFileResponseScopeEnum_GROUP;
    case 'unknownDefaultOpenApi':
      return _$adminFileResponseScopeEnum_unknownDefaultOpenApi;
    default:
      return _$adminFileResponseScopeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminFileResponseScopeEnum> _$adminFileResponseScopeEnumValues =
    BuiltSet<AdminFileResponseScopeEnum>(const <AdminFileResponseScopeEnum>[
  _$adminFileResponseScopeEnum_PRIVATE,
  _$adminFileResponseScopeEnum_DIRECT,
  _$adminFileResponseScopeEnum_GROUP,
  _$adminFileResponseScopeEnum_unknownDefaultOpenApi,
]);

const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_PENDING =
    const AdminFileResponseStatusEnum._('PENDING');
const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_UPLOADED =
    const AdminFileResponseStatusEnum._('UPLOADED');
const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_READY =
    const AdminFileResponseStatusEnum._('READY');
const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_REJECTED =
    const AdminFileResponseStatusEnum._('REJECTED');
const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_DELETE_PENDING =
    const AdminFileResponseStatusEnum._('DELETE_PENDING');
const AdminFileResponseStatusEnum _$adminFileResponseStatusEnum_DELETED =
    const AdminFileResponseStatusEnum._('DELETED');
const AdminFileResponseStatusEnum
    _$adminFileResponseStatusEnum_unknownDefaultOpenApi =
    const AdminFileResponseStatusEnum._('unknownDefaultOpenApi');

AdminFileResponseStatusEnum _$adminFileResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$adminFileResponseStatusEnum_PENDING;
    case 'UPLOADED':
      return _$adminFileResponseStatusEnum_UPLOADED;
    case 'READY':
      return _$adminFileResponseStatusEnum_READY;
    case 'REJECTED':
      return _$adminFileResponseStatusEnum_REJECTED;
    case 'DELETE_PENDING':
      return _$adminFileResponseStatusEnum_DELETE_PENDING;
    case 'DELETED':
      return _$adminFileResponseStatusEnum_DELETED;
    case 'unknownDefaultOpenApi':
      return _$adminFileResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminFileResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminFileResponseStatusEnum>
    _$adminFileResponseStatusEnumValues =
    BuiltSet<AdminFileResponseStatusEnum>(const <AdminFileResponseStatusEnum>[
  _$adminFileResponseStatusEnum_PENDING,
  _$adminFileResponseStatusEnum_UPLOADED,
  _$adminFileResponseStatusEnum_READY,
  _$adminFileResponseStatusEnum_REJECTED,
  _$adminFileResponseStatusEnum_DELETE_PENDING,
  _$adminFileResponseStatusEnum_DELETED,
  _$adminFileResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<AdminFileResponseScopeEnum> _$adminFileResponseScopeEnumSerializer =
    _$AdminFileResponseScopeEnumSerializer();
Serializer<AdminFileResponseStatusEnum>
    _$adminFileResponseStatusEnumSerializer =
    _$AdminFileResponseStatusEnumSerializer();

class _$AdminFileResponseScopeEnumSerializer
    implements PrimitiveSerializer<AdminFileResponseScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRIVATE': 'PRIVATE',
    'DIRECT': 'DIRECT',
    'GROUP': 'GROUP',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRIVATE': 'PRIVATE',
    'DIRECT': 'DIRECT',
    'GROUP': 'GROUP',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminFileResponseScopeEnum];
  @override
  final String wireName = 'AdminFileResponseScopeEnum';

  @override
  Object serialize(Serializers serializers, AdminFileResponseScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminFileResponseScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminFileResponseScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminFileResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminFileResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'UPLOADED': 'UPLOADED',
    'READY': 'READY',
    'REJECTED': 'REJECTED',
    'DELETE_PENDING': 'DELETE_PENDING',
    'DELETED': 'DELETED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'UPLOADED': 'UPLOADED',
    'READY': 'READY',
    'REJECTED': 'REJECTED',
    'DELETE_PENDING': 'DELETE_PENDING',
    'DELETED': 'DELETED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminFileResponseStatusEnum];
  @override
  final String wireName = 'AdminFileResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, AdminFileResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminFileResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminFileResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminFileResponse extends AdminFileResponse {
  @override
  final String id;
  @override
  final String ownerUserId;
  @override
  final String originalName;
  @override
  final String mimeType;
  @override
  final String sizeBytes;
  @override
  final String? sha256;
  @override
  final String purpose;
  @override
  final AdminFileResponseScopeEnum scope;
  @override
  final String? scopeId;
  @override
  final AdminFileResponseStatusEnum status;
  @override
  final String? thumbnailFileId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? uploadedAt;
  @override
  final BuiltMap<String, JsonObject?> owner;

  factory _$AdminFileResponse(
          [void Function(AdminFileResponseBuilder)? updates]) =>
      (AdminFileResponseBuilder()..update(updates))._build();

  _$AdminFileResponse._(
      {required this.id,
      required this.ownerUserId,
      required this.originalName,
      required this.mimeType,
      required this.sizeBytes,
      this.sha256,
      required this.purpose,
      required this.scope,
      this.scopeId,
      required this.status,
      this.thumbnailFileId,
      required this.createdAt,
      this.uploadedAt,
      required this.owner})
      : super._();
  @override
  AdminFileResponse rebuild(void Function(AdminFileResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminFileResponseBuilder toBuilder() =>
      AdminFileResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFileResponse &&
        id == other.id &&
        ownerUserId == other.ownerUserId &&
        originalName == other.originalName &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        sha256 == other.sha256 &&
        purpose == other.purpose &&
        scope == other.scope &&
        scopeId == other.scopeId &&
        status == other.status &&
        thumbnailFileId == other.thumbnailFileId &&
        createdAt == other.createdAt &&
        uploadedAt == other.uploadedAt &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, ownerUserId.hashCode);
    _$hash = $jc(_$hash, originalName.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, sha256.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, scopeId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, thumbnailFileId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminFileResponse')
          ..add('id', id)
          ..add('ownerUserId', ownerUserId)
          ..add('originalName', originalName)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('sha256', sha256)
          ..add('purpose', purpose)
          ..add('scope', scope)
          ..add('scopeId', scopeId)
          ..add('status', status)
          ..add('thumbnailFileId', thumbnailFileId)
          ..add('createdAt', createdAt)
          ..add('uploadedAt', uploadedAt)
          ..add('owner', owner))
        .toString();
  }
}

class AdminFileResponseBuilder
    implements Builder<AdminFileResponse, AdminFileResponseBuilder> {
  _$AdminFileResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _ownerUserId;
  String? get ownerUserId => _$this._ownerUserId;
  set ownerUserId(String? ownerUserId) => _$this._ownerUserId = ownerUserId;

  String? _originalName;
  String? get originalName => _$this._originalName;
  set originalName(String? originalName) => _$this._originalName = originalName;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  String? _sizeBytes;
  String? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(String? sizeBytes) => _$this._sizeBytes = sizeBytes;

  String? _sha256;
  String? get sha256 => _$this._sha256;
  set sha256(String? sha256) => _$this._sha256 = sha256;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  AdminFileResponseScopeEnum? _scope;
  AdminFileResponseScopeEnum? get scope => _$this._scope;
  set scope(AdminFileResponseScopeEnum? scope) => _$this._scope = scope;

  String? _scopeId;
  String? get scopeId => _$this._scopeId;
  set scopeId(String? scopeId) => _$this._scopeId = scopeId;

  AdminFileResponseStatusEnum? _status;
  AdminFileResponseStatusEnum? get status => _$this._status;
  set status(AdminFileResponseStatusEnum? status) => _$this._status = status;

  String? _thumbnailFileId;
  String? get thumbnailFileId => _$this._thumbnailFileId;
  set thumbnailFileId(String? thumbnailFileId) =>
      _$this._thumbnailFileId = thumbnailFileId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  MapBuilder<String, JsonObject?>? _owner;
  MapBuilder<String, JsonObject?> get owner =>
      _$this._owner ??= MapBuilder<String, JsonObject?>();
  set owner(MapBuilder<String, JsonObject?>? owner) => _$this._owner = owner;

  AdminFileResponseBuilder() {
    AdminFileResponse._defaults(this);
  }

  AdminFileResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _ownerUserId = $v.ownerUserId;
      _originalName = $v.originalName;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _sha256 = $v.sha256;
      _purpose = $v.purpose;
      _scope = $v.scope;
      _scopeId = $v.scopeId;
      _status = $v.status;
      _thumbnailFileId = $v.thumbnailFileId;
      _createdAt = $v.createdAt;
      _uploadedAt = $v.uploadedAt;
      _owner = $v.owner.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFileResponse other) {
    _$v = other as _$AdminFileResponse;
  }

  @override
  void update(void Function(AdminFileResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFileResponse build() => _build();

  _$AdminFileResponse _build() {
    _$AdminFileResponse _$result;
    try {
      _$result = _$v ??
          _$AdminFileResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminFileResponse', 'id'),
            ownerUserId: BuiltValueNullFieldError.checkNotNull(
                ownerUserId, r'AdminFileResponse', 'ownerUserId'),
            originalName: BuiltValueNullFieldError.checkNotNull(
                originalName, r'AdminFileResponse', 'originalName'),
            mimeType: BuiltValueNullFieldError.checkNotNull(
                mimeType, r'AdminFileResponse', 'mimeType'),
            sizeBytes: BuiltValueNullFieldError.checkNotNull(
                sizeBytes, r'AdminFileResponse', 'sizeBytes'),
            sha256: sha256,
            purpose: BuiltValueNullFieldError.checkNotNull(
                purpose, r'AdminFileResponse', 'purpose'),
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'AdminFileResponse', 'scope'),
            scopeId: scopeId,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminFileResponse', 'status'),
            thumbnailFileId: thumbnailFileId,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminFileResponse', 'createdAt'),
            uploadedAt: uploadedAt,
            owner: owner.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        owner.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminFileResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
