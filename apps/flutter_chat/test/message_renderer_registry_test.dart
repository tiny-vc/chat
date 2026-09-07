import 'package:flutter/material.dart';
import 'package:flutter_chat/features/chat/presentation/message_renderer_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects a registered renderer by content type', (tester) async {
    final registry = MessageRendererRegistry<String>(
      renderers: [
        TypedMessageRenderer<String, String>(
          (_, content, prefix) => Text('$prefix:$content'),
        ),
        TypedMessageRenderer<int, String>(
          (_, content, prefix) => Text('$prefix:${content * 2}'),
        ),
      ],
      fallback: (_, _, _) => const Text('unsupported'),
    );

    await tester.pumpWidget(
      MaterialApp(home: registry.build(_FakeContext(), 21, 'value')),
    );
    expect(find.text('value:42'), findsOneWidget);
  });

  testWidgets('unknown and null content use the fallback', (tester) async {
    final registry = MessageRendererRegistry<void>(
      renderers: const [],
      fallback: (_, content, _) => Text(content == null ? 'empty' : 'unknown'),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Column(
            children: [
              registry.build(context, null, null),
              registry.build(context, Object(), null),
            ],
          ),
        ),
      ),
    );
    expect(find.text('empty'), findsOneWidget);
    expect(find.text('unknown'), findsOneWidget);
  });
}

// The registry forwards the context to builders; this test renderer does not
// read it, so a lightweight sentinel keeps the type-focused test concise.
class _FakeContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
