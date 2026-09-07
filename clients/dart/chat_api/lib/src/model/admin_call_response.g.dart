// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCallResponseTypeEnum _$adminCallResponseTypeEnum_AUDIO =
    const AdminCallResponseTypeEnum._('AUDIO');
const AdminCallResponseTypeEnum _$adminCallResponseTypeEnum_VIDEO =
    const AdminCallResponseTypeEnum._('VIDEO');
const AdminCallResponseTypeEnum
    _$adminCallResponseTypeEnum_unknownDefaultOpenApi =
    const AdminCallResponseTypeEnum._('unknownDefaultOpenApi');

AdminCallResponseTypeEnum _$adminCallResponseTypeEnumValueOf(String name) {
  switch (name) {
    case 'AUDIO':
      return _$adminCallResponseTypeEnum_AUDIO;
    case 'VIDEO':
      return _$adminCallResponseTypeEnum_VIDEO;
    case 'unknownDefaultOpenApi':
      return _$adminCallResponseTypeEnum_unknownDefaultOpenApi;
    default:
      return _$adminCallResponseTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminCallResponseTypeEnum> _$adminCallResponseTypeEnumValues =
    BuiltSet<AdminCallResponseTypeEnum>(const <AdminCallResponseTypeEnum>[
  _$adminCallResponseTypeEnum_AUDIO,
  _$adminCallResponseTypeEnum_VIDEO,
  _$adminCallResponseTypeEnum_unknownDefaultOpenApi,
]);

const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_INVITING =
    const AdminCallResponseStatusEnum._('INVITING');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_RINGING =
    const AdminCallResponseStatusEnum._('RINGING');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_ACCEPTED =
    const AdminCallResponseStatusEnum._('ACCEPTED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_CONNECTED =
    const AdminCallResponseStatusEnum._('CONNECTED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_REJECTED =
    const AdminCallResponseStatusEnum._('REJECTED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_CANCELLED =
    const AdminCallResponseStatusEnum._('CANCELLED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_MISSED =
    const AdminCallResponseStatusEnum._('MISSED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_ENDED =
    const AdminCallResponseStatusEnum._('ENDED');
const AdminCallResponseStatusEnum _$adminCallResponseStatusEnum_FAILED =
    const AdminCallResponseStatusEnum._('FAILED');
const AdminCallResponseStatusEnum
    _$adminCallResponseStatusEnum_unknownDefaultOpenApi =
    const AdminCallResponseStatusEnum._('unknownDefaultOpenApi');

AdminCallResponseStatusEnum _$adminCallResponseStatusEnumValueOf(String name) {
  switch (name) {
    case 'INVITING':
      return _$adminCallResponseStatusEnum_INVITING;
    case 'RINGING':
      return _$adminCallResponseStatusEnum_RINGING;
    case 'ACCEPTED':
      return _$adminCallResponseStatusEnum_ACCEPTED;
    case 'CONNECTED':
      return _$adminCallResponseStatusEnum_CONNECTED;
    case 'REJECTED':
      return _$adminCallResponseStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$adminCallResponseStatusEnum_CANCELLED;
    case 'MISSED':
      return _$adminCallResponseStatusEnum_MISSED;
    case 'ENDED':
      return _$adminCallResponseStatusEnum_ENDED;
    case 'FAILED':
      return _$adminCallResponseStatusEnum_FAILED;
    case 'unknownDefaultOpenApi':
      return _$adminCallResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$adminCallResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminCallResponseStatusEnum>
    _$adminCallResponseStatusEnumValues =
    BuiltSet<AdminCallResponseStatusEnum>(const <AdminCallResponseStatusEnum>[
  _$adminCallResponseStatusEnum_INVITING,
  _$adminCallResponseStatusEnum_RINGING,
  _$adminCallResponseStatusEnum_ACCEPTED,
  _$adminCallResponseStatusEnum_CONNECTED,
  _$adminCallResponseStatusEnum_REJECTED,
  _$adminCallResponseStatusEnum_CANCELLED,
  _$adminCallResponseStatusEnum_MISSED,
  _$adminCallResponseStatusEnum_ENDED,
  _$adminCallResponseStatusEnum_FAILED,
  _$adminCallResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<AdminCallResponseTypeEnum> _$adminCallResponseTypeEnumSerializer =
    _$AdminCallResponseTypeEnumSerializer();
Serializer<AdminCallResponseStatusEnum>
    _$adminCallResponseStatusEnumSerializer =
    _$AdminCallResponseStatusEnumSerializer();

class _$AdminCallResponseTypeEnumSerializer
    implements PrimitiveSerializer<AdminCallResponseTypeEnum> {
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
  final Iterable<Type> types = const <Type>[AdminCallResponseTypeEnum];
  @override
  final String wireName = 'AdminCallResponseTypeEnum';

  @override
  Object serialize(Serializers serializers, AdminCallResponseTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminCallResponseTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminCallResponseTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminCallResponseStatusEnumSerializer
    implements PrimitiveSerializer<AdminCallResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminCallResponseStatusEnum];
  @override
  final String wireName = 'AdminCallResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, AdminCallResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminCallResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminCallResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminCallResponse extends AdminCallResponse {
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
  final AdminCallResponseTypeEnum type;
  @override
  final AdminCallResponseStatusEnum status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? answeredAt;
  @override
  final DateTime? endedAt;
  @override
  final String? endReason;
  @override
  final BuiltMap<String, JsonObject?> initiator;

  factory _$AdminCallResponse(
          [void Function(AdminCallResponseBuilder)? updates]) =>
      (AdminCallResponseBuilder()..update(updates))._build();

  _$AdminCallResponse._(
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
      this.endReason,
      required this.initiator})
      : super._();
  @override
  AdminCallResponse rebuild(void Function(AdminCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCallResponseBuilder toBuilder() =>
      AdminCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCallResponse &&
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
        endReason == other.endReason &&
        initiator == other.initiator;
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
    _$hash = $jc(_$hash, initiator.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCallResponse')
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
          ..add('endReason', endReason)
          ..add('initiator', initiator))
        .toString();
  }
}

class AdminCallResponseBuilder
    implements Builder<AdminCallResponse, AdminCallResponseBuilder> {
  _$AdminCallResponse? _$v;

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

  AdminCallResponseTypeEnum? _type;
  AdminCallResponseTypeEnum? get type => _$this._type;
  set type(AdminCallResponseTypeEnum? type) => _$this._type = type;

  AdminCallResponseStatusEnum? _status;
  AdminCallResponseStatusEnum? get status => _$this._status;
  set status(AdminCallResponseStatusEnum? status) => _$this._status = status;

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

  MapBuilder<String, JsonObject?>? _initiator;
  MapBuilder<String, JsonObject?> get initiator =>
      _$this._initiator ??= MapBuilder<String, JsonObject?>();
  set initiator(MapBuilder<String, JsonObject?>? initiator) =>
      _$this._initiator = initiator;

  AdminCallResponseBuilder() {
    AdminCallResponse._defaults(this);
  }

  AdminCallResponseBuilder get _$this {
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
      _initiator = $v.initiator.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCallResponse other) {
    _$v = other as _$AdminCallResponse;
  }

  @override
  void update(void Function(AdminCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCallResponse build() => _build();

  _$AdminCallResponse _build() {
    _$AdminCallResponse _$result;
    try {
      _$result = _$v ??
          _$AdminCallResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminCallResponse', 'id'),
            initiatorUserId: BuiltValueNullFieldError.checkNotNull(
                initiatorUserId, r'AdminCallResponse', 'initiatorUserId'),
            targetUserId: targetUserId,
            groupId: groupId,
            livekitRoomName: BuiltValueNullFieldError.checkNotNull(
                livekitRoomName, r'AdminCallResponse', 'livekitRoomName'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'AdminCallResponse', 'type'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AdminCallResponse', 'status'),
            startedAt: BuiltValueNullFieldError.checkNotNull(
                startedAt, r'AdminCallResponse', 'startedAt'),
            answeredAt: answeredAt,
            endedAt: endedAt,
            endReason: endReason,
            initiator: initiator.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'initiator';
        initiator.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminCallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
