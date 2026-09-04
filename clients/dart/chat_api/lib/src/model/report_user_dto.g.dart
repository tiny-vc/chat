// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_SPAM =
    const ReportUserDtoReasonEnum._('SPAM');
const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_HARASSMENT =
    const ReportUserDtoReasonEnum._('HARASSMENT');
const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_FRAUD =
    const ReportUserDtoReasonEnum._('FRAUD');
const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_INAPPROPRIATE =
    const ReportUserDtoReasonEnum._('INAPPROPRIATE');
const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_OTHER =
    const ReportUserDtoReasonEnum._('OTHER');
const ReportUserDtoReasonEnum _$reportUserDtoReasonEnum_unknownDefaultOpenApi =
    const ReportUserDtoReasonEnum._('unknownDefaultOpenApi');

ReportUserDtoReasonEnum _$reportUserDtoReasonEnumValueOf(String name) {
  switch (name) {
    case 'SPAM':
      return _$reportUserDtoReasonEnum_SPAM;
    case 'HARASSMENT':
      return _$reportUserDtoReasonEnum_HARASSMENT;
    case 'FRAUD':
      return _$reportUserDtoReasonEnum_FRAUD;
    case 'INAPPROPRIATE':
      return _$reportUserDtoReasonEnum_INAPPROPRIATE;
    case 'OTHER':
      return _$reportUserDtoReasonEnum_OTHER;
    case 'unknownDefaultOpenApi':
      return _$reportUserDtoReasonEnum_unknownDefaultOpenApi;
    default:
      return _$reportUserDtoReasonEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ReportUserDtoReasonEnum> _$reportUserDtoReasonEnumValues =
    BuiltSet<ReportUserDtoReasonEnum>(const <ReportUserDtoReasonEnum>[
  _$reportUserDtoReasonEnum_SPAM,
  _$reportUserDtoReasonEnum_HARASSMENT,
  _$reportUserDtoReasonEnum_FRAUD,
  _$reportUserDtoReasonEnum_INAPPROPRIATE,
  _$reportUserDtoReasonEnum_OTHER,
  _$reportUserDtoReasonEnum_unknownDefaultOpenApi,
]);

Serializer<ReportUserDtoReasonEnum> _$reportUserDtoReasonEnumSerializer =
    _$ReportUserDtoReasonEnumSerializer();

class _$ReportUserDtoReasonEnumSerializer
    implements PrimitiveSerializer<ReportUserDtoReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SPAM': 'SPAM',
    'HARASSMENT': 'HARASSMENT',
    'FRAUD': 'FRAUD',
    'INAPPROPRIATE': 'INAPPROPRIATE',
    'OTHER': 'OTHER',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SPAM': 'SPAM',
    'HARASSMENT': 'HARASSMENT',
    'FRAUD': 'FRAUD',
    'INAPPROPRIATE': 'INAPPROPRIATE',
    'OTHER': 'OTHER',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[ReportUserDtoReasonEnum];
  @override
  final String wireName = 'ReportUserDtoReasonEnum';

  @override
  Object serialize(Serializers serializers, ReportUserDtoReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReportUserDtoReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReportUserDtoReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReportUserDto extends ReportUserDto {
  @override
  final ReportUserDtoReasonEnum reason;
  @override
  final String? details;

  factory _$ReportUserDto([void Function(ReportUserDtoBuilder)? updates]) =>
      (ReportUserDtoBuilder()..update(updates))._build();

  _$ReportUserDto._({required this.reason, this.details}) : super._();
  @override
  ReportUserDto rebuild(void Function(ReportUserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportUserDtoBuilder toBuilder() => ReportUserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReportUserDto &&
        reason == other.reason &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReportUserDto')
          ..add('reason', reason)
          ..add('details', details))
        .toString();
  }
}

class ReportUserDtoBuilder
    implements Builder<ReportUserDto, ReportUserDtoBuilder> {
  _$ReportUserDto? _$v;

  ReportUserDtoReasonEnum? _reason;
  ReportUserDtoReasonEnum? get reason => _$this._reason;
  set reason(ReportUserDtoReasonEnum? reason) => _$this._reason = reason;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  ReportUserDtoBuilder() {
    ReportUserDto._defaults(this);
  }

  ReportUserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _details = $v.details;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReportUserDto other) {
    _$v = other as _$ReportUserDto;
  }

  @override
  void update(void Function(ReportUserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReportUserDto build() => _build();

  _$ReportUserDto _build() {
    final _$result = _$v ??
        _$ReportUserDto._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'ReportUserDto', 'reason'),
          details: details,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
