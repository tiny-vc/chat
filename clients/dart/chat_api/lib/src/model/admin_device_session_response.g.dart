// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_device_session_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeviceSessionResponseDeviceTypeEnum
    _$adminDeviceSessionResponseDeviceTypeEnum_APP =
    const AdminDeviceSessionResponseDeviceTypeEnum._('APP');
const AdminDeviceSessionResponseDeviceTypeEnum
    _$adminDeviceSessionResponseDeviceTypeEnum_WEB =
    const AdminDeviceSessionResponseDeviceTypeEnum._('WEB');
const AdminDeviceSessionResponseDeviceTypeEnum
    _$adminDeviceSessionResponseDeviceTypeEnum_DESKTOP =
    const AdminDeviceSessionResponseDeviceTypeEnum._('DESKTOP');
const AdminDeviceSessionResponseDeviceTypeEnum
    _$adminDeviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi =
    const AdminDeviceSessionResponseDeviceTypeEnum._('unknownDefaultOpenApi');

AdminDeviceSessionResponseDeviceTypeEnum
    _$adminDeviceSessionResponseDeviceTypeEnumValueOf(String name) {
  switch (name) {
    case 'APP':
      return _$adminDeviceSessionResponseDeviceTypeEnum_APP;
    case 'WEB':
      return _$adminDeviceSessionResponseDeviceTypeEnum_WEB;
    case 'DESKTOP':
      return _$adminDeviceSessionResponseDeviceTypeEnum_DESKTOP;
    case 'unknownDefaultOpenApi':
      return _$adminDeviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;
    default:
      return _$adminDeviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<AdminDeviceSessionResponseDeviceTypeEnum>
    _$adminDeviceSessionResponseDeviceTypeEnumValues = BuiltSet<
        AdminDeviceSessionResponseDeviceTypeEnum>(const <AdminDeviceSessionResponseDeviceTypeEnum>[
  _$adminDeviceSessionResponseDeviceTypeEnum_APP,
  _$adminDeviceSessionResponseDeviceTypeEnum_WEB,
  _$adminDeviceSessionResponseDeviceTypeEnum_DESKTOP,
  _$adminDeviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi,
]);

Serializer<AdminDeviceSessionResponseDeviceTypeEnum>
    _$adminDeviceSessionResponseDeviceTypeEnumSerializer =
    _$AdminDeviceSessionResponseDeviceTypeEnumSerializer();

class _$AdminDeviceSessionResponseDeviceTypeEnumSerializer
    implements PrimitiveSerializer<AdminDeviceSessionResponseDeviceTypeEnum> {
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
    AdminDeviceSessionResponseDeviceTypeEnum
  ];
  @override
  final String wireName = 'AdminDeviceSessionResponseDeviceTypeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDeviceSessionResponseDeviceTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDeviceSessionResponseDeviceTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDeviceSessionResponseDeviceTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDeviceSessionResponse extends AdminDeviceSessionResponse {
  @override
  final String id;
  @override
  final String deviceId;
  @override
  final AdminDeviceSessionResponseDeviceTypeEnum deviceType;
  @override
  final String deviceName;
  @override
  final String? ipAddress;
  @override
  final String? userAgent;
  @override
  final DateTime lastSeenAt;
  @override
  final DateTime expiresAt;
  @override
  final DateTime? revokedAt;
  @override
  final DateTime createdAt;

  factory _$AdminDeviceSessionResponse(
          [void Function(AdminDeviceSessionResponseBuilder)? updates]) =>
      (AdminDeviceSessionResponseBuilder()..update(updates))._build();

  _$AdminDeviceSessionResponse._(
      {required this.id,
      required this.deviceId,
      required this.deviceType,
      required this.deviceName,
      this.ipAddress,
      this.userAgent,
      required this.lastSeenAt,
      required this.expiresAt,
      this.revokedAt,
      required this.createdAt})
      : super._();
  @override
  AdminDeviceSessionResponse rebuild(
          void Function(AdminDeviceSessionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDeviceSessionResponseBuilder toBuilder() =>
      AdminDeviceSessionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeviceSessionResponse &&
        id == other.id &&
        deviceId == other.deviceId &&
        deviceType == other.deviceType &&
        deviceName == other.deviceName &&
        ipAddress == other.ipAddress &&
        userAgent == other.userAgent &&
        lastSeenAt == other.lastSeenAt &&
        expiresAt == other.expiresAt &&
        revokedAt == other.revokedAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, deviceType.hashCode);
    _$hash = $jc(_$hash, deviceName.hashCode);
    _$hash = $jc(_$hash, ipAddress.hashCode);
    _$hash = $jc(_$hash, userAgent.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, revokedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDeviceSessionResponse')
          ..add('id', id)
          ..add('deviceId', deviceId)
          ..add('deviceType', deviceType)
          ..add('deviceName', deviceName)
          ..add('ipAddress', ipAddress)
          ..add('userAgent', userAgent)
          ..add('lastSeenAt', lastSeenAt)
          ..add('expiresAt', expiresAt)
          ..add('revokedAt', revokedAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AdminDeviceSessionResponseBuilder
    implements
        Builder<AdminDeviceSessionResponse, AdminDeviceSessionResponseBuilder> {
  _$AdminDeviceSessionResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  AdminDeviceSessionResponseDeviceTypeEnum? _deviceType;
  AdminDeviceSessionResponseDeviceTypeEnum? get deviceType =>
      _$this._deviceType;
  set deviceType(AdminDeviceSessionResponseDeviceTypeEnum? deviceType) =>
      _$this._deviceType = deviceType;

  String? _deviceName;
  String? get deviceName => _$this._deviceName;
  set deviceName(String? deviceName) => _$this._deviceName = deviceName;

  String? _ipAddress;
  String? get ipAddress => _$this._ipAddress;
  set ipAddress(String? ipAddress) => _$this._ipAddress = ipAddress;

  String? _userAgent;
  String? get userAgent => _$this._userAgent;
  set userAgent(String? userAgent) => _$this._userAgent = userAgent;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _revokedAt;
  DateTime? get revokedAt => _$this._revokedAt;
  set revokedAt(DateTime? revokedAt) => _$this._revokedAt = revokedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminDeviceSessionResponseBuilder() {
    AdminDeviceSessionResponse._defaults(this);
  }

  AdminDeviceSessionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _deviceId = $v.deviceId;
      _deviceType = $v.deviceType;
      _deviceName = $v.deviceName;
      _ipAddress = $v.ipAddress;
      _userAgent = $v.userAgent;
      _lastSeenAt = $v.lastSeenAt;
      _expiresAt = $v.expiresAt;
      _revokedAt = $v.revokedAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeviceSessionResponse other) {
    _$v = other as _$AdminDeviceSessionResponse;
  }

  @override
  void update(void Function(AdminDeviceSessionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeviceSessionResponse build() => _build();

  _$AdminDeviceSessionResponse _build() {
    final _$result = _$v ??
        _$AdminDeviceSessionResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminDeviceSessionResponse', 'id'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'AdminDeviceSessionResponse', 'deviceId'),
          deviceType: BuiltValueNullFieldError.checkNotNull(
              deviceType, r'AdminDeviceSessionResponse', 'deviceType'),
          deviceName: BuiltValueNullFieldError.checkNotNull(
              deviceName, r'AdminDeviceSessionResponse', 'deviceName'),
          ipAddress: ipAddress,
          userAgent: userAgent,
          lastSeenAt: BuiltValueNullFieldError.checkNotNull(
              lastSeenAt, r'AdminDeviceSessionResponse', 'lastSeenAt'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'AdminDeviceSessionResponse', 'expiresAt'),
          revokedAt: revokedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminDeviceSessionResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
