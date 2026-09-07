// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_receipt_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MessageReceiptResponse extends MessageReceiptResponse {
  @override
  final String messageId;
  @override
  final int readCount;
  @override
  final int unreadCount;

  factory _$MessageReceiptResponse(
          [void Function(MessageReceiptResponseBuilder)? updates]) =>
      (MessageReceiptResponseBuilder()..update(updates))._build();

  _$MessageReceiptResponse._(
      {required this.messageId,
      required this.readCount,
      required this.unreadCount})
      : super._();
  @override
  MessageReceiptResponse rebuild(
          void Function(MessageReceiptResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageReceiptResponseBuilder toBuilder() =>
      MessageReceiptResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageReceiptResponse &&
        messageId == other.messageId &&
        readCount == other.readCount &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, readCount.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageReceiptResponse')
          ..add('messageId', messageId)
          ..add('readCount', readCount)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class MessageReceiptResponseBuilder
    implements Builder<MessageReceiptResponse, MessageReceiptResponseBuilder> {
  _$MessageReceiptResponse? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  int? _readCount;
  int? get readCount => _$this._readCount;
  set readCount(int? readCount) => _$this._readCount = readCount;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  MessageReceiptResponseBuilder() {
    MessageReceiptResponse._defaults(this);
  }

  MessageReceiptResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _readCount = $v.readCount;
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageReceiptResponse other) {
    _$v = other as _$MessageReceiptResponse;
  }

  @override
  void update(void Function(MessageReceiptResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageReceiptResponse build() => _build();

  _$MessageReceiptResponse _build() {
    final _$result = _$v ??
        _$MessageReceiptResponse._(
          messageId: BuiltValueNullFieldError.checkNotNull(
              messageId, r'MessageReceiptResponse', 'messageId'),
          readCount: BuiltValueNullFieldError.checkNotNull(
              readCount, r'MessageReceiptResponse', 'readCount'),
          unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount, r'MessageReceiptResponse', 'unreadCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
