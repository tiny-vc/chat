// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_info_get_info200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ServerInfoGetInfo200ResponseProductEnum
    _$serverInfoGetInfo200ResponseProductEnum_chat =
    const ServerInfoGetInfo200ResponseProductEnum._('chat');
const ServerInfoGetInfo200ResponseProductEnum
    _$serverInfoGetInfo200ResponseProductEnum_unknownDefaultOpenApi =
    const ServerInfoGetInfo200ResponseProductEnum._('unknownDefaultOpenApi');

ServerInfoGetInfo200ResponseProductEnum
    _$serverInfoGetInfo200ResponseProductEnumValueOf(String name) {
  switch (name) {
    case 'chat':
      return _$serverInfoGetInfo200ResponseProductEnum_chat;
    case 'unknownDefaultOpenApi':
      return _$serverInfoGetInfo200ResponseProductEnum_unknownDefaultOpenApi;
    default:
      return _$serverInfoGetInfo200ResponseProductEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ServerInfoGetInfo200ResponseProductEnum>
    _$serverInfoGetInfo200ResponseProductEnumValues = BuiltSet<
        ServerInfoGetInfo200ResponseProductEnum>(const <ServerInfoGetInfo200ResponseProductEnum>[
  _$serverInfoGetInfo200ResponseProductEnum_chat,
  _$serverInfoGetInfo200ResponseProductEnum_unknownDefaultOpenApi,
]);

const ServerInfoGetInfo200ResponseApiVersionEnum
    _$serverInfoGetInfo200ResponseApiVersionEnum_number1 =
    const ServerInfoGetInfo200ResponseApiVersionEnum._('number1');
const ServerInfoGetInfo200ResponseApiVersionEnum
    _$serverInfoGetInfo200ResponseApiVersionEnum_unknownDefaultOpenApi =
    const ServerInfoGetInfo200ResponseApiVersionEnum._('unknownDefaultOpenApi');

ServerInfoGetInfo200ResponseApiVersionEnum
    _$serverInfoGetInfo200ResponseApiVersionEnumValueOf(String name) {
  switch (name) {
    case 'number1':
      return _$serverInfoGetInfo200ResponseApiVersionEnum_number1;
    case 'unknownDefaultOpenApi':
      return _$serverInfoGetInfo200ResponseApiVersionEnum_unknownDefaultOpenApi;
    default:
      return _$serverInfoGetInfo200ResponseApiVersionEnum_unknownDefaultOpenApi;
  }
}

final BuiltSet<ServerInfoGetInfo200ResponseApiVersionEnum>
    _$serverInfoGetInfo200ResponseApiVersionEnumValues = BuiltSet<
        ServerInfoGetInfo200ResponseApiVersionEnum>(const <ServerInfoGetInfo200ResponseApiVersionEnum>[
  _$serverInfoGetInfo200ResponseApiVersionEnum_number1,
  _$serverInfoGetInfo200ResponseApiVersionEnum_unknownDefaultOpenApi,
]);

Serializer<ServerInfoGetInfo200ResponseProductEnum>
    _$serverInfoGetInfo200ResponseProductEnumSerializer =
    _$ServerInfoGetInfo200ResponseProductEnumSerializer();
Serializer<ServerInfoGetInfo200ResponseApiVersionEnum>
    _$serverInfoGetInfo200ResponseApiVersionEnumSerializer =
    _$ServerInfoGetInfo200ResponseApiVersionEnumSerializer();

class _$ServerInfoGetInfo200ResponseProductEnumSerializer
    implements PrimitiveSerializer<ServerInfoGetInfo200ResponseProductEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'chat': 'chat',
    'unknownDefaultOpenApi': 'unknown_default_open_api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'chat': 'chat',
    'unknown_default_open_api': 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ServerInfoGetInfo200ResponseProductEnum
  ];
  @override
  final String wireName = 'ServerInfoGetInfo200ResponseProductEnum';

  @override
  Object serialize(Serializers serializers,
          ServerInfoGetInfo200ResponseProductEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ServerInfoGetInfo200ResponseProductEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ServerInfoGetInfo200ResponseProductEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ServerInfoGetInfo200ResponseApiVersionEnumSerializer
    implements PrimitiveSerializer<ServerInfoGetInfo200ResponseApiVersionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number1': 1,
    'unknownDefaultOpenApi': 11184809,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    1: 'number1',
    11184809: 'unknownDefaultOpenApi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ServerInfoGetInfo200ResponseApiVersionEnum
  ];
  @override
  final String wireName = 'ServerInfoGetInfo200ResponseApiVersionEnum';

  @override
  Object serialize(Serializers serializers,
          ServerInfoGetInfo200ResponseApiVersionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ServerInfoGetInfo200ResponseApiVersionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ServerInfoGetInfo200ResponseApiVersionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ServerInfoGetInfo200Response extends ServerInfoGetInfo200Response {
  @override
  final ServerInfoGetInfo200ResponseProductEnum product;
  @override
  final ServerInfoGetInfo200ResponseApiVersionEnum apiVersion;
  @override
  final String name;
  @override
  final bool registrationEnabled;
  @override
  final ServerInfoGetInfo200ResponseCapabilities capabilities;
  @override
  final BuiltMap<String, int> uploadLimits;

  factory _$ServerInfoGetInfo200Response(
          [void Function(ServerInfoGetInfo200ResponseBuilder)? updates]) =>
      (ServerInfoGetInfo200ResponseBuilder()..update(updates))._build();

  _$ServerInfoGetInfo200Response._(
      {required this.product,
      required this.apiVersion,
      required this.name,
      required this.registrationEnabled,
      required this.capabilities,
      required this.uploadLimits})
      : super._();
  @override
  ServerInfoGetInfo200Response rebuild(
          void Function(ServerInfoGetInfo200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ServerInfoGetInfo200ResponseBuilder toBuilder() =>
      ServerInfoGetInfo200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServerInfoGetInfo200Response &&
        product == other.product &&
        apiVersion == other.apiVersion &&
        name == other.name &&
        registrationEnabled == other.registrationEnabled &&
        capabilities == other.capabilities &&
        uploadLimits == other.uploadLimits;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jc(_$hash, apiVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, registrationEnabled.hashCode);
    _$hash = $jc(_$hash, capabilities.hashCode);
    _$hash = $jc(_$hash, uploadLimits.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ServerInfoGetInfo200Response')
          ..add('product', product)
          ..add('apiVersion', apiVersion)
          ..add('name', name)
          ..add('registrationEnabled', registrationEnabled)
          ..add('capabilities', capabilities)
          ..add('uploadLimits', uploadLimits))
        .toString();
  }
}

class ServerInfoGetInfo200ResponseBuilder
    implements
        Builder<ServerInfoGetInfo200Response,
            ServerInfoGetInfo200ResponseBuilder> {
  _$ServerInfoGetInfo200Response? _$v;

  ServerInfoGetInfo200ResponseProductEnum? _product;
  ServerInfoGetInfo200ResponseProductEnum? get product => _$this._product;
  set product(ServerInfoGetInfo200ResponseProductEnum? product) =>
      _$this._product = product;

  ServerInfoGetInfo200ResponseApiVersionEnum? _apiVersion;
  ServerInfoGetInfo200ResponseApiVersionEnum? get apiVersion =>
      _$this._apiVersion;
  set apiVersion(ServerInfoGetInfo200ResponseApiVersionEnum? apiVersion) =>
      _$this._apiVersion = apiVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  bool? _registrationEnabled;
  bool? get registrationEnabled => _$this._registrationEnabled;
  set registrationEnabled(bool? registrationEnabled) =>
      _$this._registrationEnabled = registrationEnabled;

  ServerInfoGetInfo200ResponseCapabilitiesBuilder? _capabilities;
  ServerInfoGetInfo200ResponseCapabilitiesBuilder get capabilities =>
      _$this._capabilities ??=
          ServerInfoGetInfo200ResponseCapabilitiesBuilder();
  set capabilities(
          ServerInfoGetInfo200ResponseCapabilitiesBuilder? capabilities) =>
      _$this._capabilities = capabilities;

  MapBuilder<String, int>? _uploadLimits;
  MapBuilder<String, int> get uploadLimits =>
      _$this._uploadLimits ??= MapBuilder<String, int>();
  set uploadLimits(MapBuilder<String, int>? uploadLimits) =>
      _$this._uploadLimits = uploadLimits;

  ServerInfoGetInfo200ResponseBuilder() {
    ServerInfoGetInfo200Response._defaults(this);
  }

  ServerInfoGetInfo200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _product = $v.product;
      _apiVersion = $v.apiVersion;
      _name = $v.name;
      _registrationEnabled = $v.registrationEnabled;
      _capabilities = $v.capabilities.toBuilder();
      _uploadLimits = $v.uploadLimits.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ServerInfoGetInfo200Response other) {
    _$v = other as _$ServerInfoGetInfo200Response;
  }

  @override
  void update(void Function(ServerInfoGetInfo200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ServerInfoGetInfo200Response build() => _build();

  _$ServerInfoGetInfo200Response _build() {
    _$ServerInfoGetInfo200Response _$result;
    try {
      _$result = _$v ??
          _$ServerInfoGetInfo200Response._(
            product: BuiltValueNullFieldError.checkNotNull(
                product, r'ServerInfoGetInfo200Response', 'product'),
            apiVersion: BuiltValueNullFieldError.checkNotNull(
                apiVersion, r'ServerInfoGetInfo200Response', 'apiVersion'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ServerInfoGetInfo200Response', 'name'),
            registrationEnabled: BuiltValueNullFieldError.checkNotNull(
                registrationEnabled,
                r'ServerInfoGetInfo200Response',
                'registrationEnabled'),
            capabilities: capabilities.build(),
            uploadLimits: uploadLimits.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'capabilities';
        capabilities.build();
        _$failedField = 'uploadLimits';
        uploadLimits.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ServerInfoGetInfo200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
