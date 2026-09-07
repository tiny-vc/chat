//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'blocked_user_response.g.dart';

/// BlockedUserResponse
///
/// Properties:
/// * [user] 
/// * [createdAt] 
@BuiltValue()
abstract class BlockedUserResponse implements Built<BlockedUserResponse, BlockedUserResponseBuilder> {
  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  BlockedUserResponse._();

  factory BlockedUserResponse([void updates(BlockedUserResponseBuilder b)]) = _$BlockedUserResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockedUserResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockedUserResponse> get serializer => _$BlockedUserResponseSerializer();
}

class _$BlockedUserResponseSerializer implements PrimitiveSerializer<BlockedUserResponse> {
  @override
  final Iterable<Type> types = const [BlockedUserResponse, _$BlockedUserResponse];

  @override
  final String wireName = r'BlockedUserResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockedUserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserResponse),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockedUserResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BlockedUserResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.user.replace(valueDes);
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlockedUserResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockedUserResponseBuilder();
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

