import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/listing_card_layout.dart';

void main() {
  for (final width in [320.0, 412.0, 700.0, 1100.0]) {
    testWidgets('listing layout and actions at $width', (tester) async {
      tester.view.physicalSize = Size(width, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var tapped = false;
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: ListView(
        padding: const EdgeInsets.all(16),
        children: [ListingCardLayout(
          photo: const ColoredBox(key: Key('photo'), color: Colors.green),
          details: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Addy & Lou – Kaikoura', key: Key('title')),
            const Text('Browse the website for its current range, availability and opening details.'),
            TextButton(onPressed: () => tapped = true, child: const Text('Details / Website')),
          ]),
        )],
      ))));
      final photo = tester.getRect(find.byKey(const Key('photo')));
      final title = tester.getRect(find.byKey(const Key('title')));
      if (width >= 700) {
        expect(title.left, greaterThan(photo.right));
        expect(title.top, photo.top);
        expect(photo.width, 240);
      } else {
        expect(title.top, greaterThan(photo.bottom));
      }
      await tester.tap(find.text('Details / Website'));
      expect(tapped, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
