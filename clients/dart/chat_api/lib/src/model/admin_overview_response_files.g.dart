// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_overview_response_files.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOverviewResponseFiles extends AdminOverviewResponseFiles {
  @override
  final int ready;
  @override
  final String storageBytes;

  factory _$AdminOverviewResponseFiles(
          [void Function(AdminOverviewResponseFilesBuilder)? updates]) =>
      (AdminOverviewResponseFilesBuilder()..update(updates))._build();

  _$AdminOverviewResponseFiles._(
      {required this.ready, required this.storageBytes})
      : super._();
  @override
  AdminOverviewResponseFiles rebuild(
          void Function(AdminOverviewResponseFilesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOverviewResponseFilesBuilder toBuilder() =>
      AdminOverviewResponseFilesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOverviewResponseFiles &&
        ready == other.ready &&
        storageBytes == other.storageBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ready.hashCode);
    _$hash = $jc(_$hash, storageBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOverviewResponseFiles')
          ..add('ready', ready)
          ..add('storageBytes', storageBytes))
        .toString();
  }
}

class AdminOverviewResponseFilesBuilder
    implements
        Builder<AdminOverviewResponseFiles, AdminOverviewResponseFilesBuilder> {
  _$AdminOverviewResponseFiles? _$v;

  int? _ready;
  int? get ready => _$this._ready;
  set ready(int? ready) => _$this._ready = ready;

  String? _storageBytes;
  String? get storageBytes => _$this._storageBytes;
  set storageBytes(String? storageBytes) => _$this._storageBytes = storageBytes;

  AdminOverviewResponseFilesBuilder() {
    AdminOverviewResponseFiles._defaults(this);
  }

  AdminOverviewResponseFilesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ready = $v.ready;
      _storageBytes = $v.storageBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOverviewResponseFiles other) {
    _$v = other as _$AdminOverviewResponseFiles;
  }

  @override
  void update(void Function(AdminOverviewResponseFilesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOverviewResponseFiles build() => _build();

  _$AdminOverviewResponseFiles _build() {
    final _$result = _$v ??
        _$AdminOverviewResponseFiles._(
          ready: BuiltValueNullFieldError.checkNotNull(
              ready, r'AdminOverviewResponseFiles', 'ready'),
          storageBytes: BuiltValueNullFieldError.checkNotNull(
              storageBytes, r'AdminOverviewResponseFiles', 'storageBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
