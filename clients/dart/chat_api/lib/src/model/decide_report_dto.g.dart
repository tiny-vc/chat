// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decide_report_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DecideReportDtoStatusEnum _$decideReportDtoStatusEnum_RESOLVED =
    const DecideReportDtoStatusEnum._('RESOLVED');
const DecideReportDtoStatusEnum _$decideReportDtoStatusEnum_DISMISSED =
    const DecideReportDtoStatusEnum._('DISMISSED');
const DecideReportDtoStatusEnum
    _$decideReportDtoStatusEnum_unknownDefaultOpenApi =
    const DecideReportDtoStatusEnum._('unknownDefaultOpenApi');

DecideReportDtoStatusEnum _$decideReportDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'RESOLVED':
      return _$decideReportDtoStatusEnum_RESOLVED;
    case 'DISMISSED':
      return _$decideReportDtoStatusEnum_DISMISSED;
    case 'unknownDefaultOpenApi':
      return _$decideReportDtoStatusEnum_unknownDefaultOpenApi;
    default:
      return _$decideReportDtoStatusEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<DecideReportDtoStatusEnum> _$decideReportDtoStatusEnumValues =
    BuiltSet<DecideReportDtoStatusEnum>(const <DecideReportDtoStatusEnum>[
  _$decideReportDtoStatusEnum_RESOLVED,
  _$decideReportDtoStatusEnum_DISMISSED,
  _$decideReportDtoStatusEnum_unknownDefaultOpenApi,
]);

Serializer<DecideReportDtoStatusEnum> _$decideReportDtoStatusEnumSerializer =
    _$DecideReportDtoStatusEnumSerializer();

class _$DecideReportDtoStatusEnumSerializer
    implements PrimitiveSerializer<DecideReportDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESOLVED': 'RESOLVED',
    'DISMISSED': 'DISMISSED',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESOLVED': 'RESOLVED',
    'DISMISSED': 'DISMISSED',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[DecideReportDtoStatusEnum];
  @override
  final String wireName = 'DecideReportDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, DecideReportDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DecideReportDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DecideReportDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DecideReportDto extends DecideReportDto {
  @override
  final DecideReportDtoStatusEnum status;
  @override
  final String? note;

  factory _$DecideReportDto([void Function(DecideReportDtoBuilder)? updates]) =>
      (DecideReportDtoBuilder()..update(updates))._build();

  _$DecideReportDto._({required this.status, this.note}) : super._();
  @override
  DecideReportDto rebuild(void Function(DecideReportDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecideReportDtoBuilder toBuilder() => DecideReportDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecideReportDto &&
        status == other.status &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DecideReportDto')
          ..add('status', status)
          ..add('note', note))
        .toString();
  }
}

class DecideReportDtoBuilder
    implements Builder<DecideReportDto, DecideReportDtoBuilder> {
  _$DecideReportDto? _$v;

  DecideReportDtoStatusEnum? _status;
  DecideReportDtoStatusEnum? get status => _$this._status;
  set status(DecideReportDtoStatusEnum? status) => _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  DecideReportDtoBuilder() {
    DecideReportDto._defaults(this);
  }

  DecideReportDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecideReportDto other) {
    _$v = other as _$DecideReportDto;
  }

  @override
  void update(void Function(DecideReportDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DecideReportDto build() => _build();

  _$DecideReportDto _build() {
    final _$result = _$v ??
        _$DecideReportDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'DecideReportDto', 'status'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
