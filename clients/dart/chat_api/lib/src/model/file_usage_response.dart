//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'file_usage_response.g.dart';

/// FileUsageResponse
///
/// Properties:
/// * [usedBytes] 
/// * [quotaBytes] 
/// * [remainingBytes] 
/// * [fileCount] 
@BuiltValue()
abstract class FileUsageResponse implements Built<FileUsageResponse, FileUsageResponseBuilder> {
  @BuiltValueField(wireName: r'usedBytes')
  String get usedBytes;

  @BuiltValueField(wireName: r'quotaBytes')
  String get quotaBytes;

  @BuiltValueField(wireName: r'remainingBytes')
  String get remainingBytes;

  @BuiltValueField(wireName: r'fileCount')
  int get fileCount;

  FileUsageResponse._();

  factory FileUsageResponse([void updates(FileUsageResponseBuilder b)]) = _$FileUsageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FileUsageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FileUsageResponse> get serializer => _$FileUsageResponseSerializer();
}

class _$FileUsageResponseSerializer implements PrimitiveSerializer<FileUsageResponse> {
  @override
  final Iterable<Type> types = const [FileUsageResponse, _$FileUsageResponse];

  @override
  final String wireName = r'FileUsageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FileUsageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'usedBytes';
    yield serializers.serialize(
      object.usedBytes,
      specifiedType: const FullType(String),
    );
    yield r'quotaBytes';
    yield serializers.serialize(
      object.quotaBytes,
      specifiedType: const FullType(String),
    );
    yield r'remainingBytes';
    yield serializers.serialize(
      object.remainingBytes,
      specifiedType: const FullType(String),
    );
    yield r'fileCount';
    yield serializers.serialize(
      object.fileCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FileUsageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FileUsageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'usedBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.usedBytes = valueDes;
          break;
        case r'quotaBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quotaBytes = valueDes;
          break;
        case r'remainingBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.remainingBytes = valueDes;
          break;
        case r'fileCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fileCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FileUsageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FileUsageResponseBuilder();
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

