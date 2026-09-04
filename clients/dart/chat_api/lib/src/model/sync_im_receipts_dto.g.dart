// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_im_receipts_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SyncImReceiptsDtoChannelTypeEnum _$syncImReceiptsDtoChannelTypeEnum_n1 =
    const SyncImReceiptsDtoChannelTypeEnum._('n1');
const SyncImReceiptsDtoChannelTypeEnum _$syncImReceiptsDtoChannelTypeEnum_n2 =
    const SyncImReceiptsDtoChannelTypeEnum._('n2');
const SyncImReceiptsDtoChannelTypeEnum
    _$syncImReceiptsDtoChannelTypeEnum_unknownDefaultOpenApi =
    const SyncImReceiptsDtoChannelTypeEnum._('unknownDefaultOpenApi');

SyncImReceiptsDtoChannelTypeEnum _$syncImReceiptsDtoChannelTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'n1':
      return _$syncImReceiptsDtoChannelTypeEnum_n1;
    case 'n2':
      return _$syncImReceiptsDtoChannelTypeEnum_n2;
    case 'unknownDefaultOpenApi':
      return _$syncImReceiptsDtoChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$syncImReceiptsDtoChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<SyncImReceiptsDtoChannelTypeEnum>
    _$syncImReceiptsDtoChannelTypeEnumValues = BuiltSet<
        SyncImReceiptsDtoChannelTypeEnum>(const <SyncImReceiptsDtoChannelTypeEnum>[
  _$syncImReceiptsDtoChannelTypeEnum_n1,
  _$syncImReceiptsDtoChannelTypeEnum_n2,
  _$syncImReceiptsDtoChannelTypeEnum_unknownDefaultOpenApi,
]);

Serializer<SyncImReceiptsDtoChannelTypeEnum>
    _$syncImReceiptsDtoChannelTypeEnumSerializer =
    _$SyncImReceiptsDtoChannelTypeEnumSerializer();

class _$SyncImReceiptsDtoChannelTypeEnumSerializer
    implements PrimitiveSerializer<SyncImReceiptsDtoChannelTypeEnum> {
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
  final Iterable<Type> types = const <Type>[SyncImReceiptsDtoChannelTypeEnum];
  @override
  final String wireName = 'SyncImReceiptsDtoChannelTypeEnum';

  @override
  Object serialize(
          Serializers serializers, SyncImReceiptsDtoChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncImReceiptsDtoChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncImReceiptsDtoChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SyncImReceiptsDto extends SyncImReceiptsDto {
  @override
  final String channelId;
  @override
  final SyncImReceiptsDtoChannelTypeEnum channelType;
  @override
  final BuiltList<ReceiptMessageDto> messages;

  factory _$SyncImReceiptsDto(
          [void Function(SyncImReceiptsDtoBuilder)? updates]) =>
      (SyncImReceiptsDtoBuilder()..update(updates))._build();

  _$SyncImReceiptsDto._(
      {required this.channelId,
      required this.channelType,
      required this.messages})
      : super._();
  @override
  SyncImReceiptsDto rebuild(void Function(SyncImReceiptsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncImReceiptsDtoBuilder toBuilder() =>
      SyncImReceiptsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncImReceiptsDto &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        messages == other.messages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncImReceiptsDto')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('messages', messages))
        .toString();
  }
}

class SyncImReceiptsDtoBuilder
    implements Builder<SyncImReceiptsDto, SyncImReceiptsDtoBuilder> {
  _$SyncImReceiptsDto? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  SyncImReceiptsDtoChannelTypeEnum? _channelType;
  SyncImReceiptsDtoChannelTypeEnum? get channelType => _$this._channelType;
  set channelType(SyncImReceiptsDtoChannelTypeEnum? channelType) =>
      _$this._channelType = channelType;

  ListBuilder<ReceiptMessageDto>? _messages;
  ListBuilder<ReceiptMessageDto> get messages =>
      _$this._messages ??= ListBuilder<ReceiptMessageDto>();
  set messages(ListBuilder<ReceiptMessageDto>? messages) =>
      _$this._messages = messages;

  SyncImReceiptsDtoBuilder() {
    SyncImReceiptsDto._defaults(this);
  }

  SyncImReceiptsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _messages = $v.messages.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncImReceiptsDto other) {
    _$v = other as _$SyncImReceiptsDto;
  }

  @override
  void update(void Function(SyncImReceiptsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncImReceiptsDto build() => _build();

  _$SyncImReceiptsDto _build() {
    _$SyncImReceiptsDto _$result;
    try {
      _$result = _$v ??
          _$SyncImReceiptsDto._(
            channelId: BuiltValueNullFieldError.checkNotNull(
                channelId, r'SyncImReceiptsDto', 'channelId'),
            channelType: BuiltValueNullFieldError.checkNotNull(
                channelType, r'SyncImReceiptsDto', 'channelType'),
            messages: messages.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        messages.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SyncImReceiptsDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
