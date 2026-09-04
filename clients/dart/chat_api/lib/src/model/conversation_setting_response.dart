//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversation_setting_response.g.dart';

/// ConversationSettingResponse
///
/// Properties:
/// * [userId] 
/// * [channelId] 
/// * [channelType] 
/// * [pinned] 
/// * [muted] 
/// * [archived] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ConversationSettingResponse implements Built<ConversationSettingResponse, ConversationSettingResponseBuilder> {
  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'channelId')
  String get channelId;

  @BuiltValueField(wireName: r'channelType')
  ConversationSettingResponseChannelTypeEnum get channelType;
  // enum channelTypeEnum {  1,  2,  };

  @BuiltValueField(wireName: r'pinned')
  bool get pinned;

  @BuiltValueField(wireName: r'muted')
  bool get muted;

  @BuiltValueField(wireName: r'archived')
  bool get archived;

  @BuiltValueField(wireName: r'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime? get updatedAt;

  ConversationSettingResponse._();

  factory ConversationSettingResponse([void updates(ConversationSettingResponseBuilder b)]) = _$ConversationSettingResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversationSettingResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversationSettingResponse> get serializer => _$ConversationSettingResponseSerializer();
}

class _$ConversationSettingResponseSerializer implements PrimitiveSerializer<ConversationSettingResponse> {
  @override
  final Iterable<Type> types = const [ConversationSettingResponse, _$ConversationSettingResponse];

  @override
  final String wireName = r'ConversationSettingResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversationSettingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'channelId';
    yield serializers.serialize(
      object.channelId,
      specifiedType: const FullType(String),
    );
    yield r'channelType';
    yield serializers.serialize(
      object.channelType,
      specifiedType: const FullType(ConversationSettingResponseChannelTypeEnum),
    );
    yield r'pinned';
    yield serializers.serialize(
      object.pinned,
      specifiedType: const FullType(bool),
    );
    yield r'muted';
    yield serializers.serialize(
      object.muted,
      specifiedType: const FullType(bool),
    );
    yield r'archived';
    yield serializers.serialize(
      object.archived,
      specifiedType: const FullType(bool),
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
    ConversationSettingResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversationSettingResponseBuilder result,
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
            specifiedType: const FullType(ConversationSettingResponseChannelTypeEnum),
          ) as ConversationSettingResponseChannelTypeEnum;
          result.channelType = valueDes;
          break;
        case r'pinned':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pinned = valueDes;
          break;
        case r'muted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muted = valueDes;
          break;
        case r'archived':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.archived = valueDes;
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
  ConversationSettingResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversationSettingResponseBuilder();
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

class ConversationSettingResponseChannelTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 1)
  static const ConversationSettingResponseChannelTypeEnum number1 = _$conversationSettingResponseChannelTypeEnum_number1;
  @BuiltValueEnumConst(wireNumber: 2)
  static const ConversationSettingResponseChannelTypeEnum number2 = _$conversationSettingResponseChannelTypeEnum_number2;
  @BuiltValueEnumConst(wireNumber: 11184809, fallback: true)
  static const ConversationSettingResponseChannelTypeEnum unknownDefaultOpenApi = _$conversationSettingResponseChannelTypeEnum_unknownDefaultOpenApi;

  static Serializer<ConversationSettingResponseChannelTypeEnum> get serializer => _$conversationSettingResponseChannelTypeEnumSerializer;

  const ConversationSettingResponseChannelTypeEnum._(String name): super(name);

  static BuiltSet<ConversationSettingResponseChannelTypeEnum> get values => _$conversationSettingResponseChannelTypeEnumValues;
  static ConversationSettingResponseChannelTypeEnum valueOf(String name) => _$conversationSettingResponseChannelTypeEnumValueOf(name);
}

