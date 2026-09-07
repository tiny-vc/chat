// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runtime_settings_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RuntimeSettingsResponseDto extends RuntimeSettingsResponseDto {
  @override
  final bool registrationEnabled;
  @override
  final RuntimeCapabilitiesDto capabilities;
  @override
  final MessagingPolicySyncDto messagingPolicy;
  @override
  final DateTime updatedAt;

  factory _$RuntimeSettingsResponseDto(
          [void Function(RuntimeSettingsResponseDtoBuilder)? updates]) =>
      (RuntimeSettingsResponseDtoBuilder()..update(updates))._build();

  _$RuntimeSettingsResponseDto._(
      {required this.registrationEnabled,
      required this.capabilities,
      required this.messagingPolicy,
      required this.updatedAt})
      : super._();
  @override
  RuntimeSettingsResponseDto rebuild(
          void Function(RuntimeSettingsResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RuntimeSettingsResponseDtoBuilder toBuilder() =>
      RuntimeSettingsResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RuntimeSettingsResponseDto &&
        registrationEnabled == other.registrationEnabled &&
        capabilities == other.capabilities &&
        messagingPolicy == other.messagingPolicy &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, registrationEnabled.hashCode);
    _$hash = $jc(_$hash, capabilities.hashCode);
    _$hash = $jc(_$hash, messagingPolicy.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RuntimeSettingsResponseDto')
          ..add('registrationEnabled', registrationEnabled)
          ..add('capabilities', capabilities)
          ..add('messagingPolicy', messagingPolicy)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class RuntimeSettingsResponseDtoBuilder
    implements
        Builder<RuntimeSettingsResponseDto, RuntimeSettingsResponseDtoBuilder> {
  _$RuntimeSettingsResponseDto? _$v;

  bool? _registrationEnabled;
  bool? get registrationEnabled => _$this._registrationEnabled;
  set registrationEnabled(bool? registrationEnabled) =>
      _$this._registrationEnabled = registrationEnabled;

  RuntimeCapabilitiesDtoBuilder? _capabilities;
  RuntimeCapabilitiesDtoBuilder get capabilities =>
      _$this._capabilities ??= RuntimeCapabilitiesDtoBuilder();
  set capabilities(RuntimeCapabilitiesDtoBuilder? capabilities) =>
      _$this._capabilities = capabilities;

  MessagingPolicySyncDtoBuilder? _messagingPolicy;
  MessagingPolicySyncDtoBuilder get messagingPolicy =>
      _$this._messagingPolicy ??= MessagingPolicySyncDtoBuilder();
  set messagingPolicy(MessagingPolicySyncDtoBuilder? messagingPolicy) =>
      _$this._messagingPolicy = messagingPolicy;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  RuntimeSettingsResponseDtoBuilder() {
    RuntimeSettingsResponseDto._defaults(this);
  }

  RuntimeSettingsResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _registrationEnabled = $v.registrationEnabled;
      _capabilities = $v.capabilities.toBuilder();
      _messagingPolicy = $v.messagingPolicy.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RuntimeSettingsResponseDto other) {
    _$v = other as _$RuntimeSettingsResponseDto;
  }

  @override
  void update(void Function(RuntimeSettingsResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RuntimeSettingsResponseDto build() => _build();

  _$RuntimeSettingsResponseDto _build() {
    _$RuntimeSettingsResponseDto _$result;
    try {
      _$result = _$v ??
          _$RuntimeSettingsResponseDto._(
            registrationEnabled: BuiltValueNullFieldError.checkNotNull(
                registrationEnabled,
                r'RuntimeSettingsResponseDto',
                'registrationEnabled'),
            capabilities: capabilities.build(),
            messagingPolicy: messagingPolicy.build(),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'RuntimeSettingsResponseDto', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'capabilities';
        capabilities.build();
        _$failedField = 'messagingPolicy';
        messagingPolicy.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RuntimeSettingsResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
