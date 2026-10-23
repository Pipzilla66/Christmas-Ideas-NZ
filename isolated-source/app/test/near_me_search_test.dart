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
      authOptions: const FlutterAuthClientOptions(autoRefreshToken: false, detectSessionInUri: false),
    );
  });
  testWidgets('One Category dropdown includes shops and real Christmas trees', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: NearMePage(initialListings: [
      {'id':'shop','_type':'Store','name':'Christmas decorations shop','business_type':'shop'},
      {'id':'tree','_type':'Store','name':'Fresh Christmas tree farm','business_type':'christmas_tree'},
    ]))));
    await tester.pumpAndSettle();
    final category = find.byWidgetPredicate((w) => w is DropdownButton<String> && w.items!.any((i) => i.value == 'Stores'));
    await tester.ensureVisible(category); await tester.pumpAndSettle();
    await tester.tap(category); await tester.pumpAndSettle();
    expect(find.text('All stores'), findsOneWidget);
    expect(find.descendant(of: find.byType(DropdownMenuItem<String>), matching: find.text('Christmas Shops')), findsOneWidget);
    expect(find.descendant(of: find.byType(DropdownMenuItem<String>), matching: find.text('Real Christmas Trees')), findsOneWidget);
    expect(find.text('Store type'), findsNothing);
    await tester.ensureVisible(find.text('Real Christmas Trees').last); await tester.pumpAndSettle();
    await tester.tap(find.text('Real Christmas Trees').last); await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Search now')); await tester.pumpAndSettle();
    await tester.tap(find.text('Search now')); await tester.pumpAndSettle();
    expect(find.text('Store type'), findsNothing);
    expect(find.text('Fresh Christmas tree farm'), findsOneWidget);
    expect(find.text('Christmas decorations shop'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final width in [360.0, 1100.0]) {
    testWidgets('Search applies filters and reveals results at $width', (tester) async {
      tester.view.physicalSize = Size(width, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: NearMePage(initialListings: [
        {'id':'shop-1','_type':'Store','name':'Example Christmas shop','region':'Canterbury','city':'Christchurch','business_type':'shop'},
      ]))));
      await tester.runAsync(() async { await Future<void>.delayed(const Duration(milliseconds: 100)); });
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'No matching shop');
      await tester.pump();
      // Draft text does not change the displayed result set.
      expect(find.text('No listings match yet. Try another area, date or category.'), findsNothing);
      await tester.ensureVisible(find.text('Search now'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Search now'));
      await tester.pumpAndSettle();
      expect(find.text('No listings match yet. Try another area, date or category.').hitTestable(), findsOneWidget);
      expect(find.text('Festive finds').hitTestable(), findsOneWidget);
      expect(tester.getTopLeft(find.text('Festive finds')).dy, lessThan(50));
      tester.state<ScrollableState>(find.byType(Scrollable).first).position.jumpTo(0);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Example');
      await tester.ensureVisible(find.text('Search now'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Search now'));
      await tester.pumpAndSettle();
      expect(find.text('Example Christmas shop').hitTestable(), findsOneWidget);
      expect(tester.getTopLeft(find.text('Festive finds')).dy, lessThan(50));
      expect(tester.takeException(), isNull);
    });
  }
}
