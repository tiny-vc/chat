// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_download_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FileDownloadResponse extends FileDownloadResponse {
  @override
  final String downloadUrl;
  @override
  final int expiresIn;
  @override
  final StoredFileResponse file;

  factory _$FileDownloadResponse(
          [void Function(FileDownloadResponseBuilder)? updates]) =>
      (FileDownloadResponseBuilder()..update(updates))._build();

  _$FileDownloadResponse._(
      {required this.downloadUrl, required this.expiresIn, required this.file})
      : super._();
  @override
  FileDownloadResponse rebuild(
          void Function(FileDownloadResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileDownloadResponseBuilder toBuilder() =>
      FileDownloadResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileDownloadResponse &&
        downloadUrl == other.downloadUrl &&
        expiresIn == other.expiresIn &&
        file == other.file;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, downloadUrl.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, file.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FileDownloadResponse')
          ..add('downloadUrl', downloadUrl)
          ..add('expiresIn', expiresIn)
          ..add('file', file))
        .toString();
  }
}

class FileDownloadResponseBuilder
    implements Builder<FileDownloadResponse, FileDownloadResponseBuilder> {
  _$FileDownloadResponse? _$v;

  String? _downloadUrl;
  String? get downloadUrl => _$this._downloadUrl;
  set downloadUrl(String? downloadUrl) => _$this._downloadUrl = downloadUrl;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  StoredFileResponseBuilder? _file;
  StoredFileResponseBuilder get file =>
      _$this._file ??= StoredFileResponseBuilder();
  set file(StoredFileResponseBuilder? file) => _$this._file = file;

  FileDownloadResponseBuilder() {
    FileDownloadResponse._defaults(this);
  }

  FileDownloadResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _downloadUrl = $v.downloadUrl;
      _expiresIn = $v.expiresIn;
      _file = $v.file.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileDownloadResponse other) {
    _$v = other as _$FileDownloadResponse;
  }

  @override
  void update(void Function(FileDownloadResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FileDownloadResponse build() => _build();

  _$FileDownloadResponse _build() {
    _$FileDownloadResponse _$result;
    try {
      _$result = _$v ??
          _$FileDownloadResponse._(
            downloadUrl: BuiltValueNullFieldError.checkNotNull(
                downloadUrl, r'FileDownloadResponse', 'downloadUrl'),
            expiresIn: BuiltValueNullFieldError.checkNotNull(
                expiresIn, r'FileDownloadResponse', 'expiresIn'),
            file: file.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'file';
        file.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FileDownloadResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
