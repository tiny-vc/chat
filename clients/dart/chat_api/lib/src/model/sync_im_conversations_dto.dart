//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_im_conversations_dto.g.dart';

/// SyncImConversationsDto
///
/// Properties:
/// * [lastMsgSeqs] 
/// * [msgCount] 
/// * [version] 
@BuiltValue()
abstract class SyncImConversationsDto implements Built<SyncImConversationsDto, SyncImConversationsDtoBuilder> {
  @BuiltValueField(wireName: r'lastMsgSeqs')
  String? get lastMsgSeqs;

  @BuiltValueField(wireName: r'msgCount')
  num? get msgCount;

  @BuiltValueField(wireName: r'version')
  num? get version;

  SyncImConversationsDto._();

  factory SyncImConversationsDto([void updates(SyncImConversationsDtoBuilder b)]) = _$SyncImConversationsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncImConversationsDtoBuilder b) => b
      ..lastMsgSeqs = ''
      ..msgCount = 20
      ..version = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncImConversationsDto> get serializer => _$SyncImConversationsDtoSerializer();
}

class _$SyncImConversationsDtoSerializer implements PrimitiveSerializer<SyncImConversationsDto> {
  @override
  final Iterable<Type> types = const [SyncImConversationsDto, _$SyncImConversationsDto];

  @override
  final String wireName = r'SyncImConversationsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncImConversationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.lastMsgSeqs != null) {
      yield r'lastMsgSeqs';
      yield serializers.serialize(
        object.lastMsgSeqs,
        specifiedType: const FullType(String),
      );
    }
    if (object.msgCount != null) {
      yield r'msgCount';
      yield serializers.serialize(
        object.msgCount,
        specifiedType: const FullType(num),
      );
    }
    if (object.version != null) {
      yield r'version';
      yield serializers.serialize(
        object.version,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncImConversationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncImConversationsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lastMsgSeqs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastMsgSeqs = valueDes;
          break;
        case r'msgCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.msgCount = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncImConversationsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncImConversationsDtoBuilder();
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

