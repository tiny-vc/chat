// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forward_file_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ForwardFileDtoScopeEnum _$forwardFileDtoScopeEnum_PRIVATE =
    const ForwardFileDtoScopeEnum._('PRIVATE');
const ForwardFileDtoScopeEnum _$forwardFileDtoScopeEnum_DIRECT =
    const ForwardFileDtoScopeEnum._('DIRECT');
const ForwardFileDtoScopeEnum _$forwardFileDtoScopeEnum_GROUP =
    const ForwardFileDtoScopeEnum._('GROUP');
const ForwardFileDtoScopeEnum _$forwardFileDtoScopeEnum_unknownDefaultOpenApi =
    const ForwardFileDtoScopeEnum._('unknownDefaultOpenApi');

ForwardFileDtoScopeEnum _$forwardFileDtoScopeEnumValueOf(String name) {
  switch (name) {
    case 'PRIVATE':
      return _$forwardFileDtoScopeEnum_PRIVATE;
    case 'DIRECT':
      return _$forwardFileDtoScopeEnum_DIRECT;
    case 'GROUP':
      return _$forwardFileDtoScopeEnum_GROUP;
    case 'unknownDefaultOpenApi':
      return _$forwardFileDtoScopeEnum_unknownDefaultOpenApi;
    default:
      return _$forwardFileDtoScopeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ForwardFileDtoScopeEnum> _$forwardFileDtoScopeEnumValues =
    BuiltSet<ForwardFileDtoScopeEnum>(const <ForwardFileDtoScopeEnum>[
  _$forwardFileDtoScopeEnum_PRIVATE,
  _$forwardFileDtoScopeEnum_DIRECT,
  _$forwardFileDtoScopeEnum_GROUP,
  _$forwardFileDtoScopeEnum_unknownDefaultOpenApi,
]);

Serializer<ForwardFileDtoScopeEnum> _$forwardFileDtoScopeEnumSerializer =
    _$ForwardFileDtoScopeEnumSerializer();

class _$ForwardFileDtoScopeEnumSerializer
    implements PrimitiveSerializer<ForwardFileDtoScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRIVATE': 'PRIVATE',
    'DIRECT': 'DIRECT',
    'GROUP': 'GROUP',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRIVATE': 'PRIVATE',
    'DIRECT': 'DIRECT',
    'GROUP': 'GROUP',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ForwardFileDtoScopeEnum];
  @override
  final String wireName = 'ForwardFileDtoScopeEnum';

  @override
  Object serialize(Serializers serializers, ForwardFileDtoScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ForwardFileDtoScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ForwardFileDtoScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ForwardFileDto extends ForwardFileDto {
  @override
  final ForwardFileDtoScopeEnum scope;
  @override
  final String scopeId;

  factory _$ForwardFileDto([void Function(ForwardFileDtoBuilder)? updates]) =>
      (ForwardFileDtoBuilder()..update(updates))._build();

  _$ForwardFileDto._({required this.scope, required this.scopeId}) : super._();
  @override
  ForwardFileDto rebuild(void Function(ForwardFileDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ForwardFileDtoBuilder toBuilder() => ForwardFileDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ForwardFileDto &&
        scope == other.scope &&
        scopeId == other.scopeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, scopeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ForwardFileDto')
          ..add('scope', scope)
          ..add('scopeId', scopeId))
        .toString();
  }
}

class ForwardFileDtoBuilder
    implements Builder<ForwardFileDto, ForwardFileDtoBuilder> {
  _$ForwardFileDto? _$v;

  ForwardFileDtoScopeEnum? _scope;
  ForwardFileDtoScopeEnum? get scope => _$this._scope;
  set scope(ForwardFileDtoScopeEnum? scope) => _$this._scope = scope;

  String? _scopeId;
  String? get scopeId => _$this._scopeId;
  set scopeId(String? scopeId) => _$this._scopeId = scopeId;

  ForwardFileDtoBuilder() {
    ForwardFileDto._defaults(this);
  }

  ForwardFileDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope;
      _scopeId = $v.scopeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ForwardFileDto other) {
    _$v = other as _$ForwardFileDto;
  }

  @override
  void update(void Function(ForwardFileDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ForwardFileDto build() => _build();

  _$ForwardFileDto _build() {
    final _$result = _$v ??
        _$ForwardFileDto._(
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'ForwardFileDto', 'scope'),
          scopeId: BuiltValueNullFieldError.checkNotNull(
              scopeId, r'ForwardFileDto', 'scopeId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
