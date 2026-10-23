import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/santa_journey.dart';
import '../lib/community_features.dart';

void main() {
  test('Santa stays at the pole before NZ Christmas Eve, including UTC date boundary', () {
    final before = SantaJourney(DateTime.utc(2026,12,23,10,59));
    expect(before.christmasEveStarted, false);
    expect(before.travelling, false);
    expect(before.headline, 'Santa is at the North Pole');
    expect(before.position, SantaJourney.project(0,85));
    expect(before.countdown, const Duration(minutes:1));
    final eve = SantaJourney(DateTime.utc(2026,12,23,11));
    expect(eve.christmasEveStarted, true);
    expect(eve.travelling, false);
    expect(eve.message, contains('Christmas Eve in New Zealand'));
    expect(eve.countdown, const Duration(hours:18));
  });
  test('departure, NZ stop, interpolation, Christmas Day and annual reset', () {
    final departure = SantaJourney(DateTime.utc(2026,12,24,5));
    expect(departure.travelling, true);
    expect(departure.nextStop.name, 'The Pacific Islands');
    final nz = SantaJourney(DateTime.utc(2026,12,24,7,30));
    expect(nz.nextStop.name, 'New Zealand');
    expect(nz.progress, .5);
    expect(nz.position.dx, closeTo(SantaJourney.project(176,-29.5).dx, .0001));
    expect(nz.position.dy, closeTo(SantaJourney.project(176,-29.5).dy, .0001));
    final nzArrival = SantaJourney(DateTime.utc(2026,12,24,8));
    expect(nzArrival.stops[nzArrival.leg].name, 'New Zealand');
    expect(nzArrival.nextStop.name, 'Australia');
    final home = SantaJourney(DateTime.utc(2026,12,25,7));
    expect(home.returned, true); expect(home.travelling, false);
    expect(home.position, SantaJourney.project(0,85));
    expect(home.countdownTarget, DateTime.utc(2027,12,23,11));
    final nextYear = SantaJourney(DateTime.utc(2026,12,31,11));
    expect(nextYear.year, 2027); expect(nextYear.returned, false);
    expect(nextYear.headline, 'Santa is at the North Pole');
  });
  testWidgets('Kids Zone opens Santa journey from its first activity card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: KidsSantaPage()));
    expect(find.text('Where’s Santa?'), findsOneWidget);
    await tester.ensureVisible(find.text('Where’s Santa?'));
    await tester.tap(find.text('Where’s Santa?'));
    await tester.pumpAndSettle();
    expect(find.byType(SantaJourneyPage), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('North Pole map and countdown fit a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(320,900); tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize); addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: SantaJourneyPage(clock:()=>DateTime.utc(2026,10,12))));
    expect(find.text('Santa is at the North Pole'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Until Christmas Eve'), 150, scrollable: find.byType(Scrollable).first);
    expect(find.text('Until Christmas Eve'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
