// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_group_member_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminGroupMemberPageResponse extends AdminGroupMemberPageResponse {
  @override
  final BuiltList<AdminGroupMemberResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminGroupMemberPageResponse(
          [void Function(AdminGroupMemberPageResponseBuilder)? updates]) =>
      (AdminGroupMemberPageResponseBuilder()..update(updates))._build();

  _$AdminGroupMemberPageResponse._({required this.items, this.nextCursor})
      : super._();
  @override
  AdminGroupMemberPageResponse rebuild(
          void Function(AdminGroupMemberPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminGroupMemberPageResponseBuilder toBuilder() =>
      AdminGroupMemberPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGroupMemberPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminGroupMemberPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminGroupMemberPageResponseBuilder
    implements
        Builder<AdminGroupMemberPageResponse,
            AdminGroupMemberPageResponseBuilder> {
  _$AdminGroupMemberPageResponse? _$v;

  ListBuilder<AdminGroupMemberResponse>? _items;
  ListBuilder<AdminGroupMemberResponse> get items =>
      _$this._items ??= ListBuilder<AdminGroupMemberResponse>();
  set items(ListBuilder<AdminGroupMemberResponse>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminGroupMemberPageResponseBuilder() {
    AdminGroupMemberPageResponse._defaults(this);
  }

  AdminGroupMemberPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminGroupMemberPageResponse other) {
    _$v = other as _$AdminGroupMemberPageResponse;
  }

  @override
  void update(void Function(AdminGroupMemberPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGroupMemberPageResponse build() => _build();

  _$AdminGroupMemberPageResponse _build() {
    _$AdminGroupMemberPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminGroupMemberPageResponse._(
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
            r'AdminGroupMemberPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
