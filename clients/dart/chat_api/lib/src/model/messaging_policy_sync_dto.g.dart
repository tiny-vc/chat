// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_policy_sync_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MessagingPolicySyncDtoStatusEnum
    _$messagingPolicySyncDtoStatusEnum_PENDING =
    const MessagingPolicySyncDtoStatusEnum._('PENDING');
const MessagingPolicySyncDtoStatusEnum
    _$messagingPolicySyncDtoStatusEnum_SYNCING =
    const MessagingPolicySyncDtoStatusEnum._('SYNCING');
const MessagingPolicySyncDtoStatusEnum
    _$messagingPolicySyncDtoStatusEnum_SYNCED =
    const MessagingPolicySyncDtoStatusEnum._('SYNCED');
const MessagingPolicySyncDtoStatusEnum
    _$messagingPolicySyncDtoStatusEnum_FAILED =
    const MessagingPolicySyncDtoStatusEnum._('FAILED');
const MessagingPolicySyncDtoStatusEnum
    _$messagingPolicySyncDtoStatusEnum_unknownDefaultOpenApi =
    const MessagingPolicySyncDtoStatusEnum._('unknownDefaultOpenApi');

MessagingPolicySyncDtoStatusEnum _$messagingPolicySyncDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$messagingPolicySyncDtoStatusEnum_PENDING;
    case 'SYNCING':
      return _$messagingPolicySyncDtoStatusEnum_SYNCING;
    case 'SYNCED':
      return _$messagingPolicySyncDtoStatusEnum_SYNCED;
    case 'FAILED':
      return _$messagingPolicySyncDtoStatusEnum_FAILED;
    case 'unknownDefaultOpenApi':
      return _$messagingPolicySyncDtoStatusEnum_unknownDefaultOpenApi;
    default:
      return _$messagingPolicySyncDtoStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<MessagingPolicySyncDtoStatusEnum>
    _$messagingPolicySyncDtoStatusEnumValues = BuiltSet<
        MessagingPolicySyncDtoStatusEnum>(const <MessagingPolicySyncDtoStatusEnum>[
  _$messagingPolicySyncDtoStatusEnum_PENDING,
  _$messagingPolicySyncDtoStatusEnum_SYNCING,
  _$messagingPolicySyncDtoStatusEnum_SYNCED,
  _$messagingPolicySyncDtoStatusEnum_FAILED,
  _$messagingPolicySyncDtoStatusEnum_unknownDefaultOpenApi,
]);

Serializer<MessagingPolicySyncDtoStatusEnum>
    _$messagingPolicySyncDtoStatusEnumSerializer =
    _$MessagingPolicySyncDtoStatusEnumSerializer();

class _$MessagingPolicySyncDtoStatusEnumSerializer
    implements PrimitiveSerializer<MessagingPolicySyncDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'SYNCING': 'SYNCING',
    'SYNCED': 'SYNCED',
    'FAILED': 'FAILED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'SYNCING': 'SYNCING',
    'SYNCED': 'SYNCED',
    'FAILED': 'FAILED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[MessagingPolicySyncDtoStatusEnum];
  @override
  final String wireName = 'MessagingPolicySyncDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, MessagingPolicySyncDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MessagingPolicySyncDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MessagingPolicySyncDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MessagingPolicySyncDto extends MessagingPolicySyncDto {
  @override
  final MessagingPolicySyncDtoStatusEnum status;
  @override
  final num attempts;
  @override
  final String? lastError;
  @override
  final DateTime? syncedAt;

  factory _$MessagingPolicySyncDto(
          [void Function(MessagingPolicySyncDtoBuilder)? updates]) =>
      (MessagingPolicySyncDtoBuilder()..update(updates))._build();

  _$MessagingPolicySyncDto._(
      {required this.status,
      required this.attempts,
      this.lastError,
      this.syncedAt})
      : super._();
  @override
  MessagingPolicySyncDto rebuild(
          void Function(MessagingPolicySyncDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessagingPolicySyncDtoBuilder toBuilder() =>
      MessagingPolicySyncDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessagingPolicySyncDto &&
        status == other.status &&
        attempts == other.attempts &&
        lastError == other.lastError &&
        syncedAt == other.syncedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jc(_$hash, lastError.hashCode);
    _$hash = $jc(_$hash, syncedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessagingPolicySyncDto')
          ..add('status', status)
          ..add('attempts', attempts)
          ..add('lastError', lastError)
          ..add('syncedAt', syncedAt))
        .toString();
  }
}

class MessagingPolicySyncDtoBuilder
    implements Builder<MessagingPolicySyncDto, MessagingPolicySyncDtoBuilder> {
  _$MessagingPolicySyncDto? _$v;

  MessagingPolicySyncDtoStatusEnum? _status;
  MessagingPolicySyncDtoStatusEnum? get status => _$this._status;
  set status(MessagingPolicySyncDtoStatusEnum? status) =>
      _$this._status = status;

  num? _attempts;
  num? get attempts => _$this._attempts;
  set attempts(num? attempts) => _$this._attempts = attempts;

  String? _lastError;
  String? get lastError => _$this._lastError;
  set lastError(String? lastError) => _$this._lastError = lastError;

  DateTime? _syncedAt;
  DateTime? get syncedAt => _$this._syncedAt;
  set syncedAt(DateTime? syncedAt) => _$this._syncedAt = syncedAt;

  MessagingPolicySyncDtoBuilder() {
    MessagingPolicySyncDto._defaults(this);
  }

  MessagingPolicySyncDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _attempts = $v.attempts;
      _lastError = $v.lastError;
      _syncedAt = $v.syncedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessagingPolicySyncDto other) {
    _$v = other as _$MessagingPolicySyncDto;
  }

  @override
  void update(void Function(MessagingPolicySyncDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessagingPolicySyncDto build() => _build();

  _$MessagingPolicySyncDto _build() {
    final _$result = _$v ??
        _$MessagingPolicySyncDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'MessagingPolicySyncDto', 'status'),
          attempts: BuiltValueNullFieldError.checkNotNull(
              attempts, r'MessagingPolicySyncDto', 'attempts'),
          lastError: lastError,
          syncedAt: syncedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
