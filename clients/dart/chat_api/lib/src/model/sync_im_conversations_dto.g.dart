// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_im_conversations_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SyncImConversationsDto extends SyncImConversationsDto {
  @override
  final String? lastMsgSeqs;
  @override
  final num? msgCount;
  @override
  final num? version;

  factory _$SyncImConversationsDto(
          [void Function(SyncImConversationsDtoBuilder)? updates]) =>
      (SyncImConversationsDtoBuilder()..update(updates))._build();

  _$SyncImConversationsDto._({this.lastMsgSeqs, this.msgCount, this.version})
      : super._();
  @override
  SyncImConversationsDto rebuild(
          void Function(SyncImConversationsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncImConversationsDtoBuilder toBuilder() =>
      SyncImConversationsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncImConversationsDto &&
        lastMsgSeqs == other.lastMsgSeqs &&
        msgCount == other.msgCount &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lastMsgSeqs.hashCode);
    _$hash = $jc(_$hash, msgCount.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncImConversationsDto')
          ..add('lastMsgSeqs', lastMsgSeqs)
          ..add('msgCount', msgCount)
          ..add('version', version))
        .toString();
  }
}

class SyncImConversationsDtoBuilder
    implements Builder<SyncImConversationsDto, SyncImConversationsDtoBuilder> {
  _$SyncImConversationsDto? _$v;

  String? _lastMsgSeqs;
  String? get lastMsgSeqs => _$this._lastMsgSeqs;
  set lastMsgSeqs(String? lastMsgSeqs) => _$this._lastMsgSeqs = lastMsgSeqs;

  num? _msgCount;
  num? get msgCount => _$this._msgCount;
  set msgCount(num? msgCount) => _$this._msgCount = msgCount;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  SyncImConversationsDtoBuilder() {
    SyncImConversationsDto._defaults(this);
  }

  SyncImConversationsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lastMsgSeqs = $v.lastMsgSeqs;
      _msgCount = $v.msgCount;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncImConversationsDto other) {
    _$v = other as _$SyncImConversationsDto;
  }

  @override
  void update(void Function(SyncImConversationsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncImConversationsDto build() => _build();

  _$SyncImConversationsDto _build() {
    final _$result = _$v ??
        _$SyncImConversationsDto._(
          lastMsgSeqs: lastMsgSeqs,
          msgCount: msgCount,
          version: version,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
