//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'decide_report_dto.g.dart';

/// DecideReportDto
///
/// Properties:
/// * [status] 
/// * [note] 
@BuiltValue()
abstract class DecideReportDto implements Built<DecideReportDto, DecideReportDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  DecideReportDtoStatusEnum get status;
  // enum statusEnum {  RESOLVED,  DISMISSED,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  DecideReportDto._();

  factory DecideReportDto([void updates(DecideReportDtoBuilder b)]) = _$DecideReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DecideReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DecideReportDto> get serializer => _$DecideReportDtoSerializer();
}

class _$DecideReportDtoSerializer implements PrimitiveSerializer<DecideReportDto> {
  @override
  final Iterable<Type> types = const [DecideReportDto, _$DecideReportDto];

  @override
  final String wireName = r'DecideReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DecideReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DecideReportDtoStatusEnum),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DecideReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DecideReportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DecideReportDtoStatusEnum),
          ) as DecideReportDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DecideReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DecideReportDtoBuilder();
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

class DecideReportDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const DecideReportDtoStatusEnum RESOLVED = _$decideReportDtoStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const DecideReportDtoStatusEnum DISMISSED = _$decideReportDtoStatusEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const DecideReportDtoStatusEnum unknownDefaultOpenApi = _$decideReportDtoStatusEnum_unknownDefaultOpenApi;

  static Serializer<DecideReportDtoStatusEnum> get serializer => _$decideReportDtoStatusEnumSerializer;

  const DecideReportDtoStatusEnum._(String name): super(name);

  static BuiltSet<DecideReportDtoStatusEnum> get values => _$decideReportDtoStatusEnumValues;
  static DecideReportDtoStatusEnum valueOf(String name) => _$decideReportDtoStatusEnumValueOf(name);
}

