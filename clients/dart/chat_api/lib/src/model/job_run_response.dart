//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'job_run_response.g.dart';

/// JobRunResponse
///
/// Properties:
/// * [id] 
/// * [jobName] 
/// * [status] 
/// * [trigger] 
/// * [metrics] 
/// * [error] 
/// * [startedAt] 
/// * [finishedAt] 
@BuiltValue()
abstract class JobRunResponse implements Built<JobRunResponse, JobRunResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'jobName')
  String get jobName;

  @BuiltValueField(wireName: r'status')
  JobRunResponseStatusEnum get status;
  // enum statusEnum {  RUNNING,  SUCCESS,  FAILED,  SKIPPED,  };

  @BuiltValueField(wireName: r'trigger')
  String get trigger;

  @BuiltValueField(wireName: r'metrics')
  BuiltMap<String, JsonObject?>? get metrics;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'finishedAt')
  DateTime? get finishedAt;

  JobRunResponse._();

  factory JobRunResponse([void updates(JobRunResponseBuilder b)]) = _$JobRunResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(JobRunResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<JobRunResponse> get serializer => _$JobRunResponseSerializer();
}

class _$JobRunResponseSerializer implements PrimitiveSerializer<JobRunResponse> {
  @override
  final Iterable<Type> types = const [JobRunResponse, _$JobRunResponse];

  @override
  final String wireName = r'JobRunResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    JobRunResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'jobName';
    yield serializers.serialize(
      object.jobName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(JobRunResponseStatusEnum),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(String),
    );
    if (object.metrics != null) {
      yield r'metrics';
      yield serializers.serialize(
        object.metrics,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.finishedAt != null) {
      yield r'finishedAt';
      yield serializers.serialize(
        object.finishedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    JobRunResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required JobRunResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'jobName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.jobName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JobRunResponseStatusEnum),
          ) as JobRunResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trigger = valueDes;
          break;
        case r'metrics':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.metrics.replace(valueDes);
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'finishedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.finishedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  JobRunResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = JobRunResponseBuilder();
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

class JobRunResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RUNNING')
  static const JobRunResponseStatusEnum RUNNING = _$jobRunResponseStatusEnum_RUNNING;
  @BuiltValueEnumConst(wireName: r'SUCCESS')
  static const JobRunResponseStatusEnum SUCCESS = _$jobRunResponseStatusEnum_SUCCESS;
  @BuiltValueEnumConst(wireName: r'FAILED')
  static const JobRunResponseStatusEnum FAILED = _$jobRunResponseStatusEnum_FAILED;
  @BuiltValueEnumConst(wireName: r'SKIPPED')
  static const JobRunResponseStatusEnum SKIPPED = _$jobRunResponseStatusEnum_SKIPPED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const JobRunResponseStatusEnum unknownDefaultOpenApi = _$jobRunResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<JobRunResponseStatusEnum> get serializer => _$jobRunResponseStatusEnumSerializer;

  const JobRunResponseStatusEnum._(String name): super(name);

  static BuiltSet<JobRunResponseStatusEnum> get values => _$jobRunResponseStatusEnumValues;
  static JobRunResponseStatusEnum valueOf(String name) => _$jobRunResponseStatusEnumValueOf(name);
}

