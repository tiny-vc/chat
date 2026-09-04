// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_usage_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FileUsageResponse extends FileUsageResponse {
  @override
  final String usedBytes;
  @override
  final String quotaBytes;
  @override
  final String remainingBytes;
  @override
  final int fileCount;

  factory _$FileUsageResponse(
          [void Function(FileUsageResponseBuilder)? updates]) =>
      (FileUsageResponseBuilder()..update(updates))._build();

  _$FileUsageResponse._(
      {required this.usedBytes,
      required this.quotaBytes,
      required this.remainingBytes,
      required this.fileCount})
      : super._();
  @override
  FileUsageResponse rebuild(void Function(FileUsageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileUsageResponseBuilder toBuilder() =>
      FileUsageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileUsageResponse &&
        usedBytes == other.usedBytes &&
        quotaBytes == other.quotaBytes &&
        remainingBytes == other.remainingBytes &&
        fileCount == other.fileCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usedBytes.hashCode);
    _$hash = $jc(_$hash, quotaBytes.hashCode);
    _$hash = $jc(_$hash, remainingBytes.hashCode);
    _$hash = $jc(_$hash, fileCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FileUsageResponse')
          ..add('usedBytes', usedBytes)
          ..add('quotaBytes', quotaBytes)
          ..add('remainingBytes', remainingBytes)
          ..add('fileCount', fileCount))
        .toString();
  }
}

class FileUsageResponseBuilder
    implements Builder<FileUsageResponse, FileUsageResponseBuilder> {
  _$FileUsageResponse? _$v;

  String? _usedBytes;
  String? get usedBytes => _$this._usedBytes;
  set usedBytes(String? usedBytes) => _$this._usedBytes = usedBytes;

  String? _quotaBytes;
  String? get quotaBytes => _$this._quotaBytes;
  set quotaBytes(String? quotaBytes) => _$this._quotaBytes = quotaBytes;

  String? _remainingBytes;
  String? get remainingBytes => _$this._remainingBytes;
  set remainingBytes(String? remainingBytes) =>
      _$this._remainingBytes = remainingBytes;

  int? _fileCount;
  int? get fileCount => _$this._fileCount;
  set fileCount(int? fileCount) => _$this._fileCount = fileCount;

  FileUsageResponseBuilder() {
    FileUsageResponse._defaults(this);
  }

  FileUsageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usedBytes = $v.usedBytes;
      _quotaBytes = $v.quotaBytes;
      _remainingBytes = $v.remainingBytes;
      _fileCount = $v.fileCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileUsageResponse other) {
    _$v = other as _$FileUsageResponse;
  }

  @override
  void update(void Function(FileUsageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FileUsageResponse build() => _build();

  _$FileUsageResponse _build() {
    final _$result = _$v ??
        _$FileUsageResponse._(
          usedBytes: BuiltValueNullFieldError.checkNotNull(
              usedBytes, r'FileUsageResponse', 'usedBytes'),
          quotaBytes: BuiltValueNullFieldError.checkNotNull(
              quotaBytes, r'FileUsageResponse', 'quotaBytes'),
          remainingBytes: BuiltValueNullFieldError.checkNotNull(
              remainingBytes, r'FileUsageResponse', 'remainingBytes'),
          fileCount: BuiltValueNullFieldError.checkNotNull(
              fileCount, r'FileUsageResponse', 'fileCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
