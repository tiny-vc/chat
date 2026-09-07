//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_device_session_response.g.dart';

/// AdminDeviceSessionResponse
///
/// Properties:
/// * [id] 
/// * [deviceId] 
/// * [deviceType] 
/// * [deviceName] 
/// * [ipAddress] 
/// * [userAgent] 
/// * [lastSeenAt] 
/// * [expiresAt] 
/// * [revokedAt] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminDeviceSessionResponse implements Built<AdminDeviceSessionResponse, AdminDeviceSessionResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'deviceType')
  AdminDeviceSessionResponseDeviceTypeEnum get deviceType;
  // enum deviceTypeEnum {  APP,  WEB,  DESKTOP,  };

  @BuiltValueField(wireName: r'deviceName')
  String get deviceName;

  @BuiltValueField(wireName: r'ipAddress')
  String? get ipAddress;

  @BuiltValueField(wireName: r'userAgent')
  String? get userAgent;

  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime get lastSeenAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'revokedAt')
  DateTime? get revokedAt;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminDeviceSessionResponse._();

  factory AdminDeviceSessionResponse([void updates(AdminDeviceSessionResponseBuilder b)]) = _$AdminDeviceSessionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeviceSessionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeviceSessionResponse> get serializer => _$AdminDeviceSessionResponseSerializer();
}

class _$AdminDeviceSessionResponseSerializer implements PrimitiveSerializer<AdminDeviceSessionResponse> {
  @override
  final Iterable<Type> types = const [AdminDeviceSessionResponse, _$AdminDeviceSessionResponse];

  @override
  final String wireName = r'AdminDeviceSessionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeviceSessionResponse object, {
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
      specifiedType: const FullType(AdminDeviceSessionResponseDeviceTypeEnum),
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
    if (object.userAgent != null) {
      yield r'userAgent';
      yield serializers.serialize(
        object.userAgent,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lastSeenAt';
    yield serializers.serialize(
      object.lastSeenAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.revokedAt != null) {
      yield r'revokedAt';
      yield serializers.serialize(
        object.revokedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeviceSessionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDeviceSessionResponseBuilder result,
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
            specifiedType: const FullType(AdminDeviceSessionResponseDeviceTypeEnum),
          ) as AdminDeviceSessionResponseDeviceTypeEnum;
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
        case r'userAgent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userAgent = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastSeenAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'revokedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.revokedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeviceSessionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeviceSessionResponseBuilder();
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

class AdminDeviceSessionResponseDeviceTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APP')
  static const AdminDeviceSessionResponseDeviceTypeEnum APP = _$adminDeviceSessionResponseDeviceTypeEnum_APP;
  @BuiltValueEnumConst(wireName: r'WEB')
  static const AdminDeviceSessionResponseDeviceTypeEnum WEB = _$adminDeviceSessionResponseDeviceTypeEnum_WEB;
  @BuiltValueEnumConst(wireName: r'DESKTOP')
  static const AdminDeviceSessionResponseDeviceTypeEnum DESKTOP = _$adminDeviceSessionResponseDeviceTypeEnum_DESKTOP;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminDeviceSessionResponseDeviceTypeEnum unknownDefaultOpenApi = _$adminDeviceSessionResponseDeviceTypeEnum_unknownDefaultOpenApi;

  static Serializer<AdminDeviceSessionResponseDeviceTypeEnum> get serializer => _$adminDeviceSessionResponseDeviceTypeEnumSerializer;

  const AdminDeviceSessionResponseDeviceTypeEnum._(String name): super(name);

  static BuiltSet<AdminDeviceSessionResponseDeviceTypeEnum> get values => _$adminDeviceSessionResponseDeviceTypeEnumValues;
  static AdminDeviceSessionResponseDeviceTypeEnum valueOf(String name) => _$adminDeviceSessionResponseDeviceTypeEnumValueOf(name);
}

