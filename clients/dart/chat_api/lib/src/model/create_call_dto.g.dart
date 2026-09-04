// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_call_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateCallDtoTypeEnum _$createCallDtoTypeEnum_AUDIO =
    const CreateCallDtoTypeEnum._('AUDIO');
const CreateCallDtoTypeEnum _$createCallDtoTypeEnum_VIDEO =
    const CreateCallDtoTypeEnum._('VIDEO');
const CreateCallDtoTypeEnum _$createCallDtoTypeEnum_unknownDefaultOpenApi =
    const CreateCallDtoTypeEnum._('unknownDefaultOpenApi');

CreateCallDtoTypeEnum _$createCallDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'AUDIO':
      return _$createCallDtoTypeEnum_AUDIO;
    case 'VIDEO':
      return _$createCallDtoTypeEnum_VIDEO;
    case 'unknownDefaultOpenApi':
      return _$createCallDtoTypeEnum_unknownDefaultOpenApi;
    default:
      return _$createCallDtoTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<CreateCallDtoTypeEnum> _$createCallDtoTypeEnumValues =
    BuiltSet<CreateCallDtoTypeEnum>(const <CreateCallDtoTypeEnum>[
  _$createCallDtoTypeEnum_AUDIO,
  _$createCallDtoTypeEnum_VIDEO,
  _$createCallDtoTypeEnum_unknownDefaultOpenApi,
]);

Serializer<CreateCallDtoTypeEnum> _$createCallDtoTypeEnumSerializer =
    _$CreateCallDtoTypeEnumSerializer();

class _$CreateCallDtoTypeEnumSerializer
    implements PrimitiveSerializer<CreateCallDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AUDIO': 'AUDIO',
    'VIDEO': 'VIDEO',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AUDIO': 'AUDIO',
    'VIDEO': 'VIDEO',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateCallDtoTypeEnum];
  @override
  final String wireName = 'CreateCallDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, CreateCallDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateCallDtoTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateCallDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateCallDto extends CreateCallDto {
  @override
  final String targetUserId;
  @override
  final CreateCallDtoTypeEnum type;

  factory _$CreateCallDto([void Function(CreateCallDtoBuilder)? updates]) =>
      (CreateCallDtoBuilder()..update(updates))._build();

  _$CreateCallDto._({required this.targetUserId, required this.type})
      : super._();
  @override
  CreateCallDto rebuild(void Function(CreateCallDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCallDtoBuilder toBuilder() => CreateCallDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCallDto &&
        targetUserId == other.targetUserId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetUserId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCallDto')
          ..add('targetUserId', targetUserId)
          ..add('type', type))
        .toString();
  }
}

class CreateCallDtoBuilder
    implements Builder<CreateCallDto, CreateCallDtoBuilder> {
  _$CreateCallDto? _$v;

  String? _targetUserId;
  String? get targetUserId => _$this._targetUserId;
  set targetUserId(String? targetUserId) => _$this._targetUserId = targetUserId;

  CreateCallDtoTypeEnum? _type;
  CreateCallDtoTypeEnum? get type => _$this._type;
  set type(CreateCallDtoTypeEnum? type) => _$this._type = type;

  CreateCallDtoBuilder() {
    CreateCallDto._defaults(this);
  }

  CreateCallDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetUserId = $v.targetUserId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCallDto other) {
    _$v = other as _$CreateCallDto;
  }

  @override
  void update(void Function(CreateCallDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCallDto build() => _build();

  _$CreateCallDto _build() {
    final _$result = _$v ??
        _$CreateCallDto._(
          targetUserId: BuiltValueNullFieldError.checkNotNull(
              targetUserId, r'CreateCallDto', 'targetUserId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CreateCallDto', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
