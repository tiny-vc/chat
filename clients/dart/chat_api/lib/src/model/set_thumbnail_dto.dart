//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'set_thumbnail_dto.g.dart';

/// SetThumbnailDto
///
/// Properties:
/// * [thumbnailFileId] 
@BuiltValue()
abstract class SetThumbnailDto implements Built<SetThumbnailDto, SetThumbnailDtoBuilder> {
  @BuiltValueField(wireName: r'thumbnailFileId')
  String get thumbnailFileId;

  SetThumbnailDto._();

  factory SetThumbnailDto([void updates(SetThumbnailDtoBuilder b)]) = _$SetThumbnailDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SetThumbnailDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SetThumbnailDto> get serializer => _$SetThumbnailDtoSerializer();
}

class _$SetThumbnailDtoSerializer implements PrimitiveSerializer<SetThumbnailDto> {
  @override
  final Iterable<Type> types = const [SetThumbnailDto, _$SetThumbnailDto];

  @override
  final String wireName = r'SetThumbnailDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SetThumbnailDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'thumbnailFileId';
    yield serializers.serialize(
      object.thumbnailFileId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SetThumbnailDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SetThumbnailDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'thumbnailFileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.thumbnailFileId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SetThumbnailDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SetThumbnailDtoBuilder();
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

