import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:christmas_ideas_nz_test/main.dart';
import 'package:christmas_ideas_nz_test/review_features.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  test('website addresses normalise and unsafe schemes are rejected', () {
    expect(websiteUri('example.co.nz')!.toString(), 'https://example.co.nz');
    expect(websiteUri('https://www.instagram.com/shop/')!.host, 'www.instagram.com');
    expect(websiteUri('javascript:alert(1)'), isNull);
    expect(websiteUri('file:///tmp/photo'), isNull);
    expect(websiteUri('https://user:password@example.co.nz'), isNull);
    expect(websiteUri(''), isNull);
  });
  test('display recommendations sort highest first with stable name ties', () {
    final items = [
      {'name':'C', 'recommendation_count':0},
      {'name':'B', 'recommendation_count':3},
      {'name':'A', 'recommendation_count':3},
    ];
    expect(sortRecommended(items).map((e) => e['name']), ['A','B','C']);
    expect(items.first['name'], 'C');
  });
  test('geographical distances distinguish local and distant listings', () {
    expect(distanceKm(-43.53,172.63,-43.53,172.63), closeTo(0,0.001));
    expect(distanceKm(-43.53,172.63,-36.85,174.76), greaterThan(700));
  });
  testWidgets('welcome exposes account creation and keeps browsing available', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Onboarding(theme: XmasTheme.classic, onThemeChanged: (_) {}, onContinue: (_) {})));
    expect(find.text('Create a free account'), findsOneWidget);
    expect(find.text('Browse without an account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final width in [390.0,1100.0]) {
    testWidgets('recipes use compact cards without overflow at width $width', (tester) async {
      tester.view.physicalSize = Size(width,800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: DiscoverPage(initialSection:'Recipes', initialContent:[
        {'id':'1','title':'Christmas dinner recipe with a long title','summary':'A festive recipe for everyone to share.','content_type':'recipe'},
        {'id':'2','title':'Christmas dessert','summary':'An easy dessert.','content_type':'recipe'},
      ]))));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Christmas dessert'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
