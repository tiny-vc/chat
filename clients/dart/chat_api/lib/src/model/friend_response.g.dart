// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FriendResponse extends FriendResponse {
  @override
  final String friendshipId;
  @override
  final UserResponse user;
  @override
  final DateTime createdAt;

  factory _$FriendResponse([void Function(FriendResponseBuilder)? updates]) =>
      (FriendResponseBuilder()..update(updates))._build();

  _$FriendResponse._(
      {required this.friendshipId, required this.user, required this.createdAt})
      : super._();
  @override
  FriendResponse rebuild(void Function(FriendResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FriendResponseBuilder toBuilder() => FriendResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FriendResponse &&
        friendshipId == other.friendshipId &&
        user == other.user &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, friendshipId.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FriendResponse')
          ..add('friendshipId', friendshipId)
          ..add('user', user)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class FriendResponseBuilder
    implements Builder<FriendResponse, FriendResponseBuilder> {
  _$FriendResponse? _$v;

  String? _friendshipId;
  String? get friendshipId => _$this._friendshipId;
  set friendshipId(String? friendshipId) => _$this._friendshipId = friendshipId;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  FriendResponseBuilder() {
    FriendResponse._defaults(this);
  }

  FriendResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _friendshipId = $v.friendshipId;
      _user = $v.user.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FriendResponse other) {
    _$v = other as _$FriendResponse;
  }

  @override
  void update(void Function(FriendResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FriendResponse build() => _build();

  _$FriendResponse _build() {
    _$FriendResponse _$result;
    try {
      _$result = _$v ??
          _$FriendResponse._(
            friendshipId: BuiltValueNullFieldError.checkNotNull(
                friendshipId, r'FriendResponse', 'friendshipId'),
            user: user.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'FriendResponse', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FriendResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
