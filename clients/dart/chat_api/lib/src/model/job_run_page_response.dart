//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/job_run_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'job_run_page_response.g.dart';

/// JobRunPageResponse
///
/// Properties:
/// * [items] 
/// * [nextCursor] 
@BuiltValue()
abstract class JobRunPageResponse implements Built<JobRunPageResponse, JobRunPageResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<JobRunResponse> get items;

  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  JobRunPageResponse._();

  factory JobRunPageResponse([void updates(JobRunPageResponseBuilder b)]) = _$JobRunPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JobRunPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JobRunPageResponse> get serializer => _$JobRunPageResponseSerializer();
}

class _$JobRunPageResponseSerializer implements PrimitiveSerializer<JobRunPageResponse> {
  @override
  final Iterable<Type> types = const [JobRunPageResponse, _$JobRunPageResponse];

  @override
  final String wireName = r'JobRunPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JobRunPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(JobRunResponse)]),
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
    JobRunPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JobRunPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(JobRunResponse)]),
          ) as BuiltList<JobRunResponse>;
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
  JobRunPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JobRunPageResponseBuilder();
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

