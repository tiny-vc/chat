//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_conversation_setting_dto.g.dart';

/// UpdateConversationSettingDto
///
/// Properties:
/// * [channelId] 
/// * [channelType] 
/// * [pinned] 
/// * [muted] 
/// * [archived] 
@BuiltValue()
abstract class UpdateConversationSettingDto implements Built<UpdateConversationSettingDto, UpdateConversationSettingDtoBuilder> {
  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  UpdateConversationSettingDtoChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'pinned')
  bool? get pinned;

  @BuiltValueField(wireName: r'muted')
  bool? get muted;

  @BuiltValueField(wireName: r'archived')
  bool? get archived;

  UpdateConversationSettingDto._();

  factory UpdateConversationSettingDto([void updates(UpdateConversationSettingDtoBuilder b)]) = _$UpdateConversationSettingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateConversationSettingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateConversationSettingDto> get serializer => _$UpdateConversationSettingDtoSerializer();
}

class _$UpdateConversationSettingDtoSerializer implements PrimitiveSerializer<UpdateConversationSettingDto> {
  @override
  final Iterable<Type> types = const [UpdateConversationSettingDto, _$UpdateConversationSettingDto];

  @override
  final String wireName = r'UpdateConversationSettingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateConversationSettingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'channelId';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channelType';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(UpdateConversationSettingDtoChannelTypeEnum),
    );
    if (object.pinned != null) {
      yield r'pinned';
      yield serializers.serialize(
        object.pinned,
        specifiedType: const FullType(bool),
      );
    }
    if (object.muted != null) {
      yield r'muted';
      yield serializers.serialize(
        object.muted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.archived != null) {
      yield r'archived';
      yield serializers.serialize(
        object.archived,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateConversationSettingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateConversationSettingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'channelId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channelId = valueDes;
          break;
        case r'channelType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateConversationSettingDtoChannelTypeEnum),
          ) as UpdateConversationSettingDtoChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'pinned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.pinned = valueDes;
          break;
        case r'muted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.muted = valueDes;
          break;
        case r'archived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.archived = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateConversationSettingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateConversationSettingDtoBuilder();
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

class UpdateConversationSettingDtoChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'1')
  static const UpdateConversationSettingDtoChannelTypeEnum n1 = _$updateConversationSettingDtoChannelTypeEnum_n1;
  @BuiltValueEnumConst(wireName: r'2')
  static const UpdateConversationSettingDtoChannelTypeEnum n2 = _$updateConversationSettingDtoChannelTypeEnum_n2;
  @BuiltValueEnumConst(wireName: r'11184809', fallback: true)
  static const UpdateConversationSettingDtoChannelTypeEnum unknownDefaultOpenApi = _$updateConversationSettingDtoChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<UpdateConversationSettingDtoChannelTypeEnum> get serializer => _$updateConversationSettingDtoChannelTypeEnumSerializer;

  const UpdateConversationSettingDtoChannelTypeEnum._(String name): super(name);

  static BuiltSet<UpdateConversationSettingDtoChannelTypeEnum> get values => _$updateConversationSettingDtoChannelTypeEnumValues;
  static UpdateConversationSettingDtoChannelTypeEnum valueOf(String name) => _$updateConversationSettingDtoChannelTypeEnumValueOf(name);
}

