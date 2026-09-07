// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReportResponseStatusEnum _$adminReportResponseStatusEnum_PENDING =
    const AdminReportResponseStatusEnum._('PENDING');
const AdminReportResponseStatusEnum _$adminReportResponseStatusEnum_RESOLVED =
    const AdminReportResponseStatusEnum._('RESOLVED');
const AdminReportResponseStatusEnum _$adminReportResponseStatusEnum_DISMISSED =
    const AdminReportResponseStatusEnum._('DISMISSED');
const AdminReportResponseStatusEnum
    _$adminReportResponseStatusEnum_unknownDefaultOpenApi =
    const AdminReportResponseStatusEnum._('unknownDefaultOpenApi');

AdminReportResponseStatusEnum _$adminReportResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$adminReportResponseStatusEnum_PENDING;
    case 'RESOLVED':
      return _$adminReportResponseStatusEnum_RESOLVED;
    case 'DISMISSED':
      return _$adminReportResponseStatusEnum_DISMISSED;
    case 'unknownDefaultOpenApi':
      return _$adminReportResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminReportResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminReportResponseStatusEnum>
    _$adminReportResponseStatusEnumValues = BuiltSet<
        AdminReportResponseStatusEnum>(const <AdminReportResponseStatusEnum>[
  _$adminReportResponseStatusEnum_PENDING,
  _$adminReportResponseStatusEnum_RESOLVED,
  _$adminReportResponseStatusEnum_DISMISSED,
  _$adminReportResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<AdminReportResponseStatusEnum>
    _$adminReportResponseStatusEnumSerializer =
    _$AdminReportResponseStatusEnumSerializer();

class _$AdminReportResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminReportResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'RESOLVED': 'RESOLVED',
    'DISMISSED': 'DISMISSED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'RESOLVED': 'RESOLVED',
    'DISMISSED': 'DISMISSED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminReportResponseStatusEnum];
  @override
  final String wireName = 'AdminReportResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminReportResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminReportResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminReportResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminReportResponse extends AdminReportResponse {
  @override
  final String id;
  @override
  final String reporterUserId;
  @override
  final String targetUserId;
  @override
  final String reason;
  @override
  final String? details;
  @override
  final AdminReportResponseStatusEnum status;
  @override
  final String? decidedById;
  @override
  final String? decisionNote;
  @override
  final DateTime createdAt;
  @override
  final DateTime? decidedAt;
  @override
  final BuiltMap<String, JsonObject?> reporter;
  @override
  final BuiltMap<String, JsonObject?> target;
  @override
  final BuiltMap<String, JsonObject?>? decidedBy;

  factory _$AdminReportResponse(
          [void Function(AdminReportResponseBuilder)? updates]) =>
      (AdminReportResponseBuilder()..update(updates))._build();

  _$AdminReportResponse._(
      {required this.id,
      required this.reporterUserId,
      required this.targetUserId,
      required this.reason,
      this.details,
      required this.status,
      this.decidedById,
      this.decisionNote,
      required this.createdAt,
      this.decidedAt,
      required this.reporter,
      required this.target,
      this.decidedBy})
      : super._();
  @override
  AdminReportResponse rebuild(
          void Function(AdminReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportResponseBuilder toBuilder() =>
      AdminReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportResponse &&
        id == other.id &&
        reporterUserId == other.reporterUserId &&
        targetUserId == other.targetUserId &&
        reason == other.reason &&
        details == other.details &&
        status == other.status &&
        decidedById == other.decidedById &&
        decisionNote == other.decisionNote &&
        createdAt == other.createdAt &&
        decidedAt == other.decidedAt &&
        reporter == other.reporter &&
        target == other.target &&
        decidedBy == other.decidedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reporterUserId.hashCode);
    _$hash = $jc(_$hash, targetUserId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, decidedById.hashCode);
    _$hash = $jc(_$hash, decisionNote.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, reporter.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, decidedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReportResponse')
          ..add('id', id)
          ..add('reporterUserId', reporterUserId)
          ..add('targetUserId', targetUserId)
          ..add('reason', reason)
          ..add('details', details)
          ..add('status', status)
          ..add('decidedById', decidedById)
          ..add('decisionNote', decisionNote)
          ..add('createdAt', createdAt)
          ..add('decidedAt', decidedAt)
          ..add('reporter', reporter)
          ..add('target', target)
          ..add('decidedBy', decidedBy))
        .toString();
  }
}

class AdminReportResponseBuilder
    implements Builder<AdminReportResponse, AdminReportResponseBuilder> {
  _$AdminReportResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reporterUserId;
  String? get reporterUserId => _$this._reporterUserId;
  set reporterUserId(String? reporterUserId) =>
      _$this._reporterUserId = reporterUserId;

  String? _targetUserId;
  String? get targetUserId => _$this._targetUserId;
  set targetUserId(String? targetUserId) => _$this._targetUserId = targetUserId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  AdminReportResponseStatusEnum? _status;
  AdminReportResponseStatusEnum? get status => _$this._status;
  set status(AdminReportResponseStatusEnum? status) => _$this._status = status;

  String? _decidedById;
  String? get decidedById => _$this._decidedById;
  set decidedById(String? decidedById) => _$this._decidedById = decidedById;

  String? _decisionNote;
  String? get decisionNote => _$this._decisionNote;
  set decisionNote(String? decisionNote) => _$this._decisionNote = decisionNote;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  MapBuilder<String, JsonObject?>? _reporter;
  MapBuilder<String, JsonObject?> get reporter =>
      _$this._reporter ??= MapBuilder<String, JsonObject?>();
  set reporter(MapBuilder<String, JsonObject?>? reporter) =>
      _$this._reporter = reporter;

  MapBuilder<String, JsonObject?>? _target;
  MapBuilder<String, JsonObject?> get target =>
      _$this._target ??= MapBuilder<String, JsonObject?>();
  set target(MapBuilder<String, JsonObject?>? target) =>
      _$this._target = target;

  MapBuilder<String, JsonObject?>? _decidedBy;
  MapBuilder<String, JsonObject?> get decidedBy =>
      _$this._decidedBy ??= MapBuilder<String, JsonObject?>();
  set decidedBy(MapBuilder<String, JsonObject?>? decidedBy) =>
      _$this._decidedBy = decidedBy;

  AdminReportResponseBuilder() {
    AdminReportResponse._defaults(this);
  }

  AdminReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reporterUserId = $v.reporterUserId;
      _targetUserId = $v.targetUserId;
      _reason = $v.reason;
      _details = $v.details;
      _status = $v.status;
      _decidedById = $v.decidedById;
      _decisionNote = $v.decisionNote;
      _createdAt = $v.createdAt;
      _decidedAt = $v.decidedAt;
      _reporter = $v.reporter.toBuilder();
      _target = $v.target.toBuilder();
      _decidedBy = $v.decidedBy?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportResponse other) {
    _$v = other as _$AdminReportResponse;
  }

  @override
  void update(void Function(AdminReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportResponse build() => _build();

  _$AdminReportResponse _build() {
    _$AdminReportResponse _$result;
    try {
      _$result = _$v ??
          _$AdminReportResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminReportResponse', 'id'),
            reporterUserId: BuiltValueNullFieldError.checkNotNull(
                reporterUserId, r'AdminReportResponse', 'reporterUserId'),
            targetUserId: BuiltValueNullFieldError.checkNotNull(
                targetUserId, r'AdminReportResponse', 'targetUserId'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AdminReportResponse', 'reason'),
            details: details,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminReportResponse', 'status'),
            decidedById: decidedById,
            decisionNote: decisionNote,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminReportResponse', 'createdAt'),
            decidedAt: decidedAt,
            reporter: reporter.build(),
            target: target.build(),
            decidedBy: _decidedBy?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'reporter';
        reporter.build();
        _$failedField = 'target';
        target.build();
        _$failedField = 'decidedBy';
        _decidedBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
