//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response_groups.g.dart';

/// AdminOverviewResponseGroups
///
/// Properties:
/// * [total] 
/// * [active] 
/// * [suspended] 
@BuiltValue()
abstract class AdminOverviewResponseGroups implements Built<AdminOverviewResponseGroups, AdminOverviewResponseGroupsBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'active')
  int get active;

  @BuiltValueField(wireName: r'suspended')
  int get suspended;

  AdminOverviewResponseGroups._();

  factory AdminOverviewResponseGroups([void updates(AdminOverviewResponseGroupsBuilder b)]) = _$AdminOverviewResponseGroups;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseGroupsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponseGroups> get serializer => _$AdminOverviewResponseGroupsSerializer();
}

class _$AdminOverviewResponseGroupsSerializer implements PrimitiveSerializer<AdminOverviewResponseGroups> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponseGroups, _$AdminOverviewResponseGroups];

  @override
  final String wireName = r'AdminOverviewResponseGroups';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponseGroups object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(int),
    );
    yield r'suspended';
    yield serializers.serialize(
      object.suspended,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponseGroups object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseGroupsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.active = valueDes;
          break;
        case r'suspended':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.suspended = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponseGroups deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseGroupsBuilder();
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

