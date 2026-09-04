//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/admin_overview_response_moderation.dart';
import 'package:chat_api_client/src/model/admin_overview_response_calls.dart';
import 'package:chat_api_client/src/model/admin_overview_response_files.dart';
import 'package:chat_api_client/src/model/admin_overview_response_groups.dart';
import 'package:chat_api_client/src/model/admin_overview_response_users.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response.g.dart';

/// AdminOverviewResponse
///
/// Properties:
/// * [generatedAt] 
/// * [users] 
/// * [groups] 
/// * [files] 
/// * [calls] 
/// * [moderation] 
@BuiltValue()
abstract class AdminOverviewResponse implements Built<AdminOverviewResponse, AdminOverviewResponseBuilder> {
  @BuiltValueField(wireName: r'generatedAt')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'users')
  AdminOverviewResponseUsers get users;

  @BuiltValueField(wireName: r'groups')
  AdminOverviewResponseGroups get groups;

  @BuiltValueField(wireName: r'files')
  AdminOverviewResponseFiles get files;

  @BuiltValueField(wireName: r'calls')
  AdminOverviewResponseCalls get calls;

  @BuiltValueField(wireName: r'moderation')
  AdminOverviewResponseModeration get moderation;

  AdminOverviewResponse._();

  factory AdminOverviewResponse([void updates(AdminOverviewResponseBuilder b)]) = _$AdminOverviewResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponse> get serializer => _$AdminOverviewResponseSerializer();
}

class _$AdminOverviewResponseSerializer implements PrimitiveSerializer<AdminOverviewResponse> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponse, _$AdminOverviewResponse];

  @override
  final String wireName = r'AdminOverviewResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generatedAt';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(AdminOverviewResponseUsers),
    );
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(AdminOverviewResponseGroups),
    );
    yield r'files';
    yield serializers.serialize(
      object.files,
      specifiedType: const FullType(AdminOverviewResponseFiles),
    );
    yield r'calls';
    yield serializers.serialize(
      object.calls,
      specifiedType: const FullType(AdminOverviewResponseCalls),
    );
    yield r'moderation';
    yield serializers.serialize(
      object.moderation,
      specifiedType: const FullType(AdminOverviewResponseModeration),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'generatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewResponseUsers),
          ) as AdminOverviewResponseUsers;
          result.users.replace(valueDes);
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewResponseGroups),
          ) as AdminOverviewResponseGroups;
          result.groups.replace(valueDes);
          break;
        case r'files':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewResponseFiles),
          ) as AdminOverviewResponseFiles;
          result.files.replace(valueDes);
          break;
        case r'calls':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewResponseCalls),
          ) as AdminOverviewResponseCalls;
          result.calls.replace(valueDes);
          break;
        case r'moderation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminOverviewResponseModeration),
          ) as AdminOverviewResponseModeration;
          result.moderation.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseBuilder();
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

