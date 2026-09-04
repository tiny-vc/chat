//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'im_connection_response.g.dart';

/// ImConnectionResponse
///
/// Properties:
/// * [uid] 
/// * [token] 
/// * [address] 
@BuiltValue()
abstract class ImConnectionResponse implements Built<ImConnectionResponse, ImConnectionResponseBuilder> {
  @BuiltValueField(wireName: r'uid')
  String get uid;

  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'address')
  String get address;

  ImConnectionResponse._();

  factory ImConnectionResponse([void updates(ImConnectionResponseBuilder b)]) = _$ImConnectionResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ImConnectionResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ImConnectionResponse> get serializer => _$ImConnectionResponseSerializer();
}

class _$ImConnectionResponseSerializer implements PrimitiveSerializer<ImConnectionResponse> {
  @override
  final Iterable<Type> types = const [ImConnectionResponse, _$ImConnectionResponse];

  @override
  final String wireName = r'ImConnectionResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ImConnectionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'uid';
    yield serializers.serialize(
      object.uid,
      specifiedType: const FullType(String),
    );
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ImConnectionResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ImConnectionResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'uid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uid = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ImConnectionResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ImConnectionResponseBuilder();
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

