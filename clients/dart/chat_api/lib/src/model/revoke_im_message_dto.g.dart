// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revoke_im_message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RevokeImMessageDtoChannelTypeEnum _$revokeImMessageDtoChannelTypeEnum_n1 =
    const RevokeImMessageDtoChannelTypeEnum._('n1');
const RevokeImMessageDtoChannelTypeEnum _$revokeImMessageDtoChannelTypeEnum_n2 =
    const RevokeImMessageDtoChannelTypeEnum._('n2');
const RevokeImMessageDtoChannelTypeEnum
    _$revokeImMessageDtoChannelTypeEnum_unknownDefaultOpenApi =
    const RevokeImMessageDtoChannelTypeEnum._('unknownDefaultOpenApi');

RevokeImMessageDtoChannelTypeEnum _$revokeImMessageDtoChannelTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'n1':
      return _$revokeImMessageDtoChannelTypeEnum_n1;
    case 'n2':
      return _$revokeImMessageDtoChannelTypeEnum_n2;
    case 'unknownDefaultOpenApi':
      return _$revokeImMessageDtoChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$revokeImMessageDtoChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<RevokeImMessageDtoChannelTypeEnum>
    _$revokeImMessageDtoChannelTypeEnumValues = BuiltSet<
        RevokeImMessageDtoChannelTypeEnum>(const <RevokeImMessageDtoChannelTypeEnum>[
  _$revokeImMessageDtoChannelTypeEnum_n1,
  _$revokeImMessageDtoChannelTypeEnum_n2,
  _$revokeImMessageDtoChannelTypeEnum_unknownDefaultOpenApi,
]);

Serializer<RevokeImMessageDtoChannelTypeEnum>
    _$revokeImMessageDtoChannelTypeEnumSerializer =
    _$RevokeImMessageDtoChannelTypeEnumSerializer();

class _$RevokeImMessageDtoChannelTypeEnumSerializer
    implements PrimitiveSerializer<RevokeImMessageDtoChannelTypeEnum> {
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
  final Iterable<Type> types = const <Type>[RevokeImMessageDtoChannelTypeEnum];
  @override
  final String wireName = 'RevokeImMessageDtoChannelTypeEnum';

  @override
  Object serialize(
          Serializers serializers, RevokeImMessageDtoChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RevokeImMessageDtoChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RevokeImMessageDtoChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RevokeImMessageDto extends RevokeImMessageDto {
  @override
  final String channelId;
  @override
  final RevokeImMessageDtoChannelTypeEnum channelType;
  @override
  final String clientMsgNo;

  factory _$RevokeImMessageDto(
          [void Function(RevokeImMessageDtoBuilder)? updates]) =>
      (RevokeImMessageDtoBuilder()..update(updates))._build();

  _$RevokeImMessageDto._(
      {required this.channelId,
      required this.channelType,
      required this.clientMsgNo})
      : super._();
  @override
  RevokeImMessageDto rebuild(
          void Function(RevokeImMessageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RevokeImMessageDtoBuilder toBuilder() =>
      RevokeImMessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RevokeImMessageDto &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        clientMsgNo == other.clientMsgNo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, clientMsgNo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RevokeImMessageDto')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('clientMsgNo', clientMsgNo))
        .toString();
  }
}

class RevokeImMessageDtoBuilder
    implements Builder<RevokeImMessageDto, RevokeImMessageDtoBuilder> {
  _$RevokeImMessageDto? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  RevokeImMessageDtoChannelTypeEnum? _channelType;
  RevokeImMessageDtoChannelTypeEnum? get channelType => _$this._channelType;
  set channelType(RevokeImMessageDtoChannelTypeEnum? channelType) =>
      _$this._channelType = channelType;

  String? _clientMsgNo;
  String? get clientMsgNo => _$this._clientMsgNo;
  set clientMsgNo(String? clientMsgNo) => _$this._clientMsgNo = clientMsgNo;

  RevokeImMessageDtoBuilder() {
    RevokeImMessageDto._defaults(this);
  }

  RevokeImMessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _clientMsgNo = $v.clientMsgNo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RevokeImMessageDto other) {
    _$v = other as _$RevokeImMessageDto;
  }

  @override
  void update(void Function(RevokeImMessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RevokeImMessageDto build() => _build();

  _$RevokeImMessageDto _build() {
    final _$result = _$v ??
        _$RevokeImMessageDto._(
          channelId: BuiltValueNullFieldError.checkNotNull(
              channelId, r'RevokeImMessageDto', 'channelId'),
          channelType: BuiltValueNullFieldError.checkNotNull(
              channelType, r'RevokeImMessageDto', 'channelType'),
          clientMsgNo: BuiltValueNullFieldError.checkNotNull(
              clientMsgNo, r'RevokeImMessageDto', 'clientMsgNo'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
