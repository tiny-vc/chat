//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:chat_api_client/src/model/stored_file_response.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'file_download_response.g.dart';

/// FileDownloadResponse
///
/// Properties:
/// * [downloadUrl] 
/// * [expiresIn] 
/// * [file] 
@BuiltValue()
abstract class FileDownloadResponse implements Built<FileDownloadResponse, FileDownloadResponseBuilder> {
  @BuiltValueField(wireName: r'downloadUrl')
  String get downloadUrl;

  @BuiltValueField(wireName: r'expiresIn')
  int get expiresIn;

  @BuiltValueField(wireName: r'file')
  StoredFileResponse get file;

  FileDownloadResponse._();

  factory FileDownloadResponse([void updates(FileDownloadResponseBuilder b)]) = _$FileDownloadResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FileDownloadResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FileDownloadResponse> get serializer => _$FileDownloadResponseSerializer();
}

class _$FileDownloadResponseSerializer implements PrimitiveSerializer<FileDownloadResponse> {
  @override
  final Iterable<Type> types = const [FileDownloadResponse, _$FileDownloadResponse];

  @override
  final String wireName = r'FileDownloadResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FileDownloadResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'downloadUrl';
    yield serializers.serialize(
      object.downloadUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresIn';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'file';
    yield serializers.serialize(
      object.file,
      specifiedType: const FullType(StoredFileResponse),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FileDownloadResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FileDownloadResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'downloadUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.downloadUrl = valueDes;
          break;
        case r'expiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoredFileResponse),
          ) as StoredFileResponse;
          result.file.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FileDownloadResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FileDownloadResponseBuilder();
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

