class MessageTextPart {
  const MessageTextPart(this.text, {this.uri});

  final String text;
  final Uri? uri;
  bool get isLink => uri != null;
}

final _webLink = RegExp(
  r'(?:(?:https?://)|(?:www\.))[^\s<>"\u0000-\u001F，。！？；：、]+',
  caseSensitive: false,
);
final _trailingPunctuation = RegExp(r'[.,!?;:，。！？；：、\)\]\}）】》]+$');

List<MessageTextPart> parseMessageText(String text) {
  final parts = <MessageTextPart>[];
  var offset = 0;
  for (final match in _webLink.allMatches(text)) {
    var visible = match.group(0)!;
    final trailing = _trailingPunctuation.firstMatch(visible)?.group(0) ?? '';
    if (trailing.isNotEmpty) {
      visible = visible.substring(0, visible.length - trailing.length);
    }
    if (match.start > offset) {
      parts.add(MessageTextPart(text.substring(offset, match.start)));
    }
    final uri = safeMessageUri(visible);
    parts.add(MessageTextPart(visible, uri: uri));
    if (trailing.isNotEmpty) parts.add(MessageTextPart(trailing));
    offset = match.end;
  }
  if (offset < text.length) parts.add(MessageTextPart(text.substring(offset)));
  if (parts.isEmpty) parts.add(MessageTextPart(text));
  return parts;
}

Uri? safeMessageUri(String value) {
  final candidate = value.toLowerCase().startsWith('www.')
      ? 'https://$value'
      : value;
  final uri = Uri.tryParse(candidate);
  if (uri == null ||
      (uri.scheme != 'https' && uri.scheme != 'http') ||
      uri.userInfo.isNotEmpty ||
      uri.host.isEmpty) {
    return null;
  }
  return uri;
}
