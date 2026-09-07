// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_sync_conversation_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImSyncConversationResponse extends ImSyncConversationResponse {
  @override
  final String channelId;
  @override
  final int channelType;
  @override
  final int unread;
  @override
  final int timestamp;
  @override
  final int lastMsgSeq;
  @override
  final String lastClientMsgNo;
  @override
  final int version;
  @override
  final BuiltList<ImSyncMessageResponse> recents;

  factory _$ImSyncConversationResponse(
          [void Function(ImSyncConversationResponseBuilder)? updates]) =>
      (ImSyncConversationResponseBuilder()..update(updates))._build();

  _$ImSyncConversationResponse._(
      {required this.channelId,
      required this.channelType,
      required this.unread,
      required this.timestamp,
      required this.lastMsgSeq,
      required this.lastClientMsgNo,
      required this.version,
      required this.recents})
      : super._();
  @override
  ImSyncConversationResponse rebuild(
          void Function(ImSyncConversationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImSyncConversationResponseBuilder toBuilder() =>
      ImSyncConversationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImSyncConversationResponse &&
        channelId == other.channelId &&
        channelType == other.channelType &&
        unread == other.unread &&
        timestamp == other.timestamp &&
        lastMsgSeq == other.lastMsgSeq &&
        lastClientMsgNo == other.lastClientMsgNo &&
        version == other.version &&
        recents == other.recents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, channelType.hashCode);
    _$hash = $jc(_$hash, unread.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, lastMsgSeq.hashCode);
    _$hash = $jc(_$hash, lastClientMsgNo.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, recents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImSyncConversationResponse')
          ..add('channelId', channelId)
          ..add('channelType', channelType)
          ..add('unread', unread)
          ..add('timestamp', timestamp)
          ..add('lastMsgSeq', lastMsgSeq)
          ..add('lastClientMsgNo', lastClientMsgNo)
          ..add('version', version)
          ..add('recents', recents))
        .toString();
  }
}

class ImSyncConversationResponseBuilder
    implements
        Builder<ImSyncConversationResponse, ImSyncConversationResponseBuilder> {
  _$ImSyncConversationResponse? _$v;

  String? _channelId;
  String? get channelId => _$this._channelId;
  set channelId(String? channelId) => _$this._channelId = channelId;

  int? _channelType;
  int? get channelType => _$this._channelType;
  set channelType(int? channelType) => _$this._channelType = channelType;

  int? _unread;
  int? get unread => _$this._unread;
  set unread(int? unread) => _$this._unread = unread;

  int? _timestamp;
  int? get timestamp => _$this._timestamp;
  set timestamp(int? timestamp) => _$this._timestamp = timestamp;

  int? _lastMsgSeq;
  int? get lastMsgSeq => _$this._lastMsgSeq;
  set lastMsgSeq(int? lastMsgSeq) => _$this._lastMsgSeq = lastMsgSeq;

  String? _lastClientMsgNo;
  String? get lastClientMsgNo => _$this._lastClientMsgNo;
  set lastClientMsgNo(String? lastClientMsgNo) =>
      _$this._lastClientMsgNo = lastClientMsgNo;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ListBuilder<ImSyncMessageResponse>? _recents;
  ListBuilder<ImSyncMessageResponse> get recents =>
      _$this._recents ??= ListBuilder<ImSyncMessageResponse>();
  set recents(ListBuilder<ImSyncMessageResponse>? recents) =>
      _$this._recents = recents;

  ImSyncConversationResponseBuilder() {
    ImSyncConversationResponse._defaults(this);
  }

  ImSyncConversationResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channelId = $v.channelId;
      _channelType = $v.channelType;
      _unread = $v.unread;
      _timestamp = $v.timestamp;
      _lastMsgSeq = $v.lastMsgSeq;
      _lastClientMsgNo = $v.lastClientMsgNo;
      _version = $v.version;
      _recents = $v.recents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImSyncConversationResponse other) {
    _$v = other as _$ImSyncConversationResponse;
  }

  @override
  void update(void Function(ImSyncConversationResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImSyncConversationResponse build() => _build();

  _$ImSyncConversationResponse _build() {
    _$ImSyncConversationResponse _$result;
    try {
      _$result = _$v ??
          _$ImSyncConversationResponse._(
            channelId: BuiltValueNullFieldError.checkNotNull(
                channelId, r'ImSyncConversationResponse', 'channelId'),
            channelType: BuiltValueNullFieldError.checkNotNull(
                channelType, r'ImSyncConversationResponse', 'channelType'),
            unread: BuiltValueNullFieldError.checkNotNull(
                unread, r'ImSyncConversationResponse', 'unread'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'ImSyncConversationResponse', 'timestamp'),
            lastMsgSeq: BuiltValueNullFieldError.checkNotNull(
                lastMsgSeq, r'ImSyncConversationResponse', 'lastMsgSeq'),
            lastClientMsgNo: BuiltValueNullFieldError.checkNotNull(
                lastClientMsgNo,
                r'ImSyncConversationResponse',
                'lastClientMsgNo'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ImSyncConversationResponse', 'version'),
            recents: recents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recents';
        recents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ImSyncConversationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
