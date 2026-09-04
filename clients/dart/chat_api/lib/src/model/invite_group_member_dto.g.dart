// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_group_member_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InviteGroupMemberDto extends InviteGroupMemberDto {
  @override
  final String userId;
  @override
  final String? message;

  factory _$InviteGroupMemberDto(
          [void Function(InviteGroupMemberDtoBuilder)? updates]) =>
      (InviteGroupMemberDtoBuilder()..update(updates))._build();

  _$InviteGroupMemberDto._({required this.userId, this.message}) : super._();
  @override
  InviteGroupMemberDto rebuild(
          void Function(InviteGroupMemberDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteGroupMemberDtoBuilder toBuilder() =>
      InviteGroupMemberDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteGroupMemberDto &&
        userId == other.userId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InviteGroupMemberDto')
          ..add('userId', userId)
          ..add('message', message))
        .toString();
  }
}

class InviteGroupMemberDtoBuilder
    implements Builder<InviteGroupMemberDto, InviteGroupMemberDtoBuilder> {
  _$InviteGroupMemberDto? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  InviteGroupMemberDtoBuilder() {
    InviteGroupMemberDto._defaults(this);
  }

  InviteGroupMemberDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteGroupMemberDto other) {
    _$v = other as _$InviteGroupMemberDto;
  }

  @override
  void update(void Function(InviteGroupMemberDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InviteGroupMemberDto build() => _build();

  _$InviteGroupMemberDto _build() {
    final _$result = _$v ??
        _$InviteGroupMemberDto._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'InviteGroupMemberDto', 'userId'),
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
