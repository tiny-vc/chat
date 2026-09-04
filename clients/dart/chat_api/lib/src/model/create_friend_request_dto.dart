//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_friend_request_dto.g.dart';

/// CreateFriendRequestDto
///
/// Properties:
/// * [userId] 
@BuiltValue()
abstract class CreateFriendRequestDto implements Built<CreateFriendRequestDto, CreateFriendRequestDtoBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  CreateFriendRequestDto._();

  factory CreateFriendRequestDto([void updates(CreateFriendRequestDtoBuilder b)]) = _$CreateFriendRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateFriendRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateFriendRequestDto> get serializer => _$CreateFriendRequestDtoSerializer();
}

class _$CreateFriendRequestDtoSerializer implements PrimitiveSerializer<CreateFriendRequestDto> {
  @override
  final Iterable<Type> types = const [CreateFriendRequestDto, _$CreateFriendRequestDto];

  @override
  final String wireName = r'CreateFriendRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateFriendRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateFriendRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateFriendRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateFriendRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateFriendRequestDtoBuilder();
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

