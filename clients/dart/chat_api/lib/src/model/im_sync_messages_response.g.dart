// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_sync_messages_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ImSyncMessagesResponse extends ImSyncMessagesResponse {
  @override
  final int startMessageSeq;
  @override
  final int endMessageSeq;
  @override
  final int more;
  @override
  final BuiltList<ImSyncMessageResponse> messages;

  factory _$ImSyncMessagesResponse(
          [void Function(ImSyncMessagesResponseBuilder)? updates]) =>
      (ImSyncMessagesResponseBuilder()..update(updates))._build();

  _$ImSyncMessagesResponse._(
      {required this.startMessageSeq,
      required this.endMessageSeq,
      required this.more,
      required this.messages})
      : super._();
  @override
  ImSyncMessagesResponse rebuild(
          void Function(ImSyncMessagesResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ImSyncMessagesResponseBuilder toBuilder() =>
      ImSyncMessagesResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ImSyncMessagesResponse &&
        startMessageSeq == other.startMessageSeq &&
        endMessageSeq == other.endMessageSeq &&
        more == other.more &&
        messages == other.messages;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startMessageSeq.hashCode);
    _$hash = $jc(_$hash, endMessageSeq.hashCode);
    _$hash = $jc(_$hash, more.hashCode);
    _$hash = $jc(_$hash, messages.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ImSyncMessagesResponse')
          ..add('startMessageSeq', startMessageSeq)
          ..add('endMessageSeq', endMessageSeq)
          ..add('more', more)
          ..add('messages', messages))
        .toString();
  }
}

class ImSyncMessagesResponseBuilder
    implements Builder<ImSyncMessagesResponse, ImSyncMessagesResponseBuilder> {
  _$ImSyncMessagesResponse? _$v;

  int? _startMessageSeq;
  int? get startMessageSeq => _$this._startMessageSeq;
  set startMessageSeq(int? startMessageSeq) =>
      _$this._startMessageSeq = startMessageSeq;

  int? _endMessageSeq;
  int? get endMessageSeq => _$this._endMessageSeq;
  set endMessageSeq(int? endMessageSeq) =>
      _$this._endMessageSeq = endMessageSeq;

  int? _more;
  int? get more => _$this._more;
  set more(int? more) => _$this._more = more;

  ListBuilder<ImSyncMessageResponse>? _messages;
  ListBuilder<ImSyncMessageResponse> get messages =>
      _$this._messages ??= ListBuilder<ImSyncMessageResponse>();
  set messages(ListBuilder<ImSyncMessageResponse>? messages) =>
      _$this._messages = messages;

  ImSyncMessagesResponseBuilder() {
    ImSyncMessagesResponse._defaults(this);
  }

  ImSyncMessagesResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startMessageSeq = $v.startMessageSeq;
      _endMessageSeq = $v.endMessageSeq;
      _more = $v.more;
      _messages = $v.messages.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ImSyncMessagesResponse other) {
    _$v = other as _$ImSyncMessagesResponse;
  }

  @override
  void update(void Function(ImSyncMessagesResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ImSyncMessagesResponse build() => _build();

  _$ImSyncMessagesResponse _build() {
    _$ImSyncMessagesResponse _$result;
    try {
      _$result = _$v ??
          _$ImSyncMessagesResponse._(
            startMessageSeq: BuiltValueNullFieldError.checkNotNull(
                startMessageSeq, r'ImSyncMessagesResponse', 'startMessageSeq'),
            endMessageSeq: BuiltValueNullFieldError.checkNotNull(
                endMessageSeq, r'ImSyncMessagesResponse', 'endMessageSeq'),
            more: BuiltValueNullFieldError.checkNotNull(
                more, r'ImSyncMessagesResponse', 'more'),
            messages: messages.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'messages';
        messages.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ImSyncMessagesResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
