// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockedUserResponse extends BlockedUserResponse {
  @override
  final UserResponse user;
  @override
  final DateTime createdAt;

  factory _$BlockedUserResponse(
          [void Function(BlockedUserResponseBuilder)? updates]) =>
      (BlockedUserResponseBuilder()..update(updates))._build();

  _$BlockedUserResponse._({required this.user, required this.createdAt})
      : super._();
  @override
  BlockedUserResponse rebuild(
          void Function(BlockedUserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockedUserResponseBuilder toBuilder() =>
      BlockedUserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockedUserResponse &&
        user == other.user &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockedUserResponse')
          ..add('user', user)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class BlockedUserResponseBuilder
    implements Builder<BlockedUserResponse, BlockedUserResponseBuilder> {
  _$BlockedUserResponse? _$v;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  BlockedUserResponseBuilder() {
    BlockedUserResponse._defaults(this);
  }

  BlockedUserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockedUserResponse other) {
    _$v = other as _$BlockedUserResponse;
  }

  @override
  void update(void Function(BlockedUserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockedUserResponse build() => _build();

  _$BlockedUserResponse _build() {
    _$BlockedUserResponse _$result;
    try {
      _$result = _$v ??
          _$BlockedUserResponse._(
            user: user.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'BlockedUserResponse', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BlockedUserResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
