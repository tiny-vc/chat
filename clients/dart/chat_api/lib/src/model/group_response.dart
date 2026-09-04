//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:chat_api_client/src/model/group_member_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_response.g.dart';

/// GroupResponse
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [ownerId] 
/// * [avatarFileId] 
/// * [memberLimit] 
/// * [muteAll] 
/// * [status] 
/// * [members] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class GroupResponse implements Built<GroupResponse, GroupResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'ownerId')
  String get ownerId;

  @BuiltValueField(wireName: r'avatarFileId')
  String? get avatarFileId;

  @BuiltValueField(wireName: r'memberLimit')
  int get memberLimit;

  @BuiltValueField(wireName: r'muteAll')
  bool get muteAll;

  @BuiltValueField(wireName: r'status')
  GroupResponseStatusEnum get status;
  // enum statusEnum {  ACTIVE,  DISBANDED,  SUSPENDED,  };

  @BuiltValueField(wireName: r'members')
  BuiltList<GroupMemberResponse>? get members;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  GroupResponse._();

  factory GroupResponse([void updates(GroupResponseBuilder b)]) = _$GroupResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupResponse> get serializer => _$GroupResponseSerializer();
}

class _$GroupResponseSerializer implements PrimitiveSerializer<GroupResponse> {
  @override
  final Iterable<Type> types = const [GroupResponse, _$GroupResponse];

  @override
  final String wireName = r'GroupResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'ownerId';
    yield serializers.serialize(
      object.ownerId,
      specifiedType: const FullType(String),
    );
    if (object.avatarFileId != null) {
      yield r'avatarFileId';
      yield serializers.serialize(
        object.avatarFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'memberLimit';
    yield serializers.serialize(
      object.memberLimit,
      specifiedType: const FullType(int),
    );
    yield r'muteAll';
    yield serializers.serialize(
      object.muteAll,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(GroupResponseStatusEnum),
    );
    if (object.members != null) {
      yield r'members';
      yield serializers.serialize(
        object.members,
        specifiedType: const FullType(BuiltList, [FullType(GroupMemberResponse)]),
      );
    }
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
    GroupResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupResponseBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'ownerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerId = valueDes;
          break;
        case r'avatarFileId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarFileId = valueDes;
          break;
        case r'memberLimit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memberLimit = valueDes;
          break;
        case r'muteAll':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muteAll = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GroupResponseStatusEnum),
          ) as GroupResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(GroupMemberResponse)]),
          ) as BuiltList<GroupMemberResponse>?;
          if (valueDes == null) continue;
          result.members.replace(valueDes);
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
  GroupResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupResponseBuilder();
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

class GroupResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const GroupResponseStatusEnum ACTIVE = _$groupResponseStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'DISBANDED')
  static const GroupResponseStatusEnum DISBANDED = _$groupResponseStatusEnum_DISBANDED;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const GroupResponseStatusEnum SUSPENDED = _$groupResponseStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'unknown_default_open_api', fallback: true)
  static const GroupResponseStatusEnum unknownDefaultOpenApi = _$groupResponseStatusEnum_unknownDefaultOpenApi;

  static Serializer<GroupResponseStatusEnum> get serializer => _$groupResponseStatusEnumSerializer;

  const GroupResponseStatusEnum._(String name): super(name);

  static BuiltSet<GroupResponseStatusEnum> get values => _$groupResponseStatusEnumValues;
  static GroupResponseStatusEnum valueOf(String name) => _$groupResponseStatusEnumValueOf(name);
}

