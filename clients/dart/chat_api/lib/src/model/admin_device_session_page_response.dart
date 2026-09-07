//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/admin_device_session_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_device_session_page_response.g.dart';

/// AdminDeviceSessionPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AdminDeviceSessionPageResponse implements Built<AdminDeviceSessionPageResponse, AdminDeviceSessionPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminDeviceSessionResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminDeviceSessionPageResponse._();

  factory AdminDeviceSessionPageResponse([void updates(AdminDeviceSessionPageResponseBuilder b)]) = _$AdminDeviceSessionPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeviceSessionPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeviceSessionPageResponse> get serializer => _$AdminDeviceSessionPageResponseSerializer();
}

class _$AdminDeviceSessionPageResponseSerializer implements PrimitiveSerializer<AdminDeviceSessionPageResponse> {
  @override
  final Iterable<Type> types = const [AdminDeviceSessionPageResponse, _$AdminDeviceSessionPageResponse];

  @override
  final String wireName = r'AdminDeviceSessionPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeviceSessionPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminDeviceSessionResponse)]),
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
    AdminDeviceSessionPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDeviceSessionPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDeviceSessionResponse)]),
          ) as BuiltList<AdminDeviceSessionResponse>;
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
  AdminDeviceSessionPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeviceSessionPageResponseBuilder();
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

