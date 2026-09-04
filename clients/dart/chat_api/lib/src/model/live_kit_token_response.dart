//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'live_kit_token_response.g.dart';

/// LiveKitTokenResponse
///
/// Properties:
/// * [url] 
/// * [token] 
@BuiltValue()
abstract class LiveKitTokenResponse implements Built<LiveKitTokenResponse, LiveKitTokenResponseBuilder> {
  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'token')
  String get token;

  LiveKitTokenResponse._();

  factory LiveKitTokenResponse([void updates(LiveKitTokenResponseBuilder b)]) = _$LiveKitTokenResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LiveKitTokenResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LiveKitTokenResponse> get serializer => _$LiveKitTokenResponseSerializer();
}

class _$LiveKitTokenResponseSerializer implements PrimitiveSerializer<LiveKitTokenResponse> {
  @override
  final Iterable<Type> types = const [LiveKitTokenResponse, _$LiveKitTokenResponse];

  @override
  final String wireName = r'LiveKitTokenResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LiveKitTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LiveKitTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LiveKitTokenResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LiveKitTokenResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LiveKitTokenResponseBuilder();
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

