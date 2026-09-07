// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReportPageResponse extends AdminReportPageResponse {
  @override
  final BuiltList<AdminReportResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminReportPageResponse(
          [void Function(AdminReportPageResponseBuilder)? updates]) =>
      (AdminReportPageResponseBuilder()..update(updates))._build();

  _$AdminReportPageResponse._({required this.items, this.nextCursor})
      : super._();
  @override
  AdminReportPageResponse rebuild(
          void Function(AdminReportPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReportPageResponseBuilder toBuilder() =>
      AdminReportPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReportPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminReportPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminReportPageResponseBuilder
    implements
        Builder<AdminReportPageResponse, AdminReportPageResponseBuilder> {
  _$AdminReportPageResponse? _$v;

  ListBuilder<AdminReportResponse>? _items;
  ListBuilder<AdminReportResponse> get items =>
      _$this._items ??= ListBuilder<AdminReportResponse>();
  set items(ListBuilder<AdminReportResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminReportPageResponseBuilder() {
    AdminReportPageResponse._defaults(this);
  }

  AdminReportPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReportPageResponse other) {
    _$v = other as _$AdminReportPageResponse;
  }

  @override
  void update(void Function(AdminReportPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReportPageResponse build() => _build();

  _$AdminReportPageResponse _build() {
    _$AdminReportPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminReportPageResponse._(
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
            r'AdminReportPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
