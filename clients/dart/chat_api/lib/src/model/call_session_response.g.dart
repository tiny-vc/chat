// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CallSessionResponseTypeEnum _$callSessionResponseTypeEnum_AUDIO =
    const CallSessionResponseTypeEnum._('AUDIO');
const CallSessionResponseTypeEnum _$callSessionResponseTypeEnum_VIDEO =
    const CallSessionResponseTypeEnum._('VIDEO');
const CallSessionResponseTypeEnum
    _$callSessionResponseTypeEnum_unknownDefaultOpenApi =
    const CallSessionResponseTypeEnum._('unknownDefaultOpenApi');

CallSessionResponseTypeEnum _$callSessionResponseTypeEnumValueOf(String name) {
  switch (name) {
    case 'AUDIO':
      return _$callSessionResponseTypeEnum_AUDIO;
    case 'VIDEO':
      return _$callSessionResponseTypeEnum_VIDEO;
    case 'unknownDefaultOpenApi':
      return _$callSessionResponseTypeEnum_unknownDefaultOpenApi;
    default:
      return _$callSessionResponseTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CallSessionResponseTypeEnum>
    _$callSessionResponseTypeEnumValues =
    BuiltSet<CallSessionResponseTypeEnum>(const <CallSessionResponseTypeEnum>[
  _$callSessionResponseTypeEnum_AUDIO,
  _$callSessionResponseTypeEnum_VIDEO,
  _$callSessionResponseTypeEnum_unknownDefaultOpenApi,
]);

const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_INVITING =
    const CallSessionResponseStatusEnum._('INVITING');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_RINGING =
    const CallSessionResponseStatusEnum._('RINGING');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_ACCEPTED =
    const CallSessionResponseStatusEnum._('ACCEPTED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_CONNECTED =
    const CallSessionResponseStatusEnum._('CONNECTED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_REJECTED =
    const CallSessionResponseStatusEnum._('REJECTED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_CANCELLED =
    const CallSessionResponseStatusEnum._('CANCELLED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_MISSED =
    const CallSessionResponseStatusEnum._('MISSED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_ENDED =
    const CallSessionResponseStatusEnum._('ENDED');
const CallSessionResponseStatusEnum _$callSessionResponseStatusEnum_FAILED =
    const CallSessionResponseStatusEnum._('FAILED');
const CallSessionResponseStatusEnum
    _$callSessionResponseStatusEnum_unknownDefaultOpenApi =
    const CallSessionResponseStatusEnum._('unknownDefaultOpenApi');

CallSessionResponseStatusEnum _$callSessionResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'INVITING':
      return _$callSessionResponseStatusEnum_INVITING;
    case 'RINGING':
      return _$callSessionResponseStatusEnum_RINGING;
    case 'ACCEPTED':
      return _$callSessionResponseStatusEnum_ACCEPTED;
    case 'CONNECTED':
      return _$callSessionResponseStatusEnum_CONNECTED;
    case 'REJECTED':
      return _$callSessionResponseStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$callSessionResponseStatusEnum_CANCELLED;
    case 'MISSED':
      return _$callSessionResponseStatusEnum_MISSED;
    case 'ENDED':
      return _$callSessionResponseStatusEnum_ENDED;
    case 'FAILED':
      return _$callSessionResponseStatusEnum_FAILED;
    case 'unknownDefaultOpenApi':
      return _$callSessionResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$callSessionResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CallSessionResponseStatusEnum>
    _$callSessionResponseStatusEnumValues = BuiltSet<
        CallSessionResponseStatusEnum>(const <CallSessionResponseStatusEnum>[
  _$callSessionResponseStatusEnum_INVITING,
  _$callSessionResponseStatusEnum_RINGING,
  _$callSessionResponseStatusEnum_ACCEPTED,
  _$callSessionResponseStatusEnum_CONNECTED,
  _$callSessionResponseStatusEnum_REJECTED,
  _$callSessionResponseStatusEnum_CANCELLED,
  _$callSessionResponseStatusEnum_MISSED,
  _$callSessionResponseStatusEnum_ENDED,
  _$callSessionResponseStatusEnum_FAILED,
  _$callSessionResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<CallSessionResponseTypeEnum>
    _$callSessionResponseTypeEnumSerializer =
    _$CallSessionResponseTypeEnumSerializer();
Serializer<CallSessionResponseStatusEnum>
    _$callSessionResponseStatusEnumSerializer =
    _$CallSessionResponseStatusEnumSerializer();

class _$CallSessionResponseTypeEnumSerializer
    implements PrimitiveSerializer<CallSessionResponseTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUDIO': 'AUDIO',
    'VIDEO': 'VIDEO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUDIO': 'AUDIO',
    'VIDEO': 'VIDEO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[CallSessionResponseTypeEnum];
  @override
  final String wireName = 'CallSessionResponseTypeEnum';

  @override
  Object serialize(Serializers serializers, CallSessionResponseTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CallSessionResponseTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CallSessionResponseTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CallSessionResponseStatusEnumSerializer
    implements PrimitiveSerializer<CallSessionResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INVITING': 'INVITING',
    'RINGING': 'RINGING',
    'ACCEPTED': 'ACCEPTED',
    'CONNECTED': 'CONNECTED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
    'MISSED': 'MISSED',
    'ENDED': 'ENDED',
    'FAILED': 'FAILED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INVITING': 'INVITING',
    'RINGING': 'RINGING',
    'ACCEPTED': 'ACCEPTED',
    'CONNECTED': 'CONNECTED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
    'MISSED': 'MISSED',
    'ENDED': 'ENDED',
    'FAILED': 'FAILED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[CallSessionResponseStatusEnum];
  @override
  final String wireName = 'CallSessionResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CallSessionResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CallSessionResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CallSessionResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CallSessionResponse extends CallSessionResponse {
  @override
  final String id;
  @override
  final String initiatorUserId;
  @override
  final String? targetUserId;
  @override
  final String? groupId;
  @override
  final String livekitRoomName;
  @override
  final CallSessionResponseTypeEnum type;
  @override
  final CallSessionResponseStatusEnum status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? answeredAt;
  @override
  final DateTime? endedAt;
  @override
  final String? endReason;

  factory _$CallSessionResponse(
          [void Function(CallSessionResponseBuilder)? updates]) =>
      (CallSessionResponseBuilder()..update(updates))._build();

  _$CallSessionResponse._(
      {required this.id,
      required this.initiatorUserId,
      this.targetUserId,
      this.groupId,
      required this.livekitRoomName,
      required this.type,
      required this.status,
      required this.startedAt,
      this.answeredAt,
      this.endedAt,
      this.endReason})
      : super._();
  @override
  CallSessionResponse rebuild(
          void Function(CallSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSessionResponseBuilder toBuilder() =>
      CallSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSessionResponse &&
        id == other.id &&
        initiatorUserId == other.initiatorUserId &&
        targetUserId == other.targetUserId &&
        groupId == other.groupId &&
        livekitRoomName == other.livekitRoomName &&
        type == other.type &&
        status == other.status &&
        startedAt == other.startedAt &&
        answeredAt == other.answeredAt &&
        endedAt == other.endedAt &&
        endReason == other.endReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, initiatorUserId.hashCode);
    _$hash = $jc(_$hash, targetUserId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, livekitRoomName.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, answeredAt.hashCode);
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jc(_$hash, endReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSessionResponse')
          ..add('id', id)
          ..add('initiatorUserId', initiatorUserId)
          ..add('targetUserId', targetUserId)
          ..add('groupId', groupId)
          ..add('livekitRoomName', livekitRoomName)
          ..add('type', type)
          ..add('status', status)
          ..add('startedAt', startedAt)
          ..add('answeredAt', answeredAt)
          ..add('endedAt', endedAt)
          ..add('endReason', endReason))
        .toString();
  }
}

class CallSessionResponseBuilder
    implements Builder<CallSessionResponse, CallSessionResponseBuilder> {
  _$CallSessionResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _initiatorUserId;
  String? get initiatorUserId => _$this._initiatorUserId;
  set initiatorUserId(String? initiatorUserId) =>
      _$this._initiatorUserId = initiatorUserId;

  String? _targetUserId;
  String? get targetUserId => _$this._targetUserId;
  set targetUserId(String? targetUserId) => _$this._targetUserId = targetUserId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  String? _livekitRoomName;
  String? get livekitRoomName => _$this._livekitRoomName;
  set livekitRoomName(String? livekitRoomName) =>
      _$this._livekitRoomName = livekitRoomName;

  CallSessionResponseTypeEnum? _type;
  CallSessionResponseTypeEnum? get type => _$this._type;
  set type(CallSessionResponseTypeEnum? type) => _$this._type = type;

  CallSessionResponseStatusEnum? _status;
  CallSessionResponseStatusEnum? get status => _$this._status;
  set status(CallSessionResponseStatusEnum? status) => _$this._status = status;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(DateTime? answeredAt) => _$this._answeredAt = answeredAt;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  String? _endReason;
  String? get endReason => _$this._endReason;
  set endReason(String? endReason) => _$this._endReason = endReason;

  CallSessionResponseBuilder() {
    CallSessionResponse._defaults(this);
  }

  CallSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _initiatorUserId = $v.initiatorUserId;
      _targetUserId = $v.targetUserId;
      _groupId = $v.groupId;
      _livekitRoomName = $v.livekitRoomName;
      _type = $v.type;
      _status = $v.status;
      _startedAt = $v.startedAt;
      _answeredAt = $v.answeredAt;
      _endedAt = $v.endedAt;
      _endReason = $v.endReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSessionResponse other) {
    _$v = other as _$CallSessionResponse;
  }

  @override
  void update(void Function(CallSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSessionResponse build() => _build();

  _$CallSessionResponse _build() {
    final _$result = _$v ??
        _$CallSessionResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CallSessionResponse', 'id'),
          initiatorUserId: BuiltValueNullFieldError.checkNotNull(
              initiatorUserId, r'CallSessionResponse', 'initiatorUserId'),
          targetUserId: targetUserId,
          groupId: groupId,
          livekitRoomName: BuiltValueNullFieldError.checkNotNull(
              livekitRoomName, r'CallSessionResponse', 'livekitRoomName'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallSessionResponse', 'type'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'CallSessionResponse', 'status'),
          startedAt: BuiltValueNullFieldError.checkNotNull(
              startedAt, r'CallSessionResponse', 'startedAt'),
          answeredAt: answeredAt,
          endedAt: endedAt,
          endReason: endReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
