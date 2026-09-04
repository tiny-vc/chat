// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_run_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JobRunResponseStatusEnum _$jobRunResponseStatusEnum_RUNNING =
    const JobRunResponseStatusEnum._('RUNNING');
const JobRunResponseStatusEnum _$jobRunResponseStatusEnum_SUCCESS =
    const JobRunResponseStatusEnum._('SUCCESS');
const JobRunResponseStatusEnum _$jobRunResponseStatusEnum_FAILED =
    const JobRunResponseStatusEnum._('FAILED');
const JobRunResponseStatusEnum _$jobRunResponseStatusEnum_SKIPPED =
    const JobRunResponseStatusEnum._('SKIPPED');
const JobRunResponseStatusEnum
    _$jobRunResponseStatusEnum_unknownDefaultOpenApi =
    const JobRunResponseStatusEnum._('unknownDefaultOpenApi');

JobRunResponseStatusEnum _$jobRunResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'RUNNING':
      return _$jobRunResponseStatusEnum_RUNNING;
    case 'SUCCESS':
      return _$jobRunResponseStatusEnum_SUCCESS;
    case 'FAILED':
      return _$jobRunResponseStatusEnum_FAILED;
    case 'SKIPPED':
      return _$jobRunResponseStatusEnum_SKIPPED;
    case 'unknownDefaultOpenApi':
      return _$jobRunResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$jobRunResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<JobRunResponseStatusEnum> _$jobRunResponseStatusEnumValues =
    BuiltSet<JobRunResponseStatusEnum>(const <JobRunResponseStatusEnum>[
  _$jobRunResponseStatusEnum_RUNNING,
  _$jobRunResponseStatusEnum_SUCCESS,
  _$jobRunResponseStatusEnum_FAILED,
  _$jobRunResponseStatusEnum_SKIPPED,
  _$jobRunResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<JobRunResponseStatusEnum> _$jobRunResponseStatusEnumSerializer =
    _$JobRunResponseStatusEnumSerializer();

class _$JobRunResponseStatusEnumSerializer
    implements PrimitiveSerializer<JobRunResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RUNNING': 'RUNNING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'SKIPPED': 'SKIPPED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RUNNING': 'RUNNING',
    'SUCCESS': 'SUCCESS',
    'FAILED': 'FAILED',
    'SKIPPED': 'SKIPPED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[JobRunResponseStatusEnum];
  @override
  final String wireName = 'JobRunResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, JobRunResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JobRunResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JobRunResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$JobRunResponse extends JobRunResponse {
  @override
  final String id;
  @override
  final String jobName;
  @override
  final JobRunResponseStatusEnum status;
  @override
  final String trigger;
  @override
  final BuiltMap<String, JsonObject?>? metrics;
  @override
  final String? error;
  @override
  final DateTime startedAt;
  @override
  final DateTime? finishedAt;

  factory _$JobRunResponse([void Function(JobRunResponseBuilder)? updates]) =>
      (JobRunResponseBuilder()..update(updates))._build();

  _$JobRunResponse._(
      {required this.id,
      required this.jobName,
      required this.status,
      required this.trigger,
      this.metrics,
      this.error,
      required this.startedAt,
      this.finishedAt})
      : super._();
  @override
  JobRunResponse rebuild(void Function(JobRunResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JobRunResponseBuilder toBuilder() => JobRunResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JobRunResponse &&
        id == other.id &&
        jobName == other.jobName &&
        status == other.status &&
        trigger == other.trigger &&
        metrics == other.metrics &&
        error == other.error &&
        startedAt == other.startedAt &&
        finishedAt == other.finishedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, jobName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, trigger.hashCode);
    _$hash = $jc(_$hash, metrics.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, finishedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JobRunResponse')
          ..add('id', id)
          ..add('jobName', jobName)
          ..add('status', status)
          ..add('trigger', trigger)
          ..add('metrics', metrics)
          ..add('error', error)
          ..add('startedAt', startedAt)
          ..add('finishedAt', finishedAt))
        .toString();
  }
}

class JobRunResponseBuilder
    implements Builder<JobRunResponse, JobRunResponseBuilder> {
  _$JobRunResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _jobName;
  String? get jobName => _$this._jobName;
  set jobName(String? jobName) => _$this._jobName = jobName;

  JobRunResponseStatusEnum? _status;
  JobRunResponseStatusEnum? get status => _$this._status;
  set status(JobRunResponseStatusEnum? status) => _$this._status = status;

  String? _trigger;
  String? get trigger => _$this._trigger;
  set trigger(String? trigger) => _$this._trigger = trigger;

  MapBuilder<String, JsonObject?>? _metrics;
  MapBuilder<String, JsonObject?> get metrics =>
      _$this._metrics ??= MapBuilder<String, JsonObject?>();
  set metrics(MapBuilder<String, JsonObject?>? metrics) =>
      _$this._metrics = metrics;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _finishedAt;
  DateTime? get finishedAt => _$this._finishedAt;
  set finishedAt(DateTime? finishedAt) => _$this._finishedAt = finishedAt;

  JobRunResponseBuilder() {
    JobRunResponse._defaults(this);
  }

  JobRunResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _jobName = $v.jobName;
      _status = $v.status;
      _trigger = $v.trigger;
      _metrics = $v.metrics?.toBuilder();
      _error = $v.error;
      _startedAt = $v.startedAt;
      _finishedAt = $v.finishedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JobRunResponse other) {
    _$v = other as _$JobRunResponse;
  }

  @override
  void update(void Function(JobRunResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JobRunResponse build() => _build();

  _$JobRunResponse _build() {
    _$JobRunResponse _$result;
    try {
      _$result = _$v ??
          _$JobRunResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'JobRunResponse', 'id'),
            jobName: BuiltValueNullFieldError.checkNotNull(
                jobName, r'JobRunResponse', 'jobName'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'JobRunResponse', 'status'),
            trigger: BuiltValueNullFieldError.checkNotNull(
                trigger, r'JobRunResponse', 'trigger'),
            metrics: _metrics?.build(),
            error: error,
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'JobRunResponse', 'startedAt'),
            finishedAt: finishedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metrics';
        _metrics?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JobRunResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
