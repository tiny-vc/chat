// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_call_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCallPageResponse extends AdminCallPageResponse {
  @override
  final BuiltList<AdminCallResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminCallPageResponse(
          [void Function(AdminCallPageResponseBuilder)? updates]) =>
      (AdminCallPageResponseBuilder()..update(updates))._build();

  _$AdminCallPageResponse._({required this.items, this.nextCursor}) : super._();
  @override
  AdminCallPageResponse rebuild(
          void Function(AdminCallPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminCallPageResponseBuilder toBuilder() =>
      AdminCallPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCallPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminCallPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminCallPageResponseBuilder
    implements Builder<AdminCallPageResponse, AdminCallPageResponseBuilder> {
  _$AdminCallPageResponse? _$v;

  ListBuilder<AdminCallResponse>? _items;
  ListBuilder<AdminCallResponse> get items =>
      _$this._items ??= ListBuilder<AdminCallResponse>();
  set items(ListBuilder<AdminCallResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminCallPageResponseBuilder() {
    AdminCallPageResponse._defaults(this);
  }

  AdminCallPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCallPageResponse other) {
    _$v = other as _$AdminCallPageResponse;
  }

  @override
  void update(void Function(AdminCallPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCallPageResponse build() => _build();

  _$AdminCallPageResponse _build() {
    _$AdminCallPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminCallPageResponse._(
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
            r'AdminCallPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
