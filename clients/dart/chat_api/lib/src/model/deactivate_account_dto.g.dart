// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deactivate_account_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeactivateAccountDto extends DeactivateAccountDto {
  @override
  final String currentPassword;

  factory _$DeactivateAccountDto(
          [void Function(DeactivateAccountDtoBuilder)? updates]) =>
      (DeactivateAccountDtoBuilder()..update(updates))._build();

  _$DeactivateAccountDto._({required this.currentPassword}) : super._();
  @override
  DeactivateAccountDto rebuild(
          void Function(DeactivateAccountDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeactivateAccountDtoBuilder toBuilder() =>
      DeactivateAccountDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeactivateAccountDto &&
        currentPassword == other.currentPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currentPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeactivateAccountDto')
          ..add('currentPassword', currentPassword))
        .toString();
  }
}

class DeactivateAccountDtoBuilder
    implements Builder<DeactivateAccountDto, DeactivateAccountDtoBuilder> {
  _$DeactivateAccountDto? _$v;

  String? _currentPassword;
  String? get currentPassword => _$this._currentPassword;
  set currentPassword(String? currentPassword) =>
      _$this._currentPassword = currentPassword;

  DeactivateAccountDtoBuilder() {
    DeactivateAccountDto._defaults(this);
  }

  DeactivateAccountDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentPassword = $v.currentPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeactivateAccountDto other) {
    _$v = other as _$DeactivateAccountDto;
  }

  @override
  void update(void Function(DeactivateAccountDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeactivateAccountDto build() => _build();

  _$DeactivateAccountDto _build() {
    final _$result = _$v ??
        _$DeactivateAccountDto._(
          currentPassword: BuiltValueNullFieldError.checkNotNull(
              currentPassword, r'DeactivateAccountDto', 'currentPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
