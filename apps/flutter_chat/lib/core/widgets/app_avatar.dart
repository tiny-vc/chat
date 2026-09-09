import 'dart:io';

import 'package:flutter/material.dart';

import '../../config/app_config.dart';

/// Resolves protected file IDs through the business API, never as public URLs.
class AppAvatar extends StatefulWidget {
  const AppAvatar({
    super.key,
    required this.name,
    required this.resolveUrl,
    this.resolveFile,
    this.fileId,
    this.size = 48,
    this.group = false,
  });

  final String name;
  final String? fileId;
  final Future<ResolvedUrl> Function(String) resolveUrl;
  final Future<File> Function(String)? resolveFile;
  final double size;
  final bool group;

  @override
  State<AppAvatar> createState() => _AppAvatarState();
}

class _AppAvatarState extends State<AppAvatar> {
  Future<ResolvedUrl>? _url;
  Future<File>? _file;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(AppAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileId != widget.fileId ||
        oldWidget.resolveUrl != widget.resolveUrl ||
        oldWidget.resolveFile != widget.resolveFile) {
      _resolve();
    }
  }

  void _resolve() {
    final id = widget.fileId;
    _url = id == null || id.isEmpty || widget.resolveFile != null
        ? null
        : Future.sync(() => widget.resolveUrl(id));
    _file = id == null || id.isEmpty || widget.resolveFile == null
        ? null
        : Future.sync(() => widget.resolveFile!(id));
  }

  void _retry() => setState(_resolve);

  Widget _retryable(Widget fallback) => Tooltip(
    message: '头像加载失败，点击重试',
    child: GestureDetector(onTap: _retry, child: fallback),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final decodeSize = (widget.size * MediaQuery.devicePixelRatioOf(context))
        .ceil()
        .clamp(1, 1024);
    final name = widget.name.trim();
    final fallback = ColoredBox(
      color: widget.group ? colors.secondaryContainer : colors.primaryContainer,
      child: Center(
        child: widget.group
            ? Icon(
                Icons.group_outlined,
                size: widget.size * .48,
                color: colors.onSecondaryContainer,
              )
            : Text(
                name.isEmpty ? '?' : name.characters.first,
                style: TextStyle(
                  fontSize: widget.size * .38,
                  fontWeight: FontWeight.w600,
                  color: colors.onPrimaryContainer,
                ),
              ),
      ),
    );
    return Semantics(
      image: true,
      label: '${name.isEmpty ? (widget.group ? '群聊' : '用户') : name}头像',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: widget.size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size * .3),
            child: _file != null
                ? FutureBuilder<File>(
                    key: ValueKey(_file),
                    future: _file,
                    builder: (context, snapshot) {
                      final file = snapshot.data;
                      if (snapshot.hasError) return _retryable(fallback);
                      if (file == null) return fallback;
                      return Image.file(
                        file,
                        fit: BoxFit.cover,
                        cacheWidth: decodeSize,
                        cacheHeight: decodeSize,
                        frameBuilder: (_, child, frame, synchronous) =>
                            synchronous || frame != null ? child : fallback,
                        errorBuilder: (_, _, _) => _retryable(fallback),
                      );
                    },
                  )
                : _url == null
                ? fallback
                : FutureBuilder<ResolvedUrl>(
                    key: ValueKey(_url),
                    future: _url,
                    builder: (context, snapshot) {
                      final endpoint = snapshot.data;
                      if (endpoint == null || snapshot.hasError) {
                        return snapshot.hasError
                            ? _retryable(fallback)
                            : fallback;
                      }
                      return Image.network(
                        endpoint.url,
                        headers: endpoint.headers,
                        fit: BoxFit.cover,
                        cacheWidth: decodeSize,
                        cacheHeight: decodeSize,
                        frameBuilder: (_, child, frame, synchronous) =>
                            synchronous || frame != null ? child : fallback,
                        errorBuilder: (_, _, _) => _retryable(fallback),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
