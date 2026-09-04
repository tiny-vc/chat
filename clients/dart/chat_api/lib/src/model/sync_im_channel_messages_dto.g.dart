// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_im_channel_messages_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SyncImChannelMessagesDtoChannelTypeEnum
    _$syncImChannelMessagesDtoChannelTypeEnum_n1 =
    const SyncImChannelMessagesDtoChannelTypeEnum._('n1');
const SyncImChannelMessagesDtoChannelTypeEnum
    _$syncImChannelMessagesDtoChannelTypeEnum_n2 =
    const SyncImChannelMessagesDtoChannelTypeEnum._('n2');
const SyncImChannelMessagesDtoChannelTypeEnum
    _$syncImChannelMessagesDtoChannelTypeEnum_unknownDefaultOpenApi =
    const SyncImChannelMessagesDtoChannelTypeEnum._('unknownDefaultOpenApi');

SyncImChannelMessagesDtoChannelTypeEnum
    _$syncImChannelMessagesDtoChannelTypeEnumValueOf(String name) {
  switch (name) {
    case 'n1':
      return _$syncImChannelMessagesDtoChannelTypeEnum_n1;
    case 'n2':
      return _$syncImChannelMessagesDtoChannelTypeEnum_n2;
    case 'unknownDefaultOpenApi':
      return _$syncImChannelMessagesDtoChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$syncImChannelMessagesDtoChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<SyncImChannelMessagesDtoChannelTypeEnum>
    _$syncImChannelMessagesDtoChannelTypeEnumValues = BuiltSet<
        SyncImChannelMessagesDtoChannelTypeEnum>(const <SyncImChannelMessagesDtoChannelTypeEnum>[
  _$syncImChannelMessagesDtoChannelTypeEnum_n1,
  _$syncImChannelMessagesDtoChannelTypeEnum_n2,
  _$syncImChannelMessagesDtoChannelTypeEnum_unknownDefaultOpenApi,
]);

const SyncImChannelMessagesDtoPullModeEnum
    _$syncImChannelMessagesDtoPullModeEnum_n0 =
    const SyncImChannelMessagesDtoPullModeEnum._('n0');
const SyncImChannelMessagesDtoPullModeEnum
    _$syncImChannelMessagesDtoPullModeEnum_n1 =
    const SyncImChannelMessagesDtoPullModeEnum._('n1');
const SyncImChannelMessagesDtoPullModeEnum
    _$syncImChannelMessagesDtoPullModeEnum_unknownDefaultOpenApi =
    const SyncImChannelMessagesDtoPullModeEnum._('unknownDefaultOpenApi');

SyncImChannelMessagesDtoPullModeEnum
    _$syncImChannelMessagesDtoPullModeEnumValueOf(String name) {
  switch (name) {
    case 'n0':
      return _$syncImChannelMessagesDtoPullModeEnum_n0;
    case 'n1':
      return _$syncImChannelMessagesDtoPullModeEnum_n1;
    case 'unknownDefaultOpenApi':
      return _$syncImChannelMessagesDtoPullModeEnum_unknownDefaultOpenApi;
    default:
      return _$syncImChannelMessagesDtoPullModeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<SyncImChannelMessagesDtoPullModeEnum>
    _$syncImChannelMessagesDtoPullModeEnumValues = BuiltSet<
        SyncImChannelMessagesDtoPullModeEnum>(const <SyncImChannelMessagesDtoPullModeEnum>[
  _$syncImChannelMessagesDtoPullModeEnum_n0,
  _$syncImChannelMessagesDtoPullModeEnum_n1,
  _$syncImChannelMessagesDtoPullModeEnum_unknownDefaultOpenApi,
]);

Serializer<SyncImChannelMessagesDtoChannelTypeEnum>
    _$syncImChannelMessagesDtoChannelTypeEnumSerializer =
    _$SyncImChannelMessagesDtoChannelTypeEnumSerializer();
Serializer<SyncImChannelMessagesDtoPullModeEnum>
    _$syncImChannelMessagesDtoPullModeEnumSerializer =
    _$SyncImChannelMessagesDtoPullModeEnumSerializer();

class _$SyncImChannelMessagesDtoChannelTypeEnumSerializer
    implements PrimitiveSerializer<SyncImChannelMessagesDtoChannelTypeEnum> {
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
  final Iterable<Type> types = const <Type>[
    SyncImChannelMessagesDtoChannelTypeEnum
  ];
  @override
  final String wireName = 'SyncImChannelMessagesDtoChannelTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SyncImChannelMessagesDtoChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncImChannelMessagesDtoChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncImChannelMessagesDtoChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SyncImChannelMessagesDtoPullModeEnumSerializer
    implements PrimitiveSerializer<SyncImChannelMessagesDtoPullModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n0': '0',
    'n1': '1',
    'unknownDefaultOpenApi': '11184809',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '0': 'n0',
    '1': 'n1',
    '11184809': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SyncImChannelMessagesDtoPullModeEnum
  ];
  @override
  final String wireName = 'SyncImChannelMessagesDtoPullModeEnum';

  @override
  Object serialize(
          Serializers serializers, SyncImChannelMessagesDtoPullModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncImChannelMessagesDtoPullModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncImChannelMessagesDtoPullModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SyncImChannelMessagesDto extends SyncImChannelMessagesDto {
  @override
  final num? startMessageSeq;
  @override
  final num? endMessageSeq;
  @override
  final num? limit;
  @override
  final String channelId;
  @override
  final SyncImChannelMessagesDtoChannelTypeEnum channelType;
  @override
  final SyncImChannelMessagesDtoPullModeEnum pullMode;

  factory _$SyncImChannelMessagesDto(
          [void Function(SyncImChannelMessagesDtoBuilder)? updates]) =>
      (SyncImChannelMessagesDtoBuilder()..update(updates))._build();

  _$SyncImChannelMessagesDto._(
      {this.startMessageSeq,
      this.endMessageSeq,
      this.limit,
      required this.channelId,
      required this.channelType,
      required this.pullMode})
      : super._();
  @override
  SyncImChannelMessagesDto rebuild(
          void Function(SyncImChannelMessagesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncImChannelMessagesDtoBuilder toBuilder() =>
      SyncImChannelMessagesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncImChannelMessagesDto &&
        startMessageSeq == other.startMessageSeq &&
        endMessageSeq == other.endMessageSeq &&
        limit == other.limit &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        pullMode == other.pullMode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startMessageSeq.hashCode);
    _$hash = $jc(_$hash, endMessageSeq.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, pullMode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncImChannelMessagesDto')
          ..add('startMessageSeq', startMessageSeq)
          ..add('endMessageSeq', endMessageSeq)
          ..add('limit', limit)
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('pullMode', pullMode))
        .toString();
  }
}

class SyncImChannelMessagesDtoBuilder
    implements
        Builder<SyncImChannelMessagesDto, SyncImChannelMessagesDtoBuilder> {
  _$SyncImChannelMessagesDto? _$v;

  num? _startMessageSeq;
  num? get startMessageSeq => _$this._startMessageSeq;
  set startMessageSeq(num? startMessageSeq) =>
      _$this._startMessageSeq = startMessageSeq;

  num? _endMessageSeq;
  num? get endMessageSeq => _$this._endMessageSeq;
  set endMessageSeq(num? endMessageSeq) =>
      _$this._endMessageSeq = endMessageSeq;

  num? _limit;
  num? get limit => _$this._limit;
  set limit(num? limit) => _$this._limit = limit;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  SyncImChannelMessagesDtoChannelTypeEnum? _channelType;
  SyncImChannelMessagesDtoChannelTypeEnum? get channelType =>
      _$this._channelType;
  set channelType(SyncImChannelMessagesDtoChannelTypeEnum? channelType) =>
      _$this._channelType = channelType;

  SyncImChannelMessagesDtoPullModeEnum? _pullMode;
  SyncImChannelMessagesDtoPullModeEnum? get pullMode => _$this._pullMode;
  set pullMode(SyncImChannelMessagesDtoPullModeEnum? pullMode) =>
      _$this._pullMode = pullMode;

  SyncImChannelMessagesDtoBuilder() {
    SyncImChannelMessagesDto._defaults(this);
  }

  SyncImChannelMessagesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startMessageSeq = $v.startMessageSeq;
      _endMessageSeq = $v.endMessageSeq;
      _limit = $v.limit;
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _pullMode = $v.pullMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncImChannelMessagesDto other) {
    _$v = other as _$SyncImChannelMessagesDto;
  }

  @override
  void update(void Function(SyncImChannelMessagesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncImChannelMessagesDto build() => _build();

  _$SyncImChannelMessagesDto _build() {
    final _$result = _$v ??
        _$SyncImChannelMessagesDto._(
          startMessageSeq: startMessageSeq,
          endMessageSeq: endMessageSeq,
          limit: limit,
          channelId: BuiltValueNullFieldError.checkNotNull(
              channelId, r'SyncImChannelMessagesDto', 'channelId'),
          channelType: BuiltValueNullFieldError.checkNotNull(
              channelType, r'SyncImChannelMessagesDto', 'channelType'),
          pullMode: BuiltValueNullFieldError.checkNotNull(
              pullMode, r'SyncImChannelMessagesDto', 'pullMode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
