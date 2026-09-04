//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'add_group_members_dto.g.dart';

/// AddGroupMembersDto
///
/// Properties:
/// * [userIds] 
@BuiltValue()
abstract class AddGroupMembersDto implements Built<AddGroupMembersDto, AddGroupMembersDtoBuilder> {
  @BuiltValueField(wireName: r'userIds')
  BuiltSet<String> get userIds;

  AddGroupMembersDto._();

  factory AddGroupMembersDto([void updates(AddGroupMembersDtoBuilder b)]) = _$AddGroupMembersDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AddGroupMembersDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AddGroupMembersDto> get serializer => _$AddGroupMembersDtoSerializer();
}

class _$AddGroupMembersDtoSerializer implements PrimitiveSerializer<AddGroupMembersDto> {
  @override
  final Iterable<Type> types = const [AddGroupMembersDto, _$AddGroupMembersDto];

  @override
  final String wireName = r'AddGroupMembersDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AddGroupMembersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userIds';
    yield serializers.serialize(
      object.userIds,
      specifiedType: const FullType(BuiltSet, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AddGroupMembersDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AddGroupMembersDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'userIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>;
          result.userIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AddGroupMembersDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AddGroupMembersDtoBuilder();
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

