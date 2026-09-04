//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'success_response.g.dart';

/// SuccessResponse
///
/// Properties:
/// * [success] 
/// * [revokedSessions] 
@BuiltValue()
abstract class SuccessResponse implements Built<SuccessResponse, SuccessResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'revokedSessions')
  int? get revokedSessions;

  SuccessResponse._();

  factory SuccessResponse([void updates(SuccessResponseBuilder b)]) = _$SuccessResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SuccessResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SuccessResponse> get serializer => _$SuccessResponseSerializer();
}

class _$SuccessResponseSerializer implements PrimitiveSerializer<SuccessResponse> {
  @override
  final Iterable<Type> types = const [SuccessResponse, _$SuccessResponse];

  @override
  final String wireName = r'SuccessResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SuccessResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    if (object.revokedSessions != null) {
      yield r'revokedSessions';
      yield serializers.serialize(
        object.revokedSessions,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SuccessResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SuccessResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'revokedSessions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.revokedSessions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SuccessResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SuccessResponseBuilder();
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

