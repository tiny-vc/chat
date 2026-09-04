// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_file_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StoredFileResponseScopeEnum _$storedFileResponseScopeEnum_PRIVATE =
    const StoredFileResponseScopeEnum._('PRIVATE');
const StoredFileResponseScopeEnum _$storedFileResponseScopeEnum_DIRECT =
    const StoredFileResponseScopeEnum._('DIRECT');
const StoredFileResponseScopeEnum _$storedFileResponseScopeEnum_GROUP =
    const StoredFileResponseScopeEnum._('GROUP');
const StoredFileResponseScopeEnum
    _$storedFileResponseScopeEnum_unknownDefaultOpenApi =
    const StoredFileResponseScopeEnum._('unknownDefaultOpenApi');

StoredFileResponseScopeEnum _$storedFileResponseScopeEnumValueOf(String name) {
  switch (name) {
    case 'PRIVATE':
      return _$storedFileResponseScopeEnum_PRIVATE;
    case 'DIRECT':
      return _$storedFileResponseScopeEnum_DIRECT;
    case 'GROUP':
      return _$storedFileResponseScopeEnum_GROUP;
    case 'unknownDefaultOpenApi':
      return _$storedFileResponseScopeEnum_unknownDefaultOpenApi;
    default:
      return _$storedFileResponseScopeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<StoredFileResponseScopeEnum>
    _$storedFileResponseScopeEnumValues =
    BuiltSet<StoredFileResponseScopeEnum>(const <StoredFileResponseScopeEnum>[
  _$storedFileResponseScopeEnum_PRIVATE,
  _$storedFileResponseScopeEnum_DIRECT,
  _$storedFileResponseScopeEnum_GROUP,
  _$storedFileResponseScopeEnum_unknownDefaultOpenApi,
]);

const StoredFileResponseStatusEnum _$storedFileResponseStatusEnum_PENDING =
    const StoredFileResponseStatusEnum._('PENDING');
const StoredFileResponseStatusEnum _$storedFileResponseStatusEnum_UPLOADED =
    const StoredFileResponseStatusEnum._('UPLOADED');
const StoredFileResponseStatusEnum _$storedFileResponseStatusEnum_READY =
    const StoredFileResponseStatusEnum._('READY');
const StoredFileResponseStatusEnum _$storedFileResponseStatusEnum_REJECTED =
    const StoredFileResponseStatusEnum._('REJECTED');
const StoredFileResponseStatusEnum _$storedFileResponseStatusEnum_DELETED =
    const StoredFileResponseStatusEnum._('DELETED');
const StoredFileResponseStatusEnum
    _$storedFileResponseStatusEnum_unknownDefaultOpenApi =
    const StoredFileResponseStatusEnum._('unknownDefaultOpenApi');

StoredFileResponseStatusEnum _$storedFileResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$storedFileResponseStatusEnum_PENDING;
    case 'UPLOADED':
      return _$storedFileResponseStatusEnum_UPLOADED;
    case 'READY':
      return _$storedFileResponseStatusEnum_READY;
    case 'REJECTED':
      return _$storedFileResponseStatusEnum_REJECTED;
    case 'DELETED':
      return _$storedFileResponseStatusEnum_DELETED;
    case 'unknownDefaultOpenApi':
      return _$storedFileResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$storedFileResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<StoredFileResponseStatusEnum>
    _$storedFileResponseStatusEnumValues =
    BuiltSet<StoredFileResponseStatusEnum>(const <StoredFileResponseStatusEnum>[
  _$storedFileResponseStatusEnum_PENDING,
  _$storedFileResponseStatusEnum_UPLOADED,
  _$storedFileResponseStatusEnum_READY,
  _$storedFileResponseStatusEnum_REJECTED,
  _$storedFileResponseStatusEnum_DELETED,
  _$storedFileResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<StoredFileResponseScopeEnum>
    _$storedFileResponseScopeEnumSerializer =
    _$StoredFileResponseScopeEnumSerializer();
Serializer<StoredFileResponseStatusEnum>
    _$storedFileResponseStatusEnumSerializer =
    _$StoredFileResponseStatusEnumSerializer();

class _$StoredFileResponseScopeEnumSerializer
    implements PrimitiveSerializer<StoredFileResponseScopeEnum> {
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
  final Iterable<Type> types = const <Type>[StoredFileResponseScopeEnum];
  @override
  final String wireName = 'StoredFileResponseScopeEnum';

  @override
  Object serialize(Serializers serializers, StoredFileResponseScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoredFileResponseScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoredFileResponseScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoredFileResponseStatusEnumSerializer
    implements PrimitiveSerializer<StoredFileResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'UPLOADED': 'UPLOADED',
    'READY': 'READY',
    'REJECTED': 'REJECTED',
    'DELETED': 'DELETED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'UPLOADED': 'UPLOADED',
    'READY': 'READY',
    'REJECTED': 'REJECTED',
    'DELETED': 'DELETED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[StoredFileResponseStatusEnum];
  @override
  final String wireName = 'StoredFileResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, StoredFileResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StoredFileResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StoredFileResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StoredFileResponse extends StoredFileResponse {
  @override
  final String id;
  @override
  final String originalName;
  @override
  final String mimeType;
  @override
  final String sizeBytes;
  @override
  final String purpose;
  @override
  final StoredFileResponseScopeEnum scope;
  @override
  final String? scopeId;
  @override
  final String? thumbnailFileId;
  @override
  final StoredFileResponseStatusEnum status;
  @override
  final DateTime? uploadedAt;
  @override
  final DateTime? createdAt;

  factory _$StoredFileResponse(
          [void Function(StoredFileResponseBuilder)? updates]) =>
      (StoredFileResponseBuilder()..update(updates))._build();

  _$StoredFileResponse._(
      {required this.id,
      required this.originalName,
      required this.mimeType,
      required this.sizeBytes,
      required this.purpose,
      required this.scope,
      this.scopeId,
      this.thumbnailFileId,
      required this.status,
      this.uploadedAt,
      this.createdAt})
      : super._();
  @override
  StoredFileResponse rebuild(
          void Function(StoredFileResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StoredFileResponseBuilder toBuilder() =>
      StoredFileResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StoredFileResponse &&
        id == other.id &&
        originalName == other.originalName &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        purpose == other.purpose &&
        scope == other.scope &&
        scopeId == other.scopeId &&
        thumbnailFileId == other.thumbnailFileId &&
        status == other.status &&
        uploadedAt == other.uploadedAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, originalName.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, scopeId.hashCode);
    _$hash = $jc(_$hash, thumbnailFileId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StoredFileResponse')
          ..add('id', id)
          ..add('originalName', originalName)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('purpose', purpose)
          ..add('scope', scope)
          ..add('scopeId', scopeId)
          ..add('thumbnailFileId', thumbnailFileId)
          ..add('status', status)
          ..add('uploadedAt', uploadedAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class StoredFileResponseBuilder
    implements Builder<StoredFileResponse, StoredFileResponseBuilder> {
  _$StoredFileResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _originalName;
  String? get originalName => _$this._originalName;
  set originalName(String? originalName) => _$this._originalName = originalName;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  String? _sizeBytes;
  String? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(String? sizeBytes) => _$this._sizeBytes = sizeBytes;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  StoredFileResponseScopeEnum? _scope;
  StoredFileResponseScopeEnum? get scope => _$this._scope;
  set scope(StoredFileResponseScopeEnum? scope) => _$this._scope = scope;

  String? _scopeId;
  String? get scopeId => _$this._scopeId;
  set scopeId(String? scopeId) => _$this._scopeId = scopeId;

  String? _thumbnailFileId;
  String? get thumbnailFileId => _$this._thumbnailFileId;
  set thumbnailFileId(String? thumbnailFileId) =>
      _$this._thumbnailFileId = thumbnailFileId;

  StoredFileResponseStatusEnum? _status;
  StoredFileResponseStatusEnum? get status => _$this._status;
  set status(StoredFileResponseStatusEnum? status) => _$this._status = status;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  StoredFileResponseBuilder() {
    StoredFileResponse._defaults(this);
  }

  StoredFileResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _originalName = $v.originalName;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _purpose = $v.purpose;
      _scope = $v.scope;
      _scopeId = $v.scopeId;
      _thumbnailFileId = $v.thumbnailFileId;
      _status = $v.status;
      _uploadedAt = $v.uploadedAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StoredFileResponse other) {
    _$v = other as _$StoredFileResponse;
  }

  @override
  void update(void Function(StoredFileResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StoredFileResponse build() => _build();

  _$StoredFileResponse _build() {
    final _$result = _$v ??
        _$StoredFileResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'StoredFileResponse', 'id'),
          originalName: BuiltValueNullFieldError.checkNotNull(
              originalName, r'StoredFileResponse', 'originalName'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'StoredFileResponse', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'StoredFileResponse', 'sizeBytes'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'StoredFileResponse', 'purpose'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'StoredFileResponse', 'scope'),
          scopeId: scopeId,
          thumbnailFileId: thumbnailFileId,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'StoredFileResponse', 'status'),
          uploadedAt: uploadedAt,
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
