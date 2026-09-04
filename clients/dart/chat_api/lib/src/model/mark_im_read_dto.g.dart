// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_im_read_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MarkImReadDtoChannelTypeEnum _$markImReadDtoChannelTypeEnum_n1 =
    const MarkImReadDtoChannelTypeEnum._('n1');
const MarkImReadDtoChannelTypeEnum _$markImReadDtoChannelTypeEnum_n2 =
    const MarkImReadDtoChannelTypeEnum._('n2');
const MarkImReadDtoChannelTypeEnum
    _$markImReadDtoChannelTypeEnum_unknownDefaultOpenApi =
    const MarkImReadDtoChannelTypeEnum._('unknownDefaultOpenApi');

MarkImReadDtoChannelTypeEnum _$markImReadDtoChannelTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'n1':
      return _$markImReadDtoChannelTypeEnum_n1;
    case 'n2':
      return _$markImReadDtoChannelTypeEnum_n2;
    case 'unknownDefaultOpenApi':
      return _$markImReadDtoChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$markImReadDtoChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<MarkImReadDtoChannelTypeEnum>
    _$markImReadDtoChannelTypeEnumValues =
    BuiltSet<MarkImReadDtoChannelTypeEnum>(const <MarkImReadDtoChannelTypeEnum>[
  _$markImReadDtoChannelTypeEnum_n1,
  _$markImReadDtoChannelTypeEnum_n2,
  _$markImReadDtoChannelTypeEnum_unknownDefaultOpenApi,
]);

Serializer<MarkImReadDtoChannelTypeEnum>
    _$markImReadDtoChannelTypeEnumSerializer =
    _$MarkImReadDtoChannelTypeEnumSerializer();

class _$MarkImReadDtoChannelTypeEnumSerializer
    implements PrimitiveSerializer<MarkImReadDtoChannelTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n1': '1',
    'n2': '2',
    'unknownDefaultOpenApi': '11184809',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '1': 'n1',
    '2': 'n2',
    '11184809': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[MarkImReadDtoChannelTypeEnum];
  @override
  final String wireName = 'MarkImReadDtoChannelTypeEnum';

  @override
  Object serialize(Serializers serializers, MarkImReadDtoChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MarkImReadDtoChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MarkImReadDtoChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MarkImReadDto extends MarkImReadDto {
  @override
  final String channelId;
  @override
  final MarkImReadDtoChannelTypeEnum channelType;
  @override
  final num messageSeq;

  factory _$MarkImReadDto([void Function(MarkImReadDtoBuilder)? updates]) =>
      (MarkImReadDtoBuilder()..update(updates))._build();

  _$MarkImReadDto._(
      {required this.channelId,
      required this.channelType,
      required this.messageSeq})
      : super._();
  @override
  MarkImReadDto rebuild(void Function(MarkImReadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MarkImReadDtoBuilder toBuilder() => MarkImReadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MarkImReadDto &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        messageSeq == other.messageSeq;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, messageSeq.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MarkImReadDto')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('messageSeq', messageSeq))
        .toString();
  }
}

class MarkImReadDtoBuilder
    implements Builder<MarkImReadDto, MarkImReadDtoBuilder> {
  _$MarkImReadDto? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  MarkImReadDtoChannelTypeEnum? _channelType;
  MarkImReadDtoChannelTypeEnum? get channelType => _$this._channelType;
  set channelType(MarkImReadDtoChannelTypeEnum? channelType) =>
      _$this._channelType = channelType;

  num? _messageSeq;
  num? get messageSeq => _$this._messageSeq;
  set messageSeq(num? messageSeq) => _$this._messageSeq = messageSeq;

  MarkImReadDtoBuilder() {
    MarkImReadDto._defaults(this);
  }

  MarkImReadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _messageSeq = $v.messageSeq;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MarkImReadDto other) {
    _$v = other as _$MarkImReadDto;
  }

  @override
  void update(void Function(MarkImReadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MarkImReadDto build() => _build();

  _$MarkImReadDto _build() {
    final _$result = _$v ??
        _$MarkImReadDto._(
          channelId: BuiltValueNullFieldError.checkNotNull(
              channelId, r'MarkImReadDto', 'channelId'),
          channelType: BuiltValueNullFieldError.checkNotNull(
              channelType, r'MarkImReadDto', 'channelType'),
          messageSeq: BuiltValueNullFieldError.checkNotNull(
              messageSeq, r'MarkImReadDto', 'messageSeq'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
