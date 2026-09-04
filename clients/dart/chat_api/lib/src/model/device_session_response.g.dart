// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeviceSessionResponseDeviceTypeEnum
    _$deviceSessionResponseDeviceTypeEnum_APP =
    const DeviceSessionResponseDeviceTypeEnum._('APP');
const DeviceSessionResponseDeviceTypeEnum
    _$deviceSessionResponseDeviceTypeEnum_WEB =
    const DeviceSessionResponseDeviceTypeEnum._('WEB');
const DeviceSessionResponseDeviceTypeEnum
    _$deviceSessionResponseDeviceTypeEnum_DESKTOP =
    const DeviceSessionResponseDeviceTypeEnum._('DESKTOP');
const DeviceSessionResponseDeviceTypeEnum
    _$deviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi =
    const DeviceSessionResponseDeviceTypeEnum._('unknownDefaultOpenApi');

DeviceSessionResponseDeviceTypeEnum
    _$deviceSessionResponseDeviceTypeEnumValueOf(String name) {
  switch (name) {
    case 'APP':
      return _$deviceSessionResponseDeviceTypeEnum_APP;
    case 'WEB':
      return _$deviceSessionResponseDeviceTypeEnum_WEB;
    case 'DESKTOP':
      return _$deviceSessionResponseDeviceTypeEnum_DESKTOP;
    case 'unknownDefaultOpenApi':
      return _$deviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;
    default:
      return _$deviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<DeviceSessionResponseDeviceTypeEnum>
    _$deviceSessionResponseDeviceTypeEnumValues = BuiltSet<
        DeviceSessionResponseDeviceTypeEnum>(const <DeviceSessionResponseDeviceTypeEnum>[
  _$deviceSessionResponseDeviceTypeEnum_APP,
  _$deviceSessionResponseDeviceTypeEnum_WEB,
  _$deviceSessionResponseDeviceTypeEnum_DESKTOP,
  _$deviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi,
]);

Serializer<DeviceSessionResponseDeviceTypeEnum>
    _$deviceSessionResponseDeviceTypeEnumSerializer =
    _$DeviceSessionResponseDeviceTypeEnumSerializer();

class _$DeviceSessionResponseDeviceTypeEnumSerializer
    implements PrimitiveSerializer<DeviceSessionResponseDeviceTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APP': 'APP',
    'WEB': 'WEB',
    'DESKTOP': 'DESKTOP',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APP': 'APP',
    'WEB': 'WEB',
    'DESKTOP': 'DESKTOP',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DeviceSessionResponseDeviceTypeEnum
  ];
  @override
  final String wireName = 'DeviceSessionResponseDeviceTypeEnum';

  @override
  Object serialize(
          Serializers serializers, DeviceSessionResponseDeviceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeviceSessionResponseDeviceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeviceSessionResponseDeviceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeviceSessionResponse extends DeviceSessionResponse {
  @override
  final String id;
  @override
  final String deviceId;
  @override
  final DeviceSessionResponseDeviceTypeEnum deviceType;
  @override
  final String deviceName;
  @override
  final String? ipAddress;
  @override
  final DateTime lastSeenAt;
  @override
  final DateTime createdAt;
  @override
  final bool current;

  factory _$DeviceSessionResponse(
          [void Function(DeviceSessionResponseBuilder)? updates]) =>
      (DeviceSessionResponseBuilder()..update(updates))._build();

  _$DeviceSessionResponse._(
      {required this.id,
      required this.deviceId,
      required this.deviceType,
      required this.deviceName,
      this.ipAddress,
      required this.lastSeenAt,
      required this.createdAt,
      required this.current})
      : super._();
  @override
  DeviceSessionResponse rebuild(
          void Function(DeviceSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceSessionResponseBuilder toBuilder() =>
      DeviceSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceSessionResponse &&
        id == other.id &&
        deviceId == other.deviceId &&
        deviceType == other.deviceType &&
        deviceName == other.deviceName &&
        ipAddress == other.ipAddress &&
        lastSeenAt == other.lastSeenAt &&
        createdAt == other.createdAt &&
        current == other.current;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, deviceType.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceSessionResponse')
          ..add('id', id)
          ..add('deviceId', deviceId)
          ..add('deviceType', deviceType)
          ..add('deviceName', deviceName)
          ..add('ipAddress', ipAddress)
          ..add('lastSeenAt', lastSeenAt)
          ..add('createdAt', createdAt)
          ..add('current', current))
        .toString();
  }
}

class DeviceSessionResponseBuilder
    implements Builder<DeviceSessionResponse, DeviceSessionResponseBuilder> {
  _$DeviceSessionResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  DeviceSessionResponseDeviceTypeEnum? _deviceType;
  DeviceSessionResponseDeviceTypeEnum? get deviceType => _$this._deviceType;
  set deviceType(DeviceSessionResponseDeviceTypeEnum? deviceType) =>
      _$this._deviceType = deviceType;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _current;
  bool? get current => _$this._current;
  set current(bool? current) => _$this._current = current;

  DeviceSessionResponseBuilder() {
    DeviceSessionResponse._defaults(this);
  }

  DeviceSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceId = $v.deviceId;
      _deviceType = $v.deviceType;
      _deviceName = $v.deviceName;
      _ipAddress = $v.ipAddress;
      _lastSeenAt = $v.lastSeenAt;
      _createdAt = $v.createdAt;
      _current = $v.current;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceSessionResponse other) {
    _$v = other as _$DeviceSessionResponse;
  }

  @override
  void update(void Function(DeviceSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceSessionResponse build() => _build();

  _$DeviceSessionResponse _build() {
    final _$result = _$v ??
        _$DeviceSessionResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DeviceSessionResponse', 'id'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'DeviceSessionResponse', 'deviceId'),
          deviceType: BuiltValueNullFieldError.checkNotNull(
              deviceType, r'DeviceSessionResponse', 'deviceType'),
          deviceName: BuiltValueNullFieldError.checkNotNull(
              deviceName, r'DeviceSessionResponse', 'deviceName'),
          ipAddress: ipAddress,
          lastSeenAt: BuiltValueNullFieldError.checkNotNull(
              lastSeenAt, r'DeviceSessionResponse', 'lastSeenAt'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'DeviceSessionResponse', 'createdAt'),
          current: BuiltValueNullFieldError.checkNotNull(
              current, r'DeviceSessionResponse', 'current'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
