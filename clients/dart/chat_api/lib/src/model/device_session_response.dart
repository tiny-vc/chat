//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'device_session_response.g.dart';

/// DeviceSessionResponse
///
/// Properties:
/// * [id] 
/// * [deviceId] 
/// * [deviceType] 
/// * [deviceName] 
/// * [ipAddress] 
/// * [lastSeenAt] 
/// * [createdAt] 
/// * [current] 
@BuiltValue()
abstract class DeviceSessionResponse implements Built<DeviceSessionResponse, DeviceSessionResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'deviceType')
  DeviceSessionResponseDeviceTypeEnum get deviceType;
  // enum deviceTypeEnum {  APP,  WEB,  DESKTOP,  };

  @BuiltValueField(wireName: r'deviceName')
  String get deviceName;

  @BuiltValueField(wireName: r'ipAddress')
  String? get ipAddress;

  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime get lastSeenAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'current')
  bool get current;

  DeviceSessionResponse._();

  factory DeviceSessionResponse([void updates(DeviceSessionResponseBuilder b)]) = _$DeviceSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeviceSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeviceSessionResponse> get serializer => _$DeviceSessionResponseSerializer();
}

class _$DeviceSessionResponseSerializer implements PrimitiveSerializer<DeviceSessionResponse> {
  @override
  final Iterable<Type> types = const [DeviceSessionResponse, _$DeviceSessionResponse];

  @override
  final String wireName = r'DeviceSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeviceSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'deviceType';
    yield serializers.serialize(
      object.deviceType,
      specifiedType: const FullType(DeviceSessionResponseDeviceTypeEnum),
    );
    yield r'deviceName';
    yield serializers.serialize(
      object.deviceName,
      specifiedType: const FullType(String),
    );
    if (object.ipAddress != null) {
      yield r'ipAddress';
      yield serializers.serialize(
        object.ipAddress,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lastSeenAt';
    yield serializers.serialize(
      object.lastSeenAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeviceSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeviceSessionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        case r'deviceType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DeviceSessionResponseDeviceTypeEnum),
          ) as DeviceSessionResponseDeviceTypeEnum;
          result.deviceType = valueDes;
          break;
        case r'deviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceName = valueDes;
          break;
        case r'ipAddress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ipAddress = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastSeenAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.current = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeviceSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeviceSessionResponseBuilder();
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

class DeviceSessionResponseDeviceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APP')
  static const DeviceSessionResponseDeviceTypeEnum APP = _$deviceSessionResponseDeviceTypeEnum_APP;
  @BuiltValueEnumConst(wireName: r'WEB')
  static const DeviceSessionResponseDeviceTypeEnum WEB = _$deviceSessionResponseDeviceTypeEnum_WEB;
  @BuiltValueEnumConst(wireName: r'DESKTOP')
  static const DeviceSessionResponseDeviceTypeEnum DESKTOP = _$deviceSessionResponseDeviceTypeEnum_DESKTOP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const DeviceSessionResponseDeviceTypeEnum unknownDefaultOpenApi = _$deviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;

  static Serializer<DeviceSessionResponseDeviceTypeEnum> get serializer => _$deviceSessionResponseDeviceTypeEnumSerializer;

  const DeviceSessionResponseDeviceTypeEnum._(String name): super(name);

  static BuiltSet<DeviceSessionResponseDeviceTypeEnum> get values => _$deviceSessionResponseDeviceTypeEnumValues;
  static DeviceSessionResponseDeviceTypeEnum valueOf(String name) => _$deviceSessionResponseDeviceTypeEnumValueOf(name);
}

