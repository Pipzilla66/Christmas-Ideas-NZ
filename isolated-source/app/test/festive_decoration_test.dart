import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/festive_decoration.dart';
import '../lib/main.dart' show HomeSantaWelcome;
import '../lib/santa_journey.dart';
void main() {
  testWidgets('Sparkles allow form entry and taps on a pushed route', (tester) async {
    await tester.pumpWidget(MaterialApp(builder: (_, child) => FestiveFrame(child: child!), home: Builder(builder: (context) => Scaffold(body: Column(children: [
      const TextField(), FilledButton(onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (_) => Scaffold(body: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))))),child: const Text('Next')),
    ])))));
    await tester.enterText(find.byType(TextField),'Christmas');
    await tester.tap(find.text('Next')); await tester.pumpAndSettle();
    await tester.tap(find.text('Back')); await tester.pumpAndSettle();
    expect(find.text('Christmas'),findsOneWidget); expect(tester.takeException(),isNull);
  });
  for(final width in [320.0,1100.0]) {
    testWidgets('Santa welcome stays usable with larger text at $width', (tester) async {
      tester.view.physicalSize=Size(width,900); tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(home: MediaQuery(data: MediaQueryData(size:Size(width,900),textScaler:const TextScaler.linear(1.6)),child:const Scaffold(body:SingleChildScrollView(child:HomeSantaWelcome())))));
      await tester.tap(find.byKey(const ValueKey('home-santa-journey')));await tester.pumpAndSettle();
      expect(find.byType(SantaJourneyPage),findsOneWidget);expect(tester.takeException(),isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
