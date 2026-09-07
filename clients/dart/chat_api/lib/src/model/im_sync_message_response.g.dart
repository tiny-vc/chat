// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_sync_message_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImSyncMessageResponse extends ImSyncMessageResponse {
  @override
  final String channelId;
  @override
  final int channelType;
  @override
  final String messageId;
  @override
  final int messageSeq;
  @override
  final String clientMsgNo;
  @override
  final String fromUid;
  @override
  final int timestamp;
  @override
  final int setting;
  @override
  final BuiltMap<String, JsonObject?> payload;

  factory _$ImSyncMessageResponse(
          [void Function(ImSyncMessageResponseBuilder)? updates]) =>
      (ImSyncMessageResponseBuilder()..update(updates))._build();

  _$ImSyncMessageResponse._(
      {required this.channelId,
      required this.channelType,
      required this.messageId,
      required this.messageSeq,
      required this.clientMsgNo,
      required this.fromUid,
      required this.timestamp,
      required this.setting,
      required this.payload})
      : super._();
  @override
  ImSyncMessageResponse rebuild(
          void Function(ImSyncMessageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImSyncMessageResponseBuilder toBuilder() =>
      ImSyncMessageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImSyncMessageResponse &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        messageId == other.messageId &&
        messageSeq == other.messageSeq &&
        clientMsgNo == other.clientMsgNo &&
        fromUid == other.fromUid &&
        timestamp == other.timestamp &&
        setting == other.setting &&
        payload == other.payload;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, messageSeq.hashCode);
    _$hash = $jc(_$hash, clientMsgNo.hashCode);
    _$hash = $jc(_$hash, fromUid.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, setting.hashCode);
    _$hash = $jc(_$hash, payload.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImSyncMessageResponse')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('messageId', messageId)
          ..add('messageSeq', messageSeq)
          ..add('clientMsgNo', clientMsgNo)
          ..add('fromUid', fromUid)
          ..add('timestamp', timestamp)
          ..add('setting', setting)
          ..add('payload', payload))
        .toString();
  }
}

class ImSyncMessageResponseBuilder
    implements Builder<ImSyncMessageResponse, ImSyncMessageResponseBuilder> {
  _$ImSyncMessageResponse? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  int? _channelType;
  int? get channelType => _$this._channelType;
  set channelType(int? channelType) => _$this._channelType = channelType;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  int? _messageSeq;
  int? get messageSeq => _$this._messageSeq;
  set messageSeq(int? messageSeq) => _$this._messageSeq = messageSeq;

  String? _clientMsgNo;
  String? get clientMsgNo => _$this._clientMsgNo;
  set clientMsgNo(String? clientMsgNo) => _$this._clientMsgNo = clientMsgNo;

  String? _fromUid;
  String? get fromUid => _$this._fromUid;
  set fromUid(String? fromUid) => _$this._fromUid = fromUid;

  int? _timestamp;
  int? get timestamp => _$this._timestamp;
  set timestamp(int? timestamp) => _$this._timestamp = timestamp;

  int? _setting;
  int? get setting => _$this._setting;
  set setting(int? setting) => _$this._setting = setting;

  MapBuilder<String, JsonObject?>? _payload;
  MapBuilder<String, JsonObject?> get payload =>
      _$this._payload ??= MapBuilder<String, JsonObject?>();
  set payload(MapBuilder<String, JsonObject?>? payload) =>
      _$this._payload = payload;

  ImSyncMessageResponseBuilder() {
    ImSyncMessageResponse._defaults(this);
  }

  ImSyncMessageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _messageId = $v.messageId;
      _messageSeq = $v.messageSeq;
      _clientMsgNo = $v.clientMsgNo;
      _fromUid = $v.fromUid;
      _timestamp = $v.timestamp;
      _setting = $v.setting;
      _payload = $v.payload.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImSyncMessageResponse other) {
    _$v = other as _$ImSyncMessageResponse;
  }

  @override
  void update(void Function(ImSyncMessageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImSyncMessageResponse build() => _build();

  _$ImSyncMessageResponse _build() {
    _$ImSyncMessageResponse _$result;
    try {
      _$result = _$v ??
          _$ImSyncMessageResponse._(
            channelId: BuiltValueNullFieldError.checkNotNull(
                channelId, r'ImSyncMessageResponse', 'channelId'),
            channelType: BuiltValueNullFieldError.checkNotNull(
                channelType, r'ImSyncMessageResponse', 'channelType'),
            messageId: BuiltValueNullFieldError.checkNotNull(
                messageId, r'ImSyncMessageResponse', 'messageId'),
            messageSeq: BuiltValueNullFieldError.checkNotNull(
                messageSeq, r'ImSyncMessageResponse', 'messageSeq'),
            clientMsgNo: BuiltValueNullFieldError.checkNotNull(
                clientMsgNo, r'ImSyncMessageResponse', 'clientMsgNo'),
            fromUid: BuiltValueNullFieldError.checkNotNull(
                fromUid, r'ImSyncMessageResponse', 'fromUid'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'ImSyncMessageResponse', 'timestamp'),
            setting: BuiltValueNullFieldError.checkNotNull(
                setting, r'ImSyncMessageResponse', 'setting'),
            payload: payload.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payload';
        payload.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ImSyncMessageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
