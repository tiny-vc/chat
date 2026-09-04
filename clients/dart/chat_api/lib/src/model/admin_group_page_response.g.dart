// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_group_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminGroupPageResponse extends AdminGroupPageResponse {
  @override
  final BuiltList<AdminGroupResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminGroupPageResponse(
          [void Function(AdminGroupPageResponseBuilder)? updates]) =>
      (AdminGroupPageResponseBuilder()..update(updates))._build();

  _$AdminGroupPageResponse._({required this.items, this.nextCursor})
      : super._();
  @override
  AdminGroupPageResponse rebuild(
          void Function(AdminGroupPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGroupPageResponseBuilder toBuilder() =>
      AdminGroupPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGroupPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminGroupPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminGroupPageResponseBuilder
    implements Builder<AdminGroupPageResponse, AdminGroupPageResponseBuilder> {
  _$AdminGroupPageResponse? _$v;

  ListBuilder<AdminGroupResponse>? _items;
  ListBuilder<AdminGroupResponse> get items =>
      _$this._items ??= ListBuilder<AdminGroupResponse>();
  set items(ListBuilder<AdminGroupResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminGroupPageResponseBuilder() {
    AdminGroupPageResponse._defaults(this);
  }

  AdminGroupPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGroupPageResponse other) {
    _$v = other as _$AdminGroupPageResponse;
  }

  @override
  void update(void Function(AdminGroupPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGroupPageResponse build() => _build();

  _$AdminGroupPageResponse _build() {
    _$AdminGroupPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminGroupPageResponse._(
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
            r'AdminGroupPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
