import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:christmas_ideas_nz_test/main.dart';
void main() {
 setUpAll(() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  SharedPreferences.setMockInitialValues({});
  await Supabase.initialize(url: 'https://example.supabase.co', anonKey: 'test-key',
   authOptions: const FlutterAuthClientOptions(autoRefreshToken: false));
 });
 testWidgets('Phone gifts flow down in two columns with one parent scroll', (tester) async {
  tester.view.physicalSize = const Size(412, 820);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  const home = HomePage(name: 'Test', goTo: ignore);
  final items = List.generate(6, (i) => <String,dynamic>{'id': '$i', 'title': 'Gift $i', 'price_min': 10, 'price_max': 10});
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (context) =>
   ListView(children: [home.editorialRail(context, items, true), const SizedBox(height: 300, child: Text('After gifts'))])))));
  await tester.pumpAndSettle();
  final grid = tester.widget<GridView>(find.byKey(const ValueKey('home-gift-grid')));
  expect(grid.physics, isA<NeverScrollableScrollPhysics>());
  expect((grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount).crossAxisCount, 2);
  expect(tester.getTopLeft(find.text('Gift 2')).dy, greaterThan(tester.getTopLeft(find.text('Gift 0')).dy));
  await tester.drag(find.byType(ListView), const Offset(0, -550));
  await tester.pumpAndSettle();
  expect(find.text('After gifts').hitTestable(), findsOneWidget);
  expect(tester.takeException(), isNull);
 });
}
void ignore(int value) {}
