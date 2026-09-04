// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_join_message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupJoinMessageDto extends GroupJoinMessageDto {
  @override
  final String? message;

  factory _$GroupJoinMessageDto(
          [void Function(GroupJoinMessageDtoBuilder)? updates]) =>
      (GroupJoinMessageDtoBuilder()..update(updates))._build();

  _$GroupJoinMessageDto._({this.message}) : super._();
  @override
  GroupJoinMessageDto rebuild(
          void Function(GroupJoinMessageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupJoinMessageDtoBuilder toBuilder() =>
      GroupJoinMessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupJoinMessageDto && message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupJoinMessageDto')
          ..add('message', message))
        .toString();
  }
}

class GroupJoinMessageDtoBuilder
    implements Builder<GroupJoinMessageDto, GroupJoinMessageDtoBuilder> {
  _$GroupJoinMessageDto? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  GroupJoinMessageDtoBuilder() {
    GroupJoinMessageDto._defaults(this);
  }

  GroupJoinMessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupJoinMessageDto other) {
    _$v = other as _$GroupJoinMessageDto;
  }

  @override
  void update(void Function(GroupJoinMessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupJoinMessageDto build() => _build();

  _$GroupJoinMessageDto _build() {
    final _$result = _$v ??
        _$GroupJoinMessageDto._(
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
