//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_response.g.dart';

/// AdminReportResponse
///
/// Properties:
/// * [id] 
/// * [reporterUserId] 
/// * [targetUserId] 
/// * [reason] 
/// * [details] 
/// * [status] 
/// * [decidedById] 
/// * [decisionNote] 
/// * [createdAt] 
/// * [decidedAt] 
/// * [reporter] 
/// * [target] 
/// * [decidedBy] 
@BuiltValue()
abstract class AdminReportResponse implements Built<AdminReportResponse, AdminReportResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reporterUserId')
  String get reporterUserId;

  @BuiltValueField(wireName: r'targetUserId')
  String get targetUserId;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'details')
  String? get details;

  @BuiltValueField(wireName: r'status')
  AdminReportResponseStatusEnum get status;
  // enum statusEnum {  PENDING,  RESOLVED,  DISMISSED,  };

  @BuiltValueField(wireName: r'decidedById')
  String? get decidedById;

  @BuiltValueField(wireName: r'decisionNote')
  String? get decisionNote;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'decidedAt')
  DateTime? get decidedAt;

  @BuiltValueField(wireName: r'reporter')
  BuiltMap<String, JsonObject?> get reporter;

  @BuiltValueField(wireName: r'target')
  BuiltMap<String, JsonObject?> get target;

  @BuiltValueField(wireName: r'decidedBy')
  BuiltMap<String, JsonObject?>? get decidedBy;

  AdminReportResponse._();

  factory AdminReportResponse([void updates(AdminReportResponseBuilder b)]) = _$AdminReportResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportResponse> get serializer => _$AdminReportResponseSerializer();
}

class _$AdminReportResponseSerializer implements PrimitiveSerializer<AdminReportResponse> {
  @override
  final Iterable<Type> types = const [AdminReportResponse, _$AdminReportResponse];

  @override
  final String wireName = r'AdminReportResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reporterUserId';
    yield serializers.serialize(
      object.reporterUserId,
      specifiedType: const FullType(String),
    );
    yield r'targetUserId';
    yield serializers.serialize(
      object.targetUserId,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminReportResponseStatusEnum),
    );
    if (object.decidedById != null) {
      yield r'decidedById';
      yield serializers.serialize(
        object.decidedById,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.decisionNote != null) {
      yield r'decisionNote';
      yield serializers.serialize(
        object.decisionNote,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.decidedAt != null) {
      yield r'decidedAt';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'reporter';
    yield serializers.serialize(
      object.reporter,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'target';
    yield serializers.serialize(
      object.target,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.decidedBy != null) {
      yield r'decidedBy';
      yield serializers.serialize(
        object.decidedBy,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminReportResponseBuilder result,
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
        case r'reporterUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reporterUserId = valueDes;
          break;
        case r'targetUserId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetUserId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.details = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminReportResponseStatusEnum),
          ) as AdminReportResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'decidedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decidedById = valueDes;
          break;
        case r'decisionNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decisionNote = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'decidedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'reporter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.reporter.replace(valueDes);
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.target.replace(valueDes);
          break;
        case r'decidedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.decidedBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportResponseBuilder();
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

class AdminReportResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const AdminReportResponseStatusEnum PENDING = _$adminReportResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const AdminReportResponseStatusEnum RESOLVED = _$adminReportResponseStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const AdminReportResponseStatusEnum DISMISSED = _$adminReportResponseStatusEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const AdminReportResponseStatusEnum unknownDefaultOpenApi = _$adminReportResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<AdminReportResponseStatusEnum> get serializer => _$adminReportResponseStatusEnumSerializer;

  const AdminReportResponseStatusEnum._(String name): super(name);

  static BuiltSet<AdminReportResponseStatusEnum> get values => _$adminReportResponseStatusEnumValues;
  static AdminReportResponseStatusEnum valueOf(String name) => _$adminReportResponseStatusEnumValueOf(name);
}

