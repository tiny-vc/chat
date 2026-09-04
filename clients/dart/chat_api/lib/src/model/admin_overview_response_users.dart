//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response_users.g.dart';

/// AdminOverviewResponseUsers
///
/// Properties:
/// * [total] 
/// * [active] 
/// * [suspended] 
/// * [new24h] 
@BuiltValue()
abstract class AdminOverviewResponseUsers implements Built<AdminOverviewResponseUsers, AdminOverviewResponseUsersBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'active')
  int get active;

  @BuiltValueField(wireName: r'suspended')
  int get suspended;

  @BuiltValueField(wireName: r'new24h')
  int get new24h;

  AdminOverviewResponseUsers._();

  factory AdminOverviewResponseUsers([void updates(AdminOverviewResponseUsersBuilder b)]) = _$AdminOverviewResponseUsers;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseUsersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponseUsers> get serializer => _$AdminOverviewResponseUsersSerializer();
}

class _$AdminOverviewResponseUsersSerializer implements PrimitiveSerializer<AdminOverviewResponseUsers> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponseUsers, _$AdminOverviewResponseUsers];

  @override
  final String wireName = r'AdminOverviewResponseUsers';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponseUsers object, {
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
    yield r'new24h';
    yield serializers.serialize(
      object.new24h,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponseUsers object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseUsersBuilder result,
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
        case r'new24h':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.new24h = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponseUsers deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseUsersBuilder();
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

