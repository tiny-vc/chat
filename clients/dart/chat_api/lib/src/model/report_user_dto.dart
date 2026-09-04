//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'report_user_dto.g.dart';

/// ReportUserDto
///
/// Properties:
/// * [reason] 
/// * [details] 
@BuiltValue()
abstract class ReportUserDto implements Built<ReportUserDto, ReportUserDtoBuilder> {
  @BuiltValueField(wireName: r'reason')
  ReportUserDtoReasonEnum get reason;
  // enum reasonEnum {  SPAM,  HARASSMENT,  FRAUD,  INAPPROPRIATE,  OTHER,  };

  @BuiltValueField(wireName: r'details')
  String? get details;

  ReportUserDto._();

  factory ReportUserDto([void updates(ReportUserDtoBuilder b)]) = _$ReportUserDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReportUserDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReportUserDto> get serializer => _$ReportUserDtoSerializer();
}

class _$ReportUserDtoSerializer implements PrimitiveSerializer<ReportUserDto> {
  @override
  final Iterable<Type> types = const [ReportUserDto, _$ReportUserDto];

  @override
  final String wireName = r'ReportUserDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReportUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(ReportUserDtoReasonEnum),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReportUserDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReportUserDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReportUserDtoReasonEnum),
          ) as ReportUserDtoReasonEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReportUserDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReportUserDtoBuilder();
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

class ReportUserDtoReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SPAM')
  static const ReportUserDtoReasonEnum SPAM = _$reportUserDtoReasonEnum_SPAM;
  @BuiltValueEnumConst(wireName: r'HARASSMENT')
  static const ReportUserDtoReasonEnum HARASSMENT = _$reportUserDtoReasonEnum_HARASSMENT;
  @BuiltValueEnumConst(wireName: r'FRAUD')
  static const ReportUserDtoReasonEnum FRAUD = _$reportUserDtoReasonEnum_FRAUD;
  @BuiltValueEnumConst(wireName: r'INAPPROPRIATE')
  static const ReportUserDtoReasonEnum INAPPROPRIATE = _$reportUserDtoReasonEnum_INAPPROPRIATE;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ReportUserDtoReasonEnum OTHER = _$reportUserDtoReasonEnum_OTHER;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const ReportUserDtoReasonEnum unknownDefaultOpenApi = _$reportUserDtoReasonEnum_unknownDefaultOpenApi;

  static Serializer<ReportUserDtoReasonEnum> get serializer => _$reportUserDtoReasonEnumSerializer;

  const ReportUserDtoReasonEnum._(String name): super(name);

  static BuiltSet<ReportUserDtoReasonEnum> get values => _$reportUserDtoReasonEnumValues;
  static ReportUserDtoReasonEnum valueOf(String name) => _$reportUserDtoReasonEnumValueOf(name);
}

