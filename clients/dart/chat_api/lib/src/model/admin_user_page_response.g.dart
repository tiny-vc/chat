// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUserPageResponse extends AdminUserPageResponse {
  @override
  final BuiltList<AdminUserResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminUserPageResponse(
          [void Function(AdminUserPageResponseBuilder)? updates]) =>
      (AdminUserPageResponseBuilder()..update(updates))._build();

  _$AdminUserPageResponse._({required this.items, this.nextCursor}) : super._();
  @override
  AdminUserPageResponse rebuild(
          void Function(AdminUserPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminUserPageResponseBuilder toBuilder() =>
      AdminUserPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUserPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminUserPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminUserPageResponseBuilder
    implements Builder<AdminUserPageResponse, AdminUserPageResponseBuilder> {
  _$AdminUserPageResponse? _$v;

  ListBuilder<AdminUserResponse>? _items;
  ListBuilder<AdminUserResponse> get items =>
      _$this._items ??= ListBuilder<AdminUserResponse>();
  set items(ListBuilder<AdminUserResponse>? items) => _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminUserPageResponseBuilder() {
    AdminUserPageResponse._defaults(this);
  }

  AdminUserPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUserPageResponse other) {
    _$v = other as _$AdminUserPageResponse;
  }

  @override
  void update(void Function(AdminUserPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUserPageResponse build() => _build();

  _$AdminUserPageResponse _build() {
    _$AdminUserPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminUserPageResponse._(
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
            r'AdminUserPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
