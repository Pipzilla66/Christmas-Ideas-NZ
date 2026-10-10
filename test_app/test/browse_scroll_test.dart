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
  testWidgets('Back restores browsing position and section after opening an idea', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: DiscoverPage(
      initialSection: 'Recipes',
      initialContent: List.generate(40, (i) => {
        'id':'recipe-$i', 'title':'Recipe $i', 'summary':'A Christmas recipe.',
        'body':'Recipe details.', 'content_type':'recipe',
      }),
    ))));
    await tester.pumpAndSettle();
    final list = find.byKey(const PageStorageKey('discover-list'));
    final scrolling = find.descendant(of: list, matching: find.byType(Scrollable)).first;
    await tester.drag(list, const Offset(0, -1100));
    await tester.pumpAndSettle();
    final before = tester.state<ScrollableState>(scrolling).position.pixels;
    expect(before, greaterThan(500));
    final target = find.text('Recipe 8');
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    final selectedOffset = tester.state<ScrollableState>(scrolling).position.pixels;
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(find.byType(ContentDetailPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.state<ScrollableState>(scrolling).position.pixels, closeTo(selectedOffset, 1));
    tester.state<ScrollableState>(scrolling).position.jumpTo(0);
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Recipes')).selected, isTrue);
    expect(tester.takeException(), isNull);
  });
}
