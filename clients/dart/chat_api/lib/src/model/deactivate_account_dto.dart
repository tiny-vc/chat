//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'deactivate_account_dto.g.dart';

/// DeactivateAccountDto
///
/// Properties:
/// * [currentPassword] 
@BuiltValue()
abstract class DeactivateAccountDto implements Built<DeactivateAccountDto, DeactivateAccountDtoBuilder> {
  @BuiltValueField(wireName: r'currentPassword')
  String get currentPassword;

  DeactivateAccountDto._();

  factory DeactivateAccountDto([void updates(DeactivateAccountDtoBuilder b)]) = _$DeactivateAccountDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeactivateAccountDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeactivateAccountDto> get serializer => _$DeactivateAccountDtoSerializer();
}

class _$DeactivateAccountDtoSerializer implements PrimitiveSerializer<DeactivateAccountDto> {
  @override
  final Iterable<Type> types = const [DeactivateAccountDto, _$DeactivateAccountDto];

  @override
  final String wireName = r'DeactivateAccountDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeactivateAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currentPassword';
    yield serializers.serialize(
      object.currentPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DeactivateAccountDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeactivateAccountDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currentPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeactivateAccountDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeactivateAccountDtoBuilder();
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

