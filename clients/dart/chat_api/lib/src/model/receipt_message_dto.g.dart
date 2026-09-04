// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_message_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReceiptMessageDto extends ReceiptMessageDto {
  @override
  final String messageId;
  @override
  final num messageSeq;

  factory _$ReceiptMessageDto(
          [void Function(ReceiptMessageDtoBuilder)? updates]) =>
      (ReceiptMessageDtoBuilder()..update(updates))._build();

  _$ReceiptMessageDto._({required this.messageId, required this.messageSeq})
      : super._();
  @override
  ReceiptMessageDto rebuild(void Function(ReceiptMessageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReceiptMessageDtoBuilder toBuilder() =>
      ReceiptMessageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReceiptMessageDto &&
        messageId == other.messageId &&
        messageSeq == other.messageSeq;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, messageId.hashCode);
    _$hash = $jc(_$hash, messageSeq.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReceiptMessageDto')
          ..add('messageId', messageId)
          ..add('messageSeq', messageSeq))
        .toString();
  }
}

class ReceiptMessageDtoBuilder
    implements Builder<ReceiptMessageDto, ReceiptMessageDtoBuilder> {
  _$ReceiptMessageDto? _$v;

  String? _messageId;
  String? get messageId => _$this._messageId;
  set messageId(String? messageId) => _$this._messageId = messageId;

  num? _messageSeq;
  num? get messageSeq => _$this._messageSeq;
  set messageSeq(num? messageSeq) => _$this._messageSeq = messageSeq;

  ReceiptMessageDtoBuilder() {
    ReceiptMessageDto._defaults(this);
  }

  ReceiptMessageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _messageId = $v.messageId;
      _messageSeq = $v.messageSeq;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReceiptMessageDto other) {
    _$v = other as _$ReceiptMessageDto;
  }

  @override
  void update(void Function(ReceiptMessageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReceiptMessageDto build() => _build();

  _$ReceiptMessageDto _build() {
    final _$result = _$v ??
        _$ReceiptMessageDto._(
          messageId: BuiltValueNullFieldError.checkNotNull(
              messageId, r'ReceiptMessageDto', 'messageId'),
          messageSeq: BuiltValueNullFieldError.checkNotNull(
              messageSeq, r'ReceiptMessageDto', 'messageSeq'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
