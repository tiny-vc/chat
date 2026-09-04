//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/admin_group_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_group_page_response.g.dart';

/// AdminGroupPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AdminGroupPageResponse implements Built<AdminGroupPageResponse, AdminGroupPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminGroupResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminGroupPageResponse._();

  factory AdminGroupPageResponse([void updates(AdminGroupPageResponseBuilder b)]) = _$AdminGroupPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGroupPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGroupPageResponse> get serializer => _$AdminGroupPageResponseSerializer();
}

class _$AdminGroupPageResponseSerializer implements PrimitiveSerializer<AdminGroupPageResponse> {
  @override
  final Iterable<Type> types = const [AdminGroupPageResponse, _$AdminGroupPageResponse];

  @override
  final String wireName = r'AdminGroupPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGroupPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminGroupResponse)]),
    );
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminGroupPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminGroupPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminGroupResponse)]),
          ) as BuiltList<AdminGroupResponse>;
          result.items.replace(valueDes);
          break;
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminGroupPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGroupPageResponseBuilder();
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

