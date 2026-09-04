// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnum_AVATAR =
    const CreateUploadDtoPurposeEnum._('AVATAR');
const CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnum_CHAT_IMAGE =
    const CreateUploadDtoPurposeEnum._('CHAT_IMAGE');
const CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnum_CHAT_VOICE =
    const CreateUploadDtoPurposeEnum._('CHAT_VOICE');
const CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnum_CHAT_VIDEO =
    const CreateUploadDtoPurposeEnum._('CHAT_VIDEO');
const CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnum_CHAT_FILE =
    const CreateUploadDtoPurposeEnum._('CHAT_FILE');
const CreateUploadDtoPurposeEnum
    _$createUploadDtoPurposeEnum_unknownDefaultOpenApi =
    const CreateUploadDtoPurposeEnum._('unknownDefaultOpenApi');

CreateUploadDtoPurposeEnum _$createUploadDtoPurposeEnumValueOf(String name) {
  switch (name) {
    case 'AVATAR':
      return _$createUploadDtoPurposeEnum_AVATAR;
    case 'CHAT_IMAGE':
      return _$createUploadDtoPurposeEnum_CHAT_IMAGE;
    case 'CHAT_VOICE':
      return _$createUploadDtoPurposeEnum_CHAT_VOICE;
    case 'CHAT_VIDEO':
      return _$createUploadDtoPurposeEnum_CHAT_VIDEO;
    case 'CHAT_FILE':
      return _$createUploadDtoPurposeEnum_CHAT_FILE;
    case 'unknownDefaultOpenApi':
      return _$createUploadDtoPurposeEnum_unknownDefaultOpenApi;
    default:
      return _$createUploadDtoPurposeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CreateUploadDtoPurposeEnum> _$createUploadDtoPurposeEnumValues =
    BuiltSet<CreateUploadDtoPurposeEnum>(const <CreateUploadDtoPurposeEnum>[
  _$createUploadDtoPurposeEnum_AVATAR,
  _$createUploadDtoPurposeEnum_CHAT_IMAGE,
  _$createUploadDtoPurposeEnum_CHAT_VOICE,
  _$createUploadDtoPurposeEnum_CHAT_VIDEO,
  _$createUploadDtoPurposeEnum_CHAT_FILE,
  _$createUploadDtoPurposeEnum_unknownDefaultOpenApi,
]);

const CreateUploadDtoScopeEnum _$createUploadDtoScopeEnum_PRIVATE =
    const CreateUploadDtoScopeEnum._('PRIVATE');
const CreateUploadDtoScopeEnum _$createUploadDtoScopeEnum_DIRECT =
    const CreateUploadDtoScopeEnum._('DIRECT');
const CreateUploadDtoScopeEnum _$createUploadDtoScopeEnum_GROUP =
    const CreateUploadDtoScopeEnum._('GROUP');
const CreateUploadDtoScopeEnum
    _$createUploadDtoScopeEnum_unknownDefaultOpenApi =
    const CreateUploadDtoScopeEnum._('unknownDefaultOpenApi');

CreateUploadDtoScopeEnum _$createUploadDtoScopeEnumValueOf(String name) {
  switch (name) {
    case 'PRIVATE':
      return _$createUploadDtoScopeEnum_PRIVATE;
    case 'DIRECT':
      return _$createUploadDtoScopeEnum_DIRECT;
    case 'GROUP':
      return _$createUploadDtoScopeEnum_GROUP;
    case 'unknownDefaultOpenApi':
      return _$createUploadDtoScopeEnum_unknownDefaultOpenApi;
    default:
      return _$createUploadDtoScopeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CreateUploadDtoScopeEnum> _$createUploadDtoScopeEnumValues =
    BuiltSet<CreateUploadDtoScopeEnum>(const <CreateUploadDtoScopeEnum>[
  _$createUploadDtoScopeEnum_PRIVATE,
  _$createUploadDtoScopeEnum_DIRECT,
  _$createUploadDtoScopeEnum_GROUP,
  _$createUploadDtoScopeEnum_unknownDefaultOpenApi,
]);

Serializer<CreateUploadDtoPurposeEnum> _$createUploadDtoPurposeEnumSerializer =
    _$CreateUploadDtoPurposeEnumSerializer();
Serializer<CreateUploadDtoScopeEnum> _$createUploadDtoScopeEnumSerializer =
    _$CreateUploadDtoScopeEnumSerializer();

class _$CreateUploadDtoPurposeEnumSerializer
    implements PrimitiveSerializer<CreateUploadDtoPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVATAR': 'AVATAR',
    'CHAT_IMAGE': 'CHAT_IMAGE',
    'CHAT_VOICE': 'CHAT_VOICE',
    'CHAT_VIDEO': 'CHAT_VIDEO',
    'CHAT_FILE': 'CHAT_FILE',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVATAR': 'AVATAR',
    'CHAT_IMAGE': 'CHAT_IMAGE',
    'CHAT_VOICE': 'CHAT_VOICE',
    'CHAT_VIDEO': 'CHAT_VIDEO',
    'CHAT_FILE': 'CHAT_FILE',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateUploadDtoPurposeEnum];
  @override
  final String wireName = 'CreateUploadDtoPurposeEnum';

  @override
  Object serialize(Serializers serializers, CreateUploadDtoPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateUploadDtoPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateUploadDtoPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateUploadDtoScopeEnumSerializer
    implements PrimitiveSerializer<CreateUploadDtoScopeEnum> {
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
  final Iterable<Type> types = const <Type>[CreateUploadDtoScopeEnum];
  @override
  final String wireName = 'CreateUploadDtoScopeEnum';

  @override
  Object serialize(Serializers serializers, CreateUploadDtoScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateUploadDtoScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateUploadDtoScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateUploadDto extends CreateUploadDto {
  @override
  final String fileName;
  @override
  final String mimeType;
  @override
  final num size;
  @override
  final CreateUploadDtoPurposeEnum purpose;
  @override
  final CreateUploadDtoScopeEnum scope;
  @override
  final String? scopeId;

  factory _$CreateUploadDto([void Function(CreateUploadDtoBuilder)? updates]) =>
      (CreateUploadDtoBuilder()..update(updates))._build();

  _$CreateUploadDto._(
      {required this.fileName,
      required this.mimeType,
      required this.size,
      required this.purpose,
      required this.scope,
      this.scopeId})
      : super._();
  @override
  CreateUploadDto rebuild(void Function(CreateUploadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateUploadDtoBuilder toBuilder() => CreateUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUploadDto &&
        fileName == other.fileName &&
        mimeType == other.mimeType &&
        size == other.size &&
        purpose == other.purpose &&
        scope == other.scope &&
        scopeId == other.scopeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, scopeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateUploadDto')
          ..add('fileName', fileName)
          ..add('mimeType', mimeType)
          ..add('size', size)
          ..add('purpose', purpose)
          ..add('scope', scope)
          ..add('scopeId', scopeId))
        .toString();
  }
}

class CreateUploadDtoBuilder
    implements Builder<CreateUploadDto, CreateUploadDtoBuilder> {
  _$CreateUploadDto? _$v;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  num? _size;
  num? get size => _$this._size;
  set size(num? size) => _$this._size = size;

  CreateUploadDtoPurposeEnum? _purpose;
  CreateUploadDtoPurposeEnum? get purpose => _$this._purpose;
  set purpose(CreateUploadDtoPurposeEnum? purpose) => _$this._purpose = purpose;

  CreateUploadDtoScopeEnum? _scope;
  CreateUploadDtoScopeEnum? get scope => _$this._scope;
  set scope(CreateUploadDtoScopeEnum? scope) => _$this._scope = scope;

  String? _scopeId;
  String? get scopeId => _$this._scopeId;
  set scopeId(String? scopeId) => _$this._scopeId = scopeId;

  CreateUploadDtoBuilder() {
    CreateUploadDto._defaults(this);
  }

  CreateUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileName = $v.fileName;
      _mimeType = $v.mimeType;
      _size = $v.size;
      _purpose = $v.purpose;
      _scope = $v.scope;
      _scopeId = $v.scopeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateUploadDto other) {
    _$v = other as _$CreateUploadDto;
  }

  @override
  void update(void Function(CreateUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateUploadDto build() => _build();

  _$CreateUploadDto _build() {
    final _$result = _$v ??
        _$CreateUploadDto._(
          fileName: BuiltValueNullFieldError.checkNotNull(
              fileName, r'CreateUploadDto', 'fileName'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'CreateUploadDto', 'mimeType'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'CreateUploadDto', 'size'),
          purpose: BuiltValueNullFieldError.checkNotNull(
              purpose, r'CreateUploadDto', 'purpose'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'CreateUploadDto', 'scope'),
          scopeId: scopeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
