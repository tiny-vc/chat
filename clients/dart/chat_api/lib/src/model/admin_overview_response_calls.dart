//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response_calls.g.dart';

/// AdminOverviewResponseCalls
///
/// Properties:
/// * [active] 
@BuiltValue()
abstract class AdminOverviewResponseCalls implements Built<AdminOverviewResponseCalls, AdminOverviewResponseCallsBuilder> {
  @BuiltValueField(wireName: r'active')
  int get active;

  AdminOverviewResponseCalls._();

  factory AdminOverviewResponseCalls([void updates(AdminOverviewResponseCallsBuilder b)]) = _$AdminOverviewResponseCalls;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseCallsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponseCalls> get serializer => _$AdminOverviewResponseCallsSerializer();
}

class _$AdminOverviewResponseCallsSerializer implements PrimitiveSerializer<AdminOverviewResponseCalls> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponseCalls, _$AdminOverviewResponseCalls];

  @override
  final String wireName = r'AdminOverviewResponseCalls';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponseCalls object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponseCalls object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseCallsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponseCalls deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseCallsBuilder();
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

