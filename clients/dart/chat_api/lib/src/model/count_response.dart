//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'count_response.g.dart';

/// CountResponse
///
/// Properties:
/// * [count] 
@BuiltValue()
abstract class CountResponse implements Built<CountResponse, CountResponseBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  CountResponse._();

  factory CountResponse([void updates(CountResponseBuilder b)]) = _$CountResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CountResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CountResponse> get serializer => _$CountResponseSerializer();
}

class _$CountResponseSerializer implements PrimitiveSerializer<CountResponse> {
  @override
  final Iterable<Type> types = const [CountResponse, _$CountResponse];

  @override
  final String wireName = r'CountResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CountResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CountResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CountResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CountResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CountResponseBuilder();
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

