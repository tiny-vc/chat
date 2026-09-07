import 'package:flutter/widgets.dart';

typedef TypedMessageWidgetBuilder<T, C> =
    Widget Function(BuildContext context, T content, C dependencies);
typedef FallbackMessageWidgetBuilder<C> =
    Widget Function(BuildContext context, Object? content, C dependencies);

abstract interface class MessageRenderer<C> {
  bool supports(Object? content);
  Widget build(BuildContext context, Object content, C dependencies);
}

class TypedMessageRenderer<T extends Object, C> implements MessageRenderer<C> {
  const TypedMessageRenderer(this.builder);

  final TypedMessageWidgetBuilder<T, C> builder;

  @override
  bool supports(Object? content) => content is T;

  @override
  Widget build(BuildContext context, Object content, C dependencies) =>
      builder(context, content as T, dependencies);
}

class MessageRendererRegistry<C> {
  const MessageRendererRegistry({
    required this.renderers,
    required this.fallback,
  });

  final List<MessageRenderer<C>> renderers;
  final FallbackMessageWidgetBuilder<C> fallback;

  Widget build(BuildContext context, Object? content, C dependencies) {
    for (final renderer in renderers) {
      if (renderer.supports(content)) {
        return renderer.build(context, content!, dependencies);
      }
    }
    return fallback(context, content, dependencies);
  }
}
