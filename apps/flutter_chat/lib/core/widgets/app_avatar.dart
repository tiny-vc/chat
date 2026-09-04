import 'package:flutter/material.dart';

import '../../config/app_config.dart';

/// Resolves protected file IDs through the business API, never as public URLs.
class AppAvatar extends StatefulWidget {
  const AppAvatar({
    super.key,
    required this.name,
    required this.resolveUrl,
    this.fileId,
    this.size = 48,
    this.group = false,
  });

  final String name;
  final String? fileId;
  final Future<ResolvedUrl> Function(String) resolveUrl;
  final double size;
  final bool group;

  @override
  State<AppAvatar> createState() => _AppAvatarState();
}

class _AppAvatarState extends State<AppAvatar> {
  Future<ResolvedUrl>? _url;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(AppAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fileId != widget.fileId ||
        oldWidget.resolveUrl != widget.resolveUrl) {
      _resolve();
    }
  }

  void _resolve() {
    final id = widget.fileId;
    _url = id == null || id.isEmpty
        ? null
        : Future.sync(() => widget.resolveUrl(id));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
            child: _url == null
                ? fallback
                : FutureBuilder<ResolvedUrl>(
                    key: ValueKey(_url),
                    future: _url,
                    builder: (context, snapshot) {
                      final endpoint = snapshot.data;
                      if (endpoint == null || snapshot.hasError) {
                        return fallback;
                      }
                      return Image.network(
                        endpoint.url,
                        headers: endpoint.headers,
                        fit: BoxFit.cover,
                        frameBuilder: (_, child, frame, synchronous) =>
                            synchronous || frame != null ? child : fallback,
                        errorBuilder: (_, _, _) => fallback,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
