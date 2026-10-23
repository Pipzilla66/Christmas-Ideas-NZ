import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:christmas_ideas_nz_test/app_viewport.dart';
void main() {
 testWidgets('Wide phone viewport keeps taps and vertical scrolling aligned', (tester) async {
  tester.view.physicalSize = const Size(980, 1900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  var taps = 0;
  Size? logicalSize;
  await tester.pumpWidget(MaterialApp(builder: (context, child) => AppViewport(phoneWidth: 412, child: child!),
   home: Scaffold(body: Builder(builder: (context) {
    logicalSize = MediaQuery.sizeOf(context);
    return ListView(children: [
     SizedBox(height: 120, child: TextButton(onPressed: () => taps++, child: const Text('Tap me'))),
     ...List.generate(20, (i) => SizedBox(height: 100, child: Text('Row $i'))),
    ]);
   }))));
  await tester.pumpAndSettle();
  expect(logicalSize!.width, 412);
  expect(logicalSize!.height, closeTo(1900 * 412 / 980, .01));
  await tester.tap(find.text('Tap me'));
  await tester.pumpAndSettle();
  expect(taps, 1);
  await tester.drag(find.byType(ListView), const Offset(0, -650));
  await tester.pumpAndSettle();
  final position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
  expect(position.pixels, greaterThan(200));
  expect(tester.takeException(), isNull);
 });
 testWidgets('Normal phone and desktop need no fitted layout', (tester) async {
  await tester.pumpWidget(MaterialApp(home: AppViewport(phoneWidth: 800, child: const Text('Normal'))));
  expect(find.byType(FittedBox), findsNothing);
 });
}
