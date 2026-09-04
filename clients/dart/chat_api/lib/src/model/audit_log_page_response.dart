//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/audit_log_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_log_page_response.g.dart';

/// AuditLogPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class AuditLogPageResponse implements Built<AuditLogPageResponse, AuditLogPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AuditLogResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  AuditLogPageResponse._();

  factory AuditLogPageResponse([void updates(AuditLogPageResponseBuilder b)]) = _$AuditLogPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditLogPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditLogPageResponse> get serializer => _$AuditLogPageResponseSerializer();
}

class _$AuditLogPageResponseSerializer implements PrimitiveSerializer<AuditLogPageResponse> {
  @override
  final Iterable<Type> types = const [AuditLogPageResponse, _$AuditLogPageResponse];

  @override
  final String wireName = r'AuditLogPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditLogPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AuditLogResponse)]),
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
    AuditLogPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditLogPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AuditLogResponse)]),
          ) as BuiltList<AuditLogResponse>;
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
  AuditLogPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditLogPageResponseBuilder();
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

