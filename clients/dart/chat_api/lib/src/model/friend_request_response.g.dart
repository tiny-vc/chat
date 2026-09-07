// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FriendRequestResponseStatusEnum
    _$friendRequestResponseStatusEnum_PENDING =
    const FriendRequestResponseStatusEnum._('PENDING');
const FriendRequestResponseStatusEnum
    _$friendRequestResponseStatusEnum_ACCEPTED =
    const FriendRequestResponseStatusEnum._('ACCEPTED');
const FriendRequestResponseStatusEnum
    _$friendRequestResponseStatusEnum_REJECTED =
    const FriendRequestResponseStatusEnum._('REJECTED');
const FriendRequestResponseStatusEnum
    _$friendRequestResponseStatusEnum_BLOCKED =
    const FriendRequestResponseStatusEnum._('BLOCKED');
const FriendRequestResponseStatusEnum
    _$friendRequestResponseStatusEnum_unknownDefaultOpenApi =
    const FriendRequestResponseStatusEnum._('unknownDefaultOpenApi');

FriendRequestResponseStatusEnum _$friendRequestResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$friendRequestResponseStatusEnum_PENDING;
    case 'ACCEPTED':
      return _$friendRequestResponseStatusEnum_ACCEPTED;
    case 'REJECTED':
      return _$friendRequestResponseStatusEnum_REJECTED;
    case 'BLOCKED':
      return _$friendRequestResponseStatusEnum_BLOCKED;
    case 'unknownDefaultOpenApi':
      return _$friendRequestResponseStatusEnum_unknownDefaultOpenApi;
    default:
      return _$friendRequestResponseStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<FriendRequestResponseStatusEnum>
    _$friendRequestResponseStatusEnumValues = BuiltSet<
        FriendRequestResponseStatusEnum>(const <FriendRequestResponseStatusEnum>[
  _$friendRequestResponseStatusEnum_PENDING,
  _$friendRequestResponseStatusEnum_ACCEPTED,
  _$friendRequestResponseStatusEnum_REJECTED,
  _$friendRequestResponseStatusEnum_BLOCKED,
  _$friendRequestResponseStatusEnum_unknownDefaultOpenApi,
]);

Serializer<FriendRequestResponseStatusEnum>
    _$friendRequestResponseStatusEnumSerializer =
    _$FriendRequestResponseStatusEnumSerializer();

class _$FriendRequestResponseStatusEnumSerializer
    implements PrimitiveSerializer<FriendRequestResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[FriendRequestResponseStatusEnum];
  @override
  final String wireName = 'FriendRequestResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, FriendRequestResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FriendRequestResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FriendRequestResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FriendRequestResponse extends FriendRequestResponse {
  @override
  final UserResponse requester;
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

  factory _$FriendRequestResponse(
          [void Function(FriendRequestResponseBuilder)? updates]) =>
      (FriendRequestResponseBuilder()..update(updates))._build();

  _$FriendRequestResponse._(
      {required this.requester,
      required this.id,
      required this.requesterId,
      required this.addresseeId,
      required this.status,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  FriendRequestResponse rebuild(
          void Function(FriendRequestResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FriendRequestResponseBuilder toBuilder() =>
      FriendRequestResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FriendRequestResponse &&
        requester == other.requester &&
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
    _$hash = $jc(_$hash, requester.hashCode);
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
    return (newBuiltValueToStringHelper(r'FriendRequestResponse')
          ..add('requester', requester)
          ..add('id', id)
          ..add('requesterId', requesterId)
          ..add('addresseeId', addresseeId)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class FriendRequestResponseBuilder
    implements
        Builder<FriendRequestResponse, FriendRequestResponseBuilder>,
        FriendshipResponseBuilder {
  _$FriendRequestResponse? _$v;

  UserResponseBuilder? _requester;
  UserResponseBuilder get requester =>
      _$this._requester ??= UserResponseBuilder();
  set requester(covariant UserResponseBuilder? requester) =>
      _$this._requester = requester;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _requesterId;
  String? get requesterId => _$this._requesterId;
  set requesterId(covariant String? requesterId) =>
      _$this._requesterId = requesterId;

  String? _addresseeId;
  String? get addresseeId => _$this._addresseeId;
  set addresseeId(covariant String? addresseeId) =>
      _$this._addresseeId = addresseeId;

  FriendshipResponseStatusEnum? _status;
  FriendshipResponseStatusEnum? get status => _$this._status;
  set status(covariant FriendshipResponseStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(covariant DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(covariant DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  FriendRequestResponseBuilder() {
    FriendRequestResponse._defaults(this);
  }

  FriendRequestResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requester = $v.requester.toBuilder();
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
  void replace(covariant FriendRequestResponse other) {
    _$v = other as _$FriendRequestResponse;
  }

  @override
  void update(void Function(FriendRequestResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FriendRequestResponse build() => _build();

  _$FriendRequestResponse _build() {
    _$FriendRequestResponse _$result;
    try {
      _$result = _$v ??
          _$FriendRequestResponse._(
            requester: requester.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FriendRequestResponse', 'id'),
            requesterId: BuiltValueNullFieldError.checkNotNull(
                requesterId, r'FriendRequestResponse', 'requesterId'),
            addresseeId: BuiltValueNullFieldError.checkNotNull(
                addresseeId, r'FriendRequestResponse', 'addresseeId'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'FriendRequestResponse', 'status'),
            createdAt: createdAt,
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requester';
        requester.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FriendRequestResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
