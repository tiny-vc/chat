//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_info_get_info200_response_capabilities.g.dart';

/// ServerInfoGetInfo200ResponseCapabilities
///
/// Properties:
/// * [messaging] 
/// * [files] 
/// * [groups] 
/// * [audioCalls] 
/// * [videoCalls] 
@BuiltValue()
abstract class ServerInfoGetInfo200ResponseCapabilities implements Built<ServerInfoGetInfo200ResponseCapabilities, ServerInfoGetInfo200ResponseCapabilitiesBuilder> {
  @BuiltValueField(wireName: r'messaging')
  bool get messaging;

  @BuiltValueField(wireName: r'files')
  bool get files;

  @BuiltValueField(wireName: r'groups')
  bool get groups;

  @BuiltValueField(wireName: r'audioCalls')
  bool get audioCalls;

  @BuiltValueField(wireName: r'videoCalls')
  bool get videoCalls;

  ServerInfoGetInfo200ResponseCapabilities._();

  factory ServerInfoGetInfo200ResponseCapabilities([void updates(ServerInfoGetInfo200ResponseCapabilitiesBuilder b)]) = _$ServerInfoGetInfo200ResponseCapabilities;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerInfoGetInfo200ResponseCapabilitiesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerInfoGetInfo200ResponseCapabilities> get serializer => _$ServerInfoGetInfo200ResponseCapabilitiesSerializer();
}

class _$ServerInfoGetInfo200ResponseCapabilitiesSerializer implements PrimitiveSerializer<ServerInfoGetInfo200ResponseCapabilities> {
  @override
  final Iterable<Type> types = const [ServerInfoGetInfo200ResponseCapabilities, _$ServerInfoGetInfo200ResponseCapabilities];

  @override
  final String wireName = r'ServerInfoGetInfo200ResponseCapabilities';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerInfoGetInfo200ResponseCapabilities object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'messaging';
    yield serializers.serialize(
      object.messaging,
      specifiedType: const FullType(bool),
    );
    yield r'files';
    yield serializers.serialize(
      object.files,
      specifiedType: const FullType(bool),
    );
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(bool),
    );
    yield r'audioCalls';
    yield serializers.serialize(
      object.audioCalls,
      specifiedType: const FullType(bool),
    );
    yield r'videoCalls';
    yield serializers.serialize(
      object.videoCalls,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerInfoGetInfo200ResponseCapabilities object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ServerInfoGetInfo200ResponseCapabilitiesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'messaging':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.messaging = valueDes;
          break;
        case r'files':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.files = valueDes;
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.groups = valueDes;
          break;
        case r'audioCalls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.audioCalls = valueDes;
          break;
        case r'videoCalls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.videoCalls = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerInfoGetInfo200ResponseCapabilities deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerInfoGetInfo200ResponseCapabilitiesBuilder();
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

