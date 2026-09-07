//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/admin_report_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_page_response.g.dart';

/// AdminReportPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AdminReportPageResponse implements Built<AdminReportPageResponse, AdminReportPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminReportResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AdminReportPageResponse._();

  factory AdminReportPageResponse([void updates(AdminReportPageResponseBuilder b)]) = _$AdminReportPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportPageResponse> get serializer => _$AdminReportPageResponseSerializer();
}

class _$AdminReportPageResponseSerializer implements PrimitiveSerializer<AdminReportPageResponse> {
  @override
  final Iterable<Type> types = const [AdminReportPageResponse, _$AdminReportPageResponse];

  @override
  final String wireName = r'AdminReportPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminReportResponse)]),
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
    AdminReportPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminReportResponse)]),
          ) as BuiltList<AdminReportResponse>;
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
  AdminReportPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportPageResponseBuilder();
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

