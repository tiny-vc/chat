// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_device_session_page_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeviceSessionPageResponse extends AdminDeviceSessionPageResponse {
  @override
  final BuiltList<AdminDeviceSessionResponse> items;
  @override
  final String? nextCursor;

  factory _$AdminDeviceSessionPageResponse(
          [void Function(AdminDeviceSessionPageResponseBuilder)? updates]) =>
      (AdminDeviceSessionPageResponseBuilder()..update(updates))._build();

  _$AdminDeviceSessionPageResponse._({required this.items, this.nextCursor})
      : super._();
  @override
  AdminDeviceSessionPageResponse rebuild(
          void Function(AdminDeviceSessionPageResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDeviceSessionPageResponseBuilder toBuilder() =>
      AdminDeviceSessionPageResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeviceSessionPageResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminDeviceSessionPageResponse')
          ..add('items', items)
          ..add('nextCursor', nextCursor))
        .toString();
  }
}

class AdminDeviceSessionPageResponseBuilder
    implements
        Builder<AdminDeviceSessionPageResponse,
            AdminDeviceSessionPageResponseBuilder> {
  _$AdminDeviceSessionPageResponse? _$v;

  ListBuilder<AdminDeviceSessionResponse>? _items;
  ListBuilder<AdminDeviceSessionResponse> get items =>
      _$this._items ??= ListBuilder<AdminDeviceSessionResponse>();
  set items(ListBuilder<AdminDeviceSessionResponse>? items) =>
      _$this._items = items;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  AdminDeviceSessionPageResponseBuilder() {
    AdminDeviceSessionPageResponse._defaults(this);
  }

  AdminDeviceSessionPageResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _nextCursor = $v.nextCursor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeviceSessionPageResponse other) {
    _$v = other as _$AdminDeviceSessionPageResponse;
  }

  @override
  void update(void Function(AdminDeviceSessionPageResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeviceSessionPageResponse build() => _build();

  _$AdminDeviceSessionPageResponse _build() {
    _$AdminDeviceSessionPageResponse _$result;
    try {
      _$result = _$v ??
          _$AdminDeviceSessionPageResponse._(
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
            r'AdminDeviceSessionPageResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
