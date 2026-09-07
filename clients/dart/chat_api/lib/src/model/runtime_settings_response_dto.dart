//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/runtime_capabilities_dto.dart';
import 'package:chat_api_client/src/model/messaging_policy_sync_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'runtime_settings_response_dto.g.dart';

/// RuntimeSettingsResponseDto
///
/// Properties:
/// * [registrationEnabled] 
/// * [capabilities] 
/// * [messagingPolicy] 
/// * [updatedAt] 
@BuiltValue()
abstract class RuntimeSettingsResponseDto implements Built<RuntimeSettingsResponseDto, RuntimeSettingsResponseDtoBuilder> {
  @BuiltValueField(wireName: r'registrationEnabled')
  bool get registrationEnabled;

  @BuiltValueField(wireName: r'capabilities')
  RuntimeCapabilitiesDto get capabilities;

  @BuiltValueField(wireName: r'messagingPolicy')
  MessagingPolicySyncDto get messagingPolicy;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  RuntimeSettingsResponseDto._();

  factory RuntimeSettingsResponseDto([void updates(RuntimeSettingsResponseDtoBuilder b)]) = _$RuntimeSettingsResponseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RuntimeSettingsResponseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RuntimeSettingsResponseDto> get serializer => _$RuntimeSettingsResponseDtoSerializer();
}

class _$RuntimeSettingsResponseDtoSerializer implements PrimitiveSerializer<RuntimeSettingsResponseDto> {
  @override
  final Iterable<Type> types = const [RuntimeSettingsResponseDto, _$RuntimeSettingsResponseDto];

  @override
  final String wireName = r'RuntimeSettingsResponseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RuntimeSettingsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'registrationEnabled';
    yield serializers.serialize(
      object.registrationEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'capabilities';
    yield serializers.serialize(
      object.capabilities,
      specifiedType: const FullType(RuntimeCapabilitiesDto),
    );
    yield r'messagingPolicy';
    yield serializers.serialize(
      object.messagingPolicy,
      specifiedType: const FullType(MessagingPolicySyncDto),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RuntimeSettingsResponseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RuntimeSettingsResponseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(RuntimeCapabilitiesDto),
          ) as RuntimeCapabilitiesDto;
          result.capabilities.replace(valueDes);
          break;
        case r'messagingPolicy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MessagingPolicySyncDto),
          ) as MessagingPolicySyncDto;
          result.messagingPolicy.replace(valueDes);
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RuntimeSettingsResponseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RuntimeSettingsResponseDtoBuilder();
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

