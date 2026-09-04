// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_run_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JobRunPageResponse extends JobRunPageResponse {
  @override
  final BuiltList<JobRunResponse> items;
  @override
  final String? nextCursor;

  factory _$JobRunPageResponse(
          [void Function(JobRunPageResponseBuilder)? updates]) =>
      (JobRunPageResponseBuilder()..update(updates))._build();

  _$JobRunPageResponse._({required this.items, this.nextCursor}) : super._();
  @override
  JobRunPageResponse rebuild(
          void Function(JobRunPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JobRunPageResponseBuilder toBuilder() =>
      JobRunPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JobRunPageResponse &&
        items == other.items &&
        nextCursor == other.nextCursor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JobRunPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class JobRunPageResponseBuilder
    implements Builder<JobRunPageResponse, JobRunPageResponseBuilder> {
  _$JobRunPageResponse? _$v;

  ListBuilder<JobRunResponse>? _items;
  ListBuilder<JobRunResponse> get items =>
      _$this._items ??= ListBuilder<JobRunResponse>();
  set items(ListBuilder<JobRunResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  JobRunPageResponseBuilder() {
    JobRunPageResponse._defaults(this);
  }

  JobRunPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JobRunPageResponse other) {
    _$v = other as _$JobRunPageResponse;
  }

  @override
  void update(void Function(JobRunPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JobRunPageResponse build() => _build();

  _$JobRunPageResponse _build() {
    _$JobRunPageResponse _$result;
    try {
      _$result = _$v ??
          _$JobRunPageResponse._(
            items: items.build(),
            nextCursor: nextCursor,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'JobRunPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
