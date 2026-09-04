//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'friendship_response.g.dart';

/// FriendshipResponse
///
/// Properties:
/// * [id] 
/// * [requesterId] 
/// * [addresseeId] 
/// * [status] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class FriendshipResponse implements Built<FriendshipResponse, FriendshipResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'requesterId')
  String get requesterId;

  @BuiltValueField(wireName: r'addresseeId')
  String get addresseeId;

  @BuiltValueField(wireName: r'status')
  FriendshipResponseStatusEnum get status;
  // enum statusEnum {  PENDING,  ACCEPTED,  REJECTED,  BLOCKED,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  FriendshipResponse._();

  factory FriendshipResponse([void updates(FriendshipResponseBuilder b)]) = _$FriendshipResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FriendshipResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FriendshipResponse> get serializer => _$FriendshipResponseSerializer();
}

class _$FriendshipResponseSerializer implements PrimitiveSerializer<FriendshipResponse> {
  @override
  final Iterable<Type> types = const [FriendshipResponse, _$FriendshipResponse];

  @override
  final String wireName = r'FriendshipResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FriendshipResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'requesterId';
    yield serializers.serialize(
      object.requesterId,
      specifiedType: const FullType(String),
    );
    yield r'addresseeId';
    yield serializers.serialize(
      object.addresseeId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FriendshipResponseStatusEnum),
    );
    if (object.createdAt != null) {
      yield r'createdAt';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
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
    FriendshipResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FriendshipResponseBuilder result,
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
        case r'requesterId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requesterId = valueDes;
          break;
        case r'addresseeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.addresseeId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FriendshipResponseStatusEnum),
          ) as FriendshipResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
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
  FriendshipResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FriendshipResponseBuilder();
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

class FriendshipResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const FriendshipResponseStatusEnum PENDING = _$friendshipResponseStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const FriendshipResponseStatusEnum ACCEPTED = _$friendshipResponseStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const FriendshipResponseStatusEnum REJECTED = _$friendshipResponseStatusEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'BLOCKED')
  static const FriendshipResponseStatusEnum BLOCKED = _$friendshipResponseStatusEnum_BLOCKED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const FriendshipResponseStatusEnum unknownDefaultOpenApi = _$friendshipResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<FriendshipResponseStatusEnum> get serializer => _$friendshipResponseStatusEnumSerializer;

  const FriendshipResponseStatusEnum._(String name): super(name);

  static BuiltSet<FriendshipResponseStatusEnum> get values => _$friendshipResponseStatusEnumValues;
  static FriendshipResponseStatusEnum valueOf(String name) => _$friendshipResponseStatusEnumValueOf(name);
}

