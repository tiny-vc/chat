// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_friend_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateFriendRequestDto extends CreateFriendRequestDto {
  @override
  final String userId;

  factory _$CreateFriendRequestDto(
          [void Function(CreateFriendRequestDtoBuilder)? updates]) =>
      (CreateFriendRequestDtoBuilder()..update(updates))._build();

  _$CreateFriendRequestDto._({required this.userId}) : super._();
  @override
  CreateFriendRequestDto rebuild(
          void Function(CreateFriendRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateFriendRequestDtoBuilder toBuilder() =>
      CreateFriendRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateFriendRequestDto && userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateFriendRequestDto')
          ..add('userId', userId))
        .toString();
  }
}

class CreateFriendRequestDtoBuilder
    implements Builder<CreateFriendRequestDto, CreateFriendRequestDtoBuilder> {
  _$CreateFriendRequestDto? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  CreateFriendRequestDtoBuilder() {
    CreateFriendRequestDto._defaults(this);
  }

  CreateFriendRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateFriendRequestDto other) {
    _$v = other as _$CreateFriendRequestDto;
  }

  @override
  void update(void Function(CreateFriendRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateFriendRequestDto build() => _build();

  _$CreateFriendRequestDto _build() {
    final _$result = _$v ??
        _$CreateFriendRequestDto._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'CreateFriendRequestDto', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
