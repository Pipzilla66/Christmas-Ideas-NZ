import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import '../lib/home_hero.dart';
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  for (final width in [320.0, 412.0, 1100.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('Full hook and countdown fit at $width with text scale $scale', (tester) async {
        tester.view.physicalSize = Size(width, 1000); tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(home: MediaQuery(
          data: MediaQueryData(size: Size(width,1000), textScaler: TextScaler.linear(scale)),
          child: const Scaffold(body: SingleChildScrollView(child: ChristmasHomeHero(days: 73))),
        )));
        await tester.pump();
        expect(find.text(christmasHook), findsOneWidget);
        expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is AssetImage && (widget.image as AssetImage).assetName == 'assets/christmas_brand_logo_v3.webp'), findsOneWidget);
        expect(find.text(christmasHookDescription), findsOneWidget);
        expect(find.text('73'), findsOneWidget);
        expect(find.text('More Meaningful'), findsNothing);
        expect(find.text('Christmas Ideas NZ'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
