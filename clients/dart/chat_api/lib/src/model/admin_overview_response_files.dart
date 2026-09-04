//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_overview_response_files.g.dart';

/// AdminOverviewResponseFiles
///
/// Properties:
/// * [ready] 
/// * [storageBytes] 
@BuiltValue()
abstract class AdminOverviewResponseFiles implements Built<AdminOverviewResponseFiles, AdminOverviewResponseFilesBuilder> {
  @BuiltValueField(wireName: r'ready')
  int get ready;

  @BuiltValueField(wireName: r'storageBytes')
  String get storageBytes;

  AdminOverviewResponseFiles._();

  factory AdminOverviewResponseFiles([void updates(AdminOverviewResponseFilesBuilder b)]) = _$AdminOverviewResponseFiles;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOverviewResponseFilesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOverviewResponseFiles> get serializer => _$AdminOverviewResponseFilesSerializer();
}

class _$AdminOverviewResponseFilesSerializer implements PrimitiveSerializer<AdminOverviewResponseFiles> {
  @override
  final Iterable<Type> types = const [AdminOverviewResponseFiles, _$AdminOverviewResponseFiles];

  @override
  final String wireName = r'AdminOverviewResponseFiles';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOverviewResponseFiles object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ready';
    yield serializers.serialize(
      object.ready,
      specifiedType: const FullType(int),
    );
    yield r'storageBytes';
    yield serializers.serialize(
      object.storageBytes,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOverviewResponseFiles object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOverviewResponseFilesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ready':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ready = valueDes;
          break;
        case r'storageBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storageBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOverviewResponseFiles deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOverviewResponseFilesBuilder();
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

