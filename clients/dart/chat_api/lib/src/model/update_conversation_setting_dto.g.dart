// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_conversation_setting_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateConversationSettingDtoChannelTypeEnum
    _$updateConversationSettingDtoChannelTypeEnum_n1 =
    const UpdateConversationSettingDtoChannelTypeEnum._('n1');
const UpdateConversationSettingDtoChannelTypeEnum
    _$updateConversationSettingDtoChannelTypeEnum_n2 =
    const UpdateConversationSettingDtoChannelTypeEnum._('n2');
const UpdateConversationSettingDtoChannelTypeEnum
    _$updateConversationSettingDtoChannelTypeEnum_unknownDefaultOpenApi =
    const UpdateConversationSettingDtoChannelTypeEnum._(
        'unknownDefaultOpenApi');

UpdateConversationSettingDtoChannelTypeEnum
    _$updateConversationSettingDtoChannelTypeEnumValueOf(String name) {
  switch (name) {
    case 'n1':
      return _$updateConversationSettingDtoChannelTypeEnum_n1;
    case 'n2':
      return _$updateConversationSettingDtoChannelTypeEnum_n2;
    case 'unknownDefaultOpenApi':
      return _$updateConversationSettingDtoChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$updateConversationSettingDtoChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<UpdateConversationSettingDtoChannelTypeEnum>
    _$updateConversationSettingDtoChannelTypeEnumValues = BuiltSet<
        UpdateConversationSettingDtoChannelTypeEnum>(const <UpdateConversationSettingDtoChannelTypeEnum>[
  _$updateConversationSettingDtoChannelTypeEnum_n1,
  _$updateConversationSettingDtoChannelTypeEnum_n2,
  _$updateConversationSettingDtoChannelTypeEnum_unknownDefaultOpenApi,
]);

Serializer<UpdateConversationSettingDtoChannelTypeEnum>
    _$updateConversationSettingDtoChannelTypeEnumSerializer =
    _$UpdateConversationSettingDtoChannelTypeEnumSerializer();

class _$UpdateConversationSettingDtoChannelTypeEnumSerializer
    implements
        PrimitiveSerializer<UpdateConversationSettingDtoChannelTypeEnum> {
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
    UpdateConversationSettingDtoChannelTypeEnum
  ];
  @override
  final String wireName = 'UpdateConversationSettingDtoChannelTypeEnum';

  @override
  Object serialize(Serializers serializers,
          UpdateConversationSettingDtoChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateConversationSettingDtoChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateConversationSettingDtoChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateConversationSettingDto extends UpdateConversationSettingDto {
  @override
  final String channelId;
  @override
  final UpdateConversationSettingDtoChannelTypeEnum channelType;
  @override
  final bool? pinned;
  @override
  final bool? muted;
  @override
  final bool? archived;

  factory _$UpdateConversationSettingDto(
          [void Function(UpdateConversationSettingDtoBuilder)? updates]) =>
      (UpdateConversationSettingDtoBuilder()..update(updates))._build();

  _$UpdateConversationSettingDto._(
      {required this.channelId,
      required this.channelType,
      this.pinned,
      this.muted,
      this.archived})
      : super._();
  @override
  UpdateConversationSettingDto rebuild(
          void Function(UpdateConversationSettingDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateConversationSettingDtoBuilder toBuilder() =>
      UpdateConversationSettingDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateConversationSettingDto &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        pinned == other.pinned &&
        muted == other.muted &&
        archived == other.archived;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, pinned.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, archived.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateConversationSettingDto')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('pinned', pinned)
          ..add('muted', muted)
          ..add('archived', archived))
        .toString();
  }
}

class UpdateConversationSettingDtoBuilder
    implements
        Builder<UpdateConversationSettingDto,
            UpdateConversationSettingDtoBuilder> {
  _$UpdateConversationSettingDto? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  UpdateConversationSettingDtoChannelTypeEnum? _channelType;
  UpdateConversationSettingDtoChannelTypeEnum? get channelType =>
      _$this._channelType;
  set channelType(UpdateConversationSettingDtoChannelTypeEnum? channelType) =>
      _$this._channelType = channelType;

  bool? _pinned;
  bool? get pinned => _$this._pinned;
  set pinned(bool? pinned) => _$this._pinned = pinned;

  bool? _muted;
  bool? get muted => _$this._muted;
  set muted(bool? muted) => _$this._muted = muted;

  bool? _archived;
  bool? get archived => _$this._archived;
  set archived(bool? archived) => _$this._archived = archived;

  UpdateConversationSettingDtoBuilder() {
    UpdateConversationSettingDto._defaults(this);
  }

  UpdateConversationSettingDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _pinned = $v.pinned;
      _muted = $v.muted;
      _archived = $v.archived;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateConversationSettingDto other) {
    _$v = other as _$UpdateConversationSettingDto;
  }

  @override
  void update(void Function(UpdateConversationSettingDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateConversationSettingDto build() => _build();

  _$UpdateConversationSettingDto _build() {
    final _$result = _$v ??
        _$UpdateConversationSettingDto._(
          channelId: BuiltValueNullFieldError.checkNotNull(
              channelId, r'UpdateConversationSettingDto', 'channelId'),
          channelType: BuiltValueNullFieldError.checkNotNull(
              channelType, r'UpdateConversationSettingDto', 'channelType'),
          pinned: pinned,
          muted: muted,
          archived: archived,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
