import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../text/message_links.dart';
import 'app_feedback.dart';

class MessageText extends StatefulWidget {
  const MessageText({super.key, required this.text});

  final String text;

  @override
  State<MessageText> createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  late List<MessageTextPart> _parts;
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void initState() {
    super.initState();
    _parse();
  }

  @override
  void didUpdateWidget(MessageText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _parse();
  }

  void _parse() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
    _parts = parseMessageText(widget.text);
    for (final part in _parts.where((part) => part.isLink)) {
      _recognizers.add(
        TapGestureRecognizer()..onTap = () => unawaited(_open(part.uri!)),
      );
    }
  }

  Future<void> _open(Uri uri) async {
    final confirmed = await AppFeedback.confirm(
      context,
      title: '打开外部链接？',
      message: '目标域名：${uri.host}\n\n$uri',
      confirmLabel: '打开',
    );
    if (!confirmed || !mounted) return;
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      AppFeedback.show(context, '无法打开此链接', kind: FeedbackKind.error);
    }
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: Theme.of(context).colorScheme.primary,
    );
    var recognizerIndex = 0;
    return Text.rich(
      TextSpan(
        children: _parts.map((part) {
          if (!part.isLink) return TextSpan(text: part.text);
          return TextSpan(
            text: part.text,
            style: linkStyle,
            recognizer: _recognizers[recognizerIndex++],
          );
        }).toList(),
      ),
    );
  }
}
