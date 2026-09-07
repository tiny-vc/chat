//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response_moderation.g.dart';

/// AdminOverviewResponseModeration
///
/// Properties:
/// * [pendingGroupJoinRequests] 
/// * [pendingReports] 
/// * [abnormalFiles] 
@BuiltValue()
abstract class AdminOverviewResponseModeration implements Built<AdminOverviewResponseModeration, AdminOverviewResponseModerationBuilder> {
  @BuiltValueField(wireName: r'pendingGroupJoinRequests')
  int get pendingGroupJoinRequests;

  @BuiltValueField(wireName: r'pendingReports')
  int get pendingReports;

  @BuiltValueField(wireName: r'abnormalFiles')
  int get abnormalFiles;

  AdminOverviewResponseModeration._();

  factory AdminOverviewResponseModeration([void updates(AdminOverviewResponseModerationBuilder b)]) = _$AdminOverviewResponseModeration;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseModerationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponseModeration> get serializer => _$AdminOverviewResponseModerationSerializer();
}

class _$AdminOverviewResponseModerationSerializer implements PrimitiveSerializer<AdminOverviewResponseModeration> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponseModeration, _$AdminOverviewResponseModeration];

  @override
  final String wireName = r'AdminOverviewResponseModeration';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponseModeration object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pendingGroupJoinRequests';
    yield serializers.serialize(
      object.pendingGroupJoinRequests,
      specifiedType: const FullType(int),
    );
    yield r'pendingReports';
    yield serializers.serialize(
      object.pendingReports,
      specifiedType: const FullType(int),
    );
    yield r'abnormalFiles';
    yield serializers.serialize(
      object.abnormalFiles,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponseModeration object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseModerationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pendingGroupJoinRequests':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingGroupJoinRequests = valueDes;
          break;
        case r'pendingReports':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.pendingReports = valueDes;
          break;
        case r'abnormalFiles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.abnormalFiles = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponseModeration deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseModerationBuilder();
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

