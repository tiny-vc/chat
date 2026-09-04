// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_owner_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransferOwnerDto extends TransferOwnerDto {
  @override
  final String userId;

  factory _$TransferOwnerDto(
          [void Function(TransferOwnerDtoBuilder)? updates]) =>
      (TransferOwnerDtoBuilder()..update(updates))._build();

  _$TransferOwnerDto._({required this.userId}) : super._();
  @override
  TransferOwnerDto rebuild(void Function(TransferOwnerDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransferOwnerDtoBuilder toBuilder() =>
      TransferOwnerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransferOwnerDto && userId == other.userId;
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
    return (newBuiltValueToStringHelper(r'TransferOwnerDto')
          ..add('userId', userId))
        .toString();
  }
}

class TransferOwnerDtoBuilder
    implements Builder<TransferOwnerDto, TransferOwnerDtoBuilder> {
  _$TransferOwnerDto? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  TransferOwnerDtoBuilder() {
    TransferOwnerDto._defaults(this);
  }

  TransferOwnerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransferOwnerDto other) {
    _$v = other as _$TransferOwnerDto;
  }

  @override
  void update(void Function(TransferOwnerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransferOwnerDto build() => _build();

  _$TransferOwnerDto _build() {
    final _$result = _$v ??
        _$TransferOwnerDto._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'TransferOwnerDto', 'userId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
