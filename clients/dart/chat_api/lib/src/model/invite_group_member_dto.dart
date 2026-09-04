//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invite_group_member_dto.g.dart';

/// InviteGroupMemberDto
///
/// Properties:
/// * [userId] 
/// * [message] 
@BuiltValue()
abstract class InviteGroupMemberDto implements Built<InviteGroupMemberDto, InviteGroupMemberDtoBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'message')
  String? get message;

  InviteGroupMemberDto._();

  factory InviteGroupMemberDto([void updates(InviteGroupMemberDtoBuilder b)]) = _$InviteGroupMemberDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InviteGroupMemberDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InviteGroupMemberDto> get serializer => _$InviteGroupMemberDtoSerializer();
}

class _$InviteGroupMemberDtoSerializer implements PrimitiveSerializer<InviteGroupMemberDto> {
  @override
  final Iterable<Type> types = const [InviteGroupMemberDto, _$InviteGroupMemberDto];

  @override
  final String wireName = r'InviteGroupMemberDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InviteGroupMemberDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InviteGroupMemberDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InviteGroupMemberDtoBuilder result,
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
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InviteGroupMemberDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InviteGroupMemberDtoBuilder();
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

