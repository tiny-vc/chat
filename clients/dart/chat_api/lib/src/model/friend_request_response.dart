//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/friendship_response.dart';
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/user_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'friend_request_response.g.dart';

/// FriendRequestResponse
///
/// Properties:
/// * [id] 
/// * [requesterId] 
/// * [addresseeId] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
/// * [requester] 
@BuiltValue()
abstract class FriendRequestResponse implements FriendshipResponse, Built<FriendRequestResponse, FriendRequestResponseBuilder> {
  @BuiltValueField(wireName: r'requester')
  UserResponse get requester;

  FriendRequestResponse._();

  factory FriendRequestResponse([void updates(FriendRequestResponseBuilder b)]) = _$FriendRequestResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FriendRequestResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FriendRequestResponse> get serializer => _$FriendRequestResponseSerializer();
}

class _$FriendRequestResponseSerializer implements PrimitiveSerializer<FriendRequestResponse> {
  @override
  final Iterable<Type> types = const [FriendRequestResponse, _$FriendRequestResponse];

  @override
  final String wireName = r'FriendRequestResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FriendRequestResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requester';
    yield serializers.serialize(
      object.requester,
      specifiedType: const FullType(UserResponse),
    );
    yield r'addresseeId';
    yield serializers.serialize(
      object.addresseeId,
      specifiedType: const FullType(String),
    );
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'requesterId';
    yield serializers.serialize(
      object.requesterId,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FriendshipResponseStatusEnum),
    );
    if (object.updatedAt != null) {
      yield r'updatedAt';
      yield serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FriendRequestResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FriendRequestResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requester':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserResponse),
          ) as UserResponse;
          result.requester.replace(valueDes);
          break;
        case r'addresseeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.addresseeId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'requesterId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requesterId = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FriendshipResponseStatusEnum),
          ) as FriendshipResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FriendRequestResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FriendRequestResponseBuilder();
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

class FriendRequestResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const FriendRequestResponseStatusEnum PENDING = _$friendRequestResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const FriendRequestResponseStatusEnum ACCEPTED = _$friendRequestResponseStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const FriendRequestResponseStatusEnum REJECTED = _$friendRequestResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const FriendRequestResponseStatusEnum BLOCKED = _$friendRequestResponseStatusEnum_BLOCKED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const FriendRequestResponseStatusEnum unknownDefaultOpenApi = _$friendRequestResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<FriendRequestResponseStatusEnum> get serializer => _$friendRequestResponseStatusEnumSerializer;

  const FriendRequestResponseStatusEnum._(String name): super(name);

  static BuiltSet<FriendRequestResponseStatusEnum> get values => _$friendRequestResponseStatusEnumValues;
  static FriendRequestResponseStatusEnum valueOf(String name) => _$friendRequestResponseStatusEnumValueOf(name);
}

