// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_file_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFilePageResponse extends AdminFilePageResponse {
  @override
  final BuiltList<AdminFileResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminFilePageResponse(
          [void Function(AdminFilePageResponseBuilder)? updates]) =>
      (AdminFilePageResponseBuilder()..update(updates))._build();

  _$AdminFilePageResponse._({required this.items, this.nextCursor}) : super._();
  @override
  AdminFilePageResponse rebuild(
          void Function(AdminFilePageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminFilePageResponseBuilder toBuilder() =>
      AdminFilePageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFilePageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminFilePageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminFilePageResponseBuilder
    implements Builder<AdminFilePageResponse, AdminFilePageResponseBuilder> {
  _$AdminFilePageResponse? _$v;

  ListBuilder<AdminFileResponse>? _items;
  ListBuilder<AdminFileResponse> get items =>
      _$this._items ??= ListBuilder<AdminFileResponse>();
  set items(ListBuilder<AdminFileResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminFilePageResponseBuilder() {
    AdminFilePageResponse._defaults(this);
  }

  AdminFilePageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFilePageResponse other) {
    _$v = other as _$AdminFilePageResponse;
  }

  @override
  void update(void Function(AdminFilePageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFilePageResponse build() => _build();

  _$AdminFilePageResponse _build() {
    _$AdminFilePageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminFilePageResponse._(
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
            r'AdminFilePageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
