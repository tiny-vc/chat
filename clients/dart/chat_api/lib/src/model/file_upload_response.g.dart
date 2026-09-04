// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FileUploadResponse extends FileUploadResponse {
  @override
  final String fileId;
  @override
  final String uploadUrl;
  @override
  final String method;
  @override
  final BuiltMap<String, String> headers;
  @override
  final int expiresIn;

  factory _$FileUploadResponse(
          [void Function(FileUploadResponseBuilder)? updates]) =>
      (FileUploadResponseBuilder()..update(updates))._build();

  _$FileUploadResponse._(
      {required this.fileId,
      required this.uploadUrl,
      required this.method,
      required this.headers,
      required this.expiresIn})
      : super._();
  @override
  FileUploadResponse rebuild(
          void Function(FileUploadResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileUploadResponseBuilder toBuilder() =>
      FileUploadResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileUploadResponse &&
        fileId == other.fileId &&
        uploadUrl == other.uploadUrl &&
        method == other.method &&
        headers == other.headers &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, uploadUrl.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, headers.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FileUploadResponse')
          ..add('fileId', fileId)
          ..add('uploadUrl', uploadUrl)
          ..add('method', method)
          ..add('headers', headers)
          ..add('expiresIn', expiresIn))
        .toString();
  }
}

class FileUploadResponseBuilder
    implements Builder<FileUploadResponse, FileUploadResponseBuilder> {
  _$FileUploadResponse? _$v;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  String? _uploadUrl;
  String? get uploadUrl => _$this._uploadUrl;
  set uploadUrl(String? uploadUrl) => _$this._uploadUrl = uploadUrl;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  MapBuilder<String, String>? _headers;
  MapBuilder<String, String> get headers =>
      _$this._headers ??= MapBuilder<String, String>();
  set headers(MapBuilder<String, String>? headers) => _$this._headers = headers;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  FileUploadResponseBuilder() {
    FileUploadResponse._defaults(this);
  }

  FileUploadResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileId = $v.fileId;
      _uploadUrl = $v.uploadUrl;
      _method = $v.method;
      _headers = $v.headers.toBuilder();
      _expiresIn = $v.expiresIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileUploadResponse other) {
    _$v = other as _$FileUploadResponse;
  }

  @override
  void update(void Function(FileUploadResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FileUploadResponse build() => _build();

  _$FileUploadResponse _build() {
    _$FileUploadResponse _$result;
    try {
      _$result = _$v ??
          _$FileUploadResponse._(
            fileId: BuiltValueNullFieldError.checkNotNull(
                fileId, r'FileUploadResponse', 'fileId'),
            uploadUrl: BuiltValueNullFieldError.checkNotNull(
                uploadUrl, r'FileUploadResponse', 'uploadUrl'),
            method: BuiltValueNullFieldError.checkNotNull(
                method, r'FileUploadResponse', 'method'),
            headers: headers.build(),
            expiresIn: BuiltValueNullFieldError.checkNotNull(
                expiresIn, r'FileUploadResponse', 'expiresIn'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'headers';
        headers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FileUploadResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
