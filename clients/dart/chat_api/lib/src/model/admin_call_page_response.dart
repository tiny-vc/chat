//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/admin_call_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_call_page_response.g.dart';

/// AdminCallPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AdminCallPageResponse implements Built<AdminCallPageResponse, AdminCallPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminCallResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminCallPageResponse._();

  factory AdminCallPageResponse([void updates(AdminCallPageResponseBuilder b)]) = _$AdminCallPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCallPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCallPageResponse> get serializer => _$AdminCallPageResponseSerializer();
}

class _$AdminCallPageResponseSerializer implements PrimitiveSerializer<AdminCallPageResponse> {
  @override
  final Iterable<Type> types = const [AdminCallPageResponse, _$AdminCallPageResponse];

  @override
  final String wireName = r'AdminCallPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCallPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminCallResponse)]),
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
    AdminCallPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminCallPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminCallResponse)]),
          ) as BuiltList<AdminCallResponse>;
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
  AdminCallPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCallPageResponseBuilder();
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

