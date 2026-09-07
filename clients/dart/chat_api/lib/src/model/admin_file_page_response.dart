//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/admin_file_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_file_page_response.g.dart';

/// AdminFilePageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AdminFilePageResponse implements Built<AdminFilePageResponse, AdminFilePageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminFileResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminFilePageResponse._();

  factory AdminFilePageResponse([void updates(AdminFilePageResponseBuilder b)]) = _$AdminFilePageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminFilePageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminFilePageResponse> get serializer => _$AdminFilePageResponseSerializer();
}

class _$AdminFilePageResponseSerializer implements PrimitiveSerializer<AdminFilePageResponse> {
  @override
  final Iterable<Type> types = const [AdminFilePageResponse, _$AdminFilePageResponse];

  @override
  final String wireName = r'AdminFilePageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminFilePageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminFileResponse)]),
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
    AdminFilePageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminFilePageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminFileResponse)]),
          ) as BuiltList<AdminFileResponse>;
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
  AdminFilePageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminFilePageResponseBuilder();
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

