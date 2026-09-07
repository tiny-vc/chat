//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/server_info_get_info200_response_capabilities.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_info_get_info200_response.g.dart';

/// ServerInfoGetInfo200Response
///
/// Properties:
/// * [product] 
/// * [apiVersion] 
/// * [name] 
/// * [registrationEnabled] 
/// * [capabilities] 
/// * [uploadLimits] 
@BuiltValue()
abstract class ServerInfoGetInfo200Response implements Built<ServerInfoGetInfo200Response, ServerInfoGetInfo200ResponseBuilder> {
  @BuiltValueField(wireName: r'product')
  ServerInfoGetInfo200ResponseProductEnum get product;
  // enum productEnum {  chat,  };

  @BuiltValueField(wireName: r'apiVersion')
  ServerInfoGetInfo200ResponseApiVersionEnum get apiVersion;
  // enum apiVersionEnum {  1,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'registrationEnabled')
  bool get registrationEnabled;

  @BuiltValueField(wireName: r'capabilities')
  ServerInfoGetInfo200ResponseCapabilities get capabilities;

  @BuiltValueField(wireName: r'uploadLimits')
  BuiltMap<String, int> get uploadLimits;

  ServerInfoGetInfo200Response._();

  factory ServerInfoGetInfo200Response([void updates(ServerInfoGetInfo200ResponseBuilder b)]) = _$ServerInfoGetInfo200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerInfoGetInfo200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerInfoGetInfo200Response> get serializer => _$ServerInfoGetInfo200ResponseSerializer();
}

class _$ServerInfoGetInfo200ResponseSerializer implements PrimitiveSerializer<ServerInfoGetInfo200Response> {
  @override
  final Iterable<Type> types = const [ServerInfoGetInfo200Response, _$ServerInfoGetInfo200Response];

  @override
  final String wireName = r'ServerInfoGetInfo200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerInfoGetInfo200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'product';
    yield serializers.serialize(
      object.product,
      specifiedType: const FullType(ServerInfoGetInfo200ResponseProductEnum),
    );
    yield r'apiVersion';
    yield serializers.serialize(
      object.apiVersion,
      specifiedType: const FullType(ServerInfoGetInfo200ResponseApiVersionEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'registrationEnabled';
    yield serializers.serialize(
      object.registrationEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'capabilities';
    yield serializers.serialize(
      object.capabilities,
      specifiedType: const FullType(ServerInfoGetInfo200ResponseCapabilities),
    );
    yield r'uploadLimits';
    yield serializers.serialize(
      object.uploadLimits,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerInfoGetInfo200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerInfoGetInfo200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServerInfoGetInfo200ResponseProductEnum),
          ) as ServerInfoGetInfo200ResponseProductEnum;
          result.product = valueDes;
          break;
        case r'apiVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServerInfoGetInfo200ResponseApiVersionEnum),
          ) as ServerInfoGetInfo200ResponseApiVersionEnum;
          result.apiVersion = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'registrationEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.registrationEnabled = valueDes;
          break;
        case r'capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ServerInfoGetInfo200ResponseCapabilities),
          ) as ServerInfoGetInfo200ResponseCapabilities;
          result.capabilities.replace(valueDes);
          break;
        case r'uploadLimits':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.uploadLimits.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerInfoGetInfo200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerInfoGetInfo200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class ServerInfoGetInfo200ResponseProductEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'chat')
  static const ServerInfoGetInfo200ResponseProductEnum chat = _$serverInfoGetInfo200ResponseProductEnum_chat;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ServerInfoGetInfo200ResponseProductEnum unknownDefaultOpenApi = _$serverInfoGetInfo200ResponseProductEnum_unknownDefaultOpenApi;

  static Serializer<ServerInfoGetInfo200ResponseProductEnum> get serializer => _$serverInfoGetInfo200ResponseProductEnumSerializer;

  const ServerInfoGetInfo200ResponseProductEnum._(String name): super(name);

  static BuiltSet<ServerInfoGetInfo200ResponseProductEnum> get values => _$serverInfoGetInfo200ResponseProductEnumValues;
  static ServerInfoGetInfo200ResponseProductEnum valueOf(String name) => _$serverInfoGetInfo200ResponseProductEnumValueOf(name);
}

class ServerInfoGetInfo200ResponseApiVersionEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 1)
  static const ServerInfoGetInfo200ResponseApiVersionEnum number1 = _$serverInfoGetInfo200ResponseApiVersionEnum_number1;
  @BuiltValueEnumConst(wireNumber: 11184809, fallback: true)
  static const ServerInfoGetInfo200ResponseApiVersionEnum unknownDefaultOpenApi = _$serverInfoGetInfo200ResponseApiVersionEnum_unknownDefaultOpenApi;

  static Serializer<ServerInfoGetInfo200ResponseApiVersionEnum> get serializer => _$serverInfoGetInfo200ResponseApiVersionEnumSerializer;

  const ServerInfoGetInfo200ResponseApiVersionEnum._(String name): super(name);

  static BuiltSet<ServerInfoGetInfo200ResponseApiVersionEnum> get values => _$serverInfoGetInfo200ResponseApiVersionEnumValues;
  static ServerInfoGetInfo200ResponseApiVersionEnum valueOf(String name) => _$serverInfoGetInfo200ResponseApiVersionEnumValueOf(name);
}

