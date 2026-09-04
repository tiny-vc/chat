// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FriendshipResponseStatusEnum _$friendshipResponseStatusEnum_PENDING =
    const FriendshipResponseStatusEnum._('PENDING');
const FriendshipResponseStatusEnum _$friendshipResponseStatusEnum_ACCEPTED =
    const FriendshipResponseStatusEnum._('ACCEPTED');
const FriendshipResponseStatusEnum _$friendshipResponseStatusEnum_REJECTED =
    const FriendshipResponseStatusEnum._('REJECTED');
const FriendshipResponseStatusEnum _$friendshipResponseStatusEnum_BLOCKED =
    const FriendshipResponseStatusEnum._('BLOCKED');
const FriendshipResponseStatusEnum
    _$friendshipResponseStatusEnum_unknownDefaultOpenApi =
    const FriendshipResponseStatusEnum._('unknownDefaultOpenApi');

FriendshipResponseStatusEnum _$friendshipResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$friendshipResponseStatusEnum_PENDING;
    case 'ACCEPTED':
      return _$friendshipResponseStatusEnum_ACCEPTED;
    case 'REJECTED':
      return _$friendshipResponseStatusEnum_REJECTED;
    case 'BLOCKED':
      return _$friendshipResponseStatusEnum_BLOCKED;
    case 'unknownDefaultOpenApi':
      return _$friendshipResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$friendshipResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<FriendshipResponseStatusEnum>
    _$friendshipResponseStatusEnumValues =
    BuiltSet<FriendshipResponseStatusEnum>(const <FriendshipResponseStatusEnum>[
  _$friendshipResponseStatusEnum_PENDING,
  _$friendshipResponseStatusEnum_ACCEPTED,
  _$friendshipResponseStatusEnum_REJECTED,
  _$friendshipResponseStatusEnum_BLOCKED,
  _$friendshipResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<FriendshipResponseStatusEnum>
    _$friendshipResponseStatusEnumSerializer =
    _$FriendshipResponseStatusEnumSerializer();

class _$FriendshipResponseStatusEnumSerializer
    implements PrimitiveSerializer<FriendshipResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
    'BLOCKED': 'BLOCKED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
    'BLOCKED': 'BLOCKED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[FriendshipResponseStatusEnum];
  @override
  final String wireName = 'FriendshipResponseStatusEnum';

  @override
  Object serialize(Serializers serializers, FriendshipResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FriendshipResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FriendshipResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FriendshipResponse extends FriendshipResponse {
  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String addresseeId;
  @override
  final FriendshipResponseStatusEnum status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$FriendshipResponse(
          [void Function(FriendshipResponseBuilder)? updates]) =>
      (FriendshipResponseBuilder()..update(updates))._build();

  _$FriendshipResponse._(
      {required this.id,
      required this.requesterId,
      required this.addresseeId,
      required this.status,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  FriendshipResponse rebuild(
          void Function(FriendshipResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FriendshipResponseBuilder toBuilder() =>
      FriendshipResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FriendshipResponse &&
        id == other.id &&
        requesterId == other.requesterId &&
        addresseeId == other.addresseeId &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, requesterId.hashCode);
    _$hash = $jc(_$hash, addresseeId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FriendshipResponse')
          ..add('id', id)
          ..add('requesterId', requesterId)
          ..add('addresseeId', addresseeId)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class FriendshipResponseBuilder
    implements Builder<FriendshipResponse, FriendshipResponseBuilder> {
  _$FriendshipResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _requesterId;
  String? get requesterId => _$this._requesterId;
  set requesterId(String? requesterId) => _$this._requesterId = requesterId;

  String? _addresseeId;
  String? get addresseeId => _$this._addresseeId;
  set addresseeId(String? addresseeId) => _$this._addresseeId = addresseeId;

  FriendshipResponseStatusEnum? _status;
  FriendshipResponseStatusEnum? get status => _$this._status;
  set status(FriendshipResponseStatusEnum? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  FriendshipResponseBuilder() {
    FriendshipResponse._defaults(this);
  }

  FriendshipResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _requesterId = $v.requesterId;
      _addresseeId = $v.addresseeId;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FriendshipResponse other) {
    _$v = other as _$FriendshipResponse;
  }

  @override
  void update(void Function(FriendshipResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FriendshipResponse build() => _build();

  _$FriendshipResponse _build() {
    final _$result = _$v ??
        _$FriendshipResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FriendshipResponse', 'id'),
          requesterId: BuiltValueNullFieldError.checkNotNull(
              requesterId, r'FriendshipResponse', 'requesterId'),
          addresseeId: BuiltValueNullFieldError.checkNotNull(
              addresseeId, r'FriendshipResponse', 'addresseeId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FriendshipResponse', 'status'),
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
