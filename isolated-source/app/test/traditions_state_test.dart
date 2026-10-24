import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/christmas_inspiration.dart';

void main() {
  for (final width in [412.0, 1024.0]) {
    for (final offset in [150.16666666666669, 359.6666666666667]) {
      testWidgets('Traditions restore scroll $offset without treating it as a bool at $width', (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final bucket = PageStorageBucket();
        var show = false;
        await tester.pumpWidget(MaterialApp(home: PageStorage(bucket: bucket,
          child: StatefulBuilder(builder: (context, change) => show
            ? ChristmasInspirationPage(traditions: true, loader: () async => [], onIdea: (_) {})
            : KeyedSubtree(key: const PageStorageKey<String>('traditions-list'),
                child: Builder(builder: (seedContext) {
                  bucket.writeState(seedContext, offset);
                  return TextButton(onPressed: () => change(() => show = true), child: const Text('Open traditions'));
                }))))));
        await tester.tap(find.text('Open traditions'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final list = tester.widget<ListView>(find.byType(ListView).first);
        expect(list.controller!.offset, closeTo(offset, 1));
        final first = traditionIdeas.first;
        await tester.ensureVisible(find.text(first.title));
        await tester.tap(find.text(first.title));
        await tester.pumpAndSettle();
        expect(find.text('1. ${first.steps.first}'), findsOneWidget);
        await tester.drag(find.byType(ListView).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView).first, const Offset(0, 500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
