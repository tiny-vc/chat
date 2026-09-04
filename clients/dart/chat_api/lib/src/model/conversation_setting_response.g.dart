// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_setting_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConversationSettingResponseChannelTypeEnum
    _$conversationSettingResponseChannelTypeEnum_number1 =
    const ConversationSettingResponseChannelTypeEnum._('number1');
const ConversationSettingResponseChannelTypeEnum
    _$conversationSettingResponseChannelTypeEnum_number2 =
    const ConversationSettingResponseChannelTypeEnum._('number2');
const ConversationSettingResponseChannelTypeEnum
    _$conversationSettingResponseChannelTypeEnum_unknownDefaultOpenApi =
    const ConversationSettingResponseChannelTypeEnum._('unknownDefaultOpenApi');

ConversationSettingResponseChannelTypeEnum
    _$conversationSettingResponseChannelTypeEnumValueOf(String name) {
  switch (name) {
    case 'number1':
      return _$conversationSettingResponseChannelTypeEnum_number1;
    case 'number2':
      return _$conversationSettingResponseChannelTypeEnum_number2;
    case 'unknownDefaultOpenApi':
      return _$conversationSettingResponseChannelTypeEnum_unknownDefaultOpenApi;
    default:
      return _$conversationSettingResponseChannelTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ConversationSettingResponseChannelTypeEnum>
    _$conversationSettingResponseChannelTypeEnumValues = BuiltSet<
        ConversationSettingResponseChannelTypeEnum>(const <ConversationSettingResponseChannelTypeEnum>[
  _$conversationSettingResponseChannelTypeEnum_number1,
  _$conversationSettingResponseChannelTypeEnum_number2,
  _$conversationSettingResponseChannelTypeEnum_unknownDefaultOpenApi,
]);

Serializer<ConversationSettingResponseChannelTypeEnum>
    _$conversationSettingResponseChannelTypeEnumSerializer =
    _$ConversationSettingResponseChannelTypeEnumSerializer();

class _$ConversationSettingResponseChannelTypeEnumSerializer
    implements PrimitiveSerializer<ConversationSettingResponseChannelTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number1': 1,
    'number2': 2,
    'unknownDefaultOpenApi': 11184809,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    1: 'number1',
    2: 'number2',
    11184809: 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ConversationSettingResponseChannelTypeEnum
  ];
  @override
  final String wireName = 'ConversationSettingResponseChannelTypeEnum';

  @override
  Object serialize(Serializers serializers,
          ConversationSettingResponseChannelTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConversationSettingResponseChannelTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConversationSettingResponseChannelTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ConversationSettingResponse extends ConversationSettingResponse {
  @override
  final String userId;
  @override
  final String channelId;
  @override
  final ConversationSettingResponseChannelTypeEnum channelType;
  @override
  final bool pinned;
  @override
  final bool muted;
  @override
  final bool archived;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  factory _$ConversationSettingResponse(
          [void Function(ConversationSettingResponseBuilder)? updates]) =>
      (ConversationSettingResponseBuilder()..update(updates))._build();

  _$ConversationSettingResponse._(
      {required this.userId,
      required this.channelId,
      required this.channelType,
      required this.pinned,
      required this.muted,
      required this.archived,
      this.createdAt,
      this.updatedAt})
      : super._();
  @override
  ConversationSettingResponse rebuild(
          void Function(ConversationSettingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationSettingResponseBuilder toBuilder() =>
      ConversationSettingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationSettingResponse &&
        userId == other.userId &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        pinned == other.pinned &&
        muted == other.muted &&
        archived == other.archived &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, pinned.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, archived.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversationSettingResponse')
          ..add('userId', userId)
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('pinned', pinned)
          ..add('muted', muted)
          ..add('archived', archived)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ConversationSettingResponseBuilder
    implements
        Builder<ConversationSettingResponse,
            ConversationSettingResponseBuilder> {
  _$ConversationSettingResponse? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  ConversationSettingResponseChannelTypeEnum? _channelType;
  ConversationSettingResponseChannelTypeEnum? get channelType =>
      _$this._channelType;
  set channelType(ConversationSettingResponseChannelTypeEnum? channelType) =>
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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ConversationSettingResponseBuilder() {
    ConversationSettingResponse._defaults(this);
  }

  ConversationSettingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _pinned = $v.pinned;
      _muted = $v.muted;
      _archived = $v.archived;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversationSettingResponse other) {
    _$v = other as _$ConversationSettingResponse;
  }

  @override
  void update(void Function(ConversationSettingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationSettingResponse build() => _build();

  _$ConversationSettingResponse _build() {
    final _$result = _$v ??
        _$ConversationSettingResponse._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'ConversationSettingResponse', 'userId'),
          channelId: BuiltValueNullFieldError.checkNotNull(
              channelId, r'ConversationSettingResponse', 'channelId'),
          channelType: BuiltValueNullFieldError.checkNotNull(
              channelType, r'ConversationSettingResponse', 'channelType'),
          pinned: BuiltValueNullFieldError.checkNotNull(
              pinned, r'ConversationSettingResponse', 'pinned'),
          muted: BuiltValueNullFieldError.checkNotNull(
              muted, r'ConversationSettingResponse', 'muted'),
          archived: BuiltValueNullFieldError.checkNotNull(
              archived, r'ConversationSettingResponse', 'archived'),
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
