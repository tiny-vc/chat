// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_history_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CallHistoryResponseTypeEnum _$callHistoryResponseTypeEnum_AUDIO =
    const CallHistoryResponseTypeEnum._('AUDIO');
const CallHistoryResponseTypeEnum _$callHistoryResponseTypeEnum_VIDEO =
    const CallHistoryResponseTypeEnum._('VIDEO');
const CallHistoryResponseTypeEnum
    _$callHistoryResponseTypeEnum_unknownDefaultOpenApi =
    const CallHistoryResponseTypeEnum._('unknownDefaultOpenApi');

CallHistoryResponseTypeEnum _$callHistoryResponseTypeEnumValueOf(String name) {
  switch (name) {
    case 'AUDIO':
      return _$callHistoryResponseTypeEnum_AUDIO;
    case 'VIDEO':
      return _$callHistoryResponseTypeEnum_VIDEO;
    case 'unknownDefaultOpenApi':
      return _$callHistoryResponseTypeEnum_unknownDefaultOpenApi;
    default:
      return _$callHistoryResponseTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CallHistoryResponseTypeEnum>
    _$callHistoryResponseTypeEnumValues =
    BuiltSet<CallHistoryResponseTypeEnum>(const <CallHistoryResponseTypeEnum>[
  _$callHistoryResponseTypeEnum_AUDIO,
  _$callHistoryResponseTypeEnum_VIDEO,
  _$callHistoryResponseTypeEnum_unknownDefaultOpenApi,
]);

const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_INVITING =
    const CallHistoryResponseStatusEnum._('INVITING');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_RINGING =
    const CallHistoryResponseStatusEnum._('RINGING');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_ACCEPTED =
    const CallHistoryResponseStatusEnum._('ACCEPTED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_CONNECTED =
    const CallHistoryResponseStatusEnum._('CONNECTED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_REJECTED =
    const CallHistoryResponseStatusEnum._('REJECTED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_CANCELLED =
    const CallHistoryResponseStatusEnum._('CANCELLED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_MISSED =
    const CallHistoryResponseStatusEnum._('MISSED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_ENDED =
    const CallHistoryResponseStatusEnum._('ENDED');
const CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnum_FAILED =
    const CallHistoryResponseStatusEnum._('FAILED');
const CallHistoryResponseStatusEnum
    _$callHistoryResponseStatusEnum_unknownDefaultOpenApi =
    const CallHistoryResponseStatusEnum._('unknownDefaultOpenApi');

CallHistoryResponseStatusEnum _$callHistoryResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'INVITING':
      return _$callHistoryResponseStatusEnum_INVITING;
    case 'RINGING':
      return _$callHistoryResponseStatusEnum_RINGING;
    case 'ACCEPTED':
      return _$callHistoryResponseStatusEnum_ACCEPTED;
    case 'CONNECTED':
      return _$callHistoryResponseStatusEnum_CONNECTED;
    case 'REJECTED':
      return _$callHistoryResponseStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$callHistoryResponseStatusEnum_CANCELLED;
    case 'MISSED':
      return _$callHistoryResponseStatusEnum_MISSED;
    case 'ENDED':
      return _$callHistoryResponseStatusEnum_ENDED;
    case 'FAILED':
      return _$callHistoryResponseStatusEnum_FAILED;
    case 'unknownDefaultOpenApi':
      return _$callHistoryResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$callHistoryResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CallHistoryResponseStatusEnum>
    _$callHistoryResponseStatusEnumValues = BuiltSet<
        CallHistoryResponseStatusEnum>(const <CallHistoryResponseStatusEnum>[
  _$callHistoryResponseStatusEnum_INVITING,
  _$callHistoryResponseStatusEnum_RINGING,
  _$callHistoryResponseStatusEnum_ACCEPTED,
  _$callHistoryResponseStatusEnum_CONNECTED,
  _$callHistoryResponseStatusEnum_REJECTED,
  _$callHistoryResponseStatusEnum_CANCELLED,
  _$callHistoryResponseStatusEnum_MISSED,
  _$callHistoryResponseStatusEnum_ENDED,
  _$callHistoryResponseStatusEnum_FAILED,
  _$callHistoryResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<CallHistoryResponseTypeEnum>
    _$callHistoryResponseTypeEnumSerializer =
    _$CallHistoryResponseTypeEnumSerializer();
Serializer<CallHistoryResponseStatusEnum>
    _$callHistoryResponseStatusEnumSerializer =
    _$CallHistoryResponseStatusEnumSerializer();

class _$CallHistoryResponseTypeEnumSerializer
    implements PrimitiveSerializer<CallHistoryResponseTypeEnum> {
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
  final Iterable<Type> types = const <Type>[CallHistoryResponseTypeEnum];
  @override
  final String wireName = 'CallHistoryResponseTypeEnum';

  @override
  Object serialize(Serializers serializers, CallHistoryResponseTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CallHistoryResponseTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CallHistoryResponseTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CallHistoryResponseStatusEnumSerializer
    implements PrimitiveSerializer<CallHistoryResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[CallHistoryResponseStatusEnum];
  @override
  final String wireName = 'CallHistoryResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CallHistoryResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CallHistoryResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CallHistoryResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CallHistoryResponse extends CallHistoryResponse {
  @override
  final bool outgoing;
  @override
  final UserResponse? peer;
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

  factory _$CallHistoryResponse(
          [void Function(CallHistoryResponseBuilder)? updates]) =>
      (CallHistoryResponseBuilder()..update(updates))._build();

  _$CallHistoryResponse._(
      {required this.outgoing,
      this.peer,
      required this.id,
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
  CallHistoryResponse rebuild(
          void Function(CallHistoryResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallHistoryResponseBuilder toBuilder() =>
      CallHistoryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallHistoryResponse &&
        outgoing == other.outgoing &&
        peer == other.peer &&
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
    _$hash = $jc(_$hash, outgoing.hashCode);
    _$hash = $jc(_$hash, peer.hashCode);
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
    return (newBuiltValueToStringHelper(r'CallHistoryResponse')
          ..add('outgoing', outgoing)
          ..add('peer', peer)
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

class CallHistoryResponseBuilder
    implements
        Builder<CallHistoryResponse, CallHistoryResponseBuilder>,
        CallSessionResponseBuilder {
  _$CallHistoryResponse? _$v;

  bool? _outgoing;
  bool? get outgoing => _$this._outgoing;
  set outgoing(covariant bool? outgoing) => _$this._outgoing = outgoing;

  UserResponseBuilder? _peer;
  UserResponseBuilder get peer => _$this._peer ??= UserResponseBuilder();
  set peer(covariant UserResponseBuilder? peer) => _$this._peer = peer;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _initiatorUserId;
  String? get initiatorUserId => _$this._initiatorUserId;
  set initiatorUserId(covariant String? initiatorUserId) =>
      _$this._initiatorUserId = initiatorUserId;

  String? _targetUserId;
  String? get targetUserId => _$this._targetUserId;
  set targetUserId(covariant String? targetUserId) =>
      _$this._targetUserId = targetUserId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(covariant String? groupId) => _$this._groupId = groupId;

  String? _livekitRoomName;
  String? get livekitRoomName => _$this._livekitRoomName;
  set livekitRoomName(covariant String? livekitRoomName) =>
      _$this._livekitRoomName = livekitRoomName;

  CallSessionResponseTypeEnum? _type;
  CallSessionResponseTypeEnum? get type => _$this._type;
  set type(covariant CallSessionResponseTypeEnum? type) => _$this._type = type;

  CallSessionResponseStatusEnum? _status;
  CallSessionResponseStatusEnum? get status => _$this._status;
  set status(covariant CallSessionResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(covariant DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(covariant DateTime? answeredAt) =>
      _$this._answeredAt = answeredAt;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(covariant DateTime? endedAt) => _$this._endedAt = endedAt;

  String? _endReason;
  String? get endReason => _$this._endReason;
  set endReason(covariant String? endReason) => _$this._endReason = endReason;

  CallHistoryResponseBuilder() {
    CallHistoryResponse._defaults(this);
  }

  CallHistoryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outgoing = $v.outgoing;
      _peer = $v.peer?.toBuilder();
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
  void replace(covariant CallHistoryResponse other) {
    _$v = other as _$CallHistoryResponse;
  }

  @override
  void update(void Function(CallHistoryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallHistoryResponse build() => _build();

  _$CallHistoryResponse _build() {
    _$CallHistoryResponse _$result;
    try {
      _$result = _$v ??
          _$CallHistoryResponse._(
            outgoing: BuiltValueNullFieldError.checkNotNull(
                outgoing, r'CallHistoryResponse', 'outgoing'),
            peer: _peer?.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CallHistoryResponse', 'id'),
            initiatorUserId: BuiltValueNullFieldError.checkNotNull(
                initiatorUserId, r'CallHistoryResponse', 'initiatorUserId'),
            targetUserId: targetUserId,
            groupId: groupId,
            livekitRoomName: BuiltValueNullFieldError.checkNotNull(
                livekitRoomName, r'CallHistoryResponse', 'livekitRoomName'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallHistoryResponse', 'type'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CallHistoryResponse', 'status'),
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'CallHistoryResponse', 'startedAt'),
            answeredAt: answeredAt,
            endedAt: endedAt,
            endReason: endReason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'peer';
        _peer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallHistoryResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
