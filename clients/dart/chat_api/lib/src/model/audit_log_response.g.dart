// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuditLogResponse extends AuditLogResponse {
  @override
  final String id;
  @override
  final String? actorUserId;
  @override
  final String action;
  @override
  final String targetType;
  @override
  final String targetId;
  @override
  final BuiltMap<String, JsonObject?>? metadata;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?>? actor;

  factory _$AuditLogResponse(
          [void Function(AuditLogResponseBuilder)? updates]) =>
      (AuditLogResponseBuilder()..update(updates))._build();

  _$AuditLogResponse._(
      {required this.id,
      this.actorUserId,
      required this.action,
      required this.targetType,
      required this.targetId,
      this.metadata,
      required this.createdAt,
      this.actor})
      : super._();
  @override
  AuditLogResponse rebuild(void Function(AuditLogResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuditLogResponseBuilder toBuilder() =>
      AuditLogResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuditLogResponse &&
        id == other.id &&
        actorUserId == other.actorUserId &&
        action == other.action &&
        targetType == other.targetType &&
        targetId == other.targetId &&
        metadata == other.metadata &&
        createdAt == other.createdAt &&
        actor == other.actor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, actorUserId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuditLogResponse')
          ..add('id', id)
          ..add('actorUserId', actorUserId)
          ..add('action', action)
          ..add('targetType', targetType)
          ..add('targetId', targetId)
          ..add('metadata', metadata)
          ..add('createdAt', createdAt)
          ..add('actor', actor))
        .toString();
  }
}

class AuditLogResponseBuilder
    implements Builder<AuditLogResponse, AuditLogResponseBuilder> {
  _$AuditLogResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _actorUserId;
  String? get actorUserId => _$this._actorUserId;
  set actorUserId(String? actorUserId) => _$this._actorUserId = actorUserId;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  String? _targetId;
  String? get targetId => _$this._targetId;
  set targetId(String? targetId) => _$this._targetId = targetId;

  MapBuilder<String, JsonObject?>? _metadata;
  MapBuilder<String, JsonObject?> get metadata =>
      _$this._metadata ??= MapBuilder<String, JsonObject?>();
  set metadata(MapBuilder<String, JsonObject?>? metadata) =>
      _$this._metadata = metadata;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _actor;
  MapBuilder<String, JsonObject?> get actor =>
      _$this._actor ??= MapBuilder<String, JsonObject?>();
  set actor(MapBuilder<String, JsonObject?>? actor) => _$this._actor = actor;

  AuditLogResponseBuilder() {
    AuditLogResponse._defaults(this);
  }

  AuditLogResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _actorUserId = $v.actorUserId;
      _action = $v.action;
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _metadata = $v.metadata?.toBuilder();
      _createdAt = $v.createdAt;
      _actor = $v.actor?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuditLogResponse other) {
    _$v = other as _$AuditLogResponse;
  }

  @override
  void update(void Function(AuditLogResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuditLogResponse build() => _build();

  _$AuditLogResponse _build() {
    _$AuditLogResponse _$result;
    try {
      _$result = _$v ??
          _$AuditLogResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AuditLogResponse', 'id'),
            actorUserId: actorUserId,
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'AuditLogResponse', 'action'),
            targetType: BuiltValueNullFieldError.checkNotNull(
                targetType, r'AuditLogResponse', 'targetType'),
            targetId: BuiltValueNullFieldError.checkNotNull(
                targetId, r'AuditLogResponse', 'targetId'),
            metadata: _metadata?.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AuditLogResponse', 'createdAt'),
            actor: _actor?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        _metadata?.build();

        _$failedField = 'actor';
        _actor?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AuditLogResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
