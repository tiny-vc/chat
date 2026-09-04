//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'friend_response.g.dart';

/// FriendResponse
///
/// Properties:
/// * [friendshipId] 
/// * [user] 
/// * [createdAt] 
@BuiltValue()
abstract class FriendResponse implements Built<FriendResponse, FriendResponseBuilder> {
  @BuiltValueField(wireName: r'friendshipId')
  String get friendshipId;

  @BuiltValueField(wireName: r'user')
  UserResponse get user;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  FriendResponse._();

  factory FriendResponse([void updates(FriendResponseBuilder b)]) = _$FriendResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FriendResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FriendResponse> get serializer => _$FriendResponseSerializer();
}

class _$FriendResponseSerializer implements PrimitiveSerializer<FriendResponse> {
  @override
  final Iterable<Type> types = const [FriendResponse, _$FriendResponse];

  @override
  final String wireName = r'FriendResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FriendResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'friendshipId';
    yield serializers.serialize(
      object.friendshipId,
      specifiedType: const FullType(String),
    );
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
    FriendResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FriendResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'friendshipId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.friendshipId = valueDes;
          break;
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
  FriendResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FriendResponseBuilder();
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

